//
//  QL_UserOrderDetailsViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 商家订单详情界面
//

#import "Hen_BaseViewController.h"
#import "QL_ShopModel.h"

@interface QL_ShopOrderDetailsViewController : Hen_BaseViewController

///订单数据
@property (nonatomic, strong) QL_ShopOrderListDataModel *orderData;

///是否结算
@property (nonatomic, strong) NSString *isClearing;
@end
