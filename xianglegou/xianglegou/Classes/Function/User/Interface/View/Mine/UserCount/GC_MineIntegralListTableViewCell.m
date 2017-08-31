//
//  GC_MineIntegralListTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  积分信息 -- cell
//


#import "GC_MineIntegralListTableViewCell.h"

@interface GC_MineIntegralListTableViewCell ()
///卖家 logo
@property (nonatomic, weak) UIImageView *sellerLogoImageView;
///商品名
@property (nonatomic, weak) UILabel *productNameLabel;
///创建时间
@property (nonatomic, weak) UILabel *creaDateLabel;
///回扣积分
@property (nonatomic, weak) UILabel *rebateScoreLabel;
///当前积分
@property (nonatomic, weak) UILabel *userCurScoreLabel;
///消费方式
@property (nonatomic, weak) UILabel *payMentWayLabel;
///审核状态
@property (nonatomic, weak) UILabel *reviewStateLabel;
@end

@implementation GC_MineIntegralListTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_MineIntegralListTableViewCell";
    GC_MineIntegralListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_MineIntegralListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(195);
}


+ (CGFloat)getCellHeightForContent:(NSString *)content
{
    CGFloat worldHeight = [[Hen_Util getInstance] calculationHeightForString:content anTextWidth:kMainScreenWidth - OffSetToLeft - OffSetToRight anFont:kFontSize_28];
   
    CGFloat cellHeight = HEIGHT_TRANSFORMATION(150) + worldHeight + HEIGHT_TRANSFORMATION(12);
    
    return cellHeight > HEIGHT_TRANSFORMATION(195) ? cellHeight : HEIGHT_TRANSFORMATION(195);
}

///初始化
-(void)initDefault
{
    //[self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.sellerLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(13));
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.width.mas_equalTo(FITSCALE(82/2));
        make.height.mas_equalTo(FITSCALE(82/2));
    }];
    
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sellerLogoImageView.mas_right).offset(WIDTH_TRANSFORMATION(8));
        make.centerY.equalTo(self.sellerLogoImageView);
        make.right.equalTo(self.contentView).offset(FITSCALE(-220/2));
    }];
    
    [self.reviewStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.sellerLogoImageView);
    }];
    
    [self.creaDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.top.equalTo(self.sellerLogoImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
    }];
    
    [self.rebateScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.creaDateLabel);
    }];
    
    [self.userCurScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.creaDateLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
    }];
    
    [self.payMentWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.creaDateLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-160));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-11));
    }];
    
   
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark -- private
///更新积分ui
-(void)updateUiForScoreRecData:(GC_MResScoreRecDataModel*)data
{
    if(data){
        
        
        if(data.rebateScore.length <= 0 || [data.rebateScore isEqualToString:@""]){
            data.rebateScore = @"0";
        }
        if(data.paymentType.length <= 0 || (data.seller.name <= 0 && data.seller.storePictureUrl.length <= 0)){
            [self.sellerLogoImageView setImageForName:@"App_87_Rebate_NoFillet"];
            self.productNameLabel.text = @"享个购";
            self.payMentWayLabel.text = @"积分转化乐心";
            
            if([data.rebateScore doubleValue] < 0){
                self.rebateScoreLabel.text = [NSString stringWithFormat:@"%@",[DATAMODEL.henUtil string:data.rebateScore showDotNumber:4]];
            }else{
                self.rebateScoreLabel.text = [NSString stringWithFormat:@"+%@",[DATAMODEL.henUtil string:data.rebateScore showDotNumber:4]];
            }
        }else{
            
            ///商品图片
            [self.sellerLogoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl, data.seller.storePictureUrl] defaultImageName:@"App_87_Rebate_NoFillet"];
            ///商品名称
            self.productNameLabel.text = data.seller.name;
            self.payMentWayLabel.text = [NSString stringWithFormat:@"%@赠送积分",data.paymentType];
            self.rebateScoreLabel.text = [NSString stringWithFormat:@"+%@",[DATAMODEL.henUtil string:data.rebateScore showDotNumber:4]];
        }
        
        
        ///消费时间
        self.creaDateLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
        
        if(data.userCurScore.length <= 0 || [data.userCurScore isEqualToString:@""]){
            data.userCurScore = @"0";
        }
        self.userCurScoreLabel.text = [DATAMODEL.henUtil string:data.userCurScore showDotNumber:4];
    }
}

