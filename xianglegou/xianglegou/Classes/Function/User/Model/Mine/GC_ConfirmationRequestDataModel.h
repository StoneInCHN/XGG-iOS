//
//  GC_ConfirmationRequestDataModel.h
//  Rebate
//
//  Created by mini3 on 17/5/2.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_ConfirmationRequestDataModel : Hen_JsonModel

@end


#pragma mark -- 用户确认提现数据 请求数据

@interface GC_UserConfirmationRequestDataModel : Hen_JsonModel
///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///提现金额
@property (nonatomic, strong) NSString *withdrawAmount;
///备注信息
@property (nonatomic, strong) NSString *remark;
///提现银行卡
@property (nonatomic, strong) NSString *entityId;
@end
