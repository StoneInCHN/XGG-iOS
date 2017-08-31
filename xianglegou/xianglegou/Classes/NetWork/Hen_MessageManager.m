//
//  MessageManager.m
//  Vpn
//
//  Created by mini2 on 15/9/17.
//  Copyright (c) 2015年. All rights reserved.
//

#import "Hen_MessageManager.h"
#import "NSDictionaryAdditions.h"
#import "Hen_FileManager.h"
#import "Hen_Define.h"

@interface Hen_MessageManager ()

///http请求管理
@property (nonatomic, strong) Hen_HttpManager *httpManager;

///请求Id
@property(nonatomic, assign) NSInteger overallRequestId;

///不提示网络错误请求集合
@property(nonatomic, strong) NSMutableSet *unNoticeNetworkErrorSet;

///不跳转登录请求集合
@property(nonatomic, strong) NSMutableSet *unToLoginSet;

///请求参数缓存
@property(nonatomic, strong) NSMutableDictionary *requestParamCache;

///当前请求id
@property(nonatomic, strong) NSString *currentRequestId;

@end

static Hen_MessageManager *_messageManager = nil;

@implementation Hen_MessageManager

@synthesize httpManager;

+ (Hen_MessageManager *)shareMessageManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _messageManager = [[self alloc] init];
        
        _messageManager.httpManager = [Hen_HttpManager manager];
        _messageManager.unNoticeNetworkErrorSet = [[NSMutableSet alloc] initWithCapacity:0];
        _messageManager.unToLoginSet = [[NSMutableSet alloc] initWithCapacity:0];
    });
    
    return _messageManager;
}

///请求数据
- (NSString*)requestWithAction:(NSString *)action
               dictionaryParam:(NSDictionary *)param
               withResultBlock:(RequestResultBlock)resultBlock{

    NSAssert(action, @"action must not be nil!");
    
    if([param objectForKey:@"token"]){
        if(DATAMODEL.token){
            [param setValue:DATAMODEL.token forKey:@"token"];
        }
    }
    if([param objectForKey:@"userId"]){
        if(DATAMODEL.userInfoData.id){
            [param setValue:DATAMODEL.userInfoData.id forKey:@"userId"];
        }
    }
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //缓存请求参数
    if(resultBlock){
        [self.requestParamCache setObject:@[@(RequsetTypeOfNormal),action, param ? param : @{}, resultBlock] forKey:requestId];
    }
    
    [httpManager requestUrl:url dictionaryParam:param retquestId:requestId withResultBlock:^(NSString*requestId, NSString *code, NSString *desc, id msg, id page) {
        
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
        
        [self showNetworkErrorNotice:code desc:desc requestId:requestId];
    }];
    return requestId;
}

///请求数据(缓存请求返回数据)
- (NSString*)requestWithAction:(NSString *)action
               dictionaryParam:(NSDictionary *)param
                 cacheFileName:(NSString*)fileName
               withResultBlock:(RequestResultBlock)resultBlock
          withCacheResultBlock:(CacheResultBlock)cacheBlock
{
    NSAssert(action, @"action must not be nil!");
    
    if(cacheBlock){
        cacheBlock([Hen_FileManager readDictionaryFile:fileName]);
    }
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //缓存请求参数
    if(resultBlock && cacheBlock){
        [self.requestParamCache setObject:@[@(RequsetTypeOfCache), action, param ? param : @{}, fileName, resultBlock, cacheBlock] forKey:requestId];
    }
    
    [httpManager requestUrl:url dictionaryParam:param retquestId:requestId withResultBlock:^(NSString*requestId, NSString *code, NSString *desc, id msg, id page) {
        
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
        
        if([code isEqualToString:@"0"]){ // 成功
            //保存
            [Hen_FileManager dictionary:msg writeToFile:fileName];
        }
        
        [self showNetworkErrorNotice:code desc:desc requestId:requestId];
    }];
    
    return requestId;
}

///请求数据，带图片
- (NSString*)requestWithAction:(NSString *)action
               dictionaryParam:(NSDictionary *)param
                imageParamName:(NSString*)imageParamName
                         image:(UIImage *)image
               withResultBlock:(RequestResultBlock)resultBlock
             withProgressBlock:(UploadProgressBlock)progressBlock
{
    
    NSAssert(action, @"action must not be nil!");
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //缓存请求参数
    if(resultBlock && progressBlock){
        [self.requestParamCache setObject:@[@(RequsetTypeOfImage), action, param ? param : @{}, imageParamName, image, resultBlock, progressBlock] forKey:requestId];
    }
    
    //延迟0.1s，数据转换要阻塞ui线程，在阻塞之前先把loading显示出来
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        
        [httpManager requestUrl:url dictionaryParam:param imageParamName:imageParamName imageDataParam:imageData retquestId:requestId withResultBlock:^(NSString *requestId, NSString *code, NSString *desc, id msg, id page) {
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
            
            [self showNetworkErrorNotice:code desc:desc requestId:requestId];
        } withProgressBlock:progressBlock];
    });
    
    return requestId;
}

