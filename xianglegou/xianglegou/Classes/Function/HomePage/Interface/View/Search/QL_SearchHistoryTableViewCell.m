//
//  QL_SearchHistoryTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/31.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SearchHistoryTableViewCell.h"

@interface QL_SearchHistoryTableViewCell()

///内容
@property(nonatomic, weak) UILabel *contentLabel;
///时间
@property(nonatomic, weak) UILabel *timeLabel;

@end

@implementation QL_SearchHistoryTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_SearchHistoryTableViewCell";
    QL_SearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(110);
}

///初始化
- (void)initDefault
{
    self.bottomLongLineImage.hidden = NO;
    self.backgroundColor = kCommonBackgroudColor;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.right.equalTo(self).offset(OffSetToRight);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(30));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-10));
    }];
}

#pragma mark -- getter,setter

///内容
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_contentLabel = label];
    }
    return _contentLabel;
}

///时间
- (UILabel *)timeLabel
{
    if(!_timeLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_timeLabel = label];
    }
    return _timeLabel;
}

///设置内容
- (void)setContent:(NSString *)content
{
    self.contentLabel.text = content;
}

///设置时间
- (void)setTime:(NSString *)time
{
    self.timeLabel.text = time;
}

@end
