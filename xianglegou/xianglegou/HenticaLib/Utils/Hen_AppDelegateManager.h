//
//  HTC_AppDelegateManager.h
//  Exam
//
//  Created by mini2 on 16/9/5.
//  Copyright © 2016年 Exam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hen_AppDelegateManager : NSObject

///初始化一个单实例
+ (Hen_AppDelegateManager *)shareAppDelegateManager;

///相关初始化
-(void)relatedInitialization;

#pragma mark -- 跳转回来

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

#pragma mark -- push

///注册DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
///接收到通知 后台执行多任务
- (void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
///错误处理
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;



@end
