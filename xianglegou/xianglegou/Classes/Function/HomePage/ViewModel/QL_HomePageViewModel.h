//
//  QL_HomePageViewModel.h
//  Rebate
//
//  Created by mini2 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 首页view model
//

#import "Hen_BaseViewModel.h"
#import "QL_BusinessModel.h"
#import "QL_BusinessRequestModel.h"
#import "QL_ShopModel.h"

@interface QL_HomePageViewModel : Hen_BaseViewModel

///商家列表请求参数
@property(nonatomic, strong) QL_BusinessListRequestDataModel *businessListParam;
///商家列表数据
@property(nonatomic, strong) NSMutableArray<QL_BusinessListDataModel *> *businessListDatas;
///获取商家列表
- (void)getBusinessListDatasWithResultBlock:(RequestResultBlock)resultBlock;

///banner数据
@property(nonatomic, strong) NSMutableArray<QL_HomePageBannerDataModel *> *bannerDatas;
///获取banner数据
- (void)getBannerDatasWithResultBlock:(RequestResultBlock)resultBlock;

@end
