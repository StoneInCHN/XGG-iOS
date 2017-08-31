//
//  GC_MineMessageViewModel.h
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  我的信息 -- ViewModel
//

#import "Hen_BaseViewModel.h"
#import "GC_UserInfoRequestDataModel.h"

@interface GC_MineMessageViewModel : Hen_BaseViewModel

///获取用户信息 参数
@property (nonatomic, strong) NSMutableDictionary *userInfoParam;
///获取用户信息 数据
@property (nonatomic, strong) GC_MResUserInfoDataModel *userInfoData;
///获取用户信息 方法
-(void)getUserInfoWithResultBlock:(RequestResultBlock)resultBlock;




///退出登录 参数
@property (nonatomic, strong) NSMutableDictionary *signOutParam;
///退出登录 方法
-(void)setSignOutWithResultBlock:(RequestResultBlock)resultBlock;

///修改头像 参数
@property (nonatomic, strong) NSMutableDictionary *editUserPhotoParam;
///修改头像 方法
-(void)setUploadPhoto:(UIImage*)image editUserPhotoDataWithResultBlock:(RequestResultBlock)resultBlock withUploadProgressBlock:(UploadProgressBlock)progressBlock;


///修改用户信息 参数
@property (nonatomic, strong) GC_EditUserInfoRequestDataModel *editUserInfoParam;
///修改用户信息 方法
-(void)setEditUserInfoDataWithResultBlock:(RequestResultBlock)resultBlock;



///修改用户密码(包括登录密码和支付密码) 参数
@property (nonatomic, strong) NSMutableDictionary *updatePwdParam;
///修改用户密码(包括登录密码和支付密码) 方法
-(void)setUserUpdatePwdDataWithResultBlock:(RequestResultBlock)resultBlock;



///验证支付密码 参数
@property (nonatomic, strong) NSMutableDictionary *verifyPayPwdParam;
///验证支付密码 方法
-(void)setVerifyPayPwdDataWithResultBlock:(RequestResultBlock)resultBlock;


///微信授权 参数
@property (nonatomic, strong) NSMutableDictionary *authorizationOfWechatParam;
///微信授权 方法
-(void)setAuthorizationOfWechatDataWithResultBlock:(RequestResultBlock)resultBlock;

///微信解除授权 参数
@property (nonatomic, strong) NSMutableDictionary *cancelAuthOfWechatParam;
///微信解除授权 方法
-(void)setDeauthorizeOfWechatDataWithResultBlock:(RequestResultBlock)resultBlock;



@end
