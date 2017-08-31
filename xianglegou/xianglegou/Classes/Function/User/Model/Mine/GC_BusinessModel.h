//
//  GC_BusinessModel.h
//  xianglegou
//
//  Created by mini3 on 2017/7/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  营业中心 Model
//

#import "Hen_JsonModel.h"

@interface GC_BusinessModel : Hen_JsonModel

@end



#pragma mark -- 折扣金额

@protocol GC_MResDiscountAmountsDataModel


@end

@interface GC_MResDiscountAmountsDataModel : Hen_JsonModel
///折扣
@property (nonatomic, strong) NSString *discount;
///金额
@property (nonatomic, strong) NSString *amount;
@end


#pragma mark -- 营业中心 交易额

@interface GC_MResConsumeAmountDataModel : Hen_JsonModel

///地区ID
@property (nonatomic, strong) NSString *areaId;
///日期
@property (nonatomic, strong) NSString *date;

///总金额
@property (nonatomic, strong) NSString *totalAmount;

///折扣金额信息
@property (nonatomic, strong) NSMutableArray<GC_MResDiscountAmountsDataModel> *discountAmounts;

@end



#pragma mark -- 营业中心 业务员 信息

@protocol GC_SalesmanInfoDataModel

@end

@interface GC_SalesmanInfoDataModel : Hen_JsonModel
///ID
@property (nonatomic, strong) NSString *id;
///昵称
@property (nonatomic, strong) NSString *userName;
///昵称
@property (nonatomic, strong) NSString *nickName;
///头像
@property (nonatomic, strong) NSString *userPhoto;
///电话
@property (nonatomic, strong) NSString *cellPhoneNum;

@end

#pragma mark -- 营业中心 数目信息

@interface GC_MResBusinessCountDataModel : Hen_JsonModel

///ID
@property (nonatomic, strong) NSString *id;
///名称
@property (nonatomic, strong) NSString *name;
///个数
@property (nonatomic, strong) NSString *count;
///List
@property (nonatomic, strong) NSMutableArray<GC_SalesmanInfoDataModel> *list;

@end