///请求数据（上传多张图片）
-(NSString*)requestWithAction:(NSString *)action
         dictionaryParam:(NSDictionary*)param
         imageParameName:(NSString*)imageParameName
              imageArray:(NSArray*)imagemsgs
         withResultBlock:(RequestResultBlock)resultBlock
{
    NSAssert(action, @"name must not be nil!");
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //缓存请求参数
    if(resultBlock){
        [self.requestParamCache setObject:@[@(RequsetTypeOfImageArray), action, param ? param : @{}, imageParameName, imagemsgs, resultBlock] forKey:requestId];
    }
    
    //延迟0.2s，数据转换要阻塞ui线程，在阻塞之前先把loading显示出来
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *imageArry = [NSMutableArray array];
        
        if (imagemsgs && imagemsgs.count > 0) {
            
            for (UIImage *image in imagemsgs) {
                
                NSData *imagemsg = UIImageJPEGRepresentation(image, 0.8);
                
                [imageArry addObject:imagemsg];
                
                CGFloat length = [imagemsg length]/1024;
                NSLog(@"=====%f", length);
            }
        }
        
        [httpManager requestUrl:url dictionaryParam:param imageParameName:imageParameName imageArray:imageArry retquestId:requestId withResultBlock:^(NSString*requestId, NSString *code, NSString *desc, id msg, id page) {
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
            
            [self showNetworkErrorNotice:code desc:desc requestId:requestId];
        }];
    });
    
    return requestId;
}




///实名认证
- (NSString *)requestIdentityWithAction:(NSString *)action
                      dictionaryParam:(NSDictionary *)param
                         cardFrontPic:(UIImage *)cardFrontPic
                          cardBackPic:(UIImage *)cardBackPic
                      withResultBlock:(RequestResultBlock)resultBlock
{
    NSAssert(action, @"name must not be nil!");
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //延迟0.2s，数据转换要阻塞ui线程，在阻塞之前先把loading显示出来
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *cardFrontPicData = UIImageJPEGRepresentation(cardFrontPic, 0.8);
        NSData *cardBackPicData = UIImageJPEGRepresentation(cardBackPic, 0.8);
        
        CGFloat length1 = [cardFrontPicData length]/1024;
        CGFloat length2 = [cardBackPicData length]/1024;
        
        NSLog(@"*****%f, %f", length1, length2);
        
        [httpManager requestUrl:url dictionaryParam:param cardFrontPic:cardFrontPicData cardBackPic:cardBackPicData retquestId:requestId withResultBlock:^(NSString *requestId, NSString *code, NSString *desc, id msg, id page) {
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
            [self showNetworkErrorNotice:code desc:desc requestId:requestId];
        }];
        
    });
    return requestId;
}


///请求入驻
- (NSString *)requestApplyWithAction:(NSString *)action
                     dictionaryParam:(NSDictionary*)param
                        storePicture:(UIImage *)storePicture
                          licenseImg:(UIImage *)licenseImg
                             envImgs:(NSMutableArray*)envImgs
                      commitmentImgs:(NSMutableArray*)commitmentImgs
                     withResultBlock:(RequestResultBlock)resultBlock
{
    NSAssert(action, @"name must not be nil!");
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //延迟0.2s，数据转换要阻塞ui线程，在阻塞之前先把loading显示出来
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *storePictureData = UIImageJPEGRepresentation(storePicture, 0.8);
        NSData *licenseImgData = UIImageJPEGRepresentation(licenseImg, 0.8);
        
        CGFloat length1 = [storePictureData length]/1024;
        CGFloat length2 = [licenseImgData length]/1024;
        
        NSLog(@"*****%f, %f", length1, length2);
        
        NSMutableArray *envImgsArry = [NSMutableArray array];
        if (envImgs && envImgs.count > 0) {
            
            for (UIImage *image in envImgs) {
                NSData *imagemsg = UIImageJPEGRepresentation(image, 0.8);
                [envImgsArry addObject:imagemsg];
                
                CGFloat length = [imagemsg length]/1024;
                NSLog(@"=====%f", length);
            }
        }
        
        NSMutableArray *commitmentImgsArry = [NSMutableArray array];
        if(commitmentImgs && commitmentImgs.count > 0){
            
            for (UIImage *image in commitmentImgs) {
                NSData *imagemsg = UIImageJPEGRepresentation(image, 0.8);
                [commitmentImgsArry addObject:imagemsg];
                
                CGFloat length = [imagemsg length]/1024;
                NSLog(@"=====%f", length);
            }
        }
        
        
        [httpManager requestUrl:url dictionaryParam:param storePicture:storePictureData licenseImg:licenseImgData envImgs:envImgsArry commitmentImgs:commitmentImgsArry retquestId:requestId withResultBlock:^(NSString *requestId, NSString *code, NSString *desc, id msg, id page) {
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
            
            [self showNetworkErrorNotice:code desc:desc requestId:requestId];
        }];
    });
    
    return requestId;
}

