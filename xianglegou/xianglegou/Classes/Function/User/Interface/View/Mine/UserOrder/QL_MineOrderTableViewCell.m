//
//  QL_MineOrderTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_MineOrderTableViewCell.h"
#import "QL_UserPublishCommentViewController.h"
#import "QL_UserCommentDetailsViewController.h"
#import "QL_BusinessDetailsViewController.h"

@interface QL_MineOrderTableViewCell()

///名字
@property(nonatomic, weak) UILabel *nameLabel;
///状态
@property(nonatomic, weak) UILabel *statusLabel;
///logo
@property(nonatomic, weak) UIImageView *logoImage;
///积分
@property(nonatomic, weak) UILabel *integralLabel;
///金额
@property(nonatomic, weak) UILabel *moneyLabel;
///按钮1
@property(nonatomic, weak) UIButton *button1;
///按钮2
@property(nonatomic, weak) UIButton *button2;

///消费时间
@property (nonatomic, weak) UILabel *createDateLabel;

///订单数据
@property (nonatomic, strong) GC_MResOrderUnderUserDataModel *orderData;
@end

@implementation QL_MineOrderTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_MineOrderTableViewCell";
    QL_MineOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_MineOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(350);
}

///未支付高度
+ (CGFloat)getCellHeightForUnPaid
{
    return HEIGHT_TRANSFORMATION(240);
}
///初始化
- (void)initDefault
{
    self.topLongLineImage.hidden = NO;
    self.bottomLongLineImage.hidden = NO;
}

- (void)dealloc{

}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(24));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.right.equalTo(self).offset(OffSetToRight);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(22));
    }];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(44));
        make.width.and.height.mas_equalTo(FITSCALE(40));
    }];
    
    
    [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImage);
        make.left.equalTo(self.logoImage.mas_right).offset(WIDTH_TRANSFORMATION(20));
    }];
    
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createDateLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
        make.left.equalTo(self.logoImage.mas_right).offset(WIDTH_TRANSFORMATION(20));
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.integralLabel);
        make.top.equalTo(self.integralLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
    }];
    
    
    
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.right.equalTo(self).offset(OffSetToRight);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-20));
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.button2);
        make.right.equalTo(self.button2.mas_left).offset(WIDTH_TRANSFORMATION(-18));
    }];
}




///更新 ui
-(void)updateUiForOrderUnderUserData:(GC_MResOrderUnderUserDataModel*)data
{
    if(data){
        self.nameLabel.text = data.seller.name;
        NSString *userScore = data.userScore.length > 0 ? [DATAMODEL.henUtil string:data.userScore showDotNumber:4] : @"0.0000";
        self.integralLabel.text = [NSString stringWithFormat:@"赠送会员积分：%@",userScore];
        self.button1.hidden = NO;
        self.button2.hidden = NO;
        if([data.status isEqualToString:@"UNPAID"]){                //未支付
            self.statusLabel.text = HenLocalizedString(@"未支付");
            self.button1.hidden = YES;
            self.button2.hidden = YES;
            self.integralLabel.text = [NSString stringWithFormat:@"赠送会员积分：%@",@"0.0000"];
        }else if([data.status isEqualToString:@"PAID"]){              //待评价
            self.statusLabel.text = HenLocalizedString(@"待评价");
        }else if([data.status isEqualToString:@"FINISHED"]){    //已完成
            self.statusLabel.text = HenLocalizedString(@"已完成");
        }
        
        
        
        [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.seller.storePictureUrl] defaultImageName:@""];
        
        
        self.createDateLabel.text = [NSString stringWithFormat:@"消费时间：%@",[DATAMODEL.henUtil dateTimeStampToString:data.createDate]];
        
        
        if(data.userScore.length <= 0 || [data.userScore isEqualToString:@""]){
            data.userScore = @"0";
        }
        
        NSString *payMoney = @"";
        NSMutableAttributedString *str = nil;
        if([data.isSallerOrder isEqualToString:@"1"]){
             NSString *rebateAmount = data.rebateAmount.length > 0 ? [DATAMODEL.henUtil string:data.rebateAmount showDotNumber:2] : @"0.00";
            payMoney = [NSString stringWithFormat:@"让利金额：￥%@",rebateAmount];
            str = [[NSMutableAttributedString alloc] initWithString:payMoney];
            [str addAttribute:NSForegroundColorAttributeName value:kFontColorRed range:NSMakeRange(5,rebateAmount.length + 1)];
        }else{
            
             NSString *amount =  data.amount.length > 0 ? [DATAMODEL.henUtil string:data.amount showDotNumber:2] : @"0.00";
            
            payMoney = [NSString stringWithFormat:@"支付金额：￥%@",amount];
            str = [[NSMutableAttributedString alloc] initWithString:payMoney];
            [str addAttribute:NSForegroundColorAttributeName value:kFontColorRed range:NSMakeRange(5,amount.length + 1)];
        }
        
        
        self.moneyLabel.attributedText = str;
        //////self.moneyLabel.text = [NSString stringWithFormat:@"支付金额：￥%@",data.amount];
   
        if(data.evaluate.content.length <= 0 || [data.evaluate.content isEqualToString:@""]){
            [self.button1 setTitle:@"立即评价"];
        }else{
            [self.button1 setTitle:@"查看评价"];
        }
        
        self.orderData = data;
        
        
    }
}


