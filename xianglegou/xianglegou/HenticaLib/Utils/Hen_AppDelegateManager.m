//
//  HTC_AppDelegateManager.m
//  Exam
//
//  Created by mini2 on 16/9/5.
//  Copyright © 2016年 Exam. All rights reserved.
//

#import "Hen_AppDelegateManager.h"

#import "IQKeyboardManager.h"
#import "CoreData+MagicalRecord.h"
#import "Hen_UMSocialManager.h"
#import "Hen_PayManager.h"

static NSString *const kStoryName = @"app_user.db";

@interface Hen_AppDelegateManager()<WXApiDelegate>

@end

@implementation Hen_AppDelegateManager

static Hen_AppDelegateManager *_adManager = nil;

///初始化一个单实例
+ (Hen_AppDelegateManager *)shareAppDelegateManager
{
    //初始化一个只执行一次的线程
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _adManager = [[self alloc] init];
    });
    return _adManager;
}

///相关初始化
-(void)relatedInitialization
{
    //初始化MagicalCoreData
    [self initMagicalRecord];
    
    //初始化IQKeyboardManager
    [self initIQKeyboardManager];
    
    // 注册APNS推送
    //[self registerAPNSPush];
    
    //初始化支付
    [[Hen_PayManager sharedManager] initPay];
    
    //初始化友盟
    [[Hen_UMSocialManager shareManager] shareConfig];
}

#pragma mark -- 跳转回来

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[UMSocialManager defaultManager] handleOpenURL:url];
    
    [[Hen_PayManager sharedManager] onUPPayOpenURL:url];
    
    [[Hen_PayManager sharedManager] onAlipayOpenURL:url];
    
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[UMSocialManager defaultManager] handleOpenURL:url];
    
    [[Hen_PayManager sharedManager] onUPPayOpenURL:url];
    
    [[Hen_PayManager sharedManager] onAlipayOpenURL:url];
    
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

#pragma mark -- push

///注册DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
     NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"=====DeviceToken:%@", deviceTokenStr);
}

///接收到通知 后台执行多任务
- (void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    if (application.applicationState == UIApplicationStateActive) { // 前台运行
        
    } else if (application.applicationState == UIApplicationStateInactive) { // 后台运行
       
    }
    
    // 图标上的数字减1
    //application.applicationIconBadgeNumber -= 1;
    
    completionHandler(UIBackgroundFetchResultNewData);
}

///错误处理
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"=====注册APNS推送 error: %@", error);
}

#pragma mark -- private

///初始化存储
-(void)initMagicalRecord{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kStoryName];
    
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]])
    {
        
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kStoryName stringByDeletingPathExtension] ofType:[kStoryName pathExtension]];
        
        if (defaultStorePath)
        {
            NSError *error;
            BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success)
            {
                
            }else {
                
            }
        }
    }
    
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelWarn];
    [MagicalRecord setupCoreDataStackWithStoreNamed:kStoryName];
}

///初始化键盘管理
-(void)initIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

///注册APNS推送
-(void)registerAPNSPush
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                   UIRemoteNotificationTypeSound |
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

#pragma mark -- WXApiDelegate

-(void) onResp:(BaseResp*)resp
{
    [[Hen_PayManager sharedManager] onWXPayResp:resp];
}

@end
