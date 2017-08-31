//
//  Hen_PayViewModel.h
//  Peccancy
//
//  Created by mini2 on 16/11/2.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_JsonModel.h"
#import "Hen_PayModel.h"
#import "Hen_MessageManager.h"

@interface Hen_PayViewModel : Hen_JsonModel

///订单支付参数
@property(nonatomic, strong) NSMutableDictionary *orderPayParam;

///订单支付数据
@property(nonatomic, strong) Hen_OrderPayInfoDataModel *orderPayData;

///获取支付方式
-(void)getOpenPaymentWithResultBlock:(RequestResultBlock)resultBlock;

///订单支付
-(void)orderPayWithResultBlock:(RequestResultBlock)resultBlock;

@end
