//
//  SetupPushRequestParam.h
//  xianglegou
//
//  Created by lieon on 2017/9/4.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface SetupPushRequestParam : Hen_JsonModel
/*用户ID*/
@property (nonatomic, strong) NSString *userId;
/*用户token*/
@property (nonatomic, strong) NSString *token;
/*推送regID*/
@property (nonatomic, strong) NSString *jpushRegId;
/*手机平台*/
@property (nonatomic, strong) NSString *appPlatform;
// 推送开关 true:开启; false:
@property(nonatomic, assign) NSString * msgSwitch;
@end
