//
//  GC_MineItemTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  列表显示 -- cell
//

#import "Hen_BaseTableViewCell.h"
#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"

@interface GC_MineItemTableViewCell : Hen_BaseTableViewCell

///输入回调
@property (nonatomic, copy) void(^onInputTextFieldBlock)(NSString *inputStr, NSInteger item);

///标题
@property (nonatomic, strong) NSString *titleInfo;
///内容
@property (nonatomic, strong) NSString *contentInfo;

///输入内容
@property (nonatomic, strong) NSString *inputInfo;

///占位符
@property (nonatomic, strong) NSString *placeholder;

///输入框的 是否显示
-(void)setTextFieldHidden:(BOOL)isNo;

///输入框的 是否可用
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO;
///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden;
///Next 的显隐
-(void)setNextImageViewHidden:(BOOL)hidden;


///限制输入 字数
@property (nonatomic, assign) NSInteger maxCount;


///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType andInputPrice:(BOOL)isPrice;
@end
