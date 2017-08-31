//
//  GC_MReqLoginDataModel.h
//  Rebate
//
//  Created by mini3 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_MReqLoginDataModel : Hen_JsonModel

@end


#pragma mark -- 用户注册请求数据

@interface GC_UserRegisteredRequestDataModel : Hen_JsonModel
//手机号
@property (nonatomic, strong) NSString *cellPhoneNum;
//短信验证码
@property (nonatomic, strong) NSString *smsCode;
//密码（rsa加密）
@property (nonatomic, strong) NSString *password;
//确认密码（rsa加密）
@property (nonatomic, strong) NSString *password_confirm;
//推荐人手机号.
@property (nonatomic, strong) NSString *recommenderMobile;

@end


#pragma mark -- 用户登录请求数据

@interface GC_UserLoginRequestDataModel : Hen_JsonModel
//手机号
@property (nonatomic, strong) NSString *cellPhoneNum;
//用户名密码（rsa加密）
@property (nonatomic, strong) NSString *password;
//短信验证码
@property (nonatomic, strong) NSString *smsCode;
@end
