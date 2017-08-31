//
//  QL_PaymentMethodViewController.h
//  Peccancy
//
//  Created by mini2 on 16/10/20.
//  Copyright © 2016年 Peccancy. All rights reserved.
//
// 支付方式界面
//

#import "Hen_BaseTableViewController.h"

@interface Hen_PaymentMethodViewController : Hen_BaseTableViewController

///订单id
@property(nonatomic, strong) NSString *orderId;
/// 可用的支付方式
@property(nonatomic, strong) NSMutableArray<Hen_PaymentDataModel*> *paymentList;

///返回回调
@property(nonatomic, copy) void(^onBackActionBlock)(UIViewController* viewController);
///支付完成回调
@property(nonatomic, copy) void(^onPayFinishBlock)(BOOL isSuccess);

@end
