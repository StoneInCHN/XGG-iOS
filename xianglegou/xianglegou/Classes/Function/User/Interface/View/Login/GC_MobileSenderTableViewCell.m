//
//  GC_MobileSenderTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_MobileSenderTableViewCell.h"
#import "BFSTimerextension.h"
#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"

@interface GC_MobileSenderTableViewCell ()<UITextFieldDelegate,BFSTimerextensionDelegate>

///标题
@property (nonatomic, weak) UILabel *titleLabel;
///输入框
@property (nonatomic, weak) UITextField *inputTextField;
///发送按钮
@property (nonatomic, weak) UIButton *senderButton;
///秒
@property (nonatomic, weak) UILabel *secondLabel;

///剩余时间
@property (nonatomic, assign) long second;


@property (nonatomic, strong) BFSTimerextension *countDownTimer;
@end

@implementation GC_MobileSenderTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_MobileSenderTableViewCell";
    GC_MobileSenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_MobileSenderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)dealloc
{

    [self setCountDownTimer:nil];
}
///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.centerY.equalTo(self);
    }];
    
    [self.senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(FITSCALE(56/2));
        make.width.mas_equalTo(FITSCALE(100/2));
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(225));
        make.height.equalTo(self);
        make.right.equalTo(self.senderButton.mas_left).offset(WIDTH_TRANSFORMATION(-25));
        make.centerY.equalTo(self);
    }];
    
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
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

///输入框的字体位置
- (void)setTextFieldAlignment:(NSTextAlignment)textAlignment
{
    [self.inputTextField setTextAlignment:textAlignment];
}

///是否禁止输入框的输入功能
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
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType
{
    if(keyboardType == UIKeyboardTypeNumberPad){
        self.inputTextField.ry_inputType = RYIntInputType;
    }else{
        self.inputTextField.keyboardType = keyboardType;
    }
}


///倒计时 开启
-(void)startOnTimers
{
    self.senderButton.hidden = YES;
    self.secondLabel.hidden = NO;
    self.second = 60;
    [self.countDownTimer startTimer:1 repeats:YES];
}


#pragma BFSTimerextensionDelegate 代理

///计算时间 方法
-(void)timerfucntionCall
{
    
    if(self.second > 0){
        self.secondLabel.text = [NSString stringWithFormat:@"%ldS",self.second];
    }else{
        [self.countDownTimer stopTimer];
        self.second = 0;
        self.senderButton.hidden = NO;
        self.secondLabel.hidden = YES;
        self.secondLabel.text = @"";
       
        
        return;
    }
    self.second--;
}


#pragma mark -- action
///发送回调
- (void)onSenderButtonAction:(UIButton*)sender
{
    if(self.onSenderBlock){
        self.onSenderBlock(sender.tag);
    }
}


///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel createLabelWithText:HenLocalizedString(@"手机号") font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = titleLabel];
    }
    return _titleLabel;
}

///输入框
- (UITextField *)inputTextField
{
    if(!_inputTextField){
        UITextField *inputTextField = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        inputTextField.borderStyle = UITextBorderStyleNone;
        inputTextField.font = kFontSize_24;
        inputTextField.textAlignment = NSTextAlignmentLeft;
        inputTextField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_inputTextField = inputTextField];
    }
    return _inputTextField;
}

- (UIButton *)senderButton
{
    if(!_senderButton){
        UIButton *button = [UIButton createButtonWithTitle:HenLocalizedString(@"发送") backgroundNormalImage:@"public_botton_send" backgroundPressImage:@"public_botton_send_press" target:self action:@selector(onSenderButtonAction:)];
        button.titleLabel.font = kFontSize_28;
        [button setTitleClor:kFontColorWhite];
        
        [self.contentView addSubview:_senderButton = button];
    }
    return _senderButton;
}

///秒
-(UILabel *)secondLabel
{
    if(!_secondLabel){
        UILabel *secondLabel = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [secondLabel setTextColor:kFontColorRed];
        secondLabel.hidden = YES;
        [self.contentView addSubview:_secondLabel = secondLabel];

    }
    return _secondLabel;
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
    self.inputTextField.text = HenLocalizedString(inputInfo);
}

-(void)setSenderButtonHidden:(BOOL)hidden
{
    self.senderButton.hidden=hidden;

}

-(void)setSecondLabelHidden:(BOOL)hidden
{
    
    self.secondLabel.hidden=hidden;

}

- (BFSTimerextension *)countDownTimer
{
    if(!_countDownTimer){
        _countDownTimer = [[BFSTimerextension alloc] init];
        _countDownTimer.delegate = self;
    }
    return _countDownTimer;
}
@end
