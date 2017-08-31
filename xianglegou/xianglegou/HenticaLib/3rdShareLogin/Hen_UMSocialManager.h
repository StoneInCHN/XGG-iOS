//
//  UMShareManager.h
//  MenLi
//
//  Created by mini3 on 16/7/7.
//  Copyright © 2016年 MenLi. All rights reserved.
//
/*
 http://dev.umeng.com/social/ios/quick-integration
 
 1, 在TARGETS->Build Settings->Other Linker Flags 中添加-ObjC。
 2, 加入依赖系统库
 libsqlite3.tbd
 新浪微博
 SystemConfiguration.framework
 CoreTelephony.framework
 ImageIO.framework
 libsqlite3.tbd
 libz.tbd
 微信
 SystemConfiguration.framework
 CoreTelephony.framework
 libsqlite3.tbd
 libc++.tbd
 libz.tbd
 QQ
 SystemConfiguration.framework
 libc++.tbd
 3, 配置第三方平台URL Scheme
 微信	微信appKey	wxdc1e388c3822c80b
 QQ/Qzone	以下两项都需添加：                                         appID：100424468           100424468转十六进制为5fc5b14，
            1、"tencent"+腾讯QQ互联应用appID                          1、tencent100424468        因不足8位向前补0，结果为05fc5b14，
            2、“QQ”+腾讯QQ互联应用appID转换成十六进制（不足8位前面补0）    2、QQ05fc5b14              加"QQ"前缀QQ05fc5b14
 新浪微博   “wb”+新浪appKey	wb3921700954
 
 常见问题
 1，分享面板无法弹出
 由于 1. 创建Xcode项目会默认添加Main.storyboard作为Main Interface(General - Deployment Info)，也就是项目的主Window。 2. 如果没使用Main.storyboard而又另外在AppDelegate中创建了UIWindow对象，如
 
 self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]
 
 如果项目中同时出现Main Interface以及代码创建UIWindow会导致分享面板无法正常弹出，解决方法是移除其一即可。如果移除了Main.storyboard，需要clean工程后再重新运行。
 
 2，iOS9使用微信、QQ登录功能时遇到了一些奇葩的现象。比如：使用QQ登录时调出来的是网页版的，微信登录提示没有安装微信客户端。这是因为在iOS9下需要增加一个可跳转的白名单，指定对应跳转App的URL Scheme，否则将在第三方平台判断是否跳转时用到的canOpenURL时返回NO，进而只进行webview授权或授权失败
 */

#import <Foundation/Foundation.h>

#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"

typedef NS_ENUM(NSInteger, ThirdLoginType){
    ThirdLoginTypeOfQQ = 1,     // qq登录
    ThirdLoginTypeOfWechat,     // 微信登录
    ThirdLoginTypeOfSina        // 新浪微博登录
};

@interface Hen_ShareDataModel : Hen_JsonModel

///分享标题
@property(nonatomic, strong) NSString *title;
///分享内容
@property(nonatomic, strong) NSString *content;
///分享url
@property(nonatomic, strong) NSString *url;
///分享图片
@property(nonatomic, strong) UIImage *image;

@end

@interface Hen_UMSocialManager : NSObject

///分享成功回调
@property(nonatomic, copy) void(^onShareSuccessBlock)();

+ (Hen_UMSocialManager *)shareManager;

- (void)shareConfig;

/// 自定义分享界面 platFormName:UMSocialPlatformType_Sina UMSocialPlatformType_WechatSession UMSocialPlatformType_WechatTimeLine UMSocialPlatformType_QQ UMSocialPlatformType_Qzone
- (void)shareToPlatForShareData:(Hen_ShareDataModel *)shareData andPlatform:(UMSocialPlatformType)platFormName andViewController:(UIViewController *)viewController;

/// 自带分享界面
- (void)shareUserOriginalUIForShareData:(Hen_ShareDataModel *)shareData andViewController:(UIViewController *)controller;

///第三方登录
- (void)thirdLoginForThirdLoginType:(ThirdLoginType)loginType presentingController:(UIViewController *)presentingController withResultBlock:(void (^)(BOOL isSuccess, NSString *uid, NSString *openId, NSString *nickname))block;

@end
