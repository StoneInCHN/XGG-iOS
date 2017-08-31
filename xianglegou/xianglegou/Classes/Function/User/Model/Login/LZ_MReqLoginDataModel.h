//
//  LZ_MReqLoginDataModel.h
//  HenticaSample
//
//  Created by mini1 on 2017/5/31.
//  Copyright © 2017年 HenticaSample. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZ_MReqLoginDataModel : Hen_JsonModel

@end


#pragma mark -- 用户登录请求数据

@interface LZ_UserLoginRequestDataModel : Hen_JsonModel
//手机号
@property (nonatomic, strong) NSString *cellPhoneNum;
//用户名密码（rsa加密）
@property (nonatomic, strong) NSString *password;

//验证码
@property (nonatomic, strong) NSString *smsCode;


@end
