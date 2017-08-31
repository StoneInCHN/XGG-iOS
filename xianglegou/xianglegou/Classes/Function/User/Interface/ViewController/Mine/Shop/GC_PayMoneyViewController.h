//
//  GC_PayMoneyViewController.h
//  xianglegou
//
//  Created by mini3 on 2017/5/15.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  支付 -- 界面
//

#import "Hen_BaseViewController.h"
#import "GC_ShopManagerModel.h"
@interface GC_PayMoneyViewController : Hen_BaseViewController

//商户ID
@property (nonatomic, strong) NSString *sellerId;
//订单编号
@property (nonatomic, strong) NSString *sn;
//商户名称
@property (nonatomic, strong) NSString *goodsName;
//让利金额
@property (nonatomic, strong) NSString *amount;
///商家信息
@property(nonatomic, strong) QL_ShopInformationDataModel *shopInfoData;
@end
