//
//  GC_UserLoginViewModel.m
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_UserLoginViewModel.h"

@implementation GC_UserLoginViewModel
///用户注册 方法
-(void)setUserRegWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_reg dictionaryParam:[self.userRegParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:msg];
            
            DATAMODEL.userInfoData = self.userInfoData;
            DATAMODEL.isLogin = YES;
            
            [DATAMODEL.userDBHelper updateUserMoblie:self.userInfoData.cellPhoneNum];
            [DATAMODEL.userDBHelper updateUserId:self.userInfoData.id];
            
            
            if(resultBlock){
                resultBlock(code, desc, self.userInfoData, page);
            }
            
            //重新请求
            [[Hen_MessageManager shareMessageManager] reRequst];
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
        
    }];
}


///找回用户登录密码 方法
- (void)getResetPwdWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_resetPwd dictionaryParam:self.resetPwdParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///用户登录 方法
-(NSString *)getLoginWithResultBlock:(RequestResultBlock)resultBlock
{
    NSString *requsetId = [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_login dictionaryParam:[self.loginParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ //成功
            self.userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:msg];
            
            DATAMODEL.userInfoData = self.userInfoData;
            DATAMODEL.isLogin = YES;
            
            [DATAMODEL.userDBHelper updateUserMoblie:self.userInfoData.cellPhoneNum];
            [DATAMODEL.userDBHelper updateUserId:self.userInfoData.id];
            
            if(resultBlock){
                resultBlock(code, desc, self.userInfoData, page);
            }
            
            //重新请求
            [[Hen_MessageManager shareMessageManager] reRequst];
            
        }else{  //失败
            if(resultBlock){
                resultBlock(code, desc, self.userInfoData, page);
            }
        }
    }];
    return requsetId;
}


#pragma mark -- getter,setter
///用户注册 参数
- (GC_UserRegisteredRequestDataModel *)userRegParam
{
    if(!_userRegParam){
        _userRegParam = [[GC_UserRegisteredRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _userRegParam;
}
//- (NSMutableDictionary *)userRegParam
//{
//    if(!_userRegParam){
//        _userRegParam = [[NSMutableDictionary alloc] initWithCapacity:0];
//        //手机号
//        [_userRegParam setObject:@"" forKey:@"cellPhoneNum"];
//        //短信验证码
//        [_userRegParam setObject:@"" forKey:@"smsCode"];
//        //密码（rsa加密）
//        [_userRegParam setObject:@"" forKey:@"password"];
//        //确认密码（rsa加密）
//        [_userRegParam setObject:@"" forKey:@"password_confirm"];
//        //推荐人手机号
//        [_userRegParam setObject:@"" forKey:@"recommenderMobile"];
//    }
//    return _userRegParam;
//}

///找回用户登录密码 参数
- (NSMutableDictionary *)resetPwdParam
{
    if(!_resetPwdParam){
        _resetPwdParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //用户手机号
        [_resetPwdParam setObject:@"" forKey:@"cellPhoneNum"];
        //密码(rsa加密)
        [_resetPwdParam setObject:@"" forKey:@"password"];
        //确认密码(rsa加密)
        [_resetPwdParam setObject:@"" forKey:@"password_confirm"];
        //短信验证码
        [_resetPwdParam setObject:@"" forKey:@"smsCode"];
    }
    return _resetPwdParam;
}


///用户数据
- (GC_MResUserInfoDataModel *)userInfoData
{
    if(!_userInfoData){
        _userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _userInfoData;
}



///用户登录 参数
- (GC_UserLoginRequestDataModel *)loginParam
{
    if(!_loginParam){
        _loginParam = [[GC_UserLoginRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _loginParam;
}
//- (NSMutableDictionary *)loginParam
//{
//    if(!_loginParam){
//        _loginParam = [[NSMutableDictionary alloc] initWithCapacity:0];
//        //手机号
//        [_loginParam setObject:@"" forKey:@"cellPhoneNum"];
//        //用户名密码（rsa加密）
//        [_loginParam setObject:@"" forKey:@"password"];
//        //短信验证码
//        [_loginParam setObject:@"" forKey:@"smsCode"];
//    }
//    return _loginParam;
//}


@end
