//
//  QL_SIOtherServiceTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SIOtherServiceTableViewCell.h"

@interface QL_SIOtherServiceTableViewCell()

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///wifi
@property(nonatomic, weak) UIButton *wifiButton;
///免费停车
@property(nonatomic, weak) UIButton *freeStopButton;

@end

@implementation QL_SIOtherServiceTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_SIOtherServiceTableViewCell";
    QL_SIOtherServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SIOtherServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
- (void)initDefault
{
    [self unShowClickEffect];
    self.bottomLongLineImage.hidden = NO;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
    }];
    [self.freeStopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(180));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    [self.wifiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(180));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.freeStopButton.mas_left);
    }];
}

///更新ui
- (void)updateUIForService:(NSString *)service
{
    [self.wifiButton setSelected:NO];
    [self.freeStopButton setSelected:NO];
    
    if([service isEqualToString:@"ALL"]){
        [self.wifiButton setSelected:YES];
        [self.freeStopButton setSelected:YES];
    }else if([service isEqualToString:@"WIFI"]){
        [self.wifiButton setSelected:YES];
    }else if([service isEqualToString:@"FREE_PARKING"]){
        [self.freeStopButton setSelected:YES];
    }
}

#pragma mark -- event response

- (void)onButtonAction:(UIButton *)sender
{
    if(sender.isSelected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    
    if(self.onSelectBlock){
        if(self.wifiButton.isSelected && self.freeStopButton.isSelected){
            self.onSelectBlock(@"ALL");
        }else if(self.wifiButton.isSelected){
            self.onSelectBlock(@"WIFI");
        }else if(self.freeStopButton.isSelected){
            self.onSelectBlock(@"FREE_PARKING");
        }else{
            self.onSelectBlock(@"");
        }
    }
}

#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"其他服务" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///wifi
- (UIButton *)wifiButton
{
    if(!_wifiButton){
        UIButton *button = [UIButton createButtonWithTitle:@"wifi" normalImage:@"public_remind_select" pressImage:@"public_remind_select_choose" target:self action:@selector(onButtonAction:)];
        button.titleLabel.font = kFontSize_24;
        [button setTitleClor:kFontColorGray];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.tag = 0;
        [self.contentView addSubview:_wifiButton = button];
    }
    return _wifiButton;
}

///免费停车
- (UIButton *)freeStopButton
{
    if(!_freeStopButton){
        UIButton *button = [UIButton createButtonWithTitle:@"免费停车" normalImage:@"public_remind_select" pressImage:@"public_remind_select_choose" target:self action:@selector(onButtonAction:)];
        button.titleLabel.font = kFontSize_24;
        [button setTitleClor:kFontColorGray];
        button.tag = 1;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self.contentView addSubview:_freeStopButton = button];
    }
    return _freeStopButton;
}

@end
