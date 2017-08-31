//
//  QL_BannerDetailsTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BannerDetailsTableViewCell.h"

@interface QL_BannerDetailsTableViewCell()

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///时间
@property(nonatomic, weak) UILabel *timeLabel;
///内容
@property(nonatomic, weak) UILabel *contentLabel;
///图片
@property(nonatomic, weak) UIImageView *pngImage;

@end

@implementation QL_BannerDetailsTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_BannerDetailsTableViewCell";
    QL_BannerDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_BannerDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
- (void)initDefault
{
    
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(40));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    [self.pngImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(30));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(350));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
    }];
}

///更新UI
- (void)updateUIForData:(QL_HomePageBannerDataModel *)data
{
    if(data){
        self.titleLabel.text = data.bannerName;
        self.timeLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
        self.contentLabel.text = data.content;
        [self.pngImage sd_setImageWithUrlString:data.bannerUrl defaultImageName:@""];
    }
}

#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_32];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
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

///内容
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_contentLabel = label];
    }
    return _contentLabel;
}

///图片
- (UIImageView *)pngImage
{
    if(!_pngImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_pngImage = image];
    }
    return _pngImage;
}


@end
