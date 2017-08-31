//
//  QL_AbonusModel.h
//  Rebate
//
//  Created by mini2 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface QL_AbonusModel : Hen_JsonModel

@end

#pragma mark -- 用户个人分红

@interface QL_UserAbonusDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *bonusLeScore;/// 2,分红乐分
@property(nonatomic, strong) NSString *highBonusLeScore;/// 2, 最高分红乐分
@property(nonatomic, strong) NSString *consumeTotalAmount;/// 200,  总消费金额
@property(nonatomic, strong) NSString *reportDate;/// "2017-04-04", 统计日期
@property(nonatomic, strong) NSString *id;/// 12



@end

#pragma mark -- 全国分红

@interface QL_AllAbonusDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *consumePeopleNum;/// 1, 全国消费人数
//@property(nonatomic, strong) NSString *publicTotalAmount;/// 1,公益总金额
@property(nonatomic, strong) NSString *sellerNum;/// null,全国联盟商家
@property(nonatomic, strong) NSString *consumeTotalAmount;/// 1,全国消费总额
@property(nonatomic, strong) NSString *consumeByDay;/// 1,当日累计消费
@property(nonatomic, strong) NSString *reportDate;/// "2017-04-08",统计日期
//@property(nonatomic, strong) NSString *publicAmountByDay;/// 1,公益金额
//@property(nonatomic, strong) NSString *leMindByDay;/// 1,当日累计分红乐心
//@property(nonatomic, strong) NSString *bonusLeScoreByDay;/// 1,当日分红乐分
@property(nonatomic, strong) NSString *id;/// 1

@property (nonatomic, strong) NSString *totalBonus;   //分红金额
@property (nonatomic, strong) NSString *calValue;     //当日乐心价值

@end
