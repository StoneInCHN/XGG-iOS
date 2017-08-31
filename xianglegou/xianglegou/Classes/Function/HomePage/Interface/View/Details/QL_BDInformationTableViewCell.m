//
//  QL_BDInformationTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BDInformationTableViewCell.h"

@interface QL_BDInformationTableViewCell()

///时间提示
@property(nonatomic, weak) UILabel *timeNoticeLabel;
///时间
@property(nonatomic, weak) UILabel *timeLabel;
///服务提示
@property(nonatomic, weak) UILabel *serviceNoticeLabel;
///服务
@property(nonatomic, weak) UILabel *serviceLabel;
///简介提示
@property(nonatomic, weak) UILabel *infoNoticeLabel;
///简介
@property(nonatomic, weak) UILabel *infoLabel;

@end

@implementation QL_BDInformationTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_BDInformationTableViewCell";
    QL_BDInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_BDInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
- (void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.timeNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
        make.left.equalTo(self.timeNoticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(4));
        make.left.equalTo(self.timeNoticeLabel).with.priorityLow();
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeNoticeLabel);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeNoticeLabel);
        make.top.equalTo(self.serviceLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-20));
    }];
}

///更新UI
- (void)updateUIForData:(QL_BussinessDetialsDataModel *)data
{
    if(data){
        self.timeLabel.text = data.businessTime.length > 0 ? data.businessTime : @"无";
        if([data.featuredService isEqualToString:@"ALL"]){ // 全部
            self.serviceLabel.text = @"其他服务： wifi、免费停车";
        }else if([data.featuredService isEqualToString:@"WIFI"]){ // wifi
            self.serviceLabel.text = @"其他服务： wifi";
        }else if([data.featuredService isEqualToString:@"FREE_PARKING"]){ // 免费停车
            self.serviceLabel.text = @"其他服务： 免费停车";
        }else{
            self.serviceLabel.text = @"其他服务： 无";
        }
        self.infoLabel.text = data.Description.length > 0 ? [NSString stringWithFormat:@"店铺简介： %@", data.Description] : @"店铺简介： 无";
    }
}

#pragma mark -- getter,setter

///时间提示
- (UILabel *)timeNoticeLabel
{
    if(!_timeNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"营业时段：" font:kFontSize_28];
        [self.contentView addSubview:_timeNoticeLabel = label];
    }
    return _timeNoticeLabel;
}

///时间
- (UILabel *)timeLabel
{
    if(!_timeLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_timeLabel = label];
    }
    return _timeLabel;
}

///服务提示
- (UILabel *)serviceNoticeLabel
{
    if(!_serviceNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"其他服务：" font:kFontSize_28];
        [self.contentView addSubview:_serviceNoticeLabel = label];
    }
    return _serviceNoticeLabel;
}

///服务
- (UILabel *)serviceLabel
{
    if(!_serviceLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_serviceLabel = label];
    }
    return _serviceLabel;
}

///简介提示
- (UILabel *)infoNoticeLabel
{
    if(!_infoNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"店铺简介：" font:kFontSize_28];
        [self.contentView addSubview:_infoNoticeLabel = label];
    }
    return _infoNoticeLabel;
}

///简介
- (UILabel *)infoLabel
{
    if(!_infoLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_infoLabel = label];
    }
    return _infoLabel;
}

@end
