//
//  QL_ShopRequestDataModel.h
//  Rebate
//
//  Created by mini2 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface QL_ShopRequestDataModel : Hen_JsonModel

@end

#pragma mark -- 入驻请求数据

@interface QL_SettledShopRequestDataModel : Hen_JsonModel

///用户ID
@property(nonatomic, strong) NSString *userId;
///用户token
@property(nonatomic, strong) NSString *token;
///入驻请求ID
@property(nonatomic, strong) NSString *applyId;
///店铺名称
@property(nonatomic, strong) NSString *sellerName;
///店铺联系人手机号
@property(nonatomic, strong) NSString *contactCellPhone;
///店铺详细地址
@property(nonatomic, strong) NSString *address;
///店铺电话
@property(nonatomic, strong) NSString *storePhone;
///营业执照号
@property(nonatomic, strong) NSString *licenseNum;
///店铺简介
@property(nonatomic, strong) NSString *note;
///纬度
@property(nonatomic, strong) NSString *latitude;
///经度
@property(nonatomic, strong) NSString *longitude;
///折扣
@property(nonatomic, strong) NSString *discount;
///地区ID
@property(nonatomic, strong) NSString *areaId;
///行业类别ID
@property(nonatomic, strong) NSString *categoryId;

@end

#pragma mark -- 修改商户信息请求数据

@interface QL_EditShopRequestDataModel : Hen_JsonModel

///用户ID
@property(nonatomic, strong) NSString *userId;
///用户token
@property(nonatomic, strong) NSString *token;
///商家ID
@property(nonatomic, strong) NSString *sellerId;
///店铺名称
@property(nonatomic, strong) NSString *sellerName;
///人均消费
@property(nonatomic, strong) NSString *avgPrice;
///地区ID
@property(nonatomic, strong) NSString *areaId;
///店铺详细地址
@property(nonatomic, strong) NSString *address;
///店铺电话
@property(nonatomic, strong) NSString *storePhone;
///店铺简介
@property(nonatomic, strong) NSString *note;
///纬度
@property(nonatomic, strong) NSString *latitude;
///经度
@property(nonatomic, strong) NSString *longitude;
///其他服务
@property(nonatomic, strong) NSString *featuredService;
///营业时段 “8:00-22:00”
@property(nonatomic, strong) NSString *businessTime;

@end
