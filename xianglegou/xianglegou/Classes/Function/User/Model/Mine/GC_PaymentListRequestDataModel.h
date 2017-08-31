//
//  GC_PaymentListRequestDataModel.h
//  xianglegou
//
//  Created by mini3 on 2017/7/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_PaymentListRequestDataModel : Hen_JsonModel

///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
//查询开始时间
@property (nonatomic, strong) NSString *startTime;
///查询结束时间
@property (nonatomic, strong) NSString *endTime;
///分页：页数
@property (nonatomic, strong) NSString *pageNumber;
///分页：每页大小
@property (nonatomic, strong) NSString *pageSize;

@end
