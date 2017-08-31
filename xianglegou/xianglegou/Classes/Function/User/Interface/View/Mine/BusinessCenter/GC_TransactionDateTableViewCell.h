//
//  GC_TransactionDateTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/7/1.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  交易时间 - cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_BusinessModel.h"

@interface GC_TransactionDateTableViewCell : Hen_BaseTableViewCell

///更新ui
- (void)updateUiForConsumeAmountData:(GC_MResConsumeAmountDataModel *)data;
@end
