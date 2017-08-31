//
//  QL_MineAbonusView.h
//  Rebate
//
//  Created by mini2 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 我的分红view
//

#import <UIKit/UIKit.h>
#import "GC_MineMessageModel.h"
#import "QL_AbonusModel.h"

@interface QL_MineAbonusView : UIView

///更新ui
- (void)updateUIForUserInfoData:(GC_MResUserInfoDataModel *)data;
///更新UI
- (void)updateUIForUserAbonusData:(QL_UserAbonusDataModel *)data;

///显示加载
- (void)showLoading;
///取消加载
- (void)cancelLoading;

@end
