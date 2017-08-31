//
//  GC_MobileSenderTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  手机号发送 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_MobileSenderTableViewCell : Hen_BaseTableViewCell

///输入回调
@property (nonatomic, copy) void(^onInputTextFieldBlock)(NSString *inputStr,NSInteger item);

///发送短信回调
@property (nonatomic, copy) void(^onSenderBlock)(NSInteger item);

///标题信息
@property (nonatomic, strong) NSString *titleInfo;

///占位符
@property (nonatomic, strong) NSString *placeholder;

///输入信息
@property (nonatomic, strong) NSString *inputInfo;

///倒计时 开启
-(void)startOnTimers;

///输入框的字体位置
- (void)setTextFieldAlignment:(NSTextAlignment)textAlignment;

///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO;
///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden;
///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType;

///设置发送按钮
-(void)setSenderButtonHidden:(BOOL)hidden;
///显示的秒数
-(void)setSecondLabelHidden:(BOOL)hidden;



@end
