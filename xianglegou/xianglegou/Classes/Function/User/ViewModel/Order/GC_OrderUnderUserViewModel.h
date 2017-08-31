//
//  GC_OrderUnderUserViewModel.h
//  Rebate
//
//  Created by mini3 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "GC_UserOrderInfoModel.h"
#import "GC_OrderRequestDataModel.h"

@interface GC_OrderUnderUserViewModel : Hen_BaseViewModel

///获取用户订单 参数
@property (nonatomic, strong) GC_GetOrderUnderUserRequestDataModel *orderParam;
///获取用户订单 数据(全部)
@property (nonatomic, strong) NSMutableArray<GC_MResOrderUnderUserDataModel*>* allOrderDatas;
///获取用户订单 数据(未支付)
@property (nonatomic, strong) NSMutableArray<GC_MResOrderUnderUserDataModel*>* unpaidOrderDatas;
///获取用户订单 数据(待评价)
@property (nonatomic, strong) NSMutableArray<GC_MResOrderUnderUserDataModel*>* paidOrderDatas;
///获取用户订单 数据(已完成)
@property (nonatomic, strong) NSMutableArray<GC_MResOrderUnderUserDataModel*>* finshOrderDatas;
///获取用户订单 方法
-(void)getOrderUnderUserDatasWithResultBlock:(RequestResultBlock)resultBlock;



///用户提交评价 参数
@property (nonatomic, strong) GC_UserEvaluateOrdeRequestDataModel *userEvaluateOrderParam;
///用户提交评价 方法
-(void)setImageArray:(NSArray*)images andUserEvaluateOrderDataWithResultBlock:(RequestResultBlock)resultBlock;



///根据订单获取评价详情 参数
@property (nonatomic, strong) GC_GetEvaluateByOrderRequestDataModel *evaluateByOrderParam;
///根据订单获取评价详情 数据
@property (nonatomic, strong) GC_MResEvaluateByOrderDataModel *evaluateByOrderData;
///根据订单获取评价详情 方法
-(void)getEvaluateByOrderDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
