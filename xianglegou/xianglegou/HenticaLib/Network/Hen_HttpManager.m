//
//  HTC_HttpManager.h
//  CRM
//
//  Created by mini2 on 16/5/25.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import "Hen_HttpManager.h"

@interface Hen_HttpManager ()<NSURLConnectionDataDelegate> {
    checkAppVersonBlock _checkAppVersonBlock;
}

@property (nonatomic, strong) NSMutableData    *recevieData;

@property (nonatomic, strong) NSString *appID;      /**< APPID */

@end

@implementation Hen_HttpManager

/// 请求网络
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock
{
    [self setRequest];
    
    [self POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestSuccessForResponseObject:responseObject andRequestId:requestId withResultBlock:resultBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self againRequestUrl:url dictionaryParam:param requestCount:0 retquestId:requestId withResultBlock:resultBlock];
    }];
}

/// 请求网络 （上传单张图片）
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
   imageParamName:(NSString*)imageParamName
   imageDataParam:(NSData*)imageData
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock
withProgressBlock:(HttpUploadProgressBlock)progressBlock
{
    [self setRequest];
    
    AFHTTPRequestOperation * operation = [self POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if(imageData){
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYYMMddHHmmss"];
            NSString *name = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:date]];
            
            [formData appendPartWithFileData:imageData name:imageParamName fileName:name mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self requestSuccessForResponseObject:responseObject andRequestId:requestId withResultBlock:resultBlock];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self requestFailureForError:error andRequestId:requestId withResultBlock:resultBlock];
    }];
    
    // 上传进度
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if(progressBlock){
            progressBlock((CGFloat)totalBytesExpectedToWrite / 1000 / 100, (CGFloat)totalBytesWritten / 1000 / 100);
        }
    }];
}

///请求网络（上传多张图片）
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
  imageParameName:(NSString*)imageParameName
       imageArray:(NSArray*)imageDatas
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock
{
    [self setRequest];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    [self POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imageDatas.count > 0) {
            
            NSString *name = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:date]];
            
            for (NSUInteger i = 0; i < imageDatas.count; i++) {
                NSData *data = [imageDatas objectAtIndex:i];
                
                name = [NSString stringWithFormat:@"%ld%@.png",(long)i,[formatter stringFromDate:date]];
                
                if (data != NULL) {
                    
                    if (imageDatas.count == 1) {
                        [formData appendPartWithFileData:data name:imageParameName fileName:name mimeType:@"image/png"];
                    }else{
                        [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"%@", imageParameName] fileName:name mimeType:@"image/png"];
                    }
                }
            }
        }
        
    }  success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self requestSuccessForResponseObject:responseObject andRequestId:requestId withResultBlock:resultBlock];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self requestFailureForError:error andRequestId:requestId withResultBlock:resultBlock];
    }];
}

///请求网络（上传音频）
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
  voiceParameName:(NSString*)voiceParameName
    voiceURLArray:(NSArray*)voiceURLArray
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock
{
    [self setRequest];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    [self POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if(voiceURLArray.count > 0){
            NSString *name = @"";
            for(NSUInteger i = 0; i < voiceURLArray.count; i++){
                NSURL *voiceData = [voiceURLArray objectAtIndex:i];
                name = [NSString stringWithFormat:@"voices%ld%@.mp3",(long)i,[formatter stringFromDate:date]];
                if(voiceData){
                    
                    if(voiceURLArray.count == 1){
                        
                        [formData appendPartWithFileURL:voiceData name:voiceParameName fileName:name mimeType:@"video/mp3" error:nil];
                    }else{
                        [formData appendPartWithFileURL:voiceData name:[NSString stringWithFormat:@"%@", voiceParameName] fileName:name mimeType:@"video/mp3" error:nil];
                    }
                }
            }
        }
    }  success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self requestSuccessForResponseObject:responseObject andRequestId:requestId withResultBlock:resultBlock];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self requestFailureForError:error andRequestId:requestId withResultBlock:resultBlock];
    }];
}

#pragma mark ------------------ private

///设置请求
-(void)setRequest
{
    //设置请求格式，格式为字典 k-v
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    //超时时间
    self.requestSerializer.timeoutInterval = 45.0;
    //设置返回格式
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    //接收gzip压缩的json
    [self.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    
    //是否使用HTTPS
    if([[APP_SERVER componentsSeparatedByString:@"://"].firstObject isEqualToString:@"https"]){
        //HTTPS请求
        [self setSecurityPolicy:[self customSecurityPolicy]];
    }
}

/// 重新请求网络(网络请求错误重复请求)
-(void)againRequestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
     requestCount:(NSInteger)count
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock
{
    [self setRequest];
    
    [self POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self requestSuccessForResponseObject:responseObject andRequestId:requestId withResultBlock:resultBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(count > 2){
            [self requestFailureForError:error andRequestId:requestId withResultBlock:resultBlock];
        }else{
            [self againRequestUrl:url dictionaryParam:param requestCount:count + 1 retquestId:requestId withResultBlock:resultBlock];
        }
    }];
}

