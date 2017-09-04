//
//  AppDelegate.m
//  HenticaSample
//
//  Created by mini2 on 16/11/17.
//  Copyright © 2016年 HenticaSample. All rights reserved.
//

#import "AppDelegate.h"
#import "QL_WaiteViewController.h"
#import "GC_LoginViewController.h"
#import "RebateTabBarViewController.h"
#import "UserPushViewModel.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property(nonatomic, strong) Hen_AppDelegateManager *appDelegateManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.appDelegateManager = [Hen_AppDelegateManager shareAppDelegateManager];
    //相关初始化
    [self.appDelegateManager relatedInitialization];
    //添加登录
    [self loadLogin];
    //获取配置数据
    [self getConfigData];
    //同步用户数据
    [DATAMODEL synchronizationUserInfo];
    //开启定位
    [self startLocation];
    /// 判断是否有推送消息
    [self chheckePushWithOptions:launchOptions];
    //初始化极光推送
    [self initJPushForDidFinishLaunchingWithOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[QL_WaiteViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    ///出去
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //进入前台 同步用户信息
    [DATAMODEL synchronizationUserInfo];
    DATAMODEL.isReloadHomeData = YES;
    
    
    
    ////进来
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- 跳转回来

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.appDelegateManager application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.appDelegateManager application:application handleOpenURL:url];
}

#pragma mark -- push

///注册DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self.appDelegateManager application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"=====DeviceToken:%@", deviceTokenStr);
    DATAMODEL.deviceToken = deviceTokenStr;
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

///接收到通知 后台执行多任务
- (void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    if (application.applicationState == UIApplicationStateActive) { // 前台运行
        [DATAMODEL.progressManager showHint:[NSString stringWithFormat:@"收到推送消息：%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]];
    } else if (application.applicationState == UIApplicationStateInactive) { // 后台运行
        [[[UIApplication sharedApplication] delegate] window].rootViewController = [[RebateTabBarViewController alloc] init];
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    [self.appDelegateManager application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

///错误处理
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self.appDelegateManager application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

#pragma mark -- private

///获取配置数据
-(void)getConfigData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    __block NSString *dbPath = @"";
    [DATAMODEL.henUtil asynchronousLoadingBlock:^{
        //文件拷贝
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        dbPath = [documentsDirectory stringByAppendingPathComponent:@"area.db"];
        
        if([fileManager fileExistsAtPath:dbPath] == NO){
            NSString*resourcePath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"db"];
            [fileManager copyItemAtPath:resourcePath toPath:dbPath error:&error];
        }
    } finishBlock:^{
    }];
    
    //获取RSA公钥
    [DATAMODEL loadRSAPublickey];
    
    DATAMODEL.token = [DATAMODEL.userDBHelper getToken];
    DATAMODEL.cityId = [DATAMODEL.userDBHelper getCityId];
    DATAMODEL.cityName = [DATAMODEL.configDBHelper getCityNameForCityId:DATAMODEL.cityId];
    DATAMODEL.userId = [DATAMODEL.userDBHelper getUserId];
}

///添加登录
-(void)loadLogin
{
    GC_LoginViewController *loginVC = [[GC_LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [Hen_MessageManager shareMessageManager].loginVc = loginVC;
}

///定位
- (void)startLocation
{

    //回调
    DATAMODEL.baiduMapUtil.onLocationBlock = ^(NSString *longitude, NSString *latitude){
        if([longitude floatValue] > 0 && [latitude floatValue] > 0){
            DATAMODEL.longitude = longitude;
            DATAMODEL.latitude = latitude;
        }
    };
    DATAMODEL.baiduMapUtil.onLocationCityBlock = ^(NSString* cityName){
        if([[DATAMODEL.userDBHelper getCityId] isEqualToString:@""]){
            DATAMODEL.cityId = [DATAMODEL.configDBHelper getCityIdForCityName:cityName];
        }
        DATAMODEL.locationCityName = cityName;
        
        [DATAMODEL.baiduMapUtil cleanMap];
    };
    //初始化百度地图
    [DATAMODEL.baiduMapUtil initBaiduMap];
}

///初始化极光推送
- (void)initJPushForDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"185adad8b0cb08eb9a2e6354"
                          channel:@"channel"
                 apsForProduction:0
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (registrationID.length != 0) {
            DATAMODEL.registerId = registrationID;
            if (DATAMODEL.token.length != 0 && DATAMODEL.userId.length != 0) {
                UserPushViewModel * viewModel = [[ UserPushViewModel alloc]init];
                [viewModel uploadPushRegisterId];
            }
        }
    }];
}

/// 判断是否有推送消息
- (void)chheckePushWithOptions: (NSDictionary *)launchOptions {
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"push message: %@", userInfo);
    }
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


@end
