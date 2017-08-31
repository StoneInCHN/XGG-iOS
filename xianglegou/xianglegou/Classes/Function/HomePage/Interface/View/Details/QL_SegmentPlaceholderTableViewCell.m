//
//  QL_SegmentPlaceholderTableViewCell.m
//  Ask
//
//  Created by mini2 on 16/12/29.
//  Copyright © 2016年 Ask. All rights reserved.
//

#import "QL_SegmentPlaceholderTableViewCell.h"

@interface QL_SegmentPlaceholderTableViewCell()

///view
@property(nonatomic, weak) UIView *bgView;

@end

@implementation QL_SegmentPlaceholderTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_SegmentPlaceholderTableViewCell";
    QL_SegmentPlaceholderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_SegmentPlaceholderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainScreenWidth);
        make.centerX.equalTo(self);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(100);
    }];
}

///更新高度
-(void)updateViewHeight:(CGFloat)height
{
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark -- getter,setter

-(UIView*)bgView
{
    if(!_bgView){
        UIView *view = [UIView createViewWithBackgroundColor:kCommonWhiteBg];
        [self.contentView addSubview:_bgView = view];
    }
    return _bgView;
}

@end
