//
//  GC_ShopManagetViewModel.m
//  xianglegou
//
//  Created by mini3 on 2017/5/25.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_ShopManagetViewModel.h"

@implementation GC_ShopManagetViewModel
///店铺货款列表 方法
- (void)getPaymentListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:seller_paymentList dictionaryParam:[self.paymentListParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResPaymentListDataModel alloc] initWithDictionary:dic]];
            }
            
            if([self.paymentListParam.pageNumber isEqualToString:@"1"]){
                [self.paymentListDatas removeAllObjects];
            }
            
            [self.paymentListDatas addObjectsFromArray:resultArray];
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
            
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}

///货款明细 方法
- (void)getPaymentDetailDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:seller_paymentDetail dictionaryParam:self.paymentDetailParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            if([[self.paymentDetailParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.paymentDetailData.orders removeAllObjects];
                self.paymentDetailData = [[GC_MResPaymentDetailDataModel alloc] initWithDictionary:msg];
                [resultArray addObjectsFromArray:self.paymentDetailData.orders];
                
            }else{
                GC_MResPaymentDetailDataModel *model = [[GC_MResPaymentDetailDataModel alloc] initWithDictionary:msg];
                 [resultArray addObjectsFromArray:model.orders];
                [self.paymentDetailData.orders addObjectsFromArray:model.orders];
            }
            
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
            
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}




///录单自动填充商户信息 方法
- (void)getCurrentSellerInfoWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getCurrentSellerInfo dictionaryParam:self.getCurrentSellerInfoParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.getCurrentSellerInfoData = [[GC_MResCurrentSellerInfoDataModel alloc] initWithDictionary:msg];
            if(resultBlock){
                resultBlock(code, desc, self.getCurrentSellerInfoData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}


///录单根据手机号获取消费者信息 方法
- (void)getUserInfoByMobileDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getUserInfoByMobile dictionaryParam:self.userInfoByMobileParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.userInfoByMobileData = [[GC_MResUserInfoByMobileDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.userInfoByMobileData ,page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}




///录单加入购物车 方法
- (void)setAddOrderCartDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:sellerOrderCart_add dictionaryParam:self.addOrderCartParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.addOrderCartData = [[GC_MResOrderCartAddDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.addOrderCartData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}



///购物车批量录单 方法
- (void)setConfirmOrderDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:sellerOrderCart_confirmOrder dictionaryParam:self.confirmOrderParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.confirmOrderData = [[GC_MResConfirmOrderCartDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.confirmOrderData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}


///录单购物车批量删除 方法
- (void)setDeleteSellerOrderCartDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:sellerOrderCart_delete dictionaryParam:self.deleteSellerOrderCartParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///立即录单 方法
- (void)setGenerateSellerOrderDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_generateSellerOrder dictionaryParam:self.generateSellerOrderParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        NSLog(@"*****%@******", msg);
        if([code isEqualToString:@"0000"]){
            self.generateSellerOrderData = [[GC_MResGenerateSellerOrderDataModel alloc] initWithDictionary:msg];
            if(resultBlock){
                resultBlock(code, desc, self.generateSellerOrderData, page);
            }
            
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}



///录单购物车列表 方法
- (void)getSellerOrderCartListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    
    [[Hen_MessageManager shareMessageManager] requestWithAction:sellerOrderCart_list dictionaryParam:self.sellerOrderCartListParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){

            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResSellerOrderCartListDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.sellerOrderCartListParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.sellerOrderCartListDatas removeAllObjects];
            }
            
            [self.sellerOrderCartListDatas addObjectsFromArray:resultArray];
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}



///商户获取录单列表 方法
- (void)getSellerOrderListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_getSallerOrder dictionaryParam:self.sellerOrderListParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResSellerOrderListDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.sellerOrderListParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.sellerOrderListDatas removeAllObjects];
            }
            
            [self.sellerOrderListDatas addObjectsFromArray:resultArray];
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
            
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
    
}

#pragma mark -- getter,setter
///店铺货款列表 参数
- (GC_PaymentListRequestDataModel *)paymentListParam
{
    if(!_paymentListParam){
        _paymentListParam = [[GC_PaymentListRequestDataModel alloc] initWithDictionary:@{}];
        _paymentListParam.pageSize = NumberOfPages;
    }
    return _paymentListParam;
}


