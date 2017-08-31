//
//  GC_LoginButtonTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  登录按钮 -- cell
//


#import "GC_LoginButtonTableViewCell.h"

@interface GC_LoginButtonTableViewCell ()
///忘记密码
@property (nonatomic, weak) UIButton *forgetPwdButton;

///登陆按钮
@property (nonatomic, weak) UIButton *loginButton;

///验证码 密码 切换按钮
@property (nonatomic, weak) UIButton *switchButton;

///注册按钮
@property (nonatomic, weak) UIButton *registeredButton;
@end

@implementation GC_LoginButtonTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_LoginButtonTableViewCell";
    GC_LoginButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_LoginButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return FITHEIGHT(350/2);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = [UIColor clearColor];
}


- (void)dealloc
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(FITWITH(-110/2));
        make.top.equalTo(self).offset(FITHEIGHT(10/2));
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.forgetPwdButton.mas_bottom).offset(FITHEIGHT(50/2));
        make.width.mas_equalTo(FITSCALE(436/2));
        make.height.mas_equalTo(FITSCALE(75/2));
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(FITHEIGHT(50/2));
        make.right.equalTo(self.mas_centerX).offset(FITWITH(-12/2));
        make.width.mas_equalTo(FITSCALE(206/2));
        make.height.mas_equalTo(FITSCALE(68/2));
    }];
    
    [self.registeredButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(FITHEIGHT(50/2));
        make.left.equalTo(self.mas_centerX).offset(FITWITH(12/2));
        make.width.mas_equalTo(FITSCALE(206/2));
        make.height.mas_equalTo(FITSCALE(68/2));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -- action
///忘记密码
-(void)onForgetButtonAction:(UIButton*)sender
{
    if(self.onForgetPwdBlock){
        self.onForgetPwdBlock(sender.tag);
    }
}


///登录
- (void)onLoginButtonAction:(UIButton*)sender
{
    if(self.onLoginBlock){
        self.onLoginBlock(sender.tag);
    }
}

///验证码 密码 切换按钮
- (void)onSwitchButtonAction:(UIButton*)sender
{
    if(self.onLoginStateBlock){
        self.onLoginStateBlock(sender.tag);
    }
}

///注册 按钮
- (void)onRegisteredButtonAction:(UIButton*)sender
{
    if(self.onRegisteredBlock){
        self.onRegisteredBlock(sender.tag);
    }
}
#pragma mark -- getter,setter
///忘记密码
- (UIButton *)forgetPwdButton
{
    if(!_forgetPwdButton){
        UIButton *button = [UIButton createNoBgButtonWithTitle:HenLocalizedString(@"忘记密码？") target:self action:@selector(onForgetButtonAction:)];
        [button setTitleClor:kFontColorWhite];
        button.titleLabel.font = kFontSize_24;
        [self.contentView addSubview:_forgetPwdButton = button];
    }
    return _forgetPwdButton;
}

///登陆按钮
- (UIButton*)loginButton
{
    if(!_loginButton){
        UIButton *loginButton = [UIButton createButtonWithTitle:HenLocalizedString(@"登录") backgroundNormalImage:@"login_button_white" backgroundPressImage:@"login_button_white_press" target:self action:@selector(onLoginButtonAction:)];
         loginButton.titleLabel.font = kFontSize_36;
        [self.contentView addSubview:_loginButton = loginButton];
    }
    return _loginButton;
}

///验证码 密码 切换按钮
- (UIButton *)switchButton
{
    if(!_switchButton){
        UIButton *switchButton = [UIButton createButtonWithTitle:HenLocalizedString(@"验证码登录") backgroundNormalImage:@"login_button_little" backgroundPressImage:@"login_button_little_press" target:self action:@selector(onSwitchButtonAction:)];
        switchButton.titleLabel.font = kFontSize_28;
        [switchButton setTitleClor:kFontColorWhite];
        [self.contentView addSubview:_switchButton = switchButton];
    }
    return _switchButton;
}

- (UIButton *)registeredButton
{
    if(!_registeredButton){
        UIButton *registeredButton = [UIButton createButtonWithTitle:HenLocalizedString(@"注册账号") backgroundNormalImage:@"login_button_little" backgroundPressImage:@"login_button_little_press" target:self action:@selector(onRegisteredButtonAction:)];
        registeredButton.titleLabel.font = kFontSize_28;
        [registeredButton setTitleClor:kFontColorWhite];
        [self.contentView addSubview:_registeredButton = registeredButton];
    }
    return _registeredButton;
}

- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    [self.switchButton setTitle:HenLocalizedString(titleInfo)];
}
@end
