//
//  QL_SSInfoInputTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SSInfoInputTableViewCell.h"

@interface QL_SSInfoInputTableViewCell()<UITextViewDelegate>

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///输入背景
@property(nonatomic, weak) UIImageView *inputBgImage;
///输入框
@property(nonatomic, weak) UITextView *textView;
///字数
@property(nonatomic, weak) UILabel *worldCountLabel;
///提示
@property(nonatomic, weak) UILabel *noticeLabel;

@end

@implementation QL_SSInfoInputTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_SSInfoInputTableViewCell";
    QL_SSInfoInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SSInfoInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
- (void)initDefault
{
    
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
    }];
    [self.inputBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(160));
    }];
    [self.worldCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputBgImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(4));
        make.right.equalTo(self.inputBgImage);
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.inputBgImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(60));
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(80));
        make.top.equalTo(self.inputBgImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(90));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
    }];
}

///隐藏提示
- (void)hiddenNotice
{
    self.noticeLabel.hidden = YES;
}

#pragma mark -- UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(self.onInfoContentBlock){
        self.onInfoContentBlock(textView.text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.text.length > 500){
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.markedTextRange == nil && textView.text.length >= 500){
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 500)];
    }
    
    self.worldCountLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, 500];
}


#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"店铺简介（选填）" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///输入背景
 - (UIImageView *)inputBgImage
{
    if(!_inputBgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_shop_input"];
        [self.contentView addSubview:_inputBgImage = image];
        
        UITextView *textView = [UITextView createTextViewWithDelegateTarget:self];
        textView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_textView = textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(image).insets(UIEdgeInsetsMake(5, 5, 5, 5));
        }];
    }
    return _inputBgImage;
}

///字数
- (UILabel *)worldCountLabel
{
    if(!_worldCountLabel){
        UILabel *label = [UILabel createLabelWithText:@"0/500" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_worldCountLabel = label];
    }
    return _worldCountLabel;
}

///提示
- (UILabel *)noticeLabel
{
    if(!_noticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"同意《入驻商户服务协议》" font:kFontSize_28];
        [self.contentView addSubview:_noticeLabel = label];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"public_remind_select_choose"];
        [label addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.right.equalTo(label.mas_left).offset(WIDTH_TRANSFORMATION(-8));
        }];
    }
    return _noticeLabel;
}

///线
- (UIImageView *)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self.contentView addSubview:image];
    
    return image;
}

- (void)setContent:(NSString *)content
{
    self.textView.text = content;
    self.worldCountLabel.text = [NSString stringWithFormat:@"%ld/500", content.length];
}

@end
