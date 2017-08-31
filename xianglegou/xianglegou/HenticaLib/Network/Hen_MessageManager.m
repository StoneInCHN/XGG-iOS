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
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //缓存请求参数
    if(resultBlock){
        [self.requestParamCache setObject:@[@(RequsetTypeOfNormal),action, param ? param : @{}, resultBlock] forKey:requestId];
    }
    
    [httpManager requestUrl:url dictionaryParam:[self createRequstDictionaryParam:param] retquestId:requestId withResultBlock:^(NSString*requestId, NSString *errCode, NSString *errMsg, id data) {
        
        if(resultBlock){
            resultBlock(errCode, errMsg, data);
        }
        
        [self showNetworkErrorNotice:errCode errMsg:errMsg requestId:requestId];
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
    
    [httpManager requestUrl:url dictionaryParam:[self createRequstDictionaryParam:param] retquestId:requestId withResultBlock:^(NSString*requestId, NSString *errCode, NSString *errMsg, id data) {
        
        if(resultBlock){
            resultBlock(errCode, errMsg, data);
        }
        
        if([errCode isEqualToString:@"0"]){ // 成功
            //保存
            [Hen_FileManager dictionary:data writeToFile:fileName];
        }
        
        [self showNetworkErrorNotice:errCode errMsg:errMsg requestId:requestId];
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
    
        NSData *imageData = UIImagePNGRepresentation(image);
    
        [httpManager requestUrl:url dictionaryParam:[self createRequstDictionaryParam:param] imageParamName:imageParamName imageDataParam:imageData retquestId:requestId withResultBlock:^(NSString*requestId, NSString *errCode, NSString *errMsg, id data) {
            
            if(resultBlock){
                resultBlock(errCode, errMsg, data);
            }
        
            [self showNetworkErrorNotice:errCode errMsg:errMsg requestId:requestId];
        } withProgressBlock:progressBlock];
    });
    
    return requestId;
}

///请求数据（上传多张图片）
-(NSString*)requestWithAction:(NSString *)action
         dictionaryParam:(NSDictionary*)param
         imageParameName:(NSString*)imageParameName
              imageArray:(NSArray*)imageDatas
         withResultBlock:(RequestResultBlock)resultBlock
{
    NSAssert(action, @"name must not be nil!");
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //缓存请求参数
    if(resultBlock){
        [self.requestParamCache setObject:@[@(RequsetTypeOfImageArray), action, param ? param : @{}, imageParameName, imageDatas, resultBlock] forKey:requestId];
    }
    
    //延迟0.2s，数据转换要阻塞ui线程，在阻塞之前先把loading显示出来
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *imageArry = [NSMutableArray array];
        
        if (imageDatas && imageDatas.count > 0) {
            
            for (UIImage *image in imageDatas) {
                
                NSData *imageData = UIImagePNGRepresentation(image);
                
                [imageArry addObject:imageData];
            }
        }
        
        [httpManager requestUrl:url dictionaryParam:[self createRequstDictionaryParam:param] imageParameName:imageParameName imageArray:imageArry retquestId:requestId withResultBlock:^(NSString*requestId, NSString *errCode, NSString *errMsg, id data) {
            if(resultBlock){
                resultBlock(errCode, errMsg, data);
            }
            
            [self showNetworkErrorNotice:errCode errMsg:errMsg requestId:requestId];
        }];
    });
    
    return requestId;
}

///请求数据（上传音频）
-(NSString*)requestWithAction:(NSString*)action
              dictionaryParam:(NSDictionary*)parame
              voiceParameName:(NSString*)voiceParameName
                voiceURLArray:(NSArray*)voiceURLArray
              withResultBlock:(RequestResultBlock)resultBlock
{
    NSAssert(action, @"name must not be nil!");
    
    NSString *requestId = [self autoGetRequestId];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",APP_SERVER,action];
    
    //缓存请求参数
    if(resultBlock){
//        [self.requestParamCache setObject:@[@(RequsetTypeOfImageArray), action, param ? param : @{}, imageParameName, imageDatas, resultBlock] forKey:requestId];
    }
        
    [httpManager requestUrl:url dictionaryParam:[self createRequstDictionaryParam:parame] voiceParameName:voiceParameName voiceURLArray:voiceURLArray retquestId:requestId withResultBlock:^(NSString*requestId, NSString *errCode, NSString *errMsg, id data) {
        if(resultBlock){
            resultBlock(errCode, errMsg, data);
        }
            
        [self showNetworkErrorNotice:errCode errMsg:errMsg requestId:requestId];
    }];
    
    return requestId;
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

///构造请求参数
-(NSDictionary *)createRequstDictionaryParam:(NSDictionary *)param{
    
    NSMutableDictionary *newPar = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(param){
        NSData *data=[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataParamStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [newPar setObject:dataParamStr forKey:@"DataParam"];
    }else{
        [newPar setObject:@"" forKey:@"DataParam"];
    }
    
    [newPar setObject:self.userId forKey:@"UserId"];
    [newPar setObject:self.session forKey:@"Session"];
    [newPar setObject:@"ios" forKey:@"Platform"];
    [newPar setObject:[Hen_DeviceUtil getAppCurrentVersion] forKey:@"VersionCode"];
    
    NSString *signDataStr = [NSString stringWithFormat:@"UserID=%@&Session=%@&Key=%@&DataParam=%@", self.userId, self.session, self.signKey, [newPar getStringValueForKey:@"DataParam" defaultValue:@""]];
    [newPar setObject:[self md5:signDataStr] forKey:@"SignData"];
    
    return newPar;
}

///MD5加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

///显示网络连接错误
-(void)showNetworkErrorNotice:(NSString*)errCode
                       errMsg:(NSString*)errMsg
                    requestId:(NSString*)requestId
{
    if(([errCode isEqualToString:@"-2"] || [errCode isEqualToString:@"-1009"])){
        
        if([self.unNoticeNetworkErrorSet containsObject:requestId]){
            [self.unNoticeNetworkErrorSet removeObject:requestId];
            return;
        }
        
        [DATAMODEL.alertManager showNetworkErrorMessage:errMsg];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
                
            }
        }];
        errMsg = @"";
    }else if([errCode isEqualToString:@"100"] || [errCode isEqualToString:@"101"]){ // 需要登录/在其他地方登录
        
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

-(NSString*)userId
{
    if(!_userId){
        _userId = @"";
    }
    return _userId;
}

-(NSString*)session
{
    if(!_session){
        _session = @"";
    }
    return _session;
}

-(NSString*)signKey
{
    if(!_signKey){
        _signKey = @"";
    }
    return _signKey;
}

-(NSMutableDictionary*)requestParamCache
{
    if(!_requestParamCache){
        _requestParamCache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _requestParamCache;
}

@end
