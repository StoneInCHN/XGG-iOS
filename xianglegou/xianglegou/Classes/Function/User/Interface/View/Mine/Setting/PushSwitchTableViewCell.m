//
//  PushSwitchTableViewCell.m
//  xianglegou
//
//  Created by lieon on 2017/9/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "PushSwitchTableViewCell.h"

@interface PushSwitchTableViewCell ()
///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///开关
@property (nonatomic, weak) UISwitch *switchControl;
@end


@implementation PushSwitchTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"PushSwitchTableViewCell";
    PushSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[PushSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///加载子视图约束
- (void)loadSubviewConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(12));
        make.centerY.equalTo(self);
    }];
    
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
        make.centerY.equalTo(self);
    }];
}

- (void)switchAction: (UISwitch *)switchControl {
    if (UIApplication.sharedApplication.currentUserNotificationSettings.types == UIRemoteNotificationTypeNone) {
        if (switchControl.isOn) {
            [DATAMODEL.alertManager showNetworkErrorMessage:@"该功能无法启动\n请前往本机中的“通知中心”开启服务"];
            [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
                if(buttonIndex == 0){
                    
                }
            }];
            [switchControl setOn:false];
        }
        return;
    }
    if (self.switchBlock) {
        self.switchBlock(switchControl.isOn);
    }
}

#pragma mark -- getter setter
///图标
- (UIImageView *)iconImageView
{
    if(!_iconImageView){
        UIImageView *iconImage = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_iconImageView = iconImage];
    }
    return _iconImageView;
}

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = titleLabel];
    }
    return _titleLabel;
}

///开关
- (UISwitch *)switchControl {
    if (!_switchControl) {
        UISwitch * switchControl = [[UISwitch alloc]init];
        switchControl.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [switchControl setOnTintColor:KCommonRedBgColor];
        if (DATAMODEL.userInfoData) {
            [switchControl setOn:DATAMODEL.userInfoData.isPushMsg];
        } else {
             [switchControl setOn:false];
        }
       [ switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchControl = switchControl];
    }
    return _switchControl;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    [self.iconImageView setImageForName:icon];
}

@end
