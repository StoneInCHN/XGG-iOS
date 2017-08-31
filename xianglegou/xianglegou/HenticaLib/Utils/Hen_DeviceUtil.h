//
//  Hen_DeviceUtil.h
//  Peccancy
//
//  Created by mini2 on 16/11/3.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hen_DeviceUtil : NSObject

///获取设备唯一标识
+(NSString*)getIdentifier;

///获取手机别名
+(NSString*)getUserPhoneName;

///获取设备名称
+(NSString*)getDeviceName;

///获取手机系统版本
+(NSString*)getPhoneVersion;

///获取手机型号
+(NSString*)getPhoneModel;

/// 当前应用软件版本 比如：1
+(NSString*)getAppCurrentVersion;

/// 当前应用版本号码  比如：1.0.1
+(NSString*)getAppCurrentVersionName;

///获取当前设备的IP地址
+(NSString*)getIPAddress;

///获取当前设备的MAC地址
+(NSString*)getMacAddress;

///获取app名字
+(NSString*)getAppName;

///获取BundleID
+(NSString*)getBundleID;

///获取项目名称
+ (NSString *)getExecutableFile;

@end
