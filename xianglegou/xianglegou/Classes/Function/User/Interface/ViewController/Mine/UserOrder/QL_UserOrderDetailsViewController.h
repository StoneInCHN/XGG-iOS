//
//  QL_UserOrderDetailsViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 用户订单详情界面
//

#import "Hen_BaseViewController.h"
#import "GC_UserOrderInfoModel.h"


@interface QL_UserOrderDetailsViewController : Hen_BaseViewController

///订单数据
@property (nonatomic, strong) GC_MResOrderUnderUserDataModel *orderData;

///订单id
@property(nonatomic, strong) NSString *orderId;
///进入方式 0：默认；1：支付
@property(nonatomic, assign) NSInteger enterType;

@end
