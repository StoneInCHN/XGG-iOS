//
//  QL_DestinationTableViewCell.m
//  MenLi
//
//  Created by mini2 on 16/6/25.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "QL_SearchViewTableViewCell.h"

@interface QL_SearchViewTableViewCell()

///名字
@property(nonatomic, strong) UILabel *nameLabel;

@end

@implementation QL_SearchViewTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"QL_SearchViewTableViewCell";
    QL_SearchViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SearchViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(void)initDefault
{
    [self.contentView addSubview:self.nameLabel];
    
    WEAKSelf;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left).with.offset(OffSetToLeft);
    }];
}

-(void)dealloc
{
    [self.nameLabel removeFromSuperview];
    [self setNameLabel:nil];
}

#pragma mark -------------------- getter, setter

-(UILabel *)nameLabel
{
    if(!_nameLabel){
        _nameLabel = [UILabel createLabelWithText:@"Name" font:kFontSize_28];
    }
    return _nameLabel;
}

-(void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
}

@end
