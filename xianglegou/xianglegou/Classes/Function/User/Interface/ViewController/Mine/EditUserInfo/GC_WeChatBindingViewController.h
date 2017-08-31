//
//  GC_WeChatBindingViewController.h
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  微信绑定 界面
//

#import "Hen_BaseTableViewController.h"

@interface GC_WeChatBindingViewController : Hen_BaseTableViewController

///返回回调
@property (nonatomic, copy) void(^onReturnClickBlock)();
@end