///get请求
- (void)requestGetWithUrl:(NSString *)url
          dictionaryParam:(NSDictionary *)param
          withResultBlock:(RequestResultBlock)resultBlock
{
    [httpManager requestGetWithUrl:url dictionaryParam:param withResultBlock:^(NSString *requestId, NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
        
        [self showNetworkErrorNotice:code desc:desc requestId:requestId];
    }];
}

///添加不提示网络错误请求
-(void)addUnNoticeNetworkErrorRequestId:(NSString*)requestId
{
    [self.unNoticeNetworkErrorSet addObject:requestId];
}

///添加不跳转登录请求
-(void)addUnToLoginRequestId:(NSString*)requestId
{
    [self.unToLoginSet addObject:requestId];
}


#pragma mark --------- private 

///自动获取请求id
-(NSString*)autoGetRequestId
{
    if(self.overallRequestId > 100000){
        self.overallRequestId = 0;
    }
    self.overallRequestId++;
    
    return [NSString stringWithFormat:@"%ld", (long)self.overallRequestId];
}

///显示网络连接错误
-(void)showNetworkErrorNotice:(NSString*)code
                       desc:(NSString*)desc
                    requestId:(NSString*)requestId
{
    if(([code isEqualToString:@"-2"] || [code isEqualToString:@"-1009"])){
        
        if([self.unNoticeNetworkErrorSet containsObject:requestId]){
            [self.unNoticeNetworkErrorSet removeObject:requestId];
            return;
        }
        
        [DATAMODEL.alertManager showNetworkErrorMessage:desc];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
                
            }
        }];
        desc = @"";
    }else if([code isEqualToString:@"0004"] || [code isEqualToString:@"0008"]){ // 需要登录
        DATAMODEL.isLogin = NO;
        if([self.unToLoginSet containsObject:requestId]){
            [self.unToLoginSet removeObject:requestId];
            return;
        }
        
        if (!self.isToLogin) {
            self.isToLogin = YES;
            self.currentRequestId = requestId;
            // 0.5秒后执行（在iOS7上，不能在viewLoad中pushViewController，要在viewDidAppear中）
            [self performSelector:@selector(pushSecondController) withObject:nil afterDelay:0.5f];
        }
    }else{
        [self.requestParamCache removeAllObjects];
        self.currentRequestId = @"";
    }
    
    [self.unNoticeNetworkErrorSet removeObject:requestId];
    [self.unToLoginSet removeObject:requestId];
}

- (void) pushSecondController
{
    if(self.loginVc){
        [self.loginVc didReceiveMemoryWarning];
        
        UIViewController * currentVC = [[Hen_Util getInstance] getCurrentViewController];
        [currentVC.navigationController pushViewController:self.loginVc animated:YES];
    }
}

///重新请求
-(void)reRequst
{
    NSMutableArray *array = self.requestParamCache[self.currentRequestId];
    if(array.count > 0){
        RequsetType type = [((NSNumber*)array.firstObject) integerValue];
        if(type == RequsetTypeOfNormal){
            [self requestWithAction:array[1] dictionaryParam:array[2] withResultBlock:array[3]];
        }else if(type == RequsetTypeOfCache){
            [self requestWithAction:array[1] dictionaryParam:array[2] cacheFileName:array[3] withResultBlock:array[4] withCacheResultBlock:array[5]];
        }else if(type == RequsetTypeOfImage){
            [self requestWithAction:array[1] dictionaryParam:array[2] imageParamName:array[3] image:array[4] withResultBlock:array[5] withProgressBlock:array[6]];
        }else if(type == RequsetTypeOfImageArray){
            [self requestWithAction:array[1] dictionaryParam:array[2] imageParameName:array[3] imageArray:array[4] withResultBlock:array[5]];
        }
    }
    
    [self.loginVc didReceiveMemoryWarning];
}

#pragma mark -- 检测APP是否更新时使用

- (void)checkAppIsUpdateAPPID:(NSString *)appid andBlock:(CheckAppVersonBlock)completion{
    if (appid.length < 1) {
        if(completion){
            completion(NO, nil);
        }
        return;
    }
    [httpManager checkAppWithAppId:appid IsUpdate:^(BOOL isUpdate, id updateInfo) {
        completion(isUpdate, updateInfo);
    }];
}

#pragma mark -- getter, setter

-(NSMutableDictionary*)requestParamCache
{
    if(!_requestParamCache){
        _requestParamCache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _requestParamCache;
}

@end
