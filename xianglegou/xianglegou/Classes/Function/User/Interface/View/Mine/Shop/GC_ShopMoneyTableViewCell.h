//
//  GC_ShopMoneyTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  店铺货款 -- cell
//


#import "Hen_BaseTableViewCell.h"
#import "GC_ShopManagerModel.h"

@interface GC_ShopMoneyTableViewCell : Hen_BaseTableViewCell

///更新 ui
- (void)updateUIForPatMentListData:(GC_MResPaymentListDataModel *)data;
@end
