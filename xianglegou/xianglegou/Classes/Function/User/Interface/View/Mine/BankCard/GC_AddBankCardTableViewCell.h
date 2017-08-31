//
//  GC_AddBankCardTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  添加银行卡 - cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_AddBankCardTableViewCell : Hen_BaseTableViewCell
///输入回调
@property (nonatomic, copy) void(^onInputTextFieldBlock)(NSString *inputStr,NSInteger item);


///说明点击回调
@property (nonatomic, copy) void(^onDescriptionBlock)(NSInteger item);

///标题信息
@property (nonatomic, strong) NSString *titleInfo;

///占位符
@property (nonatomic, strong) NSString *placeholder;

///输入信息
@property (nonatomic, strong) NSString *inputInfo;


///输入类型 、1：银行卡    2：手机号    3、身份证
@property (nonatomic, assign) NSInteger inputType;

///提示图是否显示
- (void)setIconImageHidden:(BOOL)hidden;
///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden;
///键盘类型   keyboardType、2 身份证号
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType;
///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO;

@end
