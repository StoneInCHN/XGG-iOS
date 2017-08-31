//
//  GC_MineMessageViewModel.m
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_MineMessageViewModel.h"

@implementation GC_MineMessageViewModel
///获取用户信息 方法
-(void)getUserInfoWithResultBlock:(RequestResultBlock)resultBlock
{
    if([[self.userInfoParam objectForKey:@"userId"] isEqualToString:@""] || [[self.userInfoParam objectForKey:@"token"] isEqualToString:@""]){
        if(resultBlock){
            resultBlock(@"", @"", nil, nil);
        }
        return;
    }
    
    NSString *requestId = [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getUserInfo dictionaryParam:self.userInfoParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:msg];
            
            DATAMODEL.userInfoData = self.userInfoData;
            
            DATAMODEL.isLogin = YES;
            
            [DATAMODEL.userDBHelper updateUserMoblie:self.userInfoData.cellPhoneNum];
            [DATAMODEL.userDBHelper updateUserId:self.userInfoData.id];
            
            
            if(resultBlock){
                resultBlock(code, desc, self.userInfoData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
    
    [[Hen_MessageManager shareMessageManager] addUnToLoginRequestId:requestId];
}


///退出登录 方法
-(void)setSignOutWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_logout dictionaryParam:self.signOutParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///修改头像 方法
-(void)setUploadPhoto:(UIImage*)image editUserPhotoDataWithResultBlock:(RequestResultBlock)resultBlock withUploadProgressBlock:(UploadProgressBlock)progressBlock{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_editUserPhoto dictionaryParam:self.editUserPhotoParam imageParamName:@"photo" image:image withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            //////self.userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.userInfoData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    } withProgressBlock:^(CGFloat total, CGFloat current) {
        if(progressBlock){
            progressBlock(total, current);
        }
    }];
}


///修改用户信息 方法
-(void)setEditUserInfoDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_editUserInfo dictionaryParam:[self.editUserInfoParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:msg];
            if(resultBlock){
                resultBlock(code, desc, self.userInfoData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}



///修改用户密码(包括登录密码和支付密码) 方法
- (void)setUserUpdatePwdDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_updatePwd dictionaryParam:self.updatePwdParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}





///验证支付密码 方法
-(void)setVerifyPayPwdDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_verifyPayPwd dictionaryParam:self.verifyPayPwdParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}





///微信授权 方法
-(void)setAuthorizationOfWechatDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_doAuthByWechat dictionaryParam:self.authorizationOfWechatParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///微信解除授权 方法
-(void)setDeauthorizeOfWechatDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_cancelAuthByWechat dictionaryParam:self.cancelAuthOfWechatParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}
#pragma mark -- getter,setter
///获取用户信息 参数
- (NSMutableDictionary *)userInfoParam
{
    if(!_userInfoParam){
        _userInfoParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_userInfoParam setObject:@"" forKey:@"userId"];
        //用户token
        [_userInfoParam setObject:@"" forKey:@"token"];
    }
    return _userInfoParam;
}

///获取用户信息 数据
- (GC_MResUserInfoDataModel *)userInfoData
{
    if(!_userInfoData){
        _userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _userInfoData;
}



///退出登录 参数
- (NSMutableDictionary *)signOutParam
{
    if(!_signOutParam){
        _signOutParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        ///用户id
        [_signOutParam setObject:@"" forKey:@"userId"];
        ///用户token
        [_signOutParam setObject:@"" forKey:@"token"];
    }
    return _signOutParam;
}


///修改头像 参数
- (NSMutableDictionary *)editUserPhotoParam
{
    if(!_editUserPhotoParam){
        _editUserPhotoParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_editUserPhotoParam setObject:@"" forKey:@"userId"];
        //用户token
        [_editUserPhotoParam setObject:@"" forKey:@"token"];
    }
    return _editUserPhotoParam;
}


///修改用户信息 参数
- (GC_EditUserInfoRequestDataModel *)editUserInfoParam
{
    if(!_editUserInfoParam){
        _editUserInfoParam = [[GC_EditUserInfoRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _editUserInfoParam;
}


///修改用户密码(包括登录密码和支付密码) 参数
- (NSMutableDictionary *)updatePwdParam
{
    if(!_updatePwdParam){
        _updatePwdParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID.
        [_updatePwdParam setObject:@"" forKey:@"userId"];
        //用户token
        [_updatePwdParam setObject:@"" forKey:@"token"];
        //用户手机号
        [_updatePwdParam setObject:@"" forKey:@"cellPhoneNum"];
        //密码(rsa加密)
        [_updatePwdParam setObject:@"" forKey:@"password"];
        //确认密码(rsa加密)
        [_updatePwdParam setObject:@"" forKey:@"password_confirm"];
        //短信验证码
        [_updatePwdParam setObject:@"" forKey:@"smsCode"];
        //验证码类型
        /** 修改登录密码 */
        //UPDATELOGINPWD,
        /** 修改支付密码 */
        //UPDATEPAYPWD
        [_updatePwdParam setObject:@"" forKey:@"smsCodeType"];

    }
    return _updatePwdParam;
}




///验证支付密码 参数
- (NSMutableDictionary *)verifyPayPwdParam
{
    if(!_verifyPayPwdParam){
        _verifyPayPwdParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //用户ID
        [_verifyPayPwdParam setObject:@"" forKey:@"userId"];
        //用户token
        [_verifyPayPwdParam setObject:@"" forKey:@"token"];
        //支付密码(rsa加密)
        [_verifyPayPwdParam setObject:@"" forKey:@"password"];
    }
    return _verifyPayPwdParam;
}




///微信授权 参数
- (NSMutableDictionary *)authorizationOfWechatParam
{
    if(!_authorizationOfWechatParam){
        _authorizationOfWechatParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_authorizationOfWechatParam setObject:@"" forKey:@"userId"];
        //用户token
        [_authorizationOfWechatParam setObject:@"" forKey:@"token"];
        //用户微信openid
        [_authorizationOfWechatParam setObject:@"" forKey:@"openId"];
        //用户微信昵称
        [_authorizationOfWechatParam setObject:@"" forKey:@"wxNickName"];
    }
    return _authorizationOfWechatParam;
}

///微信解除授权 参数
- (NSMutableDictionary *)cancelAuthOfWechatParam
{
    if(!_cancelAuthOfWechatParam){
        _cancelAuthOfWechatParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //用户ID
        [_cancelAuthOfWechatParam setObject:@"" forKey:@"userId"];
        //用户token
        [_cancelAuthOfWechatParam setObject:@"" forKey:@"token"];
    }
    return _cancelAuthOfWechatParam;
}
@end