#pragma mark -- event response

///按钮点击
- (void)onButtonAction:(UIButton *)sender
{
    if(sender.tag == 1){ // 按钮1
        if(self.orderData.evaluate.content.length <= 0 || [self.orderData.evaluate.content isEqualToString:@""]){
            //发表评价
            QL_UserPublishCommentViewController *upcVC = [[QL_UserPublishCommentViewController alloc] init];
            upcVC.hidesBottomBarWhenPushed = YES;
            
            upcVC.orderData = self.orderData;
            [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:upcVC animated:YES];
        }else{
            //评价详情
            QL_UserCommentDetailsViewController *ucdVC = [[QL_UserCommentDetailsViewController alloc] init];
            ucdVC.hidesBottomBarWhenPushed = YES;
            ucdVC.orderData = self.orderData;
            [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:ucdVC animated:YES];
        }

        
    }else if(sender.tag == 2){ // 按钮2
        
        //商家详情
        QL_BusinessDetailsViewController *bdVC = [[QL_BusinessDetailsViewController alloc] init];
        bdVC.hidesBottomBarWhenPushed = YES;
        
        bdVC.sellerId = self.orderData.seller.id;
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:bdVC animated:YES];
        
    }
}

#pragma mark -- getter,setter

///名字
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"Name" font:kFontSize_28 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///状态
- (UILabel *)statusLabel
{
    if(!_statusLabel){
        UILabel *label = [UILabel createLabelWithText:@"xxx" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_statusLabel = label];
    }
    return _statusLabel;
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

///积分
- (UILabel *)integralLabel
{
    if(!_integralLabel){
        UILabel *label = [UILabel createLabelWithText:@"返还积分：" font:kFontSize_26 textColor:kFontColorGray];
        [self.contentView addSubview:_integralLabel = label];
    }
    return _integralLabel;
}

///金额
- (UILabel *)moneyLabel
{
    if(!_moneyLabel){
        UILabel *label = [UILabel createLabelWithText:@"支付金额：" font:kFontSize_26 textColor:kFontColorGray];
        [self.contentView addSubview:_moneyLabel = label];
    }
    return _moneyLabel;
}

///按钮1
- (UIButton *)button1
{
    if(!_button1){
        UIButton *button = [UIButton createButtonWithTitle:@"立即评价" backgroundNormalImage:@"public_botton_small_order_white" backgroundPressImage:@"public_botton_small_order_white_press" target:self action:@selector(onButtonAction:)];
        [button setTitleColor:kFontColorRed forState:UIControlStateNormal];
        button.tag = 1;
        [self.contentView addSubview:_button1 = button];
    }
    return _button1;
}

///按钮2
- (UIButton *)button2
{
    if(!_button2){
        UIButton *button = [UIButton createButtonWithTitle:@"再次消费" backgroundNormalImage:@"public_botton_small_order_red" backgroundPressImage:@"public_botton_small_order_red_press" target:self action:@selector(onButtonAction:)];
        [button setTitleColor:kFontColorWhite forState:UIControlStateNormal];
        ///button.backgroundColor = kFontColorRed;
        button.tag = 2;
        [self.contentView addSubview:_button2 = button];
    }
    return _button2;
}

///线
- (UIImageView *)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self.contentView addSubview:image];
    
    return image;
}

///消费时间
- (UILabel *)createDateLabel
{
    if(!_createDateLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorGray];
        [self.contentView addSubview:_createDateLabel = label];
    }
    return _createDateLabel;
}
@end
