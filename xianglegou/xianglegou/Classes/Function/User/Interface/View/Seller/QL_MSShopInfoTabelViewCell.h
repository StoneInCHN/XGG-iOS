//
//  QL_MSShopInfoTabelViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 我的店铺--店铺信息
//

#import "Hen_BaseTableViewCell.h"
#import "QL_ShopModel.h"

@interface QL_MSShopInfoTabelViewCell : Hen_BaseTableViewCell

///更新UI
- (void)updateUIForData:(QL_ShopInformationDataModel *)data;

@end
