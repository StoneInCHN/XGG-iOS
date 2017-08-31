//
//  GC_ConsumerHotlineTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  客服电话 -- cell
//

#import "GC_ConsumerHotlineTableViewCell.h"

@interface GC_ConsumerHotlineTableViewCell ()

///标题
@property (nonatomic, weak) UILabel *titleLabel;

///内容
@property (nonatomic, weak) UILabel *contentInfoLabel;

///Next
@property (nonatomic, weak) UIImageView *nextImageView;

///注释
@property (nonatomic, weak) UILabel *annotationsLabel;

@end

@implementation GC_ConsumerHotlineTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_ConsumerHotlineTableViewCell";
    
    GC_ConsumerHotlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_ConsumerHotlineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(130);
}


///初始化
-(void)initDefault
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(30));
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(30));
    }];
    
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-30));
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.contentInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-64));
        make.centerY.equalTo(self.titleLabel);
    }];
    
    
    [self.annotationsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(30));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(18));
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
///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel createLabelWithText:@"客服电话" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = titleLabel];
    }
    return _titleLabel;
}

///内容
- (UILabel *)contentInfoLabel
{
    if(!_contentInfoLabel){
        UILabel *contentInfo = [UILabel createLabelWithText:@"400-8789382" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_contentInfoLabel = contentInfo];
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

///注释
- (UILabel *)annotationsLabel
{
    if(!_annotationsLabel){
        UILabel *annotationsLabel = [UILabel createLabelWithText:@"注：服务时间为9:00 - 17:50" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_annotationsLabel = annotationsLabel];
    }
    return _annotationsLabel;
}

- (void)setCustomerMobile:(NSString *)customerMobile
{
    _customerMobile = customerMobile;
    self.contentInfoLabel.text = customerMobile;
}

- (void)setServiceTime:(NSString *)serviceTime
{
    _serviceTime = serviceTime;
    self.annotationsLabel.text = [NSString stringWithFormat:@"注：服务时间为%@",serviceTime];
}
@end
