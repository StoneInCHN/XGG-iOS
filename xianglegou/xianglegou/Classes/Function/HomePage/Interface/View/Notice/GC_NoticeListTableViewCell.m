//
//  GC_NoticeListTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/7.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  通知 -- cell
//

#import "GC_NoticeListTableViewCell.h"

@interface GC_NoticeListTableViewCell ()

///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///时间
@property (nonatomic, weak) UILabel *timeLabel;
///内容
@property (nonatomic, weak) UILabel *contentInfoLabel;

///未读标志
@property (nonatomic, weak) UIImageView *unReadImageView;
@end

@implementation GC_NoticeListTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_NoticeListTableViewCell";
    GC_NoticeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[GC_NoticeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(200);
}



///初始化
-(void)initDefault
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(31));
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(26));
        make.width.mas_equalTo(FITSCALE(100/2));
        make.height.mas_equalTo(FITSCALE(100/2));
    }];
    
    [self.unReadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(-12));
        make.top.equalTo(self.iconImageView.mas_top);
        make.width.mas_equalTo(FITSCALE(16/2));
        make.height.mas_equalTo(FITSCALE(16/2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(13));
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(26));
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-45));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(14));
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(13));
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-45));
    }];
    
    [self.contentInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(13));
        make.top.equalTo(self.timeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(14));
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-45));
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
///更新 ui
-(void)setUpdateUiForNoticesMsgData:(GC_MResNoticesMsgDataModel*)data
{
    if(data){
        if([data.isRead isEqualToString:@"0"]){
            self.unReadImageView.hidden = NO;
        }else{
            self.unReadImageView.hidden = YES;
        }
        
        self.titleLabel.text = data.messageTitle;
        
        self.contentInfoLabel.text = data.messageContent;
        
        self.timeLabel.text = [DATAMODEL.henUtil timeStampToString:data.createDate];
    }
}


#pragma mark -- getter,setter
///图标
- (UIImageView *)iconImageView
{
    if(!_iconImageView){
        UIImageView *iconImage = [UIImageView createImageViewWithName:@"homepage_notice_icon"];
        [iconImage makeRadiusForWidth:FITSCALE(100/2)];
        [self.contentView addSubview:_iconImageView = iconImage];
    }
    return _iconImageView;
}
///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel createLabelWithText:@"今日推荐" font:kFontSize_34];
        [self.contentView addSubview:_titleLabel = titleLabel];
    }
    return _titleLabel;
}

///时间
- (UILabel *)timeLabel
{
    if(!_timeLabel){
        UILabel *timeLabel = [UILabel createLabelWithText:@"2017-01-01" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_timeLabel = timeLabel];
    }
    return _timeLabel;
}

///内容
- (UILabel *)contentInfoLabel
{
    if(!_contentInfoLabel){
        UILabel *contentInfoLabel = [UILabel createLabelWithText:@"尊敬的用户：嘻嘻嘻xxxxxxxxxxxxxxxxxxxxx嘻嘻嘻想" font:kFontSize_28];
        [self.contentView addSubview:_contentInfoLabel = contentInfoLabel];
    }
    return _contentInfoLabel;
}


///未读标志
- (UIImageView *)unReadImageView
{
    if(!_unReadImageView){
        UIImageView *unReadImage = [UIImageView createImageViewWithName:@"public_samll_red_dot"];
        [unReadImage makeRadiusForWidth:FITSCALE(16/2)];
        [self.contentView addSubview:_unReadImageView = unReadImage];
    }
    return _unReadImageView;
}
@end
