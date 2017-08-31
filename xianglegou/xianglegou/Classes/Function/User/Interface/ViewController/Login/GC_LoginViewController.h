//
//  GC_LoginViewController.h
//  Rebate
//
//  Created by mini3 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseLoginViewController.h"

@interface GC_LoginViewController : Hen_BaseLoginViewController

///登录成功 回调
@property (nonatomic, copy) void(^onLoginSuccessBlock)();
@end