/*
 *  JSON解析返回数据
 *
 *  @param  data  解析数据
 *
 *  @return 返回json解析数据
 */
- (id)JSONObjectWithData:(NSData *)data {
    
    if([data isKindOfClass:[NSDictionary class]]){
        return data;
    }
    
    // 如果没有数据返回，则直接不解析
    if (data.length == 0) {
        
        return nil;
    }
    // 初始化解析错误
    NSError *error = nil;
    
    // JSON解析
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    return object;
}

///请求成功
-(void)requestSuccessForResponseObject:(id  _Nonnull)responseObject andRequestId:(NSString*)requestId withResultBlock:(HttpPostRequestResultBlock)resultBlock
{
    if (responseObject) {
        
        NSString *errCode = @"1";
        NSString *errMsg = @"未知错误";
        id data = nil;
        if (responseObject) {
            id objc = [self JSONObjectWithData:responseObject];
            
            if (objc) {
                
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                errCode = [numberFormatter stringFromNumber:[objc valueForKey:@"errCode"]];
                errMsg = [objc valueForKey:@"errMsg"];
                data = [objc valueForKey:@"data"];
            }
        }
        resultBlock(requestId, errCode, errMsg, data);
    }
}

///请求失败
-(void)requestFailureForError:(NSError * _Nonnull)error andRequestId:(NSString*)requestId withResultBlock:(HttpPostRequestResultBlock)resultBlock{
    
    if(error && error.code == -1009){
        if(resultBlock){
            resultBlock(requestId, @"-1009",@"网络未连接，请检查后重试",nil);
        }
    }else{
        if(resultBlock){
            resultBlock(requestId, @"-2",@"网络传输异常，请检查后重试",nil);
        }
    }
}

///对数据进行https ssl加密
- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hgcang" ofType:@"cer"];//证书的路径
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    //AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //securityPolicy.pinnedCertificates = @[certData];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    return securityPolicy;
}

#pragma mark 更新

///检测APP是否更新调用
- (void)checkAppWithAppId:(NSString *)appid IsUpdate:(checkAppVersonBlock)completion
{
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",appid];
    self.appID = appid;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 60;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    [connection start];
    _checkAppVersonBlock = completion;
}

///跳转到appStroe
- (void)toAppStore:(NSDictionary*)appInfo;
{
    NSString *iTunesLink = appInfo[@"trackViewUrl"];
    
    BOOL canOpenUrl = YES;
    
    canOpenUrl = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    
    if (canOpenUrl) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",self.appID]]];
    }
}

#pragma mark -- private

///接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",[res allHeaderFields]);
    
    self.recevieData = [NSMutableData data];
}

///接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.recevieData appendData:data];
}

///数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *objc = [self JSONObjectWithData:self.recevieData];
    
    if (objc) {
        
        if ([objc[@"resultCount"] longValue] <= 0) {
            return;
        }
        
        NSArray *results = [objc objectForKey:@"results"];
        
        NSDictionary *appInfo = [results objectAtIndex:0];
        
        NSString *latestVersion = [appInfo objectForKey:@"version"];
        
        NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        if ([self compareTwoVersonsByCurrentVerson:currentVersion andLastVerson:latestVersion]) {
            if (_checkAppVersonBlock) {
                _checkAppVersonBlock(YES, appInfo);
            }
        } else {
            if (_checkAppVersonBlock) {
                _checkAppVersonBlock(NO, nil);
            }
        }
        
    }
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

{
    //NSLog(@"%@",[error localizedDescription]);
}

///版本判断
- (BOOL)compareTwoVersonsByCurrentVerson:(NSString *)currentVerson andLastVerson:(NSString *)lastVerson {
    NSArray *currentArray = [currentVerson componentsSeparatedByString:@"."];
    NSArray *lastArray = [lastVerson componentsSeparatedByString:@"."];
    if ([currentArray[0] integerValue] < [lastArray[0] integerValue]) {
        return YES;
    }
    if ([currentArray[1] integerValue] < [lastArray[1] integerValue]) {
        return YES;
    }
    if ([currentArray[2] integerValue] < [lastArray[2] integerValue]) {
        return YES;
    }
    return NO;
}


@end
