//
//  GC_LoginRowTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  登陆行 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_LoginRowTableViewCell : Hen_BaseTableViewCell

///输入回调
@property (nonatomic, copy) void(^onEnterTextFieldBlock)(NSString *enterStr,NSInteger item);

///发送回调
@property (nonatomic, copy) void(^onSenderBlock)(NSInteger item);

///占位符、
@property (nonatomic, strong) NSString *placeholder;
///iconImage
@property (nonatomic, strong) NSString *iconImage;

///输入信息
@property (nonatomic, strong) NSString *inputInfo;

///发送 按钮显示与否
-(void)setSenderHidden:(BOOL)hidden;

///密码框 是否启动
-(void)setStartUpPwdLock:(BOOL)isNo;

///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType;


///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden;

///倒计时 开启
-(void)startOnTimers;
@end
