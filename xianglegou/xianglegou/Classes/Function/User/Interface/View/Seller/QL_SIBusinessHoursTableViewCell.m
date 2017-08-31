//
//  QL_SIBusinessHoursTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SIBusinessHoursTableViewCell.h"

@interface QL_SIBusinessHoursTableViewCell()

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///信息
@property(nonatomic, weak) UILabel *infoLabel;
///时间1
@property(nonatomic, weak) UIButton *time1Button;
///时间2
@property(nonatomic, weak) UIButton *time2Button;

///时间选择
@property(nonatomic, strong) Hen_CustomDatePickerView *timePickerView;

@end

@implementation QL_SIBusinessHoursTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_SIBusinessHoursTableViewCell";
    QL_SIBusinessHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SIBusinessHoursTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-166));
    }];
    [self.time1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.infoLabel.mas_left).offset(WIDTH_TRANSFORMATION(-10));
    }];
    [self.time2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.infoLabel.mas_right).offset(WIDTH_TRANSFORMATION(10));
    }];
}

///更新UI
- (void)updateUIForTime:(NSString *)time
{
    if(time.length > 0){
        NSArray *array = [time componentsSeparatedByString:@"-"];
        [self.time1Button setTitle:array[0]];
        [self.time2Button setTitle:array[1]];
    }else{
        [self setSelectBusinessHours];
    }
}

///设置选择
- (void)setSelectBusinessHours
{
    NSString *time1 = self.time1Button.titleLabel.text;
    NSString *time2 = self.time2Button.titleLabel.text;
    if(self.onSelectBlock){
        self.onSelectBlock([NSString stringWithFormat:@"%@-%@", time1, time2]);
    }
}

#pragma mark -- event response

- (void)onTimeAction:(UIButton *)sender
{
    [self.timePickerView showDatePickerView];
    WEAKSelf;
    if(sender.tag == 0){
        [self.timePickerView setFirstSelectedByDateString:self.time1Button.titleLabel.text];
        self.timePickerView.onDatePickerReturnBlock = ^(NSString *dateString){
            [weakSelf.time1Button setTitle:dateString];
            [weakSelf setSelectBusinessHours];
        };
    }else{
        [self.timePickerView setFirstSelectedByDateString:self.time2Button.titleLabel.text];
        self.timePickerView.onDatePickerReturnBlock = ^(NSString *dateString){
            [weakSelf.time2Button setTitle:dateString];
            [weakSelf setSelectBusinessHours];
        };
    }
}

#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"营业时段" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///信息
- (UILabel *)infoLabel
{
    if(!_infoLabel){
        UILabel *label = [UILabel createLabelWithText:@"到" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_infoLabel = label];
    }
    return _infoLabel;
}

///时间1
- (UIButton *)time1Button
{
    if(!_time1Button){
        UIButton *button = [UIButton createButtonWithTitle:@"09:00" backgroundNormalImage:@"mine_time_input" backgroundPressImage:@"mine_time_input" target:self action:@selector(onTimeAction:)];
        button.tag = 0;
        [button setTitleColor:kFontColorGray forState:UIControlStateNormal];
        [self.contentView addSubview:_time1Button = button];
    }
    return _time1Button;
}

///时间2
- (UIButton *)time2Button
{
    if(!_time2Button){
        UIButton *button = [UIButton createButtonWithTitle:@"22:00" backgroundNormalImage:@"mine_time_input" backgroundPressImage:@"mine_time_input" target:self action:@selector(onTimeAction:)];
        button.tag = 1;
        [button setTitleColor:kFontColorGray forState:UIControlStateNormal];
        [self.contentView addSubview:_time2Button = button];
    }
    return _time2Button;
}

///时间选择
- (Hen_CustomDatePickerView *)timePickerView
{
    if(!_timePickerView){
        _timePickerView = [[Hen_CustomDatePickerView alloc] init];
        [_timePickerView setDatePickerModel:UIDatePickerModeTime];
    }
    return _timePickerView;
}

@end
