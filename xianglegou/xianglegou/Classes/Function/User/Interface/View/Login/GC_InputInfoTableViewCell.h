//
//  GC_InputInfoTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseTableViewCell.h"

@interface GC_InputInfoTableViewCell : Hen_BaseTableViewCell

///输入回调
@property (nonatomic, copy) void(^onInputTextFieldBlock)(NSString *inputStr,NSInteger item);

///标题信息
@property (nonatomic, strong) NSString *titleInfo;

///占位符
@property (nonatomic, strong) NSString *placeholder;

///输入信息
@property (nonatomic, strong) NSString *inputInfo;


///密码框 是否启动
-(void)setStartUpPwdLock:(BOOL)isNo;
///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden;
///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType;
@end
