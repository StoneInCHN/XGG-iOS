//
//  QL_PayBillViewModel.m
//  Rebate
//
//  Created by mini2 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_PayBillViewModel.h"

@implementation QL_PayBillViewModel

///获取支付方式
- (void)getPaymentDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:systemConfig_getConfigByKey dictionaryParam:[self.payMemmentParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.payMentDatas = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSDictionary *dic in msg){
                [self.payMentDatas addObject:[[QL_PayMentDataModel alloc] initWithDictionary:dic]];
            }
            
            if(resultBlock){
                resultBlock(code, desc, self.payMentDatas, nil);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}

///获取支付相关信息 方法
- (void)getPayMentInfoDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_GetPayInfo dictionaryParam:[self.payMentInfoParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.payMentInfoData = [[GC_PayMentInfoDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.payMentInfoData, nil);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}

///验证支付密码 方法
-(void)setVerifyPayPwdDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_verifyPayPwd dictionaryParam:self.verifyPayPwdParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///订单支付
- (void)orderPayWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_pay dictionaryParam:[self.orderPayParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            NSLog(@"************%@*******", msg);
            self.payInfoData = [[QL_PayInfoDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.payInfoData, nil);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}



///录单支付 方法
- (void)setPaySellerOrderDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_paySellerOrder dictionaryParam:self.paySellerOrderParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.paySellerOrderData = [[QL_PayInfoDataModel alloc] initWithDictionary:msg];
            if(resultBlock){
                resultBlock(code, desc, self.paySellerOrderData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}


#pragma mark -- getter,setter

///获取支付方式参数
- (QL_PayMemmentRequestDataModel *)payMemmentParam
{
    if(!_payMemmentParam){
        _payMemmentParam = [[QL_PayMemmentRequestDataModel alloc] initWithDictionary:@{}];
        
        _payMemmentParam.configKey = @"PAYMENTTYPE";
    }
    return _payMemmentParam;
}


///获取支付相关信息 参数
- (GC_PayMentInfoRequestDataModel *)payMentInfoParam
{
    if(!_payMentInfoParam){
        _payMentInfoParam = [[GC_PayMentInfoRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _payMentInfoParam;
}


///获取支付相关信息 数据
- (GC_PayMentInfoDataModel *)payMentInfoData
{
    if(!_payMentInfoData){
        _payMentInfoData = [[GC_PayMentInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _payMentInfoData;
}


///订单支付参数
- (QL_OrderPayRequestDataModel *)orderPayParam
{
    if(!_orderPayParam){
        _orderPayParam = [[QL_OrderPayRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _orderPayParam;
}


///录单支付 参数
- (NSMutableDictionary *)paySellerOrderParam
{
    if(!_paySellerOrderParam){
        _paySellerOrderParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_paySellerOrderParam setObject:@"" forKey:@"userId"];
        //用户token
        [_paySellerOrderParam setObject:@"" forKey:@"token"];
        //支付方式
        [_paySellerOrderParam setObject:@"" forKey:@"payType"];
        
        //支付方式ID
        [_paySellerOrderParam setObject:@"" forKey:@"payTypeId"];
        //商户ID
        [_paySellerOrderParam setObject:@"" forKey:@"sellerId"];
        //订单编号
        [_paySellerOrderParam setObject:@"" forKey:@"sn"];
    }
    return _paySellerOrderParam;
}
///录单支付 数据
- (QL_PayInfoDataModel *)paySellerOrderData
{
    if(!_paySellerOrderData){
        _paySellerOrderData = [[QL_PayInfoDataModel alloc] initWithDictionary:@{}];
        
    }
    return _paySellerOrderData;
}


///验证支付密码 参数
- (NSMutableDictionary *)verifyPayPwdParam
{
    if(!_verifyPayPwdParam){
        _verifyPayPwdParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //用户ID
        [_verifyPayPwdParam setObject:@"" forKey:@"userId"];
        //用户token
        [_verifyPayPwdParam setObject:@"" forKey:@"token"];
        //支付密码(rsa加密)
        [_verifyPayPwdParam setObject:@"" forKey:@"password"];
    }
    return _verifyPayPwdParam;
}

@end
