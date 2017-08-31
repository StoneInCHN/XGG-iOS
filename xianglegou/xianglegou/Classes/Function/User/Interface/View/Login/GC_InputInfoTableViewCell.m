//
//  GC_InputInfoTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_InputInfoTableViewCell.h"

#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"

@interface GC_InputInfoTableViewCell ()<UITextFieldDelegate>

///标题
@property (nonatomic, weak) UILabel *titleLabel;
///输入内容
@property (nonatomic, weak) UITextField *inputTextField;

@end

@implementation GC_InputInfoTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_InputInfoTableViewCell";
    GC_InputInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_InputInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(90);
}



///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.centerY.equalTo(self);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(225));
        make.right.equalTo(self).offset(OffSetToRight);
        make.height.equalTo(self);
        make.centerY.equalTo(self);
    }];
}


#pragma mark -- UITextFeildDelegate
///输入框 回调 方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.onInputTextFieldBlock){
        self.onInputTextFieldBlock(textField.text, textField.tag);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTextField endEditing:YES];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -- private
///密码框 是否启动
-(void)setStartUpPwdLock:(BOOL)isNo
{
    self.inputTextField.secureTextEntry = isNo;
}

///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType
{
    if(keyboardType == UIKeyboardTypeNumberPad){
        self.inputTextField.ry_inputType = RYIntInputType;
    }else{
        self.inputTextField.keyboardType = keyboardType;
    }
}



///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden
{
    if(hidden){
        self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.inputTextField.clearButtonMode = UITextFieldViewModeNever;
    }
    
}

#pragma mark -- getter,setter
///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = titleLabel];
    }
    return _titleLabel;
}

///输入内容
- (UITextField *)inputTextField
{
    if(!_inputTextField){
        UITextField *textField = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = kFontSize_24;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_inputTextField = textField];
    }
    return _inputTextField;
}

- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    self.titleLabel.text = HenLocalizedString(titleInfo);
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.inputTextField.placeholder = HenLocalizedString(placeholder);
}

- (void)setInputInfo:(NSString *)inputInfo
{
    _inputInfo = inputInfo;
    self.inputTextField.text = inputInfo;
}
@end
