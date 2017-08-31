//
//  GC_LoginButtonTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  登录按钮 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_LoginButtonTableViewCell : Hen_BaseTableViewCell

///忘记密码 回调
@property (nonatomic, copy) void(^onForgetPwdBlock)(NSInteger item);

///登录 回调
@property (nonatomic, copy) void(^onLoginBlock)(NSInteger item);

///登录 状态切换 回调
@property (nonatomic, copy) void(^onLoginStateBlock)(NSInteger item);

///注册账号 回调
@property (nonatomic, copy) void(^onRegisteredBlock)(NSInteger item);

///按钮字体显示
@property (nonatomic, strong) NSString *titleInfo;
@end
