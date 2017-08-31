//
//  GC_UserHelpViewModel.m
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_UserHelpViewModel.h"

@implementation GC_UserHelpViewModel
///获取帮助信息列表 方法
-(void)getUserHelpListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:settingConfig_userHelpList dictionaryParam:@{} withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            [self.userHelpListDatas removeAllObjects];
            
            for (NSDictionary *dic in msg) {
                [self.userHelpListDatas addObject:[[GC_MResUserHelpListDataModel alloc] initWithDictionary:dic]];
            }
            if(resultBlock){
                resultBlock(code, desc, self.userHelpListDatas, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}

///获取帮助详细信息 方法
-(void)getUserHelpDetailDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:settingConfig_userHelpDetail dictionaryParam:self.userHelpDetailParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.userHelpDetailData = [[GC_MResUserHelpDetailDataModel alloc] initWithDictionary:msg];
            if(resultBlock){
                resultBlock(code, desc, self.userHelpDetailData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}
#pragma mark -- getter,setter
///获取帮助信息列表 数据
- (NSMutableArray<GC_MResUserHelpListDataModel *> *)userHelpListDatas
{
    if(!_userHelpListDatas){
        _userHelpListDatas = [[NSMutableArray alloc] init];
    }
    return _userHelpListDatas;
}

///获取帮助详细信息 参数
- (NSMutableDictionary *)userHelpDetailParam
{
    if(!_userHelpDetailParam){
        _userHelpDetailParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //帮助信息ID
        [_userHelpDetailParam setObject:@"" forKey:@"entityId"];
    }
    return _userHelpDetailParam;
}

///获取帮助详细信息 数据
- (GC_MResUserHelpDetailDataModel *)userHelpDetailData
{
    if(!_userHelpDetailData){
        _userHelpDetailData = [[GC_MResUserHelpDetailDataModel alloc] initWithDictionary:@{}];
    }
    return _userHelpDetailData;
}
@end
