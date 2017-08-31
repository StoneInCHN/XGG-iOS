//
//  GC_MineItemTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_MineItemTableViewCell.h"

@interface GC_MineItemTableViewCell ()<UITextFieldDelegate>
///标题
@property (nonatomic, weak) UILabel *titleLabel;

///Next ImageView
@property (nonatomic, weak) UIImageView *nextImageView;
///内容
@property (nonatomic, weak) UILabel *contentInfoLabel;

///输入框
@property (nonatomic, weak) UITextField *inputTextField;
@end

@implementation GC_MineItemTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_MineItemTableViewCell";
    
    GC_MineItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_MineItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(30));
        make.centerY.equalTo(self);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-30));
        make.centerY.equalTo(self);
    }];
    
    [self.contentInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-64));
        make.centerY.equalTo(self);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self).offset(OffSetToRight);
        make.left.equalTo(self.titleLabel.mas_right).offset(WIDTH_TRANSFORMATION(50));
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




- (void)textFieldDidChange:(UITextField *)textField
{
    
    if(self.maxCount > 0){
        
        
//        if (textField == self.inputTextField) {
//            if (textField.text.length > self.maxCount) {
//                textField.text = [textField.text substringToIndex:self.maxCount];
//            }
//        }
        
        NSString *toBeString = textField.text;
        
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
        if (!position){
            if (toBeString.length > self.maxCount){
                //中文和emoj表情存在问题，需要对此进行处理
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxCount)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}


//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if(range.length + range.location > textField.text.length)
//    {
//        return NO;
//    }
//    
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
//    
//    return newLength <= 7;//最大字数长度
//    
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTextField endEditing:YES];
    return YES;
}

#pragma mark -- private
///输入框的 是否显示
-(void)setTextFieldHidden:(BOOL)isNo
{
    self.inputTextField.hidden = isNo;
//    if(isNo){
//        self.contentInfoLabel.hidden = NO;
//    }else{
//        self.contentInfoLabel.hidden = YES;
//    }
}

///输入框的 是否可用
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO
{
    self.inputTextField.userInteractionEnabled = isNO;
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

///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType andInputPrice:(BOOL)isPrice
{
    if(isPrice){
        self.inputTextField.ry_inputType = RYFloatInputType;
        self.inputTextField.ry_inputZeroBeginning = 1;
        self.inputTextField.ry_floatDecimal = 2;
    }else{
        self.inputTextField.keyboardType = keyboardType;
    }
}


///Next 的显隐
-(void)setNextImageViewHidden:(BOOL)hidden
{
    self.nextImageView.hidden = hidden;
}
#pragma mark -- action

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

///Next
- (UIImageView *)nextImageView
{
    if(!_nextImageView){
        UIImageView *nextImage = [UIImageView createImageViewWithName:@"public_next"];
        [self.contentView addSubview:_nextImageView = nextImage];
    }
    return _nextImageView;
}

///内容
- (UILabel *)contentInfoLabel
{
    if(!_contentInfoLabel){
        UILabel *contentKLabel = [UILabel createLabelWithText:@"" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_contentInfoLabel = contentKLabel];
    }
    return _contentInfoLabel;
}

///输入框
- (UITextField *)inputTextField
{
    if(!_inputTextField){
        UITextField *inputTextField = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        inputTextField.borderStyle = UITextBorderStyleNone;
        inputTextField.font = kFontSize_24;
        inputTextField.textAlignment = NSTextAlignmentRight;
        inputTextField.returnKeyType = UIReturnKeyDone;
        [inputTextField setTextColor:kFontColorGray];
        inputTextField.hidden = YES;
        [inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_inputTextField = inputTextField];
    }
    return _inputTextField;
}

- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    self.titleLabel.text = HenLocalizedString(titleInfo);
}


- (void)setContentInfo:(NSString *)contentInfo
{
    _contentInfo = contentInfo;
    self.contentInfoLabel.text = HenLocalizedString(contentInfo);
}


- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.inputTextField.placeholder = placeholder;
}

- (void)setInputInfo:(NSString *)inputInfo
{
    _inputInfo = inputInfo;
    self.inputTextField.text = inputInfo;
}
@end
