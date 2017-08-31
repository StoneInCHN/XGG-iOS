//
//  QL_MineShopViewViewModel.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "QL_ShopModel.h"

@interface QL_MineShopViewViewModel : Hen_BaseViewModel

///店铺信息
@property(nonatomic, strong) QL_ShopInformationDataModel *shopInfoData;
///获取店铺信息
- (void)getShopInfoDataWithResultBlock:(RequestResultBlock)resultBlock;

@end
