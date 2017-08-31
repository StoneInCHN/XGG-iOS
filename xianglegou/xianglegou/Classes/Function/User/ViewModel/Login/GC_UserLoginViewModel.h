//
//  GC_UserLoginViewModel.h
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "GC_MReqLoginDataModel.h"

@interface GC_UserLoginViewModel : Hen_BaseViewModel
///用户注册 参数
///@property (nonatomic, strong) NSMutableDictionary *userRegParam;
@property (nonatomic, strong) GC_UserRegisteredRequestDataModel *userRegParam;
///用户注册 方法
-(void)setUserRegWithResultBlock:(RequestResultBlock)resultBlock;


///找回用户登录密码 参数
@property (nonatomic, strong) NSMutableDictionary *resetPwdParam;
///找回用户登录密码 方法
-(void)getResetPwdWithResultBlock:(RequestResultBlock)resultBlock;


///用户信息 数据
@property (nonatomic, strong) GC_MResUserInfoDataModel *userInfoData;

///用户登录 参数

@property (nonatomic, strong) GC_UserLoginRequestDataModel *loginParam;

///@property (nonatomic, strong) NSMutableDictionary *loginParam;
///用户登录 方法
-(NSString *)getLoginWithResultBlock:(RequestResultBlock)resultBlock;

@end
