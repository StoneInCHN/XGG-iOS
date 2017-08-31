//
//  GC_OrderUnderUserViewModel.m
//  Rebate
//
//  Created by mini3 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_OrderUnderUserViewModel.h"

@implementation GC_OrderUnderUserViewModel
///获取用户订单 方法
-(void)getOrderUnderUserDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_getOrderUnderUser dictionaryParam:[self.orderParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            if([self.orderParam.orderStatus isEqualToString:@""]){                  //全部订单
                NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in msg) {
                    [resultArray addObject:[[GC_MResOrderUnderUserDataModel alloc] initWithDictionary:dic]];
                }
                
                if([self.orderParam.pageNumber isEqualToString:@"1"]){
                    [self.allOrderDatas removeAllObjects];
                }
                
                [self.allOrderDatas addObjectsFromArray:resultArray];
                if(resultBlock){
                    resultBlock(code, desc, resultArray, page);
                }
            }else if([self.orderParam.orderStatus isEqualToString:@"PAID"]){        //待评价
                NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in msg) {
                    [resultArray addObject:[[GC_MResOrderUnderUserDataModel alloc] initWithDictionary:dic]];
                }
                if([self.orderParam.pageNumber isEqualToString:@"1"]){
                    [self.paidOrderDatas removeAllObjects];
                }
                
                [self.paidOrderDatas addObjectsFromArray:resultArray];
                if(resultBlock){
                    resultBlock(code, desc, resultArray, page);
                }
            }else if([self.orderParam.orderStatus isEqualToString:@"FINISHED"]){    //已完成
                NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in msg) {
                    [resultArray addObject:[[GC_MResOrderUnderUserDataModel alloc] initWithDictionary:dic]];
                }
                
                if([self.orderParam.pageNumber isEqualToString:@"1"]){
                    [self.finshOrderDatas removeAllObjects];
                }
                
                [self.finshOrderDatas addObjectsFromArray:resultArray];
                
                if(resultBlock){
                    resultBlock(code, desc, resultArray, page);
                }
            }else if([self.orderParam.orderStatus isEqualToString:@"UNPAID"]){      //未支付
                NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in msg) {
                    [resultArray addObject:[[GC_MResOrderUnderUserDataModel alloc] initWithDictionary:dic]];
                }
                
                if([self.orderParam.pageNumber isEqualToString:@"1"]){
                    [self.unpaidOrderDatas removeAllObjects];
                }
                
                [self.unpaidOrderDatas addObjectsFromArray:resultArray];
                
                if(resultBlock){
                    resultBlock(code, desc, resultArray, page);
                }
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
}



///用户提交评价 方法
-(void)setImageArray:(NSArray*)images andUserEvaluateOrderDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_userEvaluateOrder dictionaryParam:[self.userEvaluateOrderParam toDictionary] imageParameName:@"evaluateImage" imageArray:images withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}



///根据订单获取评价详情 方法
-(void)getEvaluateByOrderDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_getEvaluateByOrder dictionaryParam:[self.evaluateByOrderParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.evaluateByOrderData = [[GC_MResEvaluateByOrderDataModel alloc] initWithDictionary:msg];
            if(resultBlock){
                resultBlock(code, desc, self.evaluateByOrderData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
}

#pragma mark -- getter,setter
///获取用户订单 参数
- (GC_GetOrderUnderUserRequestDataModel *)orderParam
{
    if(!_orderParam){
        _orderParam = [[GC_GetOrderUnderUserRequestDataModel alloc] initWithDictionary:@{}];
        _orderParam.pageSize = NumberOfPages;
    }
    return _orderParam;
}
///获取用户订单 数据(全部)
- (NSMutableArray<GC_MResOrderUnderUserDataModel *> *)allOrderDatas
{
    if(!_allOrderDatas){
        _allOrderDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _allOrderDatas;
}


///获取用户订单 数据(待评价)
- (NSMutableArray<GC_MResOrderUnderUserDataModel *> *)paidOrderDatas
{
    if(!_paidOrderDatas){
        _paidOrderDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _paidOrderDatas;
}
///获取用户订单 数据(已完成)
- (NSMutableArray<GC_MResOrderUnderUserDataModel *> *)finshOrderDatas
{
    if(!_finshOrderDatas){
        _finshOrderDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _finshOrderDatas;
}


///用户提交评价 参数
- (GC_UserEvaluateOrdeRequestDataModel *)userEvaluateOrderParam
{
    if(!_userEvaluateOrderParam){
        _userEvaluateOrderParam = [[GC_UserEvaluateOrdeRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _userEvaluateOrderParam;
}


///根据订单获取评价详情 参数
- (GC_GetEvaluateByOrderRequestDataModel *)evaluateByOrderParam
{
    if(!_evaluateByOrderParam){
        _evaluateByOrderParam = [[GC_GetEvaluateByOrderRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _evaluateByOrderParam;
}

///根据订单获取评价详情 数据
- (GC_MResEvaluateByOrderDataModel *)evaluateByOrderData
{
    if(!_evaluateByOrderData){
        _evaluateByOrderData = [[GC_MResEvaluateByOrderDataModel alloc] initWithDictionary:@{}];
    }
    return _evaluateByOrderData;
}

- (NSMutableArray<GC_MResOrderUnderUserDataModel *> *)unpaidOrderDatas
{
    if(!_unpaidOrderDatas){
        _unpaidOrderDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _unpaidOrderDatas;
}
@end
