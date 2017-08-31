//
//  QL_OrderManagerTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_OrderManagerTableViewCell.h"

#import "GC_ShopOrderCommentViewController.h"
#import "GC_PayMoneyViewController.h"



@interface QL_OrderManagerTableViewCell()

///名字
@property(nonatomic, weak) UILabel *nameLabel;
///时间
@property(nonatomic, weak) UILabel *timeLabel;
///消费时间
@property (nonatomic, weak) UILabel *createDateLabel;
///订单
@property(nonatomic, weak) UILabel *orderIdLabel;
///返回积分
@property(nonatomic, weak) UILabel *backScoreLabel;
///支付金额提示
@property (nonatomic, weak) UILabel *payMoneyPromptLabel;
///支付金额
@property(nonatomic, weak) UILabel *payMoneyLabel;

///评价按钮
@property(nonatomic, weak) UIButton *commentButton;
///联系电话按钮
@property(nonatomic, weak) UIButton *phoneButton;

///电话
@property(nonatomic, strong) NSString *phoneNumber;
///评价状态 1:待回复，2：已回复
@property(nonatomic, assign) NSInteger commentStatus;

///订单信息
@property (nonatomic, strong) QL_ShopOrderListDataModel *orderData;

///订单状态
@property (nonatomic, weak) UILabel *statusLabel;

///删除订单 button
@property (nonatomic, weak) UIButton *deleteOrderButton;
///立即支付
@property (nonatomic, weak) UIButton *payButton;


///订单ID
@property (nonatomic, strong) NSString *entityId;
@end

@implementation QL_OrderManagerTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_OrderManagerTableViewCell";
    QL_OrderManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_OrderManagerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(400);
}


///获取cell高度 根据 订单类型  订单状态
+(CGFloat)getCellHeightForIsSallerOrder:(NSString *)isSallerOrder andStatus:(NSString *)status
{
    if(![isSallerOrder isEqualToString:@"1"] && [status isEqualToString:@"UNPAID"]){
        return HEIGHT_TRANSFORMATION(295);
    }else{
        return HEIGHT_TRANSFORMATION(400);
    }
}


///初始化
- (void)initDefault
{
    self.topLongLineImage.hidden = NO;
    self.bottomLongLineImage.hidden = NO;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(20));
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-190));
    }];
    
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    UILabel *label1 = [self orderIdNoticeLabel];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(40));
    }];
    
    
    
    
    [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(label1.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
    }];
    
    
    
    
    
    UILabel *label2 = [self backScoreNoticeLabel];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self.createDateLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
    }];
    UILabel *label3 = [self payMoneyNoticeLabel];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(label2.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
    }];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-20));
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneButton);
        make.right.equalTo(self.phoneButton.mas_left).offset(WIDTH_TRANSFORMATION(-18));
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-20));
    }];
    
    [self.deleteOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneButton);
        make.right.equalTo(self.phoneButton.mas_left).offset(WIDTH_TRANSFORMATION(-18));
    }];
}

