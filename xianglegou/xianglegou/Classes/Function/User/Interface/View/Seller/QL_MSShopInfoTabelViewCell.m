//
//  QL_MSShopInfoTabelViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_MSShopInfoTabelViewCell.h"

@interface QL_MSShopInfoTabelViewCell()

///logo背景
@property(nonatomic, weak) UIImageView *logoBgImage;
///logo
@property(nonatomic, weak) UIImageView *logoImage;
///名称
@property(nonatomic, weak) UILabel *titleLabel;
///地址
@property(nonatomic, weak) UILabel *addressLabel;
///收藏提示
@property(nonatomic, weak) UILabel *collectionNoticeLabel;
///收藏
@property(nonatomic, weak) UILabel *collectionLabel;
///折扣提示
@property(nonatomic, weak) UILabel *discountNoticeLabel;
///折扣
@property(nonatomic, weak) UILabel *discountLabel;
///总额度提示
@property(nonatomic, weak) UILabel *totalQuotaNoticeLabel;
///总额度
@property(nonatomic, weak) UILabel *totalQuotaLabel;
///当前额度提示
@property(nonatomic, weak) UILabel *currentQuotaNoticeLabel;
///当前额度
@property(nonatomic, weak) UILabel *currentQuotaLabel;

@end

@implementation QL_MSShopInfoTabelViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_MSShopInfoTabelViewCell";
    QL_MSShopInfoTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_MSShopInfoTabelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(350);
}

///初始化
- (void)initDefault
{
    self.topLongLineImage.hidden = NO;
    self.bottomLongLineImage.hidden = NO;
    [self unShowClickEffect];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.logoBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(14));
        make.width.and.height.mas_equalTo(FITSCALE(104));
    }];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.logoBgImage);
        make.width.and.height.mas_equalTo(FITSCALE(80));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoBgImage.mas_right).offset(WIDTH_TRANSFORMATION(22));
        make.top.equalTo(self.logoBgImage).offset(HEIGHT_TRANSFORMATION(20));
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.logoBgImage).offset(HEIGHT_TRANSFORMATION(-33));
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.logoBgImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
    }];
    
    
    
    [self.collectionNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-60));
        make.left.equalTo(self.contentView);
        make.width.mas_equalTo(kMainScreenWidth / 4 - WIDTH_TRANSFORMATION(25));
//        make.centerX.equalTo(self).offset(-kMainScreenWidth / 8);
    }];
    
    [self.collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collectionNoticeLabel);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-20));
    }];
    [[self verticalLine] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionNoticeLabel.mas_right);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-14));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(90));
    }];
    
    
    [self.discountNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-60));
        make.left.equalTo(self.collectionNoticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(1));
        make.width.mas_equalTo(kMainScreenWidth / 4 - WIDTH_TRANSFORMATION(15));
//        make.centerX.equalTo(self).offset(kMainScreenWidth / 8);
    }];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.discountNoticeLabel);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-20));
    }];
    
    
    [[self verticalLine] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountNoticeLabel.mas_right);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-14));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(90));
    }];
    
    [self.totalQuotaNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-60));
        make.left.equalTo(self.discountNoticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(1));
        make.width.mas_equalTo(kMainScreenWidth / 4);
    }];
    [self.totalQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.totalQuotaNoticeLabel);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-20));
    }];
    
    
    [[self verticalLine] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalQuotaNoticeLabel.mas_right);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-14));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(90));
    }];
    
    [self.currentQuotaNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-60));
        make.left.equalTo(self.totalQuotaNoticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(1));
        make.right.equalTo(self.contentView);
    }];
    
    [self.currentQuotaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.currentQuotaNoticeLabel);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-20));
    }];
}

///更新UI
- (void)updateUIForData:(QL_ShopInformationDataModel *)data
{
    if(data){
        [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl, data.storePictureUrl] defaultImageName:@"mine_shop"];
        self.titleLabel.text = data.name;
        self.addressLabel.text = data.address;
        self.collectionLabel.text = data.favoriteNum;
        self.discountLabel.text = data.discount;
        
        self.totalQuotaLabel.text = [DATAMODEL.henUtil string:data.limitAmountByDay showDotNumber:2];
        
        double remAmountByDay = [data.limitAmountByDay doubleValue] - [data.curLimitAmountByDay doubleValue];
        
        self.currentQuotaLabel.text = [NSString stringWithFormat:@"%0.2f",remAmountByDay];
    }
}

#pragma mark -- getter,setter

///logo背景
- (UIImageView *)logoBgImage
{
    if(!_logoBgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_head_bg_gray"];
        [self.contentView addSubview:_logoBgImage = image];
    }
    return _logoBgImage;
}

///logo
- (UIImageView *)logoImage
{
    if(!_logoImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_shop"];
        [image makeRadiusForWidth:FITSCALE(80)];
        [self.contentView addSubview:_logoImage = image];
    }
    return _logoImage;
}

///名称
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_34 textColor:kBussinessFontColorBlack];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///地址
- (UILabel *)addressLabel
{
    if(!_addressLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28];
        [label lableAutoLinefeed];
        [self.contentView addSubview:_addressLabel = label];
    }
    return _addressLabel;
}

///收藏提示
- (UILabel *)collectionNoticeLabel
{
    if(!_collectionNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"收藏" font:kFontSize_28];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_collectionNoticeLabel = label];
    }
    return _collectionNoticeLabel;
}

///收藏
- (UILabel *)collectionLabel
{
    if(!_collectionLabel){
        UILabel *label = [UILabel createLabelWithText:@"0" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_collectionLabel = label];
    }
    return _collectionLabel;
}

///折扣提示
- (UILabel *)discountNoticeLabel
{
    if(!_discountNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"折扣(折)" font:kFontSize_28];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_discountNoticeLabel = label];
    }
    return _discountNoticeLabel;
}

///折扣
- (UILabel *)discountLabel
{
    if(!_discountLabel){
        UILabel *label = [UILabel createLabelWithText:@"0" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_discountLabel = label];
    }
    return _discountLabel;
}

///横线
- (UIImageView *)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self.contentView addSubview:image];
    
    return image;
}

///竖线
- (UIImageView *)verticalLine
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line2"];
    [self.contentView addSubview:image];
    
    return image;
}

///总额度
- (UILabel *)totalQuotaNoticeLabel
{
    if(!_totalQuotaNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"总额度(元)" font:kFontSize_28];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_totalQuotaNoticeLabel = label];
    }
    return _totalQuotaNoticeLabel;
}

///总额度
- (UILabel *)totalQuotaLabel
{
    if(!_totalQuotaLabel){
        UILabel *label = [UILabel createLabelWithText:@"0" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_totalQuotaLabel = label];
    }
    return _totalQuotaLabel;
}

///当前额度
- (UILabel *)currentQuotaNoticeLabel
{
    if(!_currentQuotaNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"剩余额度(元)" font:kFontSize_28];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_currentQuotaNoticeLabel = label];
    }
    return _currentQuotaNoticeLabel;
}
///当前额度
- (UILabel *)currentQuotaLabel
{
    if(!_currentQuotaLabel){
        UILabel *label = [UILabel createLabelWithText:@"0" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_currentQuotaLabel = label];
    }
    return _currentQuotaLabel;
}

@end
