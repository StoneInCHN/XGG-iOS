//
//  QL_ConfigDataModel.h
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface QL_ConfigDataModel : Hen_JsonModel

@end

#pragma mark -- 地区数据

@interface QL_AreaDataModel : Hen_JsonModel

///地区id
@property(nonatomic, strong) NSString *areaId;
///全名字
@property(nonatomic, strong) NSString *fullName;
///名字
@property(nonatomic, strong) NSString *name;
///父id
@property(nonatomic, strong) NSString *parentId;
///拼音
@property(nonatomic, strong) NSString *zhName;

@end