///更新ui
- (void)updateUIForData:(QL_ShopOrderListDataModel *)data
{
    if(data){
        self.timeLabel.hidden = YES;
        self.nameLabel.text = data.endUser.nickName.length <= 0 ? @" " : data.endUser.nickName;
        self.orderIdLabel.text = data.sn;
        
        
        self.backScoreLabel.text = data.sellerScore.length > 0 ? [DATAMODEL.henUtil string:data.sellerScore showDotNumber:4] : @"0.0000";
        self.phoneButton.hidden = NO;
        self.commentButton.hidden = NO;
        self.deleteOrderButton.hidden = YES;
        self.payButton.hidden = YES;
        if([data.status isEqualToString:@"UNPAID"]){        //未支付
            self.statusLabel.text = @"未支付";
            self.phoneButton.hidden = YES;
            self.commentButton.hidden = YES;
            self.backScoreLabel.text = @"0.0000";
            
            if([data.isSallerOrder isEqualToString:@"1"]){
                self.deleteOrderButton.hidden = NO;
                self.payButton.hidden = NO;
            }else{
                self.deleteOrderButton.hidden = YES;
                self.payButton.hidden = YES;
            }
        }else if([data.status isEqualToString:@"PAID"]){    //已支付
            self.statusLabel.text = @"已支付";
        }else if([data.status isEqualToString:@"FINISHED"]){//已完成
            self.statusLabel.text = @"已完成";
        }
        
        if(self.currentItem == 4 || self.currentItem == 0){
            if([data.isClearing isEqualToString:@"1"]){   //已结算
                self.statusLabel.text = @"已结算";
            }
        }
        
        if(self.isClearing.length > 0){
            if([data.isClearing isEqualToString:@"1"]){   //已结算
                self.statusLabel.text = @"已结算";
            }else if([data.isClearing isEqualToString:@"0"]){   //结算中
                self.statusLabel.text = @"结算中";
            }
        }
        
        
        
        if([data.isSallerOrder isEqualToString:@"1"]){
            self.payMoneyPromptLabel.text = @"让利金额：";
            
            NSString  *rebateAmount=data.rebateAmount.length > 0 ? [DATAMODEL.henUtil string:data.rebateAmount showDotNumber:2] : @"0.00";
            self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%@", rebateAmount];
        }else{
            self.payMoneyPromptLabel.text = @"支付金额：";
            NSString  *amount=data.amount.length > 0 ? [DATAMODEL.henUtil string:data.amount showDotNumber:2] : @"0.00";
            self.payMoneyLabel.text = [NSString stringWithFormat:@"￥%@", amount];
        }
        
        
        
        
        
        
        self.createDateLabel.text = [NSString stringWithFormat:@"消费时间：%@",[DATAMODEL.henUtil dateTimeStampToString:data.createDate]];
        
        
        if([data.status isEqualToString:@"FINISHED"]){
            if([data.evaluate.sellerReply isEqualToString:@""]){
                self.commentStatus = 1;
                [self.commentButton setTitle:@"立即回复"];
            }else{
                self.commentStatus = 2;
                [self.commentButton setTitle:@"查看回复"];
            }
        }else{
            self.commentButton.hidden = YES;
        }
        
        self.phoneNumber = data.endUser.cellPhoneNum;
        self.orderData = data;
        
        self.entityId = data.id;
    }
}

#pragma mark -- event response

- (void)onButtonAction:(UIButton *)sender
{
    if(sender.tag == 0){
        if(self.commentStatus == 1){//立即回复
            GC_ShopOrderCommentViewController *scVC = [[GC_ShopOrderCommentViewController alloc] init];
            scVC.hidesBottomBarWhenPushed = YES;
            scVC.orderData = self.orderData;
            scVC.replyState = @"1";
            
            [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:scVC animated:YES];

        }else if(self.commentStatus == 2){ // 查看回复
            GC_ShopOrderCommentViewController *scVC = [[GC_ShopOrderCommentViewController alloc] init];
            scVC.hidesBottomBarWhenPushed = YES;
            scVC.orderData = self.orderData;
            scVC.replyState = @"2";
            
            [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:scVC animated:YES];
        }
    }else if(sender.tag == 1){ // 打电话
        [DATAMODEL.henUtil customerPhone:self.phoneNumber];
    }
}


///删除订单
- (void)onDelOrderAction:(UIButton *)sender
{
    [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要删除此订单吗？"];
    WEAKSelf;
    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            [weakSelf delSellerUnpaidOrder];
        }
    }];
    
    
}


///删除订单
- (void)delSellerUnpaidOrder
{
    [self.viewModel.delSellerUnpaidOrderParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.delSellerUnpaidOrderParam setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.delSellerUnpaidOrderParam setObject:self.entityId forKey:@"entityId"];
    WEAKSelf;
    //显示加载
    [DATAMODEL.progressManager showPayHud:@""];
    [self.viewModel setDelSellerUnpaidOrderDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [DATAMODEL.progressManager hideHud];
        if([code isEqualToString:@"0000"]){
            if(weakSelf.onDelSuccess){
                weakSelf.onDelSuccess();
            }
        }else{
            [DATAMODEL.progressManager showHint:desc];
        }
    }];
    
}
///立即支付
- (void)onOrderPayAction:(UIButton *)sender
{
    GC_PayMoneyViewController *pmVC = [[GC_PayMoneyViewController alloc] init];
    pmVC.hidesBottomBarWhenPushed = YES;
    pmVC.sellerId = self.orderData.seller.id;
    pmVC.sn = self.orderData.sn;
    pmVC.goodsName = self.orderData.seller.name;
    pmVC.amount =  [DATAMODEL.henUtil string:self.orderData.rebateAmount showDotNumber:2];
    [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:pmVC animated:YES];
}

#pragma mark -- getter,setter

