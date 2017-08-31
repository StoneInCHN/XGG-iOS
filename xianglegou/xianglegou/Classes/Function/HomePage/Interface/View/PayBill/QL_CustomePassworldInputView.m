//
//  QL_CustomePassworldInputView.m
//  Rebate
//
//  Created by mini2 on 2017/4/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_CustomePassworldInputView.h"


@interface QL_CustomePassworldInputView()<UITextFieldDelegate>

@property(nonatomic, strong) NSMutableArray *pwLabelArray;
@property(nonatomic, strong) NSMutableArray *pwImageArray;

@property(nonatomic, weak) UITextField *textField;

///是否取消
@property(nonatomic, assign) BOOL isCancel;

@end

@implementation QL_CustomePassworldInputView

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAction:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    UIView *tempView;
    for(NSInteger i = 0; i < 6; i++){
        UIView *view = [self pwView];
        if(i == 0){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.width.mas_equalTo(SinglePW_Width);
                make.height.mas_equalTo(CPIView_Height);
                make.top.equalTo(self);
            }];
        }else{
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(-1);
                make.width.mas_equalTo(SinglePW_Width);
                make.height.mas_equalTo(CPIView_Height);
                make.top.equalTo(self);
            }];
        }
        tempView = view;
    }
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.and.height.equalTo(self);
    }];
}

///显示
- (void)showForPassword:(NSString *)password;
{
    self.textField.text = password;
    for(UIImageView *image in self.pwImageArray){
        image.hidden = YES;
    }
    if(password.length > 0){
        for(NSInteger i = 0; i < password.length; i++){
            ((UIImageView *)self.pwImageArray[i]).hidden = NO;
        }
    }
    [self.textField becomeFirstResponder];
}

///取消
- (void)cancel
{
    self.isCancel = YES;
    [self.textField endEditing:YES];
}

///完成
- (void)finish
{
    [self.textField endEditing:YES];
}

#pragma mark -- private

- (void)showPwPoint:(UIImageView *)image pwLabel:(UILabel *)label
{
    //延迟0.2s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        image.hidden = NO;
        label.text = @"";
    });
}

#pragma mark -- event response

- (void)onClickAction:(id)sender
{
    [self.textField becomeFirstResponder];
}

#pragma mark -- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.isCancel){
        self.isCancel = NO;
    }else{
        if(self.onInputFinishBlock){
            self.onInputFinishBlock(self.textField.text);
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>=6) {
        return NO;
    }else{
        UILabel *label = self.pwLabelArray[range.location];
        UIImageView *image = self.pwImageArray[range.location];
        if([string isEqualToString:@""]){
            label.text = @"";
            image.hidden = YES;
        }else{
            label.text = string;
            [self showPwPoint:image pwLabel:label];
            
            if(range.location == 5){
                WEAKSelf;
                //延迟0.2s
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf finish];
                });
            }
        }
        
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self finish];

    return YES;
}

#pragma mark -- getter,setter

- (UIImageView *)pwView
{
    UIImageView *view = [UIImageView createImageViewWithName:@"public_pay_password_bg"];
    [self addSubview:view];
    
    UILabel *pwLabel = [UILabel createLabelWithText:@"" font:kFontSize_28];
    [view addSubview:pwLabel];
    [pwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    [self.pwLabelArray addObject:pwLabel];
    UIImageView *pwImage = [UIImageView createImageViewWithName:@"public_pay_password_point"];
    pwImage.hidden = YES;
    [view addSubview:pwImage];
    [pwImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    [self.pwImageArray addObject:pwImage];
    
    return view;
}

///输入框
- (UITextField *)textField
{
    if(!_textField){
        UITextField *textField = [UITextField createTextFieldWithPlaceholder:@"" delegateTarget:self];
        textField.returnKeyType = UIReturnKeyDone;
        textField.hidden = YES;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_textField = textField];
    }
    return _textField;
}

- (NSMutableArray *)pwLabelArray
{
    if(!_pwLabelArray){
        _pwLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _pwLabelArray;
}

- (NSMutableArray *)pwImageArray
{
    if(!_pwImageArray){
        _pwImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _pwImageArray;
}

@end
