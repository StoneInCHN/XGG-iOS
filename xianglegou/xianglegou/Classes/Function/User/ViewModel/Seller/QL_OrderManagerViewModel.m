//
//  QL_OrderManagerViewModel.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_OrderManagerViewModel.h"

@implementation QL_OrderManagerViewModel

///获取订单列表
- (void)getOrderListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_getOrderUnderSeller dictionaryParam:[self.orderListParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSDictionary *dic in msg){
                [array addObject:[[QL_ShopOrderListDataModel alloc] initWithDictionary:dic]];
            }
            if([self.orderListParam.pageNumber isEqualToString:@"1"]){
                [self.orderListDatas removeAllObjects];
            }
            [self.orderListDatas addObjectsFromArray:array];
            
            if(resultBlock){
                resultBlock(code, desc, array, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
}


///删除未支付的录单订单 方法
- (void)setDelSellerUnpaidOrderDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_delSellerUnpaidOrder dictionaryParam:self.delSellerUnpaidOrderParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}
#pragma mark -- getter,setter

///获取订单列表参数
- (GC_OrderManageListRequestDataModel *)orderListParam
{
    if(!_orderListParam){
        _orderListParam = [[GC_OrderManageListRequestDataModel alloc] initWithDictionary:@{}];
        _orderListParam.pageSize = NumberOfPages;
        
    }
    return _orderListParam;
}
//- (NSMutableDictionary *)orderListParam
//{
//    if(!_orderListParam){
//        _orderListParam = [NSMutableDictionary dictionaryWithCapacity:0];
//        
//        //用户ID
//        [_orderListParam setObject:@"" forKey:@"userId"];
//        //用户token
//        [_orderListParam setObject:@"" forKey:@"token"];
//        //商家ID
//        [_orderListParam setObject:@"" forKey:@"entityId"];
//        //分页：页数
//        [_orderListParam setObject:@"" forKey:@"pageNumber"];
//        //分页：每页大小
//        [_orderListParam setObject:NumberOfPages forKey:@"pageSize"];
//        //是否是录单订单
//        [_orderListParam setObject:@"" forKey:@"isSallerOrder"];
//        
//        //订单状态
//        [_orderListParam setObject:@"" forKey:@"orderStatus"];
//        //结算状态(结算中:false;已结算:true)
//        [_orderListParam setObject:@"" forKey:@"isClearing"];
//        
//        
//    }
//    return _orderListParam;
//}
///订单列表数据
- (NSMutableArray<QL_ShopOrderListDataModel *> *)orderListDatas
{
    if(!_orderListDatas){
        _orderListDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderListDatas;
}


///删除未支付的录单订单 参数
- (NSMutableDictionary *)delSellerUnpaidOrderParam
{
    if(!_delSellerUnpaidOrderParam){
        _delSellerUnpaidOrderParam = [[NSMutableDictionary alloc] initWithCapacity:0];
    
        //用户ID
        [_delSellerUnpaidOrderParam setObject:@"" forKey:@"userId"];
        //用户token
        [_delSellerUnpaidOrderParam setObject:@"" forKey:@"token"];
        //订单ID
        [_delSellerUnpaidOrderParam setObject:@"" forKey:@"entityId"];
    }
    return _delSellerUnpaidOrderParam;
}
@end
