//
//  GC_FinishButtonTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  完成按钮 -- cell
//

#import "GC_FinishButtonTableViewCell.h"
#import "GC_SettingConfigViewController.h"

@interface GC_FinishButtonTableViewCell ()
///完成按钮
@property (nonatomic, weak) UIButton *finshButton;

///许可协议
@property (nonatomic, weak) UILabel *protocolLabel;
@end

@implementation GC_FinishButtonTableViewCell
///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_FinishButtonTableViewCell";
    GC_FinishButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_FinishButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return FITSCALE(360/2);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = kCommonBackgroudColor;
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.finshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(FITSCALE(150/2));
        make.width.mas_equalTo(FITSCALE(435/2));
        make.height.mas_equalTo(FITSCALE(75/2));
    }];
    
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.finshButton.mas_bottom).offset(HEIGHT_TRANSFORMATION(28));
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(FITSCALE(60/2));
        make.right.equalTo(self).offset(-FITSCALE(60/2));
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
///隐藏 协议按钮
-(void)setProtocolHidden:(BOOL)hidden
{
    self.protocolLabel.hidden = hidden;
    
    if(hidden){
        [self.finshButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(FITSCALE(200/2));
        }];
    }else{
        [self.finshButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(FITSCALE(150/2));
        }];
    }
}



#pragma mark -- action
///服务协议
-(void)onProtocolLabelTouchUpInside:(UITapGestureRecognizer *)recognizer
{
    
    GC_SettingConfigViewController *scVC = [[GC_SettingConfigViewController alloc] init];
    scVC.hidesBottomBarWhenPushed = YES;
    scVC.titleInfo = @"软件许可及服务协议";
    scVC.configKey = @"LICENSE_AGREEMENT";
    [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:scVC animated:YES];
    
}

///完成按钮
-(void)onFinshButtonAction:(UIButton*)sender
{
    if(self.onFinshBlock){
        self.onFinshBlock(sender.tag);
    }
}


///完成按钮
- (UIButton *)finshButton
{
    if(!_finshButton){
        UIButton *finshButton = [UIButton createButtonWithTitle:HenLocalizedString(@"完成") backgroundNormalImage:@"public_botton_complete" backgroundPressImage:@"public_botton_complete_press" target:self action:@selector(onFinshButtonAction:)];
        finshButton.titleLabel.font = kFontSize_36;
        [finshButton setTitleClor:kFontColorWhite];
        [self.contentView addSubview:_finshButton = finshButton];
    }
    return _finshButton;
}

///许可协议
- (UILabel *)protocolLabel
{
    if(!_protocolLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_24 textColor:kFontColorGray];
        
        NSString *text = @"轻触 “完成” 按钮，即表示你同意《软件许可及服务协议》";
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:kFontColorRed range:NSMakeRange(17,11)];
        
        label.attributedText = str;
        
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onProtocolLabelTouchUpInside:)];
        [label addGestureRecognizer:labelTapGestureRecognizer];
        
        [label lableAutoLinefeed];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        [self.contentView addSubview:_protocolLabel = label];
    }
    return _protocolLabel;
}
@end
