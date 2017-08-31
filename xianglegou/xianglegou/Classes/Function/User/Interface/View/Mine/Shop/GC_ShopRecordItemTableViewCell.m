//
//  GC_ShopRecordItemTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  店铺录单 -- cell
//

#import "GC_ShopRecordItemTableViewCell.h"

#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"


@interface GC_ShopRecordItemTableViewCell ()<UITextFieldDelegate>

///标题
@property (nonatomic, weak) UILabel *titleLabel;
///内容
@property (nonatomic, weak) UILabel *contentLabel;
///输入框
@property (nonatomic, weak) UITextField *textField;

///下一步
@property (nonatomic, weak) UIImageView *nextImageView;
@end

@implementation GC_ShopRecordItemTableViewCell
///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_ShopRecordItemTableViewCell";
    GC_ShopRecordItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_ShopRecordItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(230));
        make.centerY.equalTo(self.contentView);
        
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.height.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(230));
    }];
    
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.centerY.equalTo(self.contentView);
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
        self.onInputTextFieldBlock(textField.text);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField endEditing:YES];
    return YES;
}

#pragma mark -- private
///TextField的显隐
-(void)setTextFieldHidden:(BOOL)hidden
{
    self.textField.hidden = hidden;
}

///清空按钮 显隐
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

    if(keyboardType == UIKeyboardTypeDecimalPad){       //小数
        self.textField.ry_inputType = RYFloatInputType;
        self.textField.ry_inputZeroBeginning = 1;
        self.textField.ry_floatDecimal = 2;
    }else if(keyboardType == UIKeyboardTypeNumberPad){  //整数
        self.textField.ry_inputType = RYIntInputType;
    }else{
        self.textField.keyboardType = keyboardType;
    }
    
}


///Next的显隐
-(void)setNextImageHidden:(BOOL)hidden
{
    self.nextImageView.hidden = hidden;
    
    
    if(hidden){
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        }];
    }else{
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-65));
        }];
    }
}


///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO
{
    self.textField.userInteractionEnabled = isNO;
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

///内容
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_24 textColor:kFontColorGray];
        [label setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_contentLabel = label];
    }
    return _contentLabel;
}
///输入框
- (UITextField *)textField
{
    if(!_textField){
        UITextField *textField = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = kFontSize_24;
        textField.textAlignment = NSTextAlignmentRight;
        textField.returnKeyType = UIReturnKeyDone;
        [textField setTextColor:kFontColorGray];
        textField.hidden = YES;
        [self.contentView addSubview:_textField = textField];
    }
    return _textField;
}


- (UIImageView *)nextImageView
{
    if(!_nextImageView){
        
        UIImageView *image = [UIImageView createImageViewWithName:@"public_next"];
        image.hidden = YES;
        [self.contentView addSubview:_nextImageView = image];
    }
    return _nextImageView;
}

- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    self.titleLabel.text = HenLocalizedString(titleInfo);
}


- (void)setContentInfo:(NSString *)contentInfo
{
    _contentInfo = contentInfo;
    self.contentLabel.text = contentInfo;
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
