//
//  QL_HomePageViewModel.m
//  Rebate
//
//  Created by mini2 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_HomePageViewModel.h"

@implementation QL_HomePageViewModel

///获取商家列表
- (void)getBusinessListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:seller_list dictionaryParam:[self.businessListParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSDictionary *dic in msg){
                QL_BusinessListDataModel *model = [[QL_BusinessListDataModel alloc] initWithDictionary:dic];
                model.Description = [dic getStringValueForKey:@"description" defaultValue:@""];
                [array addObject:model];
            }
            if([self.businessListParam.pageNumber isEqualToString:@"1"]){
                [self.businessListDatas removeAllObjects];
            }
            [self.businessListDatas addObjectsFromArray:array];
            
            if(resultBlock){
                resultBlock(code, desc, array, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
}

///获取banner数据
- (void)getBannerDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:banner_hpTop dictionaryParam:@{} withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            [self.bannerDatas removeAllObjects];
            for(NSDictionary *dic in msg){
                [self.bannerDatas addObject:[[QL_HomePageBannerDataModel alloc] initWithDictionary:dic]];
            }
            
            if(resultBlock){
                resultBlock(code, desc, self.bannerDatas, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
}

#pragma mark -- getter,setter

///商家列表请求参数
- (QL_BusinessListRequestDataModel *)businessListParam
{
    if(!_businessListParam){
        _businessListParam = [[QL_BusinessListRequestDataModel alloc] initWithDictionary:@{}];
        
        _businessListParam.pageSize = NumberOfPages;
    }
    return _businessListParam;
}

///商家列表数据
- (NSMutableArray<QL_BusinessListDataModel *> *)businessListDatas
{
    if(!_businessListDatas){
        _businessListDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _businessListDatas;
}

///banner数据
- (NSMutableArray<QL_HomePageBannerDataModel *> *)bannerDatas
{
    if(!_bannerDatas){
        _bannerDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _bannerDatas;
}

@end
