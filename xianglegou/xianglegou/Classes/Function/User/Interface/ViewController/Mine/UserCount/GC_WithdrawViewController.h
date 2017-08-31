//
//  GC_WithdrawViewController.h
//  Rebate
//
//  Created by mini3 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  提现界面
//


#import "Hen_BaseTableViewController.h"


@interface GC_WithdrawViewController : Hen_BaseViewController

///提现完成 回调
@property (nonatomic, copy) void(^onSuccessful)();
@end
