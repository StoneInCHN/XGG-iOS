//
//  QL_UserOrderDetailsTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_UserOrderDetailsTableViewCell.h"

#import "QL_BusinessDetailsViewController.h"

@interface QL_UserOrderDetailsTableViewCell()

///积分提示
@property(nonatomic, weak) UILabel *scoreNoticeLabel;
///积分
@property(nonatomic, weak) UILabel *scroeLabel;
///商家信息背景
@property(nonatomic, weak) UIView *infoBgView;
///logo
@property(nonatomic, weak) UIImageView *logoImage;
///名字
@property(nonatomic, weak) UILabel *nameLabel;
///支付提示
@property(nonatomic, weak) UILabel *payNoticeLabel;
///支付金额
@property(nonatomic, weak) UILabel *payMoneyLabel;
///下一步按钮
@property(nonatomic, weak) UIImageView *nextImage;
///订单编号提示
@property(nonatomic, weak) UILabel *orderNoticeLabel;
///订单编号
@property(nonatomic, weak) UILabel *orderLabel;
///消费时间提示
@property(nonatomic, weak) UILabel *timeNoticeLabel;
///消费时间
@property(nonatomic, weak) UILabel *timeLabel;
///备注提示
@property(nonatomic, weak) UILabel *remarkNoticeLabel;
///备注
@property(nonatomic, weak) UILabel *remarkLabel;


///商户的ID
@property (nonatomic, strong) NSString *sellerId;
///订单状态
@property (nonatomic, weak) UILabel *orderStateLabel;
@end

@implementation QL_UserOrderDetailsTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_UserOrderDetailsTableViewCell";
    QL_UserOrderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_UserOrderDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///初始化
- (void)initDefault
{
    [self unShowClickEffect];
    self.bottomLongLineImage.hidden = NO;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.scoreNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
    }];
    [self.scroeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.scoreNoticeLabel);
    }];
    [self.infoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(118));
        make.top.equalTo(self.scoreNoticeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.scoreNoticeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.scoreNoticeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(58));
        make.width.and.height.mas_equalTo(FITSCALE(40));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImage).offset(HEIGHT_TRANSFORMATION(-25));
        make.left.equalTo(self.logoImage.mas_right).offset(WIDTH_TRANSFORMATION(20));
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-80));
    }];
    [self.nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    
    [self.orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImage);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.payNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.logoImage).offset(HEIGHT_TRANSFORMATION(25));
        make.left.equalTo(self.logoImage.mas_right).offset(WIDTH_TRANSFORMATION(20));
    }];
    [self.payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payNoticeLabel);
        make.left.equalTo(self.payNoticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(2));
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.logoImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(40));
    }];
    [self.orderNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.logoImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(80));
    }];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.orderNoticeLabel);
    }];
    [self.timeNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.orderNoticeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(46));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeNoticeLabel);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
    [self.remarkNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.timeNoticeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(46));
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.left.equalTo(self.contentView).offset(FITSCALE(200/2));
        ///make.left.equalTo(self.remarkNoticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(50));
        ///make.left.equalTo(self.remarkNoticeLabel).with.priorityLow();
        make.top.equalTo(self.timeNoticeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(50));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
    }];
}


