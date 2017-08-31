//
//  MessageManager.h
//  Vpn
//
//  Created by jiwuwang on 15/9/17.
//  Copyright (c) 2015年 jiwuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "Hen_HttpManager.h"
#import "Hen_BaseLoginViewController.h"


///请求结果回调
typedef void(^RequestResultBlock)(NSString* code, NSString* desc, id msg, id page);
///缓存结果回调
typedef void(^CacheResultBlock)(id data);
///上传进度回调
typedef void(^UploadProgressBlock)(CGFloat total, CGFloat current);
///检测更新回调
typedef void(^CheckAppVersonBlock)(BOOL isUpdate, id updateInfo);

///请求类型
typedef NS_ENUM(NSInteger, RequsetType){
    RequsetTypeOfNormal = 1,    // 普通
    RequsetTypeOfCache,         // 缓存
    RequsetTypeOfImage,         // 带图片
    RequsetTypeOfImageArray     // 多张图片
};

@interface Hen_MessageManager : NSObject

///登录viewController
@property(nonatomic, strong) Hen_BaseLoginViewController *loginVc;
///是否到登录
@property(nonatomic, assign) BOOL isToLogin;

+ (Hen_MessageManager *)shareMessageManager;

///请求数据
- (NSString*)requestWithAction:(NSString *)action
               dictionaryParam:(NSDictionary *)param
               withResultBlock:(RequestResultBlock)resultBlock;

///请求数据(缓存请求返回数据)
- (NSString*)requestWithAction:(NSString *)action
               dictionaryParam:(NSDictionary *)param
                 cacheFileName:(NSString*)fileName
               withResultBlock:(RequestResultBlock)resultBlock
          withCacheResultBlock:(CacheResultBlock)cacheBlock;

///请求数据，带图片
- (NSString*)requestWithAction:(NSString *)action
          dictionaryParam:(NSDictionary *)param
           imageParamName:(NSString*)imageParamName
                    image:(UIImage *)image
          withResultBlock:(RequestResultBlock)resultBlock
        withProgressBlock:(UploadProgressBlock)progressBlock;

///请求数据（上传多张图片）
-(NSString*)requestWithAction:(NSString *)action
         dictionaryParam:(NSDictionary*)param
         imageParameName:(NSString*)imageParameName
              imageArray:(NSArray*)imageDatas
         withResultBlock:(RequestResultBlock)resultBlock;

///实名认证
-(NSString*)requestIdentityWithAction:(NSString *)action
                      dictionaryParam:(NSDictionary *)param
                         cardFrontPic:(UIImage *)cardFrontPic
                          cardBackPic:(UIImage *)cardBackPic
                      withResultBlock:(RequestResultBlock)resultBlock;


///请求入驻
- (NSString *)requestApplyWithAction:(NSString *)action
                     dictionaryParam:(NSDictionary*)param
                        storePicture:(UIImage *)storePicture
                          licenseImg:(UIImage *)licenseImg
                             envImgs:(NSMutableArray*)envImgs
                      commitmentImgs:(NSMutableArray*)commitmentImgs
                     withResultBlock:(RequestResultBlock)resultBlock;

///get请求
- (void)requestGetWithUrl:(NSString *)url
          dictionaryParam:(NSDictionary *)param
          withResultBlock:(RequestResultBlock)resultBlock;


///添加不提示网络错误请求
-(void)addUnNoticeNetworkErrorRequestId:(NSString*)requestId;

///添加不跳转登录请求
-(void)addUnToLoginRequestId:(NSString*)requestId;

///重新请求
-(void)reRequst;

#pragma mark -- 更新

///检测 app 是否跟新时使用
- (void)checkAppIsUpdateAPPID:(NSString *)appid andBlock:(CheckAppVersonBlock)completion;

@end
