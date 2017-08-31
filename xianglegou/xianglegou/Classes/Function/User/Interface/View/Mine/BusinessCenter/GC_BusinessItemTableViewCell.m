//
//  GC_BusinessItemTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BusinessItemTableViewCell.h"

@interface GC_BusinessItemTableViewCell ()
///标题
@property (nonatomic, weak) UILabel *titleLabel;

///内容
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation GC_BusinessItemTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_BusinessItemTableViewCell";
    GC_BusinessItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_BusinessItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self unShowClickEffect];
    self.bottomLongLineImage.hidden = NO;
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(29));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-29));
    }];
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(29));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-29));
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


///更新 ui
- (void)updateUiForSellerCount:(GC_MResBusinessCountDataModel *)data
{
    if(data){
        self.titleLabel.text = data.name;
        self.contentLabel.text = data.count;
    }
}


#pragma mark -- getter,setter
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"成都市" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///内容
- (UILabel *)contentLabel
{
    if(!_contentLabel){
        UILabel *label = [UILabel createLabelWithText:@"1" font:kFontSize_28];
        [self.contentView addSubview:_contentLabel = label];
    }
    return _contentLabel;
}
@end