#pragma mark -- private
///更新ui
- (void)setUpdateUiForOrderUnderUserData:(GC_MResOrderUnderUserDataModel*)data
{
    if(data){
        
        
        if(data.userScore.length <= 0){
            data.userScore = @"0";
        }
        self.scoreNoticeLabel.text = @"赠送会员积分";
        self.scroeLabel.text = [DATAMODEL.henUtil string:data.userScore showDotNumber:4];
        if([data.status isEqualToString:@"UNPAID"]){                //未支付
            self.orderStateLabel.text = @"未支付";
            self.scroeLabel.text = @"0.0000";
        }else if([data.status isEqualToString:@"PAID"]){              //待评价
            self.orderStateLabel.text = @"待评价";
        }else if([data.status isEqualToString:@"FINISHED"]){    //已完成
            self.orderStateLabel.text = @"已完成";
        }
        
        
        [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.seller.storePictureUrl] defaultImageName:@""];
        
        
        self.nameLabel.text = data.seller.name;
        
        if([data.isSallerOrder isEqualToString:@"1"]){
            self.payNoticeLabel.text = @"让利金额：";
            self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%@", [DATAMODEL.henUtil string:data.rebateAmount showDotNumber:2]];
        }else{
            self.payNoticeLabel.text = @"支付金额：";
            self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%@", [DATAMODEL.henUtil string:data.amount showDotNumber:2]];
        }
        
        
        self.orderLabel.text = data.sn;
        
        self.timeLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
        if(data.remark.length <= 0 || [data.remark isEqualToString:@""]){
            data.remark = @"  ";
        }
        self.remarkLabel.text = data.remark;
        
        self.sellerId = data.seller.id;
        
        if([data.isSallerOrder isEqualToString:@"1"]){
            self.remarkLabel.hidden = YES;
            self.remarkNoticeLabel.hidden = YES;
            self.timeNoticeLabel.text = @"创建时间";
            [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
            }];
        }else{
            self.remarkLabel.hidden = NO;
            self.remarkNoticeLabel.hidden = NO;
            self.timeNoticeLabel.text = @"消费时间";
            [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
            }];
        }
    }
}

///更新UI
- (void)updateUIForShopOrderListData:(QL_ShopOrderListDataModel *)data
{
    if(data){
        if(data.sellerScore.length <= 0){
            data.sellerScore = @"0";
        }
        
        self.scoreNoticeLabel.text = @"赠送商家积分";
        self.scroeLabel.text = [DATAMODEL.henUtil string:data.sellerScore showDotNumber:4];
        
        if([data.status isEqualToString:@"UNPAID"]){        //未支付
            self.orderStateLabel.text = @"未支付";
            self.scroeLabel.text = @"0.0000";
        }else if([data.status isEqualToString:@"PAID"]){    //已支付
            self.orderStateLabel.text = @"已支付";
        }else if([data.status isEqualToString:@"FINISHED"]){//已完成
            self.orderStateLabel.text = @"已完成";
        }
        
        
        if(self.isClearing.length > 0){
            if([data.isClearing isEqualToString:@"1"]){   //已结算
                self.orderStateLabel.text = @"已结算";
            }else if([data.isClearing isEqualToString:@"0"]){   //结算中
                self.orderStateLabel.text = @"结算中";
            }
        }
        
        
        
        if([data.isSallerOrder isEqualToString:@"1"]){
            self.remarkLabel.hidden = YES;
            self.remarkNoticeLabel.hidden = YES;
            [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
            }];
        }else{
            self.remarkLabel.hidden = NO;
            self.remarkNoticeLabel.hidden = NO;
            [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-30));
            }];
        }
        
        
        [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.endUser.userPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
        
        self.nameLabel.text = data.endUser.nickName;
        
        if([data.isSallerOrder isEqualToString:@"1"]){
            self.payNoticeLabel.text = @"让利金额：";
            self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%@", [DATAMODEL.henUtil string:data.rebateAmount showDotNumber:2]];
        }else{
            self.payNoticeLabel.text = @"支付金额：";
            self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%@",[DATAMODEL.henUtil string: data.amount showDotNumber:2]];
        }
        
        
        self.orderLabel.text = data.sn;
        
        self.timeLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
        if(data.remark.length <= 0){
            data.remark = @"  ";
        }
        self.remarkLabel.text = data.remark;
    }
}

///设置下一步显隐
- (void)setNextImageHidden:(BOOL)hidden
{
    self.nextImage.hidden = hidden;
    self.infoBgView.userInteractionEnabled = !hidden;
}

#pragma mark -- event response

