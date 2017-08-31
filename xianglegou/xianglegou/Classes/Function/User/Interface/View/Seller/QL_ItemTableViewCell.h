//
//  QL_ItemTableViewCell.h
//  Ask
//
//  Created by mini2 on 17/1/4.
//  Copyright © 2017年 Ask. All rights reserved.
//

#import "Hen_BaseTableViewCell.h"

@interface QL_ItemTableViewCell : Hen_BaseTableViewCell

///标题
@property(nonatomic, strong) NSString *title;
///信息
@property(nonatomic, strong) NSString *info;
///占位符
@property(nonatomic, strong) NSString *placeholder;
///单位
@property(nonatomic, strong) NSString *unit;
///已输入内容
@property(nonatomic, strong) NSString *inputedContent;
///小数位数
@property(nonatomic, assign) NSInteger decimalDigits;

///输入完成回调
@property(nonatomic, copy) void(^onInputFinishBlock)(NSString *inputStr);
///点击定位回调
@property(nonatomic, copy) void(^onLocationBlock)();

///设置下一步显隐
- (void)setNextImageHidden:(BOOL)hidden;
///设置输入框显隐
- (void)setTextFieldHidden:(BOOL)hidden;
///设置信息显隐
- (void)setInfoLabelHidden:(BOOL)hidden;
///设置输入框键盘类型
- (void)setTextFieldKeyboardType:(UIKeyboardType)keyboardType;
///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden;
///设置定位显隐
- (void)setLocationHidden:(BOOL)hidden;
///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO;
@end
