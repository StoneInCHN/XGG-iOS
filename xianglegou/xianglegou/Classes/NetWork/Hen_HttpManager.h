//
//  HTC_HttpManager.h
//  CRM
//
//  Created by mini2 on 16/5/25.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

typedef void(^HttpPostRequestResultBlock)(NSString*requestId, NSString* code, NSString* desc, id msg, id page);
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


///实名认证
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
     cardFrontPic:(NSData *)cardFrontPic
      cardBackPic:(NSData *)cardBackPic
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock;

//请求入驻
-(void)requestUrl:(NSString*)url
  dictionaryParam:(NSDictionary*)param
     storePicture:(NSData *)storePicture
       licenseImg:(NSData *)licenseImg
          envImgs:(NSArray*)envImgs
   commitmentImgs:(NSArray*)commitmentImgs
       retquestId:(NSString*)requestId
  withResultBlock:(HttpPostRequestResultBlock)resultBlock;

///get请求
- (void)requestGetWithUrl:(NSString *)url
          dictionaryParam:(NSDictionary *)param
          withResultBlock:(HttpPostRequestResultBlock)resultBlock;

#pragma mark -- 更新

///检测APP是否更新调用
- (void)checkAppWithAppId:(NSString *)appid IsUpdate:(checkAppVersonBlock)completion;

///跳转到appStroe
- (void)toAppStore:(NSDictionary*)appInfo;

@end
