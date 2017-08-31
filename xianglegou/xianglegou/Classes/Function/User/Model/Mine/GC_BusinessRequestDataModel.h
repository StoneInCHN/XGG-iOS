//
//  GC_BusinessRequestDataModel.h
//  xianglegou
//
//  Created by mini3 on 2017/7/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_BusinessRequestDataModel : Hen_JsonModel

@end


#pragma mark - 营业中心交易额 请求参数
@interface GC_ConsumeAmountRequestDataModel : Hen_JsonModel
///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///地区id
@property (nonatomic, strong) NSString *areaId;
///查询开始日期
@property (nonatomic, strong) NSString *startDate;
///查询结束日期
@property (nonatomic, strong) NSString *endDate;
///分页：页数
@property (nonatomic, strong) NSString *pageNumber;
///分页：每页大小
@property (nonatomic, strong) NSString *pageSize;

@end



#pragma mark -- 营业中心商家数 请求参数

@interface GC_SellerCountRequestDataModel : Hen_JsonModel
///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///地区id
@property (nonatomic, strong) NSString *areaId;
///分页：页数
@property (nonatomic, strong) NSString *pageNumber;
///分页：每页大小
@property (nonatomic, strong) NSString *pageSize;

@end


#pragma mark -- 营业中心消费者数 请求参数

@interface GC_EndUserCountRequestDataModel : Hen_JsonModel
///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///地区id
@property (nonatomic, strong) NSString *areaId;
///分页：页数
@property (nonatomic, strong) NSString *pageNumber;
///分页：每页大小
@property (nonatomic, strong) NSString *pageSize;
@end


#pragma mark -- 营业中心业务员数 请求参数


@interface GC_SalesmanCountRequestDataModel : Hen_JsonModel
///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///地区id
@property (nonatomic, strong) NSString *areaId;
///分页：页数
@property (nonatomic, strong) NSString *pageNumber;
///分页：每页大小
@property (nonatomic, strong) NSString *pageSize;
@end
