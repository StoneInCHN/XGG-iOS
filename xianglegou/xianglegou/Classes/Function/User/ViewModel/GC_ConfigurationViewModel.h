//
//  GC_ConfigurationViewModel.h
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "GC_ConfigurationModel.h"

@interface GC_ConfigurationViewModel : Hen_BaseViewModel

///获取配置信息 参数
@property (nonatomic, strong) NSMutableDictionary *configParam;
///获取配置信息 数据
@property (nonatomic, strong) GC_MResConfigurationDataModel *configurationData;
///获取配置信息 方法
-(void)getConfigurationDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
