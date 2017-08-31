//
//  QL_PayBillInfoTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_PayBillInfoTableViewCell.h"
#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"

@interface QL_PayBillInfoTableViewCell()<UITextFieldDelegate, UITextViewDelegate>

///logo
@property(nonatomic, weak) UIImageView *logoImage;
///名字
@property(nonatomic, weak) UILabel *nameLabel;
///消费提示
@property(nonatomic, weak) UILabel *consumptionInfoLabel;
///消费金额提示
@property(nonatomic, weak) UILabel *consumptionFreeNoticeLabel;
///消费金额输入
@property(nonatomic, weak) UITextField *freeTextField;
///备注输入
@property(nonatomic, weak) UITextView *remarksTextView;
///字数
@property(nonatomic, weak) UILabel *worldCountLabel;

///备注
@property(nonatomic, strong) NSString *remark;



@end

@implementation QL_PayBillInfoTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_PayBillInfoTableViewCell";
    QL_PayBillInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_PayBillInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(680);
}

///初始化
- (void)initDefault
{
    self.bottomLongLineImage.hidden = NO;
    [self unShowClickEffect];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(40));
        make.width.mas_equalTo(FITSCALE(250/2));
        make.height.mas_equalTo(FITSCALE(250/2));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.logoImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
    }];
    [self.consumptionInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(24));
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.consumptionInfoLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(24));
    }];
    [self.consumptionFreeNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self.consumptionInfoLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(56));
    }];
    [self.freeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.consumptionFreeNoticeLabel);
        make.right.equalTo(self).offset(OffSetToRight);
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(220));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(90));
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.freeTextField.mas_bottom);
    }];
    [self.remarksTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self.freeTextField.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
        make.right.equalTo(self).offset(OffSetToRight);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(70));
    }];
    [self.worldCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
        make.top.equalTo(self.remarksTextView.mas_bottom);
    }];
}

///更新
- (void)updateUIForData:(QL_BussinessDetialsDataModel *)data
{
    if(data){
        [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl, data.storePictureUrl] defaultImageName:@""];
        self.nameLabel.text = data.name;
        self.consumptionInfoLabel.text = [NSString stringWithFormat:@"消费%@赠送%@积分", data.unitConsume, data.rebateScore];
    }
}


///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden
{
    if(hidden){
        self.freeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else{
        self.freeTextField.clearButtonMode = UITextFieldViewModeNever;
    }
    
}

#pragma mark -- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.onPriceInputBlock){
        self.onPriceInputBlock(textField.text);
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
        const NSInteger limited = 2;
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

#pragma mark -- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.remark.length <= 0){
        textView.text = @"";
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 15){
        textView.text = [textView.text substringToIndex:15 + 1];
    }
    
    self.remark = textView.text;
    
    self.worldCountLabel.text = [NSString stringWithFormat:@"%ld/%d", (long)self.remark.length, 15];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        textView.text = @"备注（选填）";
    }
    if(self.onRemarkInputBlock){
        self.onRemarkInputBlock(textView.text);
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果为回车则将键盘收起
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    if(![text isEqualToString:@""] && textView.text.length >= 15){
        return NO;
    }
    
    return YES;
}

#pragma mark -- getter,setter

///logo
- (UIImageView *)logoImage
{
    if(!_logoImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        image.backgroundColor = kCommonBackgroudColor;
        [self.contentView addSubview:_logoImage = image];
    }
    return _logoImage;
}

///名字
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"Name" font:kFontSize_38 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///消费提示
- (UILabel *)consumptionInfoLabel
{
    if(!_consumptionInfoLabel){
        UILabel *label = [UILabel createLabelWithText:@"消费xx赠送xx积分" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_consumptionInfoLabel = label];
    }
    return _consumptionInfoLabel;
}

///消费金额提示
- (UILabel *)consumptionFreeNoticeLabel
{
    if(!_consumptionFreeNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"消费金额" font:kFontSize_28];
        [self.contentView addSubview:_consumptionFreeNoticeLabel = label];
    }
    return _consumptionFreeNoticeLabel;
}

///消费金额输入
- (UITextField *)freeTextField
{
    if(!_freeTextField){
        
        UITextField *textField = [UITextField createTextFieldWithPlaceholder:@"询问服务员后输入" delegateTarget:self];
        ///textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.ry_inputType = RYFloatInputType;
        textField.ry_inputZeroBeginning = 1;
        textField.ry_floatDecimal = 2;
        [self.contentView addSubview:_freeTextField = textField];
    }
    return _freeTextField;
}

///备注输入
- (UITextView *)remarksTextView
{
    if(!_remarksTextView){
        UITextView *textView = [UITextView createTextViewWithDelegateTarget:self];
        textView.textColor = kFontColorGray;
        textView.font = kFontSize_28;
        textView.returnKeyType = UIReturnKeyDone;
        textView.text = @"备注（选填）";
        [self.contentView addSubview:_remarksTextView = textView];
    }
    return _remarksTextView;
}

///字数
- (UILabel *)worldCountLabel
{
    if(!_worldCountLabel){
        UILabel *label = [UILabel createLabelWithText:@"0/15" font:kFontSize_28 textColor:kFontColorGray];
        [self.contentView addSubview:_worldCountLabel = label];
    }
    return _worldCountLabel;
}

///线
- (UIImageView *)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self.contentView addSubview:image];
    return image;
}

@end
