//
//  GC_OrderRequestDataModel.h
//  Rebate
//
//  Created by mini3 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"

@interface GC_OrderRequestDataModel : Hen_JsonModel

@end

#pragma mark --- 订单查询请求 数据

@interface GC_GetOrderUnderUserRequestDataModel : Hen_JsonModel

///用户Id
@property (nonatomic, strong) NSString *userId;

///Token
@property (nonatomic, strong) NSString *token;

///订单状态
@property (nonatomic, strong) NSString *orderStatus;

///是否是录单订单
@property (nonatomic, strong) NSString *isSallerOrder;

///分页：页数
@property (nonatomic, strong) NSString *pageNumber;

///分页：每页大小
@property (nonatomic, strong) NSString *pageSize;
@end



#pragma mark -- 用户提交评价请求 数据

@interface GC_UserEvaluateOrdeRequestDataModel : Hen_JsonModel

///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///订单Id
@property (nonatomic, strong) NSString *entityId;
///用户评分
@property (nonatomic, strong) NSString *score;
///用户评价
@property (nonatomic, strong) NSString *content;

@end


#pragma mark -- 获取订单评价详情请求 数据

@interface GC_GetEvaluateByOrderRequestDataModel : Hen_JsonModel

///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///订单ID
@property (nonatomic, strong) NSString *entityId;
@end


#pragma mark -- 获取订单管理 列表参数

@interface GC_OrderManageListRequestDataModel : Hen_JsonModel
//用户ID
@property (nonatomic, strong) NSString *userId;
//用户token
@property (nonatomic, strong) NSString *token;
//商家ID
@property (nonatomic, strong) NSString *entityId;
//分页：页数
@property (nonatomic, strong) NSString *pageNumber;
//分页：每页大小
@property (nonatomic, strong) NSString *pageSize;
//是否是录单订单
@property (nonatomic, strong) NSString *isSallerOrder;

//订单状态
@property (nonatomic, strong) NSString *orderStatus;
//结算状态(结算中:false;已结算:true)
@property (nonatomic, strong) NSString *isClearing;

@end
