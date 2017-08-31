//
//  GC_AuthorizationButtonTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_AuthorizationButtonTableViewCell.h"

@interface GC_AuthorizationButtonTableViewCell ()

///解除授权 按钮
@property (nonatomic, weak) UIButton *deauthorizeButton;
///重新授权 按钮
@property (nonatomic, weak) UIButton *reauthorizationButton;
@end

@implementation GC_AuthorizationButtonTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_AuthorizationButtonTableViewCell";
    GC_AuthorizationButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_AuthorizationButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(300);
}



///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.deauthorizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(30));
        make.centerX.equalTo(self);
    }];
    
    [self.reauthorizationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.deauthorizeButton.mas_bottom).offset(HEIGHT_TRANSFORMATION(56));
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
///解除授权 按钮
- (void)onDeauthorizeAction:(UIButton*)sender
{
    if(self.onDeauthorizeBlock){
        self.onDeauthorizeBlock(sender.tag);
    }
}


///重新授权 按钮
- (void)onReauthorizationAction:(UIButton*)sender
{
    if(self.onReauthorizationBlock){
        self.onReauthorizationBlock(sender.tag);
    }
}



#pragma mark -- getter,sette

///解除授权 按钮
- (UIButton *)deauthorizeButton
{
    if(!_deauthorizeButton){
        UIButton *button = [UIButton createButtonWithTitle:HenLocalizedString(@"解除授权") backgroundNormalImage:@"public_botton_big_red" backgroundPressImage:@"public_botton_big_red_press" target:self action:@selector(onDeauthorizeAction:)];
        [button setTitleClor:kFontColorWhite];
        button.titleLabel.font = kFontSize_36;
        [self.contentView addSubview:_deauthorizeButton = button];
    }
    return _deauthorizeButton;
}

///重新授权 按钮
- (UIButton *)reauthorizationButton
{
    if(!_reauthorizationButton){
        UIButton *button = [UIButton createButtonWithTitle:HenLocalizedString(@"重新授权") backgroundNormalImage:@"public_botton_big_white" backgroundPressImage:@"public_botton_big_white_press" target:self action:@selector(onReauthorizationAction:)];
        [button setTitleClor:kFontColorRed];
        button.titleLabel.font = kFontSize_36;
        [self.contentView addSubview:_reauthorizationButton = button];
    }
    return _reauthorizationButton;
}

@end
