//
//  HTC_HttpManager.h
//  CRM
//
//  Created by mini2 on 16/5/25.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

typedef void(^HttpPostRequestResultBlock)(NSString*requestId, NSString* errCode, NSString* errMsg, id data);
typedef void(^HttpUploadProgressBlock)(CGFloat total, CGFloat current);
typedef void(^checkAppVersonBlock)(BOOL isUpdate, id appInfo);

@interface Hen_HttpManager : AFHTTPRequestOperationManager


/// 请求网络
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock;

/// 请求网络 （上传单张图片）
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
   imageParamName:(NSString*)imageParamName
   imageDataParam:(NSData*)imageData
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock
withProgressBlock:(HttpUploadProgressBlock)progressBlock;

///请求网络（上传多张图片）
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
  imageParameName:(NSString*)imageParameName
       imageArray:(NSArray*)imageDatas
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock;

///请求网络（上传音频）
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
  voiceParameName:(NSString*)voiceParameName
       voiceURLArray:(NSArray*)voiceURLArray
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock;

#pragma mark -- 更新

///检测APP是否更新调用
- (void)checkAppWithAppId:(NSString *)appid IsUpdate:(checkAppVersonBlock)completion;

///跳转到appStroe
- (void)toAppStore:(NSDictionary*)appInfo;

@end
