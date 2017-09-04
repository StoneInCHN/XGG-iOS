//
//  DataModel.h
//  dentistry
//
//  Created by mini2 on 15/12/21.
//  Copyright © 2015年 hentica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QL_ConfigDBHelper.h"
#import "QL_UserDBHelper.h"
#import "GC_MineMessageModel.h"
#import "Hen_BaiduMapUtil.h"

@interface DataModel : Hen_BaseDataModel

////初始化一个单实例
+ (DataModel *)getInstance;

///是否登录
@property (nonatomic, assign) BOOL  isLogin;
///是否重新加载首页数据
@property(nonatomic, assign) BOOL isReloadHomeData;

///实名认证进入 界面来源   1、我的界面      2、我的银行卡界面     3、我的店铺界面    4、店铺录单界面   5、店铺货款界面   6、乐分提现界面
@property (nonatomic, strong) NSString *interfaceSource;


///Device Token
@property(nonatomic, strong) NSString *deviceToken;

///请求token
@property(nonatomic, strong) NSString *token;
///用户id
@property(nonatomic, strong) NSString *userId;
///店铺Id
@property(nonatomic, strong) NSString *sellerId;
///城市id
@property(nonatomic, strong) NSString *cityId;
///城市名
@property(nonatomic, strong) NSString *cityName;
///默认城市
@property(nonatomic, strong) NSString *defaultCityName;
///定位城市
@property(nonatomic, strong) NSString *locationCityName;
///所在位置纬度
@property(nonatomic, strong) NSString *latitude;
///所在位置经度
@property(nonatomic, strong) NSString *longitude;
/// jpush registerId
@property(nonatomic, strong) NSString *registerId;

///RSA publickey
@property(nonatomic, strong) NSString *RSAPublickey;

///用户信息 数据
@property (nonatomic, strong) GC_MResUserInfoDataModel *userInfoData;


///配置数据库帮助类
@property(nonatomic, strong) QL_ConfigDBHelper *configDBHelper;
///用户数据库帮助类
@property(nonatomic, strong) QL_UserDBHelper *userDBHelper;
///百度地图工具类
@property(nonatomic, strong) Hen_BaiduMapUtil *baiduMapUtil;

///加载RSA publickey
- (void)loadRSAPublickey;
///RSA加密字符串
- (NSString *)RSAEncryptorString:(NSString *)originalString;
///同步用户数据
- (void)synchronizationUserInfo;



@end