///店铺货款列表 数据

- (NSMutableArray<GC_MResPaymentListDataModel *> *)paymentListDatas
{
    if(!_paymentListDatas){
        _paymentListDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _paymentListDatas;
}
///货款明细 参数
- (NSMutableDictionary *)paymentDetailParam
{
    if(!_paymentDetailParam){
        _paymentDetailParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_paymentDetailParam setObject:@"" forKey:@"userId"];
        
        //用户token
        [_paymentDetailParam setObject:@"" forKey:@"token"];
        
        //货款记录id
        [_paymentDetailParam setObject:@"" forKey:@"entityId"];
        
        //分页：页数.
        [_paymentDetailParam setObject:@"" forKey:@"pageNumber"];
        
        //分页：每页大小
        [_paymentDetailParam setObject:NumberOfPages forKey:@"pageSize"];

    }
    return _paymentDetailParam;
}
///货款明细 数据
- (GC_MResPaymentDetailDataModel *)paymentDetailData
{
    if(!_paymentDetailData){
        _paymentDetailData = [[GC_MResPaymentDetailDataModel alloc] initWithDictionary:@{}];
    }
    return _paymentDetailData;
}



///录单自动填充商户信息 参数
- (NSMutableDictionary *)getCurrentSellerInfoParam
{
    if(!_getCurrentSellerInfoParam){
        _getCurrentSellerInfoParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //用户ID
        [_getCurrentSellerInfoParam setObject:@"" forKey:@"userId"];
        
        //用户token
        [_getCurrentSellerInfoParam setObject:@"" forKey:@"token"];
    }
    return _getCurrentSellerInfoParam;
}


