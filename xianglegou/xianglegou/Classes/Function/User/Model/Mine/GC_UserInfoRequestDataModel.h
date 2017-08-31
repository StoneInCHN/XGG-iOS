//
//  GC_UserInfoRequestDataModel.h
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_UserInfoRequestDataModel : Hen_JsonModel

@end

#pragma mark -- 用户修改信息 请求数据

@interface GC_EditUserInfoRequestDataModel : Hen_JsonModel
///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///昵称
@property (nonatomic, strong) NSString *nickName;
///地区ID
@property (nonatomic, strong) NSString *areaId;
@end
