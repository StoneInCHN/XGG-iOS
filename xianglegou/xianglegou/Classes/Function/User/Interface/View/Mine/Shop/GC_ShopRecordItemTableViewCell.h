//
//  GC_ShopRecordItemTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  店铺录单 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_ShopRecordItemTableViewCell : Hen_BaseTableViewCell

///输入回调
@property (nonatomic, copy) void(^onInputTextFieldBlock)(NSString *inputStr);

///标题信息
@property (nonatomic, strong) NSString *titleInfo;

///内容
@property (nonatomic, strong) NSString *contentInfo;

///输入信息
@property (nonatomic, strong) NSString *inputInfo;

///占位符
@property (nonatomic, strong) NSString *placeholder;

///TextField的显隐
-(void)setTextFieldHidden:(BOOL)hidden;

///清空按钮 显隐
-(void)setClearButtonHidden:(BOOL)hidden;
///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType;

///Next的显隐
-(void)setNextImageHidden:(BOOL)hidden;

///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO;
@end
