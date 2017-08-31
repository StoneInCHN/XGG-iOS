//
//  GC_BusinessCenterViewModel.h
//  xianglegou
//
//  Created by mini3 on 2017/7/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  营业中心 ViewModel
//

#import "Hen_BaseViewModel.h"
#import "GC_BusinessModel.h"
#import "GC_BusinessRequestDataModel.h"

@interface GC_BusinessCenterViewModel : Hen_BaseViewModel

///营业中心交易额 参数
@property (nonatomic, strong) GC_ConsumeAmountRequestDataModel *consumeAmountParam;
///营业中心交易额 数据
@property (nonatomic, strong) NSMutableArray<GC_MResConsumeAmountDataModel *> *consumeAmountDatas;
///营业中心交易额 方法
- (void)getConsumeAmountDatasWithResultBlock:(RequestResultBlock)resultBlock;

///营业中心商家数 参数
@property (nonatomic, strong) GC_SellerCountRequestDataModel *sellerCountParam;
///营业中心商家数 数据
@property (nonatomic, strong) NSMutableArray<GC_MResBusinessCountDataModel *> *sellerCountDatas;
///营业中心商家数 方法
- (void)getSellerCountDatasWithResultBlock:(RequestResultBlock)resultBlock;

///营业中心消费者数 参数
@property (nonatomic, strong) GC_EndUserCountRequestDataModel *endUserCountParam;
///营业中心消费者数 数据
@property (nonatomic, strong) NSMutableArray<GC_MResBusinessCountDataModel *> *endUserCountDatas;
///营业中心消费者数 方法
- (void)getEndUserCountDatasWithResultBlock:(RequestResultBlock)resultBlock;

///营业中心业务员数 参数
@property (nonatomic, strong) GC_SalesmanCountRequestDataModel *salesmanCountParam;
///营业中心业务员数 数据
@property (nonatomic, strong) NSMutableArray<GC_MResBusinessCountDataModel *> *salesmanCountDatas;
///营业中心业务员数 方法
- (void)getSalesmanCountDatasWithResultBlock:(RequestResultBlock)resultBlock;


@end