///名字
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_34 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///时间
- (UILabel *)timeLabel
{
    if(!_timeLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_24 textColor:kFontColorGray];
        label.hidden = YES;
        [self.contentView addSubview:_timeLabel = label];
    }
    return _timeLabel;
}

///消费时间
- (UILabel *)createDateLabel
{
    if(!_createDateLabel){
        UILabel *label = [UILabel createLabelWithText:@"消费时间：" font:kFontSize_28];
        [self.contentView addSubview:_createDateLabel = label];
    }
    return _createDateLabel;
}


///订单
- (UILabel *)orderIdNoticeLabel
{
    UILabel *noticeLabel = [UILabel createLabelWithText:@"订单编号：" font:kFontSize_28];
    [self.contentView addSubview:noticeLabel];
    
    UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
    [self.contentView addSubview:_orderIdLabel = label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(noticeLabel);
        make.left.equalTo(noticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(0));
    }];
    
    UIImageView *line = [UIImageView createImageViewWithName:@"public_line"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.right.equalTo(self);
        make.bottom.equalTo(noticeLabel.mas_top).offset(HEIGHT_TRANSFORMATION(-20));
    }];
    
    return noticeLabel;
}

///返回积分
- (UILabel *)backScoreNoticeLabel
{
    UILabel *noticeLabel = [UILabel createLabelWithText:@"赠送商家积分：" font:kFontSize_28];
    [self.contentView addSubview:noticeLabel];
    
    UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
    [self.contentView addSubview:_backScoreLabel = label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(noticeLabel);
        make.left.equalTo(noticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(4));
    }];
    
    return noticeLabel;
}

///支付金额
- (UILabel *)payMoneyNoticeLabel
{
    UILabel *noticeLabel = [UILabel createLabelWithText:@"支付金额：" font:kFontSize_28];
    [self.contentView addSubview:_payMoneyPromptLabel = noticeLabel];
    
    UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorRed];
    [self.contentView addSubview:_payMoneyLabel = label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(noticeLabel);
        make.left.equalTo(noticeLabel.mas_right).offset(WIDTH_TRANSFORMATION(4));
    }];
    
    UIImageView *line = [UIImageView createImageViewWithName:@"public_line"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.right.equalTo(self);
        make.top.equalTo(noticeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
    }];
    
    return noticeLabel;
}

///评价按钮
- (UIButton *)commentButton
{
    if(!_commentButton){
        UIButton *button = [UIButton createButtonWithTitle:@"立即回复" backgroundNormalImage:@"public_botton_small_order_white" backgroundPressImage:@"public_botton_small_order_white_press" target:self action:@selector(onButtonAction:)];
        button.tag = 0;
        [button setTitleClor:kFontColorRed];
        [self.contentView addSubview:_commentButton = button];
    }
    return _commentButton;
}


///订单状态
- (UILabel *)statusLabel
{
    if(!_statusLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_statusLabel = label];
    }
    return _statusLabel;
}

///联系电话按钮
- (UIButton *)phoneButton
{
    if(!_phoneButton){
        UIButton *button = [UIButton createButtonWithTitle:@"联系电话" backgroundNormalImage:@"public_botton_small_order_red" backgroundPressImage:@"public_botton_small_order_red_press" target:self action:@selector(onButtonAction:)];
        button.tag = 1;
        [button setTitleClor:kFontColorWhite];
        [self.contentView addSubview:_phoneButton = button];
    }
    return _phoneButton;
}

///删除订单
- (UIButton *)deleteOrderButton
{
    if(!_deleteOrderButton){
        UIButton *button = [UIButton createButtonWithTitle:@"删除订单" backgroundNormalImage:@"public_botton_small_order_white" backgroundPressImage:@"public_botton_small_order_white_press" target:self action:@selector(onDelOrderAction:)];
        [button setTitleClor:kFontColorRed];
        button.hidden = YES;
        [self.contentView addSubview:_deleteOrderButton = button];
    }
    return _deleteOrderButton;
}

///立即支付
- (UIButton *)payButton
{
    if(!_payButton){
        UIButton *button = [UIButton createButtonWithTitle:@"立即支付" backgroundNormalImage:@"public_botton_small_order_red" backgroundPressImage:@"public_botton_small_order_red_press" target:self action:@selector(onOrderPayAction:)];
        [button setTitleClor:kFontColorWhite];
        button.hidden = YES;
        [self.contentView addSubview:_payButton = button];
    }
    return _payButton;
}


- (void)setIsClearing:(NSString *)isClearing
{
    _isClearing = isClearing;
}
@end
