//
//  QL_DetailsAddressInputTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/14.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_DetailsAddressInputTableViewCell.h"

@interface QL_DetailsAddressInputTableViewCell()<UITextViewDelegate>

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///输入框
@property(nonatomic, weak) UITextView *textField;
///定位
@property(nonatomic, weak) UIButton *locationButton;

@end

@implementation QL_DetailsAddressInputTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_DetailsAddressInputTableViewCell";
    QL_DetailsAddressInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_DetailsAddressInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self unShowClickEffect];
    self.bottomLongLineImage.hidden = NO;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
    }];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.titleLabel.mas_right);
        make.height.equalTo(self.contentView);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(106));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(18));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-18));
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(250));
    }];
}

#pragma mark -- event response

- (void)onLocationAction:(UIButton *)sender
{
    if(self.onLocationBlock){
        self.onLocationBlock();
    }
}

#pragma mark -- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.info.length <= 0){
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.info = textView.text;
    if(self.info.length <= 0){
        textView.text = self.placeholder;
    }
    
    if(self.onInputFinishBlock){
        self.onInputFinishBlock(self.info);
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(self.onInputChangeBlock){
        self.onInputChangeBlock(textView.text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

///禁用TextView
- (void)setDisabledTextViewIsNo:(BOOL)isNO
{
    self.textField.editable = isNO;
}

///定位 按钮是否隐藏
- (void)setPositioningHidden:(BOOL)isHidden
{
    self.locationButton.hidden = isHidden;
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

///输入框
- (UITextView *)textField
{
    if(!_textField){
        UITextView *textView = [UITextView createTextViewWithDelegateTarget:self];
        textView.textColor = kFontColorGray;
        textView.font = kFontSize_24;
        textView.returnKeyType = UIReturnKeyDone;
        textView.scrollEnabled = NO;
        textView.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_textField = textView];
    }
    return _textField;
}

///定位
- (UIButton *)locationButton
{
    if(!_locationButton){
        UIButton *button = [UIButton createButtonWithTitle:@"定位" normalImage:@"public_icon_location" pressImage:@"public_icon_location" target:self action:@selector(onLocationAction:)];
        [button setTitleClor:kFontColorGray];
        button.titleLabel.font = kFontSize_24;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
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
    if(_info.length <= 0){
        self.textField.text = self.placeholder;
    }else{
        self.textField.text = info;
    }
}

///设置占位符
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if(self.info.length <= 0){
        self.textField.text = placeholder;
    }
}

@end
