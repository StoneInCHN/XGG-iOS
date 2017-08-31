//
//  GC_BusinessCenterViewModel.m
//  xianglegou
//
//  Created by mini3 on 2017/7/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  营业中心 ViewModel
//

#import "GC_BusinessCenterViewModel.h"

@implementation GC_BusinessCenterViewModel

///营业中心交易额 方法
- (void)getConsumeAmountDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:agent_consumeAmountReport dictionaryParam:[self.consumeAmountParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                GC_MResConsumeAmountDataModel *model = [[GC_MResConsumeAmountDataModel alloc] initWithDictionary:dic];
                [resultArray addObject:model];
            }
            
            if([self.consumeAmountParam.pageNumber isEqualToString:@"1"]){
                [self.consumeAmountDatas removeAllObjects];
            }
            [self.consumeAmountDatas addObjectsFromArray:resultArray];
            
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

///营业中心商家数 方法
- (void)getSellerCountDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:agent_sellerCountReport dictionaryParam:[self.sellerCountParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                GC_MResBusinessCountDataModel *model = [[GC_MResBusinessCountDataModel alloc] initWithDictionary:dic];
                [resultArray addObject:model];
            }
            
            if([self.sellerCountParam.pageNumber isEqualToString:@"1"]){
                [self.sellerCountDatas removeAllObjects];
            }
            
            
            [self.sellerCountDatas addObjectsFromArray:resultArray];
            
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


///营业中心消费者数 方法
- (void)getEndUserCountDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:agent_endUserCountReport dictionaryParam:[self.endUserCountParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                GC_MResBusinessCountDataModel *model = [[GC_MResBusinessCountDataModel alloc] initWithDictionary:dic];
                [resultArray addObject:model];
            }
            
            if([self.endUserCountParam.pageNumber isEqualToString:@"1"]){
                [self.endUserCountDatas removeAllObjects];
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

///营业中心业务员数 方法
- (void)getSalesmanCountDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:agent_salesmanCountReport dictionaryParam:[self.salesmanCountParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                GC_MResBusinessCountDataModel *model = [[GC_MResBusinessCountDataModel alloc] initWithDictionary:dic];
                [resultArray addObject:model];
            }
            
            if([self.salesmanCountParam.pageNumber isEqualToString:@"1"]){
                [self.salesmanCountDatas removeAllObjects];
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


#pragma mark -- getter,setter
///营业中心交易额 参数
- (GC_ConsumeAmountRequestDataModel *)consumeAmountParam
{
    if(!_consumeAmountParam){
        _consumeAmountParam = [[GC_ConsumeAmountRequestDataModel alloc] initWithDictionary:@{}];
        _consumeAmountParam.pageSize = NumberOfPages;
    }
    return _consumeAmountParam;
}

///营业中心交易额 数据
- (NSMutableArray<GC_MResConsumeAmountDataModel *> *)consumeAmountDatas
{
    if(!_consumeAmountDatas){
        _consumeAmountDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _consumeAmountDatas;
}



///营业中心商家数 参数
- (GC_SellerCountRequestDataModel *)sellerCountParam
{
    if(!_sellerCountParam){
        _sellerCountParam = [[GC_SellerCountRequestDataModel alloc] initWithDictionary:@{}];
        _sellerCountParam.pageSize = NumberOfPages;
    }
    return _sellerCountParam;
}
///营业中心商家数 数据
- (NSMutableArray<GC_MResBusinessCountDataModel *> *)sellerCountDatas
{
    if(!_sellerCountDatas){
        _sellerCountDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _sellerCountDatas;
}


///营业中心消费者数 参数
- (GC_EndUserCountRequestDataModel *)endUserCountParam
{
    if(!_endUserCountParam){
        _endUserCountParam = [[GC_EndUserCountRequestDataModel alloc] initWithDictionary:@{}];
        _endUserCountParam.pageSize = NumberOfPages;
    }
    return _endUserCountParam;
}

///营业中心消费者数 数据
- (NSMutableArray<GC_MResBusinessCountDataModel *> *)endUserCountDatas
{
    if(!_endUserCountDatas){
        _endUserCountDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _endUserCountDatas;
}


///营业中心业务员数 参数
- (GC_SalesmanCountRequestDataModel *)salesmanCountParam
{
    if(!_salesmanCountParam){
        _salesmanCountParam = [[GC_SalesmanCountRequestDataModel alloc] initWithDictionary:@{}];
        _salesmanCountParam.pageSize = NumberOfPages;
    }
    return _salesmanCountParam;
}


///营业中心业务员数 数据
- (NSMutableArray<GC_MResBusinessCountDataModel *> *)salesmanCountDatas
{
    if(!_salesmanCountDatas){
        _salesmanCountDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _salesmanCountDatas;
}


@end
