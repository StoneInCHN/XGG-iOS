//
//  GC_MineIntegralViewController.h
//  Rebate
//
//  Created by mini3 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  我的积分 -- 界面
//

#import "Hen_BaseViewController.h"

@interface GC_MineIntegralViewController : Hen_BaseViewController

///当前积分
@property (nonatomic, strong) NSString *curScore;
///累计积分
@property (nonatomic, strong) NSString *totalScore;

@end