///点击信息
- (void)onInfoAction:(id)sender
{
    //商家详情
    QL_BusinessDetailsViewController *bdVC = [[QL_BusinessDetailsViewController alloc] init];
    bdVC.hidesBottomBarWhenPushed = YES;
    
    bdVC.sellerId = self.sellerId;
    
    [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:bdVC animated:YES];
}

#pragma mark -- getter,setter

///积分提示
- (UILabel *)scoreNoticeLabel
{
    if(!_scoreNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"返还积分" font:kFontSize_28];
        [self.contentView addSubview:_scoreNoticeLabel = label];
    }
    return _scoreNoticeLabel;
}

///积分
- (UILabel *)scroeLabel
{
    if(!_scroeLabel){
        UILabel *label = [UILabel createLabelWithText:@"0" font:kFontSize_28];
        [self.contentView addSubview:_scroeLabel = label];
    }
    return _scroeLabel;
}

///商家信息背景
- (UIView *)infoBgView
{
    if(!_infoBgView){
        UIView *view = [UIView createViewWithBackgroundColor:kCommonWhiteBg];
        [self.contentView addSubview:_infoBgView = view];
        //点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onInfoAction:)];
        [view addGestureRecognizer:tap];
    }
    return _infoBgView;
}

///logo
- (UIImageView *)logoImage
{
    if(!_logoImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        image.backgroundColor = kCommonBackgroudColor;
        [self.contentView addSubview:_logoImage = image];
    }
    return _logoImage;
}

///名字
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_34 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///支付提示
- (UILabel *)payNoticeLabel
{
    if(!_payNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"支付金额：" font:kFontSize_28];
        [self.contentView addSubview:_payNoticeLabel = label];
    }
    return _payNoticeLabel;
}

///支付金额
- (UILabel *)payMoneyLabel
{
    if(!_payMoneyLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_payMoneyLabel = label];
    }
    return _payMoneyLabel;
}

///下一步按钮
- (UIImageView *)nextImage
{
    if(!_nextImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_next"];
        image.backgroundColor = kCommonBackgroudColor;
        [self.contentView addSubview:_nextImage = image];
    }
    return _nextImage;
}

///订单编号提示
- (UILabel *)orderNoticeLabel
{
    if(!_orderNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"订单编号" font:kFontSize_28];
        [self.contentView addSubview:_orderNoticeLabel = label];
    }
    return _orderNoticeLabel;
}

///订单编号
- (UILabel *)orderLabel
{
    if(!_orderLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28 textColor:kFontColorGray];
        [self.contentView addSubview:_orderLabel = label];
    }
    return _orderLabel;
}

///消费时间提示
- (UILabel *)timeNoticeLabel
{
    if(!_timeNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"消费时间" font:kFontSize_28];
        [self.contentView addSubview:_timeNoticeLabel = label];
    }
    return _timeNoticeLabel;
}

///消费时间
- (UILabel *)timeLabel
{
    if(!_timeLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28 textColor:kFontColorGray];
        [self.contentView addSubview:_timeLabel = label];
    }
    return _timeLabel;
}

///备注提示
- (UILabel *)remarkNoticeLabel
{
    if(!_remarkNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"备注" font:kFontSize_28];
        [self.contentView addSubview:_remarkNoticeLabel = label];
    }
    return _remarkNoticeLabel;
}

///备注
- (UILabel *)remarkLabel
{
    if(!_remarkLabel){
        UILabel *label = [UILabel createLabelWithText:@"xxxxxxxxxxxxxxxxxxx" font:kFontSize_28 textColor:kFontColorGray];
        [label lableAutoLinefeed];
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_remarkLabel = label];
    }
    return _remarkLabel;
}

///线
- (UIImageView *)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self.contentView addSubview:image];
    
    return image;
}


///订单状态
- (UILabel *)orderStateLabel
{
    if(!_orderStateLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_orderStateLabel = label];
    }
    return _orderStateLabel;
}

- (void)setIsClearing:(NSString *)isClearing
{
    _isClearing = isClearing;
}
@end
