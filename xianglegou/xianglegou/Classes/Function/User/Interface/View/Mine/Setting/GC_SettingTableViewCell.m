//
//  GC_SettingTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_SettingTableViewCell.h"

@interface GC_SettingTableViewCell ()
///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///内容
@property (nonatomic, weak) UILabel *contentInfoLabel;
///Next
@property (nonatomic, weak) UIImageView *nextImageView;

@end

@implementation GC_SettingTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_SettingTableViewCell";
    GC_SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(12));
        make.centerY.equalTo(self);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
        make.centerY.equalTo(self);
    }];
    
    [self.contentInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-60));
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
#pragma mark -- getter,setter
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


///内容
- (UILabel *)contentInfoLabel
{
    if(!_contentInfoLabel){
        UILabel *contentLabel = [UILabel createLabelWithText:@"" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_contentInfoLabel = contentLabel];
    }
    return _contentInfoLabel;
}


///Next
- (UIImageView *)nextImageView
{
    if(!_nextImageView){
        UIImageView *nextImage = [UIImageView createImageViewWithName:@"public_next"];
        [self.contentView addSubview:_nextImageView = nextImage];
    }
    return _nextImageView;
}


- (void)setIcon:(NSString *)icon
{
    _icon = icon;
    [self.iconImageView setImageForName:icon];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = HenLocalizedString(title);
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentInfoLabel.text = content;
}
@end
