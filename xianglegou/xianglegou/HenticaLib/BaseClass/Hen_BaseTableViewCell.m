//
//  QL_BaseTableViewCell.m
//  MenLi
//
//  Created by mini2 on 16/6/21.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "Hen_BaseTableViewCell.h"
#import "HenticaLib.h"

@implementation Hen_BaseTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"Hen_BaseTableViewCell";
    Hen_BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[Hen_BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(104);
}

///获取cell高度
+(CGFloat)getCellHeightForContent:(NSString*)content
{
    //文字高度
    CGFloat wordHeight = [[Hen_Util getInstance] calculationHeightForString:content anTextWidth:kMainScreenWidth - WIDTH_TRANSFORMATION(40) anFont:kFontSize_24];
    
    return wordHeight;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self initDefault];
        [self loadSubviewConstraints];
        [self loadLine];
    }
    
    return self;
}

-(void)initDefault
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    
}

///不显示点击效果
-(void)unShowClickEffect
{
    //不显示选中颜色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

///显示点击效果
- (void)showClickEffect
{
    //显示选中颜色
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

///加载分界线
-(void)loadLine
{
    [self.topLongLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.topShortLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(20));
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-20));
        make.top.equalTo(self);
    }];
    [self.bottomLongLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.bottomShortLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(20));
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-20));
        make.bottom.equalTo(self);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- getter,setter

-(UIImageView*)topLongLineImage
{
    if(!_topLongLineImage){
        UIImageView *topLongLineImage = [UIImageView createImageViewWithName:@"public_line"];
        topLongLineImage.hidden = YES;
        [self.contentView addSubview:_topLongLineImage = topLongLineImage];
    }
    return _topLongLineImage;
}

-(UIImageView*)topShortLineImage
{
    if(!_topShortLineImage){
        UIImageView *topShortLineImage = [UIImageView createImageViewWithName:@"public_line"];
        topShortLineImage.hidden = YES;
        [self.contentView addSubview:_topShortLineImage = topShortLineImage];
    }
    return _topShortLineImage;
}

-(UIImageView*)bottomLongLineImage
{
    if(!_bottomLongLineImage){
        UIImageView *bottomLongLineImage = [UIImageView createImageViewWithName:@"public_line"];
        bottomLongLineImage.hidden = YES;
        [self.contentView addSubview:_bottomLongLineImage = bottomLongLineImage];
    }
    return _bottomLongLineImage;
}

-(UIImageView*)bottomShortLineImage
{
    if(!_bottomShortLineImage){
        UIImageView *bottomShortLineImage = [UIImageView createImageViewWithName:@"public_line"];
        bottomShortLineImage.hidden = YES;
        [self.contentView addSubview:_bottomShortLineImage = bottomShortLineImage];
    }
    return _bottomShortLineImage;
}

@end
