//
//  GC_JiaoAmountTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  交易额 - cell
//

#import "GC_JiaoAmountTableViewCell.h"

@interface GC_JiaoAmountTableViewCell ()

///背景图

@property (nonatomic, weak) UIImageView *bgImage;
///图标
@property (nonatomic, weak) UIImageView *iconImage;
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///内容
@property (nonatomic, weak) UILabel *contentLabel;

@end


@implementation GC_JiaoAmountTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_JiaoAmountTableViewCell";
    GC_JiaoAmountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_JiaoAmountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(100);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = kCommonBackgroudColor;
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(60));
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage).offset(WIDTH_TRANSFORMATION(30));
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(WIDTH_TRANSFORMATION(12));
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.mas_right).offset(WIDTH_TRANSFORMATION(-36));
        make.bottom.equalTo(self.contentView);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


///更新ui
- (void)updateUiForDiscountAmountsData:(GC_MResDiscountAmountsDataModel *)data
{
    if(data){
        self.titleLabel.text = [NSString stringWithFormat:@"%@折",data.discount];
        
        NSString *str =  [DATAMODEL.henUtil string:data.amount showDotNumber:4];
        
        self.contentLabel.text = [NSString stringWithFormat:@"¥%@",str];
    }
}


#pragma mark -- getter,setter
///背景
- (UIImageView *)bgImage
{
    if(!_bgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_page4"];
        [self.contentView addSubview:_bgImage = image];
    }
    return _bgImage;
}


///图标
- (UIImageView *)iconImage
{
    if(!_iconImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_money"];
        [self.contentView addSubview:_iconImage = image];
    }
    return _iconImage;
}

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"0折" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///内容
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        UILabel *label = [UILabel createLabelWithText:@"￥0" font:kFontSize_28];
        [self.contentView addSubview:_contentLabel = label];
    }
    return _contentLabel;
}
@end
