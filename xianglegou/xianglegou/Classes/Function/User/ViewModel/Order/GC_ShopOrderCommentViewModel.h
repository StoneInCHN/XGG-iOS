//
//  GC_ShopOrderCommentViewModel.h
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "GC_OrderRequestDataModel.h"
#import "GC_UserOrderInfoModel.h"

@interface GC_ShopOrderCommentViewModel : Hen_BaseViewModel
///商家回复用户评价 参数
@property (nonatomic, strong) NSMutableDictionary *sellerReplyParam;
///商家回复用户评价 方法
-(void)setSellerReplyDataWithResuleBlock:(RequestResultBlock)resultBlock;


///根据订单获取评价详情 参数
@property (nonatomic, strong) GC_GetEvaluateByOrderRequestDataModel *evaluateByOrderParam;
///根据订单获取评价详情 数据
@property (nonatomic, strong) GC_MResEvaluateByOrderDataModel *evaluateByOrderData;
///根据订单获取评价详情 方法
-(void)getEvaluateByOrderDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
