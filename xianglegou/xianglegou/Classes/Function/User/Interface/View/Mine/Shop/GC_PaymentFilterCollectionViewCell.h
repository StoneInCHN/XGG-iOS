//
//  GC_PaymentFilterCollectionViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/7/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseCollectionViewCell.h"
#import "GC_PaymentFilterView.h"

@interface GC_PaymentFilterCollectionViewCell : Hen_BaseCollectionViewCell

///更新 ui
- (void)updateUiForDate:(GC_PaymentFilterDataModel *)data;

///选择状态
- (void)setFilterIsSelected:(BOOL)isSelected;
@end
