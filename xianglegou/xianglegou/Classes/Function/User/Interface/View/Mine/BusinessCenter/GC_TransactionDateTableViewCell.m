//
//  GC_TransactionDateTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/7/1.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  交易时间 - cell
//

#import "GC_TransactionDateTableViewCell.h"


@interface GC_TransactionDateTableViewCell ()
///背景图
@property (nonatomic, weak) UIImageView *bgImageView;
///日期
@property (nonatomic, weak) UILabel *creaDateLabel;
///金额
@property (nonatomic, weak) UILabel *totalPriceLabel;

@end

@implementation GC_TransactionDateTableViewCell
///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_TransactionDateTableViewCell";
    GC_TransactionDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_TransactionDateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(93);
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
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(93));
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.creaDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(WIDTH_TRANSFORMATION(33));
        make.centerY.equalTo(self.contentView);
    }];
    
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView).offset(WIDTH_TRANSFORMATION(-36));
        make.centerY.equalTo(self.contentView);
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
- (void)updateUiForConsumeAmountData:(GC_MResConsumeAmountDataModel *)data
{
    if(data){
        self.creaDateLabel.text = data.date;
        self.totalPriceLabel.text = [DATAMODEL.henUtil string:data.totalAmount showDotNumber:4];
    }
}


///背景图
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_page1"];
        [self.contentView addSubview:_bgImageView = image];
    }
    return _bgImageView;
}



///日期
- (UILabel *)creaDateLabel
{
    if(!_creaDateLabel){
        UILabel *label = [UILabel createLabelWithText:@"0000-00-00" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_creaDateLabel = label];
    }
    return _creaDateLabel;
}

///金额
- (UILabel *)totalPriceLabel
{
    if(!_totalPriceLabel){
        UILabel *label = [UILabel createLabelWithText:@"￥0.0000" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_totalPriceLabel = label];
    }
    return _totalPriceLabel;
}
@end
