//
//  GC_MineEditPasswordViewController.h
//  Rebate
//
//  Created by mini3 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  修改 密码 界面
//

#import "Hen_BaseTableViewController.h"

@interface GC_MineEditPasswordViewController : Hen_BaseTableViewController

///修改密码类型  0：登录密码修改   1：支付密码修改
@property (nonatomic, assign) NSInteger editPwdType;


///修改成功 回调
@property (nonatomic, copy) void(^onEditSuccessBlock)();


///支付密码 修改成功 回调
@property (nonatomic, copy) void (^onEditPaySuccessBlock)(NSString *payPwd);
@end
