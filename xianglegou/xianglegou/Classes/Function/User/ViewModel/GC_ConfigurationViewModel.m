//
//  GC_ConfigurationViewModel.m
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_ConfigurationViewModel.h"

@implementation GC_ConfigurationViewModel

///获取配置信息 方法
-(void)getConfigurationDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:settingConfig_getConfigByKey dictionaryParam:self.configParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.configurationData = [[GC_MResConfigurationDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.configurationData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}
#pragma mark -- getter,setter
///获取配置信息 参数
- (NSMutableDictionary *)configParam
{
    if(!_configParam){
        _configParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        ///配置项
        [_configParam setObject:@"" forKey:@"configKey"];
    }
    return _configParam;
}

///获取配置信息 数据
- (GC_MResConfigurationDataModel *)configurationData
{
    if(!_configurationData){
        _configurationData = [[GC_MResConfigurationDataModel alloc] initWithDictionary:@{}];
    }
    return _configurationData;
}


@end