///录单自动填充商户信息 数据
- (GC_MResCurrentSellerInfoDataModel *)getCurrentSellerInfoData
{
    if(!_getCurrentSellerInfoData){
        _getCurrentSellerInfoData = [[GC_MResCurrentSellerInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _getCurrentSellerInfoData;
}



///录单根据手机号获取消费者信息 参数
- (NSMutableDictionary *)userInfoByMobileParam
{
    if(!_userInfoByMobileParam){
        _userInfoByMobileParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        
        //用户ID
        [_userInfoByMobileParam setObject:@"" forKey:@"userId"];
        
        //用户token
        [_userInfoByMobileParam setObject:@"" forKey:@"token"];
        
        //消费者手机号
        [_userInfoByMobileParam setObject:@"" forKey:@"cellPhoneNum"];
        
        
    }
    return _userInfoByMobileParam;
}
///录单根据手机号获取消费者信息 数据
- (GC_MResUserInfoByMobileDataModel *)userInfoByMobileData
{
    if(!_userInfoByMobileData){
        _userInfoByMobileData = [[GC_MResUserInfoByMobileDataModel alloc] initWithDictionary:@{}];
    }
    return _userInfoByMobileData;
}



///录单加入购物车 参数
- (NSMutableDictionary *)addOrderCartParam
{
    if(!_addOrderCartParam){
        _addOrderCartParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //登录用户ID
        [_addOrderCartParam setObject:@"" forKey:@"userId"];
        
        //用户token
        [_addOrderCartParam setObject:@"" forKey:@"token"];
        
        
        
        //录单消费者ID
        [_addOrderCartParam setObject:@"" forKey:@"entityId"];
        
        //录单商户ID
        [_addOrderCartParam setObject:@"" forKey:@"sellerId"];
        
        //录单消费金额
        [_addOrderCartParam setObject:@"" forKey:@"amount"];
        //录单订单折扣
        [_addOrderCartParam setObject:@"" forKey:@"sellerDiscount"];
    }
    return _addOrderCartParam;
}
///录单加入购物车 数据
- (GC_MResOrderCartAddDataModel *)addOrderCartData
{
    if(!_addOrderCartData){
        _addOrderCartData = [[GC_MResOrderCartAddDataModel alloc] initWithDictionary:@{}];
    }
    return _addOrderCartData;
}



///购物车批量录单 参数
- (NSMutableDictionary *)confirmOrderParam
{
    if(!_confirmOrderParam){
        _confirmOrderParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //登录用户ID
        [_confirmOrderParam setObject:@"" forKey:@"userId"];
        //用户token
        [_confirmOrderParam setObject:@"" forKey:@"token"];
        //购车项ID集合
        [_confirmOrderParam setObject:@[] forKey:@"entityIds"];
        //录单商户ID
        [_confirmOrderParam setObject:@"" forKey:@"entityId"];
    }
    return _confirmOrderParam;
}

///购物车批量录单 数据
- (GC_MResConfirmOrderCartDataModel *)confirmOrderData
{
    if(!_confirmOrderData){
        _confirmOrderData = [[GC_MResConfirmOrderCartDataModel alloc] initWithDictionary:@{}];
    }
    return _confirmOrderData;
}




///录单购物车批量删除 参数
- (NSMutableDictionary *)deleteSellerOrderCartParam
{
    if(!_deleteSellerOrderCartParam){
        _deleteSellerOrderCartParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        
        //登录用户ID
        [_deleteSellerOrderCartParam setObject:@"" forKey:@"userId"];
        //用户token
        [_deleteSellerOrderCartParam setObject:@"" forKey:@"token"];
        
        //购车项ID集合
        [_deleteSellerOrderCartParam setObject:@[] forKey:@"entityIds"];
        
        
    }
    return _deleteSellerOrderCartParam;
}


///立即录单 参数
- (NSMutableDictionary *)generateSellerOrderParam
{
    if(!_generateSellerOrderParam){
        _generateSellerOrderParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //登录用户ID
        [_generateSellerOrderParam setObject:@"" forKey:@"userId"];
        //用户token
        [_generateSellerOrderParam setObject:@"" forKey:@"token"];
        //消费者ID
        [_generateSellerOrderParam setObject:@"" forKey:@"entityId"];
        //录单金额
        [_generateSellerOrderParam setObject:@"" forKey:@"amount"];
        //商家ID
        [_generateSellerOrderParam setObject:@"" forKey:@"sellerId"];
        //录单订单折扣
        [_generateSellerOrderParam setObject:@"" forKey:@"sellerDiscount"];
    }
    return _generateSellerOrderParam;
}
///立即录单 数据
- (GC_MResGenerateSellerOrderDataModel *)generateSellerOrderData
{
    if(!_generateSellerOrderData){
        _generateSellerOrderData = [[GC_MResGenerateSellerOrderDataModel alloc] initWithDictionary:@{}];
    }
    return _generateSellerOrderData;
}




///录单购物车列表 参数
- (NSMutableDictionary *)sellerOrderCartListParam
{
    if(!_sellerOrderCartListParam){
        _sellerOrderCartListParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //登录用户ID
        [_sellerOrderCartListParam setObject:@"" forKey:@"userId"];
        //用户token
        [_sellerOrderCartListParam setObject:@"" forKey:@"token"];
        //分页：每页大小
        [_sellerOrderCartListParam setObject:@"" forKey:@"pageNumber"];
        //分页：页数
        [_sellerOrderCartListParam setObject:NumberOfPages forKey:@"pageSize"];
        
    }
    return _sellerOrderCartListParam;
}
///录单购物车列表 数据
- (NSMutableArray<GC_MResSellerOrderCartListDataModel *> *)sellerOrderCartListDatas
{
    if(!_sellerOrderCartListDatas){
        _sellerOrderCartListDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _sellerOrderCartListDatas;
}




///商户获取录单列表 参数
- (NSMutableDictionary *)sellerOrderListParam
{
    if(!_sellerOrderListParam){
        _sellerOrderListParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //登录用户ID
        [_sellerOrderListParam setObject:@"" forKey:@"userId"];
        //用户token
        [_sellerOrderListParam setObject:@"" forKey:@"token"];
        //分页：每页大小
        [_sellerOrderListParam setObject:@"" forKey:@"pageNumber"];
        //分页：页数
        [_sellerOrderListParam setObject:NumberOfPages forKey:@"pageSize"];
    }
    return _sellerOrderListParam;
}

///商户获取录单列表 数据

- (NSMutableArray<GC_MResSellerOrderListDataModel *> *)sellerOrderListDatas
{
    if(!_sellerOrderListDatas){
        _sellerOrderListDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _sellerOrderListDatas;
}

@end
