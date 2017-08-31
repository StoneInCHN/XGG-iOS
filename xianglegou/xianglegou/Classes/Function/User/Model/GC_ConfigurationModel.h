//
//  GC_ConfigurationModel.h
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_ConfigurationModel : Hen_JsonModel

@end

#pragma mark --  配置数据信息
@interface GC_MResConfigurationDataModel : Hen_JsonModel
///id
@property (nonatomic, strong) NSString *id;
///内容
@property (nonatomic, strong) NSString *configValue;

@end
