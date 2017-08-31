//
//  UMShareManager.m
//  MenLi
//
//  Created by mini3 on 16/7/7.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "Hen_UMSocialManager.h"
#import <UShareUI/UShareUI.h>

@implementation Hen_ShareDataModel

@end

@interface Hen_UMSocialManager ()

@end

static Hen_UMSocialManager *shareManager;

@implementation Hen_UMSocialManager {
    UIViewController *_viewController;
}

+ (Hen_UMSocialManager *)shareManager
{
    if (!shareManager) {
        shareManager = [[Hen_UMSocialManager alloc] init];
    }
    return shareManager;
}

- (void)shareConfig
{
    //设置友盟社会化组件appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_APPKey];
    [[UMSocialManager defaultManager] openLog:NO];
    
    //设置分享到QQ互联的appKey和appSecret
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APP_KEY  appSecret:QQ_APP_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINA_APP_KEY  appSecret:SINA_APP_SECRET redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

/// 自定义分享界面 platFormName: UMSocialPlatformType_Sina UMSocialPlatformType_WechatSession UMSocialPlatformType_WechatTimeLine UMSocialPlatformType_QQ UMSocialPlatformType_Qzone
- (void)shareToPlatForShareData:(Hen_ShareDataModel *)shareData andPlatform:(UMSocialPlatformType)platFormName andViewController:(UIViewController *)viewController
{
    if(platFormName == UMSocialPlatformType_WechatSession || platFormName == UMSocialPlatformType_WechatTimeLine){
        //检测是否安装微信
        if (![WXApi isWXAppInstalled]){
            //提示
            [DATAMODEL.progressManager showHint:@"分享失败，未安装微信客户端！"];
            return;
        }
    }
    [self shareForShareData:shareData toPlatformType:platFormName];
}

/// 自带分享界面
- (void)shareUserOriginalUIForShareData:(Hen_ShareDataModel *)shareData andViewController:(UIViewController *)controller
{
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_KEY appSecret:WX_APP_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    //显示分享面板
    WEAKSelf;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [weakSelf shareForShareData:shareData toPlatformType:platformType];
    }];
}

- (void)shareForShareData:(Hen_ShareDataModel *)shareData toPlatformType:(UMSocialPlatformType)platformType
{
    if(shareData){
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareData.title descr:shareData.content thumImage:shareData.image];
        //设置网页地址
        shareObject.webpageUrl = shareData.url;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        WEAKSelf;
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[DATAMODEL.henUtil getCurrentViewController] completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                //提示
                [DATAMODEL.progressManager showHint:@"分享失败！"];
            }else{
                NSLog(@"response data is %@",data);
                if(weakSelf.onShareSuccessBlock){
                    weakSelf.onShareSuccessBlock();
                }
            }
        }];
    }
}

///第三方登录
- (void)thirdLoginForThirdLoginType:(ThirdLoginType)loginType  presentingController:(UIViewController *)presentingControlle withResultBlock:(void (^)(BOOL isSuccess, NSString *uid, NSString *openId, NSString *nickname))block
{
    UMSocialPlatformType platformType = UMSocialPlatformType_UnKnown;
    if (loginType == ThirdLoginTypeOfQQ) {  // QQ
        platformType = UMSocialPlatformType_QQ;
    } else if (loginType == ThirdLoginTypeOfWechat) {  // 微信
        platformType = UMSocialPlatformType_WechatSession;
    } else if (loginType == ThirdLoginTypeOfSina) {  // 新浪微博
        platformType = UMSocialPlatformType_Sina;
    }
    
    //授权
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:[DATAMODEL.henUtil getCurrentViewController] completion:^(id result, NSError *error) {
        if (error) {
            if(block){
                block(NO, @"", @"", @"");
            }
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            if(block){
                block(YES, resp.uid, resp.openid, resp.name);
            }
        }
    }];
}

@end
