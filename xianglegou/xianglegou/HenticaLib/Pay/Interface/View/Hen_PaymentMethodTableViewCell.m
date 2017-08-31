//
//  Hen_PaymentMethodTableViewCell.m
//  Peccancy
//
//  Created by mini2 on 16/10/9.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_PaymentMethodTableViewCell.h"

@interface Hen_PaymentMethodTableViewCell()<UITextFieldDelegate>

///图标
@property(nonatomic, strong) UIImageView *iconImageView;
///名字
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation Hen_PaymentMethodTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"Hen_PaymentMethodTableViewCell";
    Hen_PaymentMethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[Hen_PaymentMethodTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(100);
}

-(void)dealloc
{
    [self.iconImageView removeFromSuperview];
    [self setIconImageView:nil];
    [self.titleLabel removeFromSuperview];
    [self setTitleLabel:nil];
}

///初始化
-(void)initDefault
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [[self iconImageView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(OffSetToLeft);
    }];
    [[self titleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(WIDTH_TRANSFORMATION(100));
    }];
}


#pragma mark -- getter, setter

-(UIImageView*)iconImageView
{
    if(!_iconImageView){
        _iconImageView = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

-(UILabel*)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(void)setIcon:(NSString *)icon
{
    [self.iconImageView sd_setImageWithUrlString:icon defaultImageName:@""];
}

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