///更新乐分ui
-(void)updateUiForLeScoreRecData:(GC_MResLeScoreRecDataModel*)data
{
    //图标 App_87_Rebate_NoFillet
    if(data){
        
        self.creaDateLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
        if(data.amount.length <= 0 || [data.amount isEqualToString:@""]){
            data.amount = @"0";
        }
        if(data.userCurLeScore.length <= 0 || [data.userCurLeScore isEqualToString:@"0"]){
            data.userCurLeScore = @"0";
        }
        
        if([data.amount doubleValue] < 0){
            self.rebateScoreLabel.text = [NSString stringWithFormat:@"%@",[DATAMODEL.henUtil string:data.amount showDotNumber:4]];
        }else{
            self.rebateScoreLabel.text = [NSString stringWithFormat:@"+%@",[DATAMODEL.henUtil string:data.amount showDotNumber:4]];
        }
         self.reviewStateLabel.hidden = YES;
        self.userCurScoreLabel.text = [DATAMODEL.henUtil string:data.userCurLeScore showDotNumber:4];
        if([data.leScoreType isEqualToString:@"CONSUME"]){       //乐分消费
            if(data.seller.name.length > 0){
                [self.sellerLogoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.seller.storePictureUrl] defaultImageName:@"App_87_Rebate_NoFillet"];
                self.productNameLabel.text = data.seller.name;
            }else{
                [self.sellerLogoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.recommenderPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
                self.productNameLabel.text = data.recommender;
            }
            self.payMentWayLabel.text= @"消费";
        }else if([data.leScoreType isEqualToString:@"BONUS"]){          //乐心（积分）产生的分红
            [self.sellerLogoImageView setImageForName:@"App_87_Rebate_NoFillet"];
            self.productNameLabel.text = @"享个购";
            self.payMentWayLabel.text = @"乐心分红赠送乐分";
        }else if([data.leScoreType isEqualToString:@"RECOMMEND_USER"]){ //推荐好友消费返利
            [self.sellerLogoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.recommenderPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
            self.productNameLabel.text = data.recommender;
            self.payMentWayLabel.text = @"好友消费赠送乐分";
            
        }else if([data.leScoreType isEqualToString:@"RECOMMEND_SELLER"]){   //推荐店铺收益返利
            [self.sellerLogoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl, data.recommenderPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
            self.productNameLabel.text = data.recommender;
            //self.payMentWayLabel.text = @"好友收益赠送乐分";
            self.payMentWayLabel.text = @"业务员发展商家收益赠送乐分";
        }else if([data.leScoreType isEqualToString:@"AGENT"]){               //代理商提成
            [self.sellerLogoImageView setImageForName:@"App_87_Rebate_NoFillet"];
            self.productNameLabel.text = @"享个购";
            self.payMentWayLabel.text = @"代理商提成赠送乐分";
        }else if([data.leScoreType isEqualToString:@"WITHDRAW"]){            //提现
            [self.sellerLogoImageView setImageForName:@"App_87_Rebate_NoFillet"];
            self.productNameLabel.text = @"享个购";
            
            if(data.remark.length > 0){
                self.payMentWayLabel.text = [NSString stringWithFormat:@"提现（%@）",data.remark];
            }else{
                self.payMentWayLabel.text = @"提现";
            }
            
            self.reviewStateLabel.hidden = NO;
            if([data.withdrawStatus isEqualToString:@"AUDIT_WAITING"]){
                self.reviewStateLabel.text = @"待审核";
            }else if([data.withdrawStatus isEqualToString:@"AUDIT_PASSED"]){
    
                if(data.status.length > 0){
                    if([data.status isEqualToString:@"PROCESSING"]){    //处理中
                        self.reviewStateLabel.text = @"处理中";
                    }else if([data.status isEqualToString:@"SUCCESS"]){ //处理成功
                        self.reviewStateLabel.text = @"处理成功";
                    }else if([data.status isEqualToString:@"FAILED"]){  //处理失败
                        self.reviewStateLabel.text = @"处理失败";
                    }
                }else{
                    self.reviewStateLabel.text = @"审核通过";
                }
            }else if([data.withdrawStatus isEqualToString:@"AUDIT_FAILED"]){
                self.reviewStateLabel.text = @"审核退回";
            }
        }else if([data.leScoreType isEqualToString:@"TRANSFER"]){///转账
            self.reviewStateLabel.hidden = YES;
            [self.sellerLogoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl, data.recommenderPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
            self.productNameLabel.text = data.recommender;
            if([data.amount doubleValue] < 0){
                self.payMentWayLabel.text = @"您向好友转账";
            }else{
                self.payMentWayLabel.text = @"好友向您转账";
            }
            
        }
    }
}
///更新乐豆ui
-(void)updateUiForLeBeanRecData:(GC_MResLeBeanRecDataModel*)data
{
    if(data){
        [self.sellerLogoImageView setImageForName:@"App_87_Rebate_NoFillet"];
        self.productNameLabel.text = @"享个购";
        self.creaDateLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
        
        if(data.amount.length <= 0 || [data.amount isEqualToString:@""]){
            data.amount = @"0";
        }
        
        if([data.amount doubleValue] < 0){
            self.rebateScoreLabel.text = [NSString stringWithFormat:@"%@",[DATAMODEL.henUtil string:data.amount showDotNumber:4]];
        }else{
            self.rebateScoreLabel.text = [NSString stringWithFormat:@"+%@",[DATAMODEL.henUtil string:data.amount showDotNumber:4]];
        }
        
        
        
        if(data.userCurLeBean.length <= 0 || [data.userCurLeBean isEqualToString:@""]){
            data.userCurLeBean = @"0";
        }
        self.userCurScoreLabel.text = [DATAMODEL.henUtil string:data.userCurLeBean showDotNumber:4];
        
        if([data.type isEqualToString:@"BONUS"]){   //乐心分红赠送乐豆
            self.payMentWayLabel.text = @"乐心分红赠送乐豆";
        }else if([data.type isEqualToString:@"RECOMMEND_USER"]){    //推荐好友消费送乐豆
            self.payMentWayLabel.text = @"好友消费赠送乐豆";
        }else if([data.type isEqualToString:@"RECOMMEND_SELLER"]){  //推荐店铺收益送乐豆
            self.payMentWayLabel.text = @"好友收益赠送乐豆";
        }else if([data.type isEqualToString:@"CONSUME"]){           //消费
            self.payMentWayLabel.text = @"消费";
            [self.sellerLogoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl, data.seller.storePictureUrl] defaultImageName:@"App_87_Rebate_NoFillet"];
            self.productNameLabel.text = data.seller.name;
        }else if([data.type isEqualToString:@"TRANSFER"]){ ///转账
            [self.sellerLogoImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl, data.recommenderPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
            self.productNameLabel.text = data.recommender;
          
            self.payMentWayLabel.text =data.remark;
            
        }else if([data.type isEqualToString:@"ENCOURAGE"]){ //消费赠送鼓励金
            self.payMentWayLabel.text = @"消费赠送鼓励金";
        }
    }
}


#pragma mark -- getter,setter
///卖家 logo
- (UIImageView *)sellerLogoImageView
{
    if(!_sellerLogoImageView){
        UIImageView *sellerLogoImage = [UIImageView createImageViewWithName:@"App_87_Rebate_NoFillet"];
        [self.contentView addSubview:_sellerLogoImageView = sellerLogoImage];
    }
    return _sellerLogoImageView;
}

///商品名
- (UILabel *)productNameLabel
{
    if(!_productNameLabel){
        UILabel *productName = [UILabel createLabelWithText:@"" font:kFontSize_34 textColor:kBussinessFontColorBlack];
        [self.contentView addSubview:_productNameLabel = productName];
    }
    return _productNameLabel;
}
///创建时间
- (UILabel *)creaDateLabel
{
    if(!_creaDateLabel){
        UILabel *creaDate = [UILabel createLabelWithText:@"2017-17-06 15:30" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_creaDateLabel = creaDate];
    }
    return _creaDateLabel;
}
///回扣积分
- (UILabel *)rebateScoreLabel
{
    if(!_rebateScoreLabel){
        UILabel *rebateScore = [UILabel createLabelWithText:@"+17" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_rebateScoreLabel = rebateScore];
    }
    return _rebateScoreLabel;
}
///当前积分
- (UILabel *)userCurScoreLabel
{
    if(!_userCurScoreLabel){
        UILabel *userCurScore = [UILabel createLabelWithText:@"10" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_userCurScoreLabel = userCurScore];
    }
    return _userCurScoreLabel;
}

///消费方式
- (UILabel *)payMentWayLabel
{
    if(!_payMentWayLabel){
        UILabel *payMentWay = [UILabel createLabelWithText:@"消费" font:kFontSize_28 textColor:kFontColorBlack];
        
        [payMentWay lableAutoLinefeed];
        [self.contentView addSubview:_payMentWayLabel = payMentWay];
    }
    return _payMentWayLabel;
}

- (UILabel *)reviewStateLabel
{
    if(!_reviewStateLabel){
        UILabel *label = [UILabel createLabelWithText:@"待支付" font:kFontSize_24 textColor:kFontColorBlack];
        label.hidden = YES;
        [self.contentView addSubview:_reviewStateLabel = label];
    }
    return _reviewStateLabel;
}
@end
