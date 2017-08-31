//
//  GC_AddBankCardTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_AddBankCardTableViewCell.h"

#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"

@interface GC_AddBankCardTableViewCell ()<UITextFieldDelegate>

///标题
@property (nonatomic, weak) UILabel *titleLabel;
///输入框
@property (nonatomic, weak) UITextField *textField;
///图标
//@property (nonatomic, weak) UIImageView *iconImageView;

///图标
@property (nonatomic, weak) UIButton *iconButton;
@end


@implementation GC_AddBankCardTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_AddBankCardTableViewCell";
    GC_AddBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_AddBankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(160));
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-75));
    }];
    
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(OffSetToRight);
//        make.centerY.equalTo(self.contentView);
//        make.width.mas_equalTo(FITSCALE(30/2));
//        make.height.mas_equalTo(FITSCALE(30/2));
//    }];

    
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(HEIGHT_TRANSFORMATION(30));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(30));
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    [self.textField endEditing:YES];
    return YES;
}


#pragma mark -- private

///提示图是否显示
- (void)setIconImageHidden:(BOOL)hidden
{
    self.iconButton.hidden = hidden;
    if(hidden){
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(OffSetToRight);
        }];
    }else{
        [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-75));
        }];
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

///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType
{
    if(keyboardType == UIKeyboardTypeNumberPad){
        self.textField.ry_inputType = RYIntInputType;
        if(self.inputType == 1){
            self.textField.ry_inputAccessoryText = @"请输入银行卡号";
        }
        
    }else if(keyboardType == UIKeyboardTypeNumbersAndPunctuation){
        self.textField.ry_inputType = RYIDCardInputType;
        if(self.inputType == 3){
            self.textField.ry_inputAccessoryText = @"请输入身份证号";
        }
    }else{
        self.textField.keyboardType = keyboardType;
    }
}
///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO
{
    self.textField.userInteractionEnabled = isNO;
}



///icon点击回调
- (void)onDescriptionAction:(UIButton *)sender
{
    if(self.onDescriptionBlock){
        self.onDescriptionBlock(sender.tag);
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
- (UITextField *)textField
{
    if(!_textField){
        UITextField *textField = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = kFontSize_24;
        textField.textAlignment = NSTextAlignmentRight;
        textField.returnKeyType = UIReturnKeyDone;
        [textField setTextColor:kFontColorGray];
        [self.contentView addSubview:_textField = textField];
    }
    return _textField;
}

///图标
//- (UIImageView *)iconImageView
//{
//    if(!_iconImageView){
//        UIImageView *image = [UIImageView createImageViewWithName:@"mine_becareful"];
//        [image makeRadiusForWidth:FITSCALE(30/2)];
//        [self.contentView addSubview:_iconImageView = image];
//    }
//    return _iconImageView;
//}


///图标
- (UIButton *)iconButton
{
    if(!_iconButton){
        UIButton *butto = [UIButton createButtonWithTitle:@"" normalImage:@"mine_becareful" pressImage:@"mine_becareful" target:self action:@selector(onDescriptionAction:)];
        [self.contentView addSubview:_iconButton = butto];
    }
    return _iconButton;
}


- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    self.titleLabel.text = HenLocalizedString(titleInfo);
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.placeholder = HenLocalizedString(placeholder);
}

- (void)setInputInfo:(NSString *)inputInfo
{
    _inputInfo = inputInfo;
    self.textField.text = inputInfo;
}



@end
