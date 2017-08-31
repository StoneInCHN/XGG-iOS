//
//  QL_AddAddressViewController.h
//  MenLi
//
//  Created by mini2 on 16/6/29.
//  Copyright © 2016年 MenLi. All rights reserved.
//
// 地址定位界面
//

#import "Hen_BaseViewController.h"

@interface QL_ShopAddressLocationViewController : Hen_BaseViewController

///经度
@property(nonatomic, strong) NSString *longitude;
///纬度
@property(nonatomic, strong) NSString *latitude;
///地址
@property(nonatomic, strong) NSString *address;
///店铺名
@property(nonatomic, strong) NSString *sellerName;

///完成回调
@property(nonatomic, copy) void(^onFinishBlock)(NSString *longitude, NSString *latitude, NSString *address);
@property(nonatomic, copy) void(^onFinishWithAreaBlock)(NSString *longitude, NSString *latitude, NSString *address, NSString *proName, NSString *cityName, NSString *areaName);

@end
