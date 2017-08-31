//
//  GC_RegisteredViewController.h
//  Rebate
//
//  Created by mini3 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  注册界面
//

#import "Hen_BaseViewController.h"

@interface GC_RegisteredViewController : Hen_BaseViewController

///注册 成功回调
@property (nonatomic, copy) void(^onRegisteredSuccessBlock)();
@end
