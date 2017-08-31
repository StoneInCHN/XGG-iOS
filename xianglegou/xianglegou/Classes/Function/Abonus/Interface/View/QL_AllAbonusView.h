//
//  QL_AllAbonusView.h
//  Rebate
//
//  Created by mini2 on 17/3/31.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 全国分红view
//

#import <UIKit/UIKit.h>
#import "QL_AbonusModel.h"

@interface QL_AllAbonusView : UIView

///更新ui
- (void)updateUIForAllAbonusData:(QL_AllAbonusDataModel *)data;

///显示加载
- (void)showLoading;
///取消加载
- (void)cancelLoading;

@end
