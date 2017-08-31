//
//  QL_MineAbonusCollectionViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/12.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseCollectionViewCell.h"
#import "GC_MineMessageModel.h"
#import "QL_AbonusModel.h"

@interface QL_MineAbonusCollectionViewCell : Hen_BaseCollectionViewCell

///更新ui
- (void)updateUIForUserInfoData:(GC_MResUserInfoDataModel *)data;
///更新UI
- (void)updateUIForUserAbonusData:(QL_UserAbonusDataModel *)data;

///显示加载
- (void)showLoading;
///取消加载
- (void)cancelLoading;

@end
