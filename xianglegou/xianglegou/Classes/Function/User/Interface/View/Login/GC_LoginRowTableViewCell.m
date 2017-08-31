//
//  GC_LoginRowTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  登录行 -- cell
//

#import "GC_LoginRowTableViewCell.h"
#import "BFSTimerextension.h"

#import "RYNumberKeyboard.h"
#import "UITextField+RYNumberKeyboard.h"

@interface GC_LoginRowTableViewCell ()<UITextFieldDelegate,BFSTimerextensionDelegate>
///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///输入框
@property (nonatomic, weak) UITextField *enterTextField;
///发送按钮
@property (nonatomic, weak) UIButton *senderButton;
///倒计时显示
@property (nonatomic, weak) UILabel *secondLabel;
///下划线
@property (nonatomic, weak) UIImageView *lineImageView;

///剩余时间
@property (nonatomic, assign) long second;

///验证码发送 状态
@property (nonatomic, assign) BOOL senderState;


@property (nonatomic, strong) BFSTimerextension *countDownTimer;
@end



@implementation GC_LoginRowTableViewCell
///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_LoginRowTableViewCell";
    GC_LoginRowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_LoginRowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return FITSCALE(65/2);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = [UIColor clearColor];
    self.senderState = NO;
}


- (void)dealloc
{
    self.second = 0;
    
    [self setCountDownTimer:nil];
}


///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(24));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(28));
        make.left.equalTo(self).offset(FITSCALE(110/2));
        make.centerY.equalTo(self);
    }];
    
    [self.senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(FITWITH(-110/2));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(FITSCALE(104/2));
        make.height.mas_equalTo(FITSCALE(60/2));
    }];
    
    [self.enterTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(FITSCALE(20/2));
        make.right.equalTo(self.senderButton.mas_left).offset(FITSCALE(-10/2));
        make.height.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(FITSCALE(-115/2));
        make.centerY.equalTo(self);
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(FITSCALE(20/2));
        make.right.equalTo(self).offset(FITSCALE(-110/2));
    }];
}

#pragma mark -- UITextFeildDelegate
///输入框 回调 方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.onEnterTextFieldBlock){
        self.onEnterTextFieldBlock(textField.text, textField.tag);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.enterTextField endEditing:YES];
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
    self.enterTextField.secureTextEntry = isNo;
}

///键盘类型
-(void)setTextFieldForKeyboardType:(UIKeyboardType)keyboardType
{
    if(keyboardType == UIKeyboardTypeNumberPad){
        self.enterTextField.ry_inputType = RYIntInputType;
    }else{
        self.enterTextField.keyboardType = keyboardType;
    }
    
}

///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden
{
    if(hidden){
        UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  FITSCALE(60/2), FITSCALE(60/2))];
        
        UIImageView* xImageView = [UIImageView createImageViewWithName:@"login_delete2"];
        xImageView.frame = CGRectMake(0, 0,FITSCALE(60/2), FITSCALE(60/2));
        [rightVeiw addSubview:xImageView];
        
        xImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *xImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xImageViewClick:)];
        [xImageView addGestureRecognizer:xImageViewTap];
        
        self.enterTextField.rightView = rightVeiw;
        self.enterTextField.rightViewMode = UITextFieldViewModeWhileEditing;
        
    }else{
        self.enterTextField.clearButtonMode = UITextFieldViewModeNever;
    }
}


///倒计时 开启
-(void)startOnTimers
{
    self.senderState = YES;
    self.senderButton.hidden = YES;
    self.secondLabel.hidden = NO;
    self.second = 60;


    [self.countDownTimer startTimer:1 repeats:YES];
}

#pragma BFSTimerextensionDelegate
///计算时间 方法
-(void)timerfucntionCall
{
    
    if(self.second > 0){
        self.secondLabel.text = [NSString stringWithFormat:@"%ldS",self.second];
    }else{
        [self.countDownTimer stopTimer];
        self.senderState = NO;
        self.second = 0;
        self.senderButton.hidden = NO;
        self.secondLabel.hidden = YES;
        self.secondLabel.text = @"";
        return;
    }
    self.second--;
}
///根据验证码 发送状态显示 发送按钮
-(void)setSenderStateHidden:(BOOL)hidden
{
    self.senderButton.hidden = hidden;
    if(hidden){
        self.secondLabel.hidden = NO;
    }else{
        self.secondLabel.hidden = YES;
    }
    
}

///发送 按钮显示与否
-(void)setSenderHidden:(BOOL)hidden
{
    if(hidden){         //隐藏发送按钮
        self.senderButton.hidden = hidden;
        self.secondLabel.hidden = hidden;
        
        [self.senderButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        
    }else{              //显示发送按钮
        self.senderButton.hidden = hidden;
        
        if(self.senderState){       //处于倒计时中...
            [self setSenderStateHidden:YES];
        }else{
            [self setSenderStateHidden:NO];
        }
        
        
        [self.senderButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(FITSCALE(104/2));
        }];
    }
}


#pragma mark -- action
///发送 按钮
- (void)onSenderButtonAction:(UIButton*)sender
{
    if(self.onSenderBlock){
        self.onSenderBlock(sender.tag);
    }
}

/////点击事件 ：
- (void)xImageViewClick:(UITextField*) textField
{
    if(self.enterTextField.editing)
    {
        [self.enterTextField setText:@""];
    }
}
#pragma mark -- getter,setter
///Icon 图标
- (UIImageView *)iconImageView
{
    if(!_iconImageView){
        UIImageView *icon = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_iconImageView = icon];
    }
    return _iconImageView;
}

///输入 TextField
- (UITextField *)enterTextField
{
    if(!_enterTextField){
        UITextField *enterText = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        enterText.borderStyle = UITextBorderStyleNone;
        enterText.font = kFontSize_28;
        enterText.textAlignment = NSTextAlignmentLeft;
        enterText.returnKeyType = UIReturnKeyDone;
        [enterText setTextColor:kFontColorWhite];
        
        
        [self.contentView addSubview:_enterTextField = enterText];
    }
    return _enterTextField;
}

///发送按钮
- (UIButton *)senderButton
{
    if(!_senderButton){
        UIButton *sender = [UIButton createButtonWithTitle:HenLocalizedString(@"发送") backgroundNormalImage:@"login_button_send" backgroundPressImage:@"login_button_send_press" target:self action:@selector(onSenderButtonAction:)];
        sender.titleLabel.font = kFontSize_28;
        [sender setTitleClor:kFontColorWhite];
        sender.hidden = YES;
        [self.contentView addSubview:_senderButton = sender];
    }
    return _senderButton;
}

///时间显示
- (UILabel *)secondLabel
{
    if(!_secondLabel){
        UILabel *second = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorWhite];
        second.hidden = YES;
        [self.contentView addSubview:_secondLabel = second];
    }
    return _secondLabel;
}

///下划线
- (UIImageView *)lineImageView
{
    if(!_lineImageView){
        UIImageView *lineImage = [UIImageView createImageViewWithName:@"login_line"];
        [self.contentView addSubview:_lineImageView = lineImage];
    }
    return _lineImageView;
}

///输入框 占位符
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.enterTextField.placeholder = HenLocalizedString(placeholder);
    [self.enterTextField setValue:kFontColorWhite forKeyPath:@"_placeholderLabel.textColor"];
}

///icon图标
- (void)setIconImage:(NSString *)iconImage
{
    _iconImage = iconImage;
    [self.iconImageView setImageForName:iconImage];
}

///输入信息
- (void)setInputInfo:(NSString *)inputInfo
{
    _inputInfo = inputInfo;
    self.enterTextField.text = inputInfo;
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
