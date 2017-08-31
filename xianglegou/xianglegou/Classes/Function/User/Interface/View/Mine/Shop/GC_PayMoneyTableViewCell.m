//
//  GC_PayMoneyTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/15.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  支付 -- cell
//


#import "GC_PayMoneyTableViewCell.h"

@interface GC_PayMoneyTableViewCell ()
///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///Next
@property (nonatomic, weak) UIImageView *nextImageView;
@end


@implementation GC_PayMoneyTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_PayMoneyTableViewCell";
    
    GC_PayMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_PayMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.width.mas_equalTo(FITSCALE(47/2));
        make.height.mas_equalTo(FITSCALE(47/2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(15));
    }];

    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
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
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
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



///图标
- (void)setIconName:(NSString *)iconName
{
    _iconName = iconName;
    [self.iconImageView setImageForName:iconName];
}

- (void)setTitleInfo:(NSString *)titleInfo
{
    _titleInfo = titleInfo;
    self.titleLabel.text = titleInfo;
}

@end
