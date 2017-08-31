//
//  QL_OrderManagerViewModel.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 订单管理view model
//

#import "Hen_BaseViewModel.h"
#import "QL_ShopModel.h"
#import "GC_OrderRequestDataModel.h"

@interface QL_OrderManagerViewModel : Hen_BaseViewModel

///获取订单列表参数
@property(nonatomic, strong) GC_OrderManageListRequestDataModel *orderListParam;
//@property(nonatomic, strong) NSMutableDictionary *orderListParam;
///订单列表数据
@property(nonatomic, strong) NSMutableArray<QL_ShopOrderListDataModel *> *orderListDatas;
///获取订单列表
- (void)getOrderListDatasWithResultBlock:(RequestResultBlock)resultBlock;



///删除未支付的录单订单 参数
@property (nonatomic, strong) NSMutableDictionary *delSellerUnpaidOrderParam;
///删除未支付的录单订单 方法
- (void)setDelSellerUnpaidOrderDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
