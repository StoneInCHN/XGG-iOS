//
//  QL_PayPasswordInputView.m
//  Rebate
//
//  Created by mini2 on 17/4/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_PayPasswordInputView.h"
#import "IQKeyboardManager.h"
#import "QL_CustomePassworldInputView.h"

#define VIEW_HEIGHT       HEIGHT_TRANSFORMATION(310) + 226

@interface QL_PayPasswordInputView()

///蒙层
@property (nonatomic, strong) UIView *maskImageView;

@property(nonatomic, strong) UIView *topBgView;

///关闭按钮
@property(nonatomic, strong) UIButton *closeButton;

///输入框
@property(nonatomic, weak) QL_CustomePassworldInputView *pwView;

///标志view是否出现
@property (nonatomic, assign) BOOL isViewShow;

@property(nonatomic, assign) CGFloat viewHeight;

///输入密码
@property(nonatomic, strong) NSString *inputPassword;

@end

@implementation QL_PayPasswordInputView

- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

#pragma mark -- private

///初始
- (void)initDefault
{
    self.viewHeight = VIEW_HEIGHT;
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, self.viewHeight);
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.topBgView];
    [self addSubview:self.closeButton];
    
    WEAKSelf;
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.topBgView);
        make.left.equalTo(self);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(150));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
    }];
    [[self noticeLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topBgView);
    }];
    [self.pwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(6 * SinglePW_Width);
        make.height.mas_equalTo(CPIView_Height);
        make.top.equalTo(self.topBgView.mas_bottom).offset(HEIGHT_TRANSFORMATION(80));
    }];
}

///显示
- (void)showView
{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    self.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, self.viewHeight);
    
    [view addSubview:self];
    [view addSubview:self.maskImageView];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kMainScreenHeight - self.frame.size.height, kMainScreenWidth, self.frame.size.height);
        self.maskImageView.alpha = 0.5;
        self.maskImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - self.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.isViewShow = YES;
    }];
    self.inputPassword = @"";
    [self.pwView showForPassword:self.inputPassword];
}

///完成
- (void)finishInput
{
    if([self.inputPassword isEqualToString:@""]){
        //提示
        [DATAMODEL.progressManager showHint:@"密码不能为空！"];
        return;
    }
    
    if(self.onInputFinishBlock){
        self.onInputFinishBlock(self.inputPassword);
    }
    
    [self dismissPickerView];
}

#pragma mark -- action

-(void)onCloseButtonClick:(UIButton*)sender
{
    [self.pwView cancel];
    
    [self dismissPickerView];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tap
{
    [self.pwView cancel];
    
    [self dismissPickerView];
}

#pragma mark -- private

- (void)dismissPickerView
{
    if (!self.isViewShow) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, self.frame.size.height);
        self.maskImageView.alpha = 0;
        self.maskImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isViewShow = NO;
        [self.maskImageView removeFromSuperview];
    }];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

#pragma mark -- getter,setter

- (UIView *)maskImageView
{
    if (!_maskImageView) {
        _maskImageView = [UIView createViewWithFrame:[UIScreen mainScreen].bounds backgroundColor:[UIColor blackColor]];
        _maskImageView.userInteractionEnabled = YES;
        _maskImageView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [_maskImageView addGestureRecognizer:tap];
    }
    return _maskImageView;
}

- (UIView*)topBgView{
    if(!_topBgView){
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = kCommonBackgroudColor;
    }
    return _topBgView;
}

-(UIButton*)closeButton{
    if(!_closeButton){
        _closeButton = [UIButton createButtonWithTitle:@"" normalImage:@"public_back1" pressImage:@"public_back1" target:self action:@selector(onCloseButtonClick:)];
        _closeButton.titleLabel.font = kFontSize_28;
    }
    return _closeButton;
}

///输入框
- (QL_CustomePassworldInputView *)pwView
{
    if(!_pwView){
        QL_CustomePassworldInputView *view = [[QL_CustomePassworldInputView alloc] init];
        [self addSubview:_pwView = view];
        //回调
        WEAKSelf;
        view.onInputFinishBlock = ^(NSString *password){
            weakSelf.inputPassword = password;
            [weakSelf finishInput];
        };
    }
    return _pwView;
}

///提示
- (UILabel *)noticeLabel
{
    UILabel *label = [UILabel createLabelWithText:@"请输入支付密码" font:kFontSize_28];
    [self addSubview:label];
    
    return label;
}

@end
