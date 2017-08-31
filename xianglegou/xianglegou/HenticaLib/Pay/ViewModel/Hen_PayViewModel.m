//
//  Hen_PayViewModel.m
//  Peccancy
//
//  Created by mini2 on 16/11/2.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_PayViewModel.h"

@implementation Hen_PayViewModel

///获取支付方式
-(void)getOpenPaymentWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:@"order/listOpenPayment" dictionaryParam:nil withResultBlock:^(NSString *errCode, NSString *errMsg, id data, id page) {
        if([errCode isEqualToString:@"0"]){// 成功
            NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSMutableDictionary *dic in data){
                [result addObject:[[Hen_PaymentDataModel alloc] initWithDictionary:dic]];
            }
            
            if(resultBlock){
                resultBlock(errCode, errMsg, result, page);
            }
        }else{
            if(resultBlock){
                resultBlock(errCode, errMsg, nil, page);
            }
        }
    }];
}

///订单支付
-(void)orderPayWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:@"order/pay" dictionaryParam:self.orderPayParam withResultBlock:^(NSString *errCode, NSString *errMsg, id data, id page) {
        if([errCode isEqualToString:@"0"]){ // 成功
            
            self.orderPayData = [[Hen_OrderPayInfoDataModel alloc] initWithDictionary:data];
            
            if(resultBlock){
                resultBlock(errCode, errMsg, self.orderPayData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(errCode, errMsg, nil, page);
            }
        }
    }];
}

#pragma mark -- getter,setter

-(NSMutableDictionary*)orderPayParam
{
    if(!_orderPayParam){
        _orderPayParam = [NSMutableDictionary dictionaryWithCapacity:0];
        
        //订单id
        [_orderPayParam setObject:@"" forKey:@"orderId"];
        //支付方式，1：支付宝，2：微信，3：银联
        [_orderPayParam setObject:@"" forKey:@"payType"];
        //支付平台，1：Android；2：IOS；3：微信
        [_orderPayParam setObject:@"2" forKey:@"platform"];
    }
    return _orderPayParam;
}

-(Hen_OrderPayInfoDataModel*)orderPayData
{
    if(!_orderPayData){
        _orderPayData = [[Hen_OrderPayInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _orderPayData;
}

@end
