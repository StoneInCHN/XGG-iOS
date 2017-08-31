//
//  GC_PaymentIncomeInfoTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  货款收益 -- cell
//

#import "GC_PaymentIncomeInfoTableViewCell.h"

@interface GC_PaymentIncomeInfoTableViewCell ()

///实际收益
@property (nonatomic, weak) UILabel *actualIncomeLabel;
@property (nonatomic, weak) UILabel *sjsyLabel;
///货款编号
@property (nonatomic, weak) UILabel *paymentNumLabel;
@property (nonatomic, weak) UILabel *hkbmLabel;

///总收益
@property (nonatomic, weak) UILabel *totalIncomeLabel;
@property (nonatomic, weak) UILabel *zsyLabel;

///背景
@property (nonatomic, weak) UIImageView *bgImageView;
///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///名称
@property (nonatomic, weak) UILabel *nameLabel;
///类型
@property (nonatomic, weak) UILabel *typeLabel;
///卡号
@property (nonatomic, weak) UILabel *cardNoLabel;


@end

@implementation GC_PaymentIncomeInfoTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_PaymentIncomeInfoTableViewCell";
    
    GC_PaymentIncomeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_PaymentIncomeInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(195);
}



///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    
    
    [self.sjsyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(34));
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
    }];
    
    [self.actualIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(180));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.sjsyLabel);
    }];
    
    [self.hkbmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.sjsyLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(25));
    }];
    
    [self.paymentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(180));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.hkbmLabel);
    }];
    
    [self.zsyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.hkbmLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(25));
    }];
    
    [self.totalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(180));
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.zsyLabel);
    }];
    
    
    
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.zsyLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(26));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(162));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-33));
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageView);
        make.left.equalTo(self.bgImageView).offset(WIDTH_TRANSFORMATION(20));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(116));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(72));
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(15));
        make.top.equalTo(self.bgImageView).offset(HEIGHT_TRANSFORMATION(15));
        make.right.equalTo(self.bgImageView.mas_right).offset(WIDTH_TRANSFORMATION(-190));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(HEIGHT_TRANSFORMATION(15));
        make.right.equalTo(self.bgImageView.mas_right).offset(WIDTH_TRANSFORMATION(-21));
    }];
    
    [self.cardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(15));
        make.centerY.equalTo(self.bgImageView);
        make.right.equalTo(self.bgImageView.mas_right).offset(WIDTH_TRANSFORMATION(-21));
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
- (void)updateUIForPayMentDetailsData:(GC_MResPaymentDetailDataModel *)data
{
    ///实际收益
    self.actualIncomeLabel.text = [NSString stringWithFormat:@"￥%@", data.amount.length > 0 ? [DATAMODEL.henUtil string:data.amount showDotNumber:4] : @"0.0000"];
    //货款编码
    self.paymentNumLabel.text = data.clearingSn;
    //总收益
    self.totalIncomeLabel.text = [NSString stringWithFormat:@"￥%@",data.totalOrderAmount.length > 0 ? [DATAMODEL.henUtil string:data.totalOrderAmount showDotNumber:4] : @"0.0000"];
    [self.iconImageView sd_setImageWithUrlString:@"" defaultImageName:@"mine_bank_card"];
    self.nameLabel.text = data.bankCard.bankName;
    self.typeLabel.text = data.bankCard.cardType;
    self.cardNoLabel.text = [DATAMODEL.henUtil getStringLastThree:data.bankCard.cardNum andCharNum:4];
}



#pragma mark -- getter,setter



///实际收益
- (UILabel *)sjsyLabel
{
    if(!_sjsyLabel){
        UILabel *label = [UILabel createLabelWithText:@"实际收益：" font:kFontSize_28];
        [self.contentView addSubview:_sjsyLabel = label];
    }
    return _sjsyLabel;
}

- (UILabel *)actualIncomeLabel
{
    if(!_actualIncomeLabel){
        UILabel *label = [UILabel createLabelWithText:@"￥5655.0000" font:kFontSize_36 textColor:kFontColorRed];
        [self.contentView addSubview:_actualIncomeLabel = label];
    }
    return _actualIncomeLabel;
}

///货款编码
- (UILabel *)hkbmLabel
{
    if(!_hkbmLabel){
        UILabel *label = [UILabel createLabelWithText:@"货款编码：" font:kFontSize_28];
        [self.contentView addSubview:_hkbmLabel = label];
    }
    return _hkbmLabel;
}

- (UILabel *)paymentNumLabel
{
    if(!_paymentNumLabel){
        UILabel *label = [UILabel createLabelWithText:@"455644564564" font:kFontSize_28];
        [self.contentView addSubview:_paymentNumLabel = label];
    }
    return _paymentNumLabel;
}


///总收益
- (UILabel *)zsyLabel
{
    if(!_zsyLabel){
        UILabel *label = [UILabel createLabelWithText:@"总收益：" font:kFontSize_28];
        [self.contentView addSubview:_zsyLabel = label];
    }
    return _zsyLabel;
}

- (UILabel *)totalIncomeLabel
{
    if(!_totalIncomeLabel){
        UILabel *label = [UILabel createLabelWithText:@"￥54565456.00" font:kFontSize_28];
        [self.contentView addSubview:_totalIncomeLabel = label];
    }
    return _totalIncomeLabel;
}


///背景图
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_bank2"];
        [self.contentView addSubview:_bgImageView = bgImage];
    }
    return _bgImageView;
}

///图标
- (UIImageView *)iconImageView
{
    if(!_iconImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_bank_card"];
//        [image makeRadiusForWidth:HEIGHT_TRANSFORMATION(110)];
        [self.contentView addSubview:_iconImageView = image];
    }
    return _iconImageView;
}

///名称
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"招商银行" font:kFontSize_28 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///类型
- (UILabel *)typeLabel
{
    if(!_typeLabel){
        UILabel *label = [UILabel createLabelWithText:@"储蓄卡" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_typeLabel = label];
    }
    return _typeLabel;
}


///卡号
- (UILabel *)cardNoLabel
{
    if(!_cardNoLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_cardNoLabel = label];
    }
    return _cardNoLabel;
}

@end
