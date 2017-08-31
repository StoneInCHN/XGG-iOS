//
//  GC_EditPayPasswordTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  修改支付密码 -- cell
//

#import "GC_EditPayPasswordTableViewCell.h"


#define SinglePW_Width  WIDTH_TRANSFORMATION(85)
#define CPIView_Height  HEIGHT_TRANSFORMATION(85)

@interface GC_EditPayPasswordTableViewCell ()<UITextFieldDelegate>
@property(nonatomic, strong) NSMutableArray *pwLabelArray;
@property(nonatomic, strong) NSMutableArray *pwImageArray;

@property(nonatomic, weak) UITextField *textField;

///标题
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation GC_EditPayPasswordTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_EditPayPasswordTableViewCell";
    GC_EditPayPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_EditPayPasswordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAction:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *tempView;
    for(NSInteger i = 0; i < 6; i++){
        UIView *view = [self pwView];
        if(i == 0){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(225));
                make.width.mas_equalTo((kMainScreenWidth - WIDTH_TRANSFORMATION(255)) / 6);
                make.height.mas_equalTo(CPIView_Height);
                make.top.equalTo(self);
            }];
        }else{
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(-1);
                make.width.mas_equalTo((kMainScreenWidth - WIDTH_TRANSFORMATION(255)) / 6);
                make.height.mas_equalTo(CPIView_Height);
                make.top.equalTo(self);
            }];
        }
        tempView = view;
    }
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(225));
        make.right.equalTo(self).offset(OffSetToRight);
        make.height.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




#pragma mark -- private

///完成
- (void)finish
{
    [self.textField endEditing:YES];
}

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
   
    if(self.onInputFinishBlock){
        self.onInputFinishBlock(self.textField.text);
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

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

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


- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    
    self.titleLabel.text = titleInfo;
}

@end
