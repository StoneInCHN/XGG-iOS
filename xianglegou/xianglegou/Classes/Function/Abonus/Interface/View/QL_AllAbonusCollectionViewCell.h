//
//  QL_AllAbonusCollectionViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/12.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseCollectionViewCell.h"
#import "GC_MineMessageModel.h"
#import "QL_AbonusModel.h"

@interface QL_AllAbonusCollectionViewCell : Hen_BaseCollectionViewCell

///更新ui
- (void)updateUIForAllAbonusData:(QL_AllAbonusDataModel *)data;

///显示加载
- (void)showLoading;
///取消加载
- (void)cancelLoading;

@end
