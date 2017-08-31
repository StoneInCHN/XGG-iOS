//
//  DataModel.m
//  dentistry
//
//  Created by mini2 on 15/12/21.
//  Copyright © 2015年 hentica. All rights reserved.
//

#import "DataModel.h"
#import "RSAEncryptor.h"

@implementation DataModel

static DataModel *_dataModel = nil;

+ (DataModel *)getInstance
{
    //初始化一个只执行一次的线程
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataModel = [[self alloc] init];
        
        _dataModel.isLogin = NO;
        _dataModel.deviceToken = @"";
        _dataModel.defaultCityName = @"成都市";
        _dataModel.longitude = @"";
        _dataModel.latitude = @"";
    });
    return _dataModel;
}

///加载RSA publickey
- (void)loadRSAPublickey
{
    if(self.RSAPublickey.length <= 0){
        NSString *requestId = [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_rsa dictionaryParam:nil withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            if([code isEqualToString:@"0000"]){
                DATAMODEL.RSAPublickey = desc;
            }
        }];
        [[Hen_MessageManager shareMessageManager] addUnNoticeNetworkErrorRequestId:requestId];
    }
}

///RSA加密字符串
- (NSString *)RSAEncryptorString:(NSString *)originalString
{
    return [RSAEncryptor encryptString:originalString publicKey:self.RSAPublickey];
}

///同步用户数据
- (void)synchronizationUserInfo
{
    //参数
    NSMutableDictionary *userInfoParam = [[NSMutableDictionary alloc] initWithCapacity:0];
    //用户ID
    [userInfoParam setObject:self.userInfoData.id forKey:@"userId"];
    //用户token
    [userInfoParam setObject:self.token forKey:@"token"];
    //请求
    NSString *requestId = [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getUserInfo dictionaryParam:userInfoParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            self.userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:msg];
            
            DATAMODEL.isLogin = YES;
            
            [DATAMODEL.userDBHelper updateUserMoblie:self.userInfoData.cellPhoneNum];
            [DATAMODEL.userDBHelper updateUserId:self.userInfoData.id];
        }else{
            DATAMODEL.isLogin = NO;
        }
    }];
    [[Hen_MessageManager shareMessageManager] addUnToLoginRequestId:requestId];
    [[Hen_MessageManager shareMessageManager] addUnNoticeNetworkErrorRequestId:requestId];
}

#pragma mark -- getter, setter

-(QL_ConfigDBHelper*)configDBHelper
{
    if(!_configDBHelper){
        _configDBHelper = [[QL_ConfigDBHelper alloc] init];
    }
    return _configDBHelper;
}

- (QL_UserDBHelper *)userDBHelper
{
    if(!_userDBHelper){
        _userDBHelper = [[QL_UserDBHelper alloc] init];
    }
    return _userDBHelper;
}

///百度地图工具类
- (Hen_BaiduMapUtil *)baiduMapUtil
{
    if(!_baiduMapUtil){
        _baiduMapUtil = [[Hen_BaiduMapUtil alloc] init];
    }
    return _baiduMapUtil;
}

///用户信息
- (GC_MResUserInfoDataModel *)userInfoData
{
    if(!_userInfoData){
        _userInfoData = [[GC_MResUserInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _userInfoData;
}

///设置token
- (void)setToken:(NSString *)token
{
    _token = token;
    if(![token isEqualToString:@""]){
        [self.userDBHelper updateToken:token];
    }
}

///设置用户id
- (void)setUserId:(NSString *)userId
{
    _userId = userId;
    self.userInfoData.id = userId;
    if(![userId isEqualToString:@""]){
        [self.userDBHelper updateUserId:userId];
    }
}

- (void)setSellerId:(NSString *)sellerId
{
    _sellerId = sellerId;
}

///设置城市
- (void)setCityId:(NSString *)cityId
{
    _cityId = cityId;
    if(![cityId isEqualToString:@""]){
        [self.userDBHelper updateCityId:cityId];
        self.cityName = [self.configDBHelper getCityNameForCityId:cityId];
    }
}




@end
