//
//  GC_ShopMoneyTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  店铺货款 -- cell
//


#import "GC_ShopMoneyTableViewCell.h"

@interface GC_ShopMoneyTableViewCell ()

///货款编码
@property (nonatomic, weak) UILabel *paymentCodeLabel;
///是否结算
@property (nonatomic, weak) UILabel *isNoSettlementLabel;

///创建时间
@property (nonatomic, weak) UILabel *createDateLabel;
///收益信息
@property (nonatomic, weak) UILabel *incomeLabel;

@end

@implementation GC_ShopMoneyTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_ShopMoneyTableViewCell";
    GC_ShopMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_ShopMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(144);
}

///初始化
-(void)initDefault
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.paymentCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(35));
    }];
    
    [self.isNoSettlementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.paymentCodeLabel);
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
    }];
    
    [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
    }];
    
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.createDateLabel);
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
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
- (void)updateUIForPatMentListData:(GC_MResPaymentListDataModel *)data
{
    //货款编码
    self.paymentCodeLabel.text = [NSString stringWithFormat:@"货款编码：%@",data.clearingSn];
    //是否结算
    if([data.isClearing isEqualToString:@"1"]){
        self.isNoSettlementLabel.text = @"已结算";
        self.incomeLabel.text = [NSString stringWithFormat:@"￥%@",[DATAMODEL.henUtil string:data.amount showDotNumber:4]];
    }else{
        self.isNoSettlementLabel.text = @"未结算";
        self.incomeLabel.text = [NSString stringWithFormat:@"￥%@",[DATAMODEL.henUtil string:data.amount showDotNumber:4]];
    }
    
    self.createDateLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
}



#pragma mark -- getter,setter
///货款编码
- (UILabel *)paymentCodeLabel
{
    if(!_paymentCodeLabel){
        UILabel *label = [UILabel createLabelWithText:@"货款编码：988889910" font:kFontSize_28];
        [self.contentView addSubview:_paymentCodeLabel = label];
    }
    return _paymentCodeLabel;
}

///结算方式
- (UILabel *)isNoSettlementLabel
{
    if(!_isNoSettlementLabel){
        UILabel *label = [UILabel createLabelWithText:@"未结算" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_isNoSettlementLabel = label];
    }
    return _isNoSettlementLabel;
}


///创建时间
- (UILabel *)createDateLabel
{
    if(!_createDateLabel){
        UILabel *label = [UILabel createLabelWithText:@"2017-03-14 17:09" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_createDateLabel = label];
    }
    return _createDateLabel;
}
///收益信息
- (UILabel *)incomeLabel
{
    if(!_incomeLabel){
        UILabel *label = [UILabel createLabelWithText:@"实际收益" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_incomeLabel = label];
    }
    return _incomeLabel;
}




@end
