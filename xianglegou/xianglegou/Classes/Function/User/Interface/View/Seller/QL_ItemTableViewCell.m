//
//  QL_ItemTableViewCell.m
//  Ask
//
//  Created by mini2 on 17/1/4.
//  Copyright © 2017年 Ask. All rights reserved.
//

#import "QL_ItemTableViewCell.h"
#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"

@interface QL_ItemTableViewCell()<UITextFieldDelegate>

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///信息
@property(nonatomic, weak) UILabel *infoLabel;
///输入框
@property(nonatomic, weak) UITextField *textField;
///单位
@property(nonatomic, weak) UILabel *unitLabel;
///下一步
@property(nonatomic, weak) UIImageView *nextImageView;
///定位
@property(nonatomic, weak) UIButton *locationButton;

@end

@implementation QL_ItemTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_ItemTableViewCell";
    QL_ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(92);
}

///初始化
- (void)initDefault
{
    self.decimalDigits = 1;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-56));
    }];
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.height.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(200));
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.titleLabel.mas_right);
        make.height.equalTo(self.contentView);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(106));
    }];
}

///设置下一步显隐
- (void)setNextImageHidden:(BOOL)hidden
{
    self.nextImageView.hidden = hidden;
    if(hidden){
        [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(OffSetToRight);
        }];
    }else{
        [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-58));
        }];
    }
}

///设置输入框显隐
- (void)setTextFieldHidden:(BOOL)hidden
{
    self.textField.hidden = hidden;
}

///设置信息显隐
- (void)setInfoLabelHidden:(BOOL)hidden
{
    self.infoLabel.hidden = hidden;
}

///设置输入框键盘类型
-(void)setTextFieldKeyboardType:(UIKeyboardType)keyboardType
{
    if(keyboardType == UIKeyboardTypeNumberPad || keyboardType == UIKeyboardTypePhonePad){
       self.textField.ry_inputType = RYIntInputType;
    }else if(keyboardType == UIKeyboardTypeDecimalPad){
        self.textField.ry_inputType = RYFloatInputType;
        self.textField.ry_inputZeroBeginning = 1;
        self.textField.ry_floatDecimal = 1;
    }else{
        self.textField.keyboardType = keyboardType;
    }
    
    
}

///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden
{
    if(hidden){
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.textField.clearButtonMode = UITextFieldViewModeNever;
    }
    
}

///设置定位显隐
- (void)setLocationHidden:(BOOL)hidden
{
    self.locationButton.hidden = hidden;
}

///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO
{
    self.textField.userInteractionEnabled = isNO;
}
#pragma mark -- event response

- (void)onLocationAction:(UIButton *)sender
{
    if(self.onLocationBlock){
        self.onLocationBlock();
    }
}

#pragma mark -- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.onInputFinishBlock){
        self.onInputFinishBlock(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.keyboardType == UIKeyboardTypeDecimalPad || textField.keyboardType == UIKeyboardTypeNumberPad){
        //输入两位以上数字不能已0开头
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        if(futureString.length > 1 && [futureString hasPrefix:@"0"]){
            if([futureString rangeOfString:@"."].location == NSNotFound){
                return NO;
            }
        }
    }
    if(textField.keyboardType == UIKeyboardTypeDecimalPad){
        //不能以.开始
        if([textField.text isEqualToString:@""] && [string isEqualToString:@"."]){
            return NO;
        }
        if([textField.text rangeOfString:@"."].location !=NSNotFound && [string isEqualToString:@"."]){
            return NO;
        }
        
        //限制用户输入小数点后位数的方法
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        
        NSInteger flag=0;
        const NSInteger limited = self.decimalDigits;
        for (NSInteger i = futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                
                if (flag > limited) {
                    return NO;
                }
                
                break;
            }
            flag++;
        }
        
        return YES;
    }
    return YES;
}

#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///信息
- (UILabel *)infoLabel
{
    if(!_infoLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_infoLabel = label];
    }
    return _infoLabel;
}

///输入框
- (UITextField *)textField
{
    if(!_textField){
        UITextField *textField = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        textField.hidden = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = kFontSize_24;
        textField.textColor = kFontColorGray;
        [self.contentView addSubview:_textField = textField];
    }
    return _textField;
}

///单位
- (UILabel *)unitLabel
{
    if(!_unitLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_24 textColor:kFontColorGray];
        label.hidden = YES;
        [self.contentView addSubview:_unitLabel = label];
    }
    return _unitLabel;
}

///下一步
- (UIImageView *)nextImageView
{
    if(!_nextImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_next"];
        [self.contentView addSubview:_nextImageView = image];
    }
    return _nextImageView;
}

///定位
- (UIButton *)locationButton
{
    if(!_locationButton){
        UIButton *button = [UIButton createButtonWithTitle:@"定位" normalImage:@"public_icon_location" pressImage:@"public_icon_location" target:self action:@selector(onLocationAction:)];
        [button setTitleClor:kFontColorGray];
        button.titleLabel.font = kFontSize_24;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.hidden = YES;
        [self.contentView addSubview:_locationButton = button];
    }
    return _locationButton;
}

///设置标题
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

///设置信息
- (void)setInfo:(NSString *)info
{
    _info = info;
    self.infoLabel.text = info;
    self.textField.text = info;
}

///设置占位符
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
    [self.textField setValue:kFontColorGray forKeyPath:@"_placeholderLabel.textColor"];
    
    self.textField.hidden = NO;
    self.infoLabel.hidden = YES;
}

///设置单位
- (void)setUnit:(NSString *)unit
{
    self.unitLabel.hidden = NO;
    self.unitLabel.text = unit;
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(WIDTH_TRANSFORMATION(-70));
    }];
}

///设置已输入内容
- (void)setInputedContent:(NSString *)inputedContent
{
    _inputedContent = inputedContent;
    self.textField.text = inputedContent;
}

@end
