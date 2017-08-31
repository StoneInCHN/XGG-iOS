//
//  GC_PaymentConsumptionInfoTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  货款消费 -- cell
//

#import "GC_PaymentConsumptionInfoTableViewCell.h"

@interface GC_PaymentConsumptionInfoTableViewCell ()

///创建时间
@property (nonatomic, weak) UILabel *creatDateLabel;
///收益
@property (nonatomic, weak) UILabel *incomePriceLabel;
///订单编号
@property (nonatomic, weak) UILabel *orderNumberLabel;
///商家折扣
@property (nonatomic, weak) UILabel *sellerDiscountLabel;

///消费金额
@property (nonatomic, weak) UILabel *consumptionPricelabel;
///让利金额
@property (nonatomic, weak) UILabel *noneOtherPriceLabel;
@end

@implementation GC_PaymentConsumptionInfoTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_PaymentConsumptionInfoTableViewCell";
    GC_PaymentConsumptionInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_PaymentConsumptionInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(220);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.creatDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(25));
    }];
    
    [self.incomePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(25));
    }];
    
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.top.equalTo(self.creatDateLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(15));
    }];
    
    [self.sellerDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.centerY.equalTo(self.orderNumberLabel);
    }];
    
    [self.consumptionPricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.top.equalTo(self.orderNumberLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(15));
    }];
    
    [self.noneOtherPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.top.equalTo(self.consumptionPricelabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(15));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-20));
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
- (void)updateUiForPayMentOrdersData:(GC_MResPayMentOrdersDataModel *)data
{
    if(data){
        //创建时间
        self.creatDateLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.order.createDate];
        
        //收益
        NSString *sellerIncome = data.order.sellerIncome.length > 0 ? [DATAMODEL.henUtil string:data.order.sellerIncome showDotNumber:4] : @"0.0000";
        
        NSString *text = [NSString stringWithFormat:@"收益：￥%@",sellerIncome];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:kFontColorRed range:NSMakeRange(3,sellerIncome.length + 1)];
        
        self.incomePriceLabel.attributedText = str;
        
        
        ///编号
        self.orderNumberLabel.text = data.order.sn;
        ///折扣
        NSString *disStr = data.order.sellerDiscount.length > 0 ? data.order.sellerDiscount : @"0";
        NSString *discount = [NSString stringWithFormat:@"商家折扣：%@折",disStr];
        NSMutableAttributedString *discountStr = [[NSMutableAttributedString alloc] initWithString:discount];
        [discountStr addAttribute:NSForegroundColorAttributeName value:kFontColorRed range:NSMakeRange(5,disStr.length + 1)];
        self.sellerDiscountLabel.attributedText = discountStr;
        
        
        //消费金额
        
        
        self.consumptionPricelabel.text = [NSString stringWithFormat:@"消费金额：%@",data.order.amount.length > 0 ? [DATAMODEL.henUtil string:data.order.amount showDotNumber:4] : @"0.0000"];
        
        //让利金额
        
        self.noneOtherPriceLabel.text = [NSString stringWithFormat:@"让利金额：%@",data.order.rebateAmount.length > 0 ? [DATAMODEL.henUtil string:data.order.rebateAmount showDotNumber:4] : @"0.0000"];
    }
}

#pragma mark -- getter,setter

///创建时间
- (UILabel *)creatDateLabel
{
    if(!_creatDateLabel){
        UILabel *label = [UILabel createLabelWithText:@"2017-03-02 14:23" font:kFontSize_28];
        [self.contentView addSubview:_creatDateLabel = label];
    }
    return _creatDateLabel;
}


///收益
- (UILabel *)incomePriceLabel
{
    if(!_incomePriceLabel){
        UILabel *label = [UILabel createLabelWithText:@"收益：0.0000" font:kFontSize_28];
        [self.contentView addSubview:_incomePriceLabel = label];
    }
    return _incomePriceLabel;
}

///订单编号
- (UILabel *)orderNumberLabel
{
    if(!_orderNumberLabel){
        UILabel *label = [UILabel createLabelWithText:@"订单编号：000000" font:kFontSize_28];
        [self.contentView addSubview:_orderNumberLabel = label];
    }
    return _orderNumberLabel;
}

///商家折扣
- (UILabel *)sellerDiscountLabel
{
    if(!_sellerDiscountLabel){
        UILabel *label = [UILabel createLabelWithText:@"商家折扣：0折" font:kFontSize_28];
        [self.contentView addSubview:_sellerDiscountLabel = label];
    }
    return _sellerDiscountLabel;
}
///消费金额
- (UILabel *)consumptionPricelabel
{
    if(!_consumptionPricelabel){
        UILabel *label = [UILabel createLabelWithText:@"消费金额：0.0000" font:kFontSize_28];
        [self.contentView addSubview:_consumptionPricelabel = label];
    }
    return _consumptionPricelabel;
}

///让利金额
- (UILabel *)noneOtherPriceLabel
{
    if(!_noneOtherPriceLabel){
        UILabel *label = [UILabel createLabelWithText:@"让利金额：0.0000" font:kFontSize_28];
        [self.contentView addSubview:_noneOtherPriceLabel = label];
    }
    return _noneOtherPriceLabel;
}

@end
