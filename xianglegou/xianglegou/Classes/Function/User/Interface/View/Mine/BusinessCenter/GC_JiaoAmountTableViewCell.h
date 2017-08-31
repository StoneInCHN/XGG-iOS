//
//  GC_JiaoAmountTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  交易额 - cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_BusinessModel.h"

@interface GC_JiaoAmountTableViewCell : Hen_BaseTableViewCell

///更新ui
- (void)updateUiForDiscountAmountsData:(GC_MResDiscountAmountsDataModel *)data;
@end
