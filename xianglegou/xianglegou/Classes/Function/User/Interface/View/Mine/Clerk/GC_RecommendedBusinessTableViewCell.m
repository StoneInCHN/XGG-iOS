//
//  GC_RecommendedBusinessTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  推荐商家 -- cell
//

#import "GC_RecommendedBusinessTableViewCell.h"

@interface GC_RecommendedBusinessTableViewCell ()

///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///状态
@property (nonatomic, weak) UILabel *statusLabel;
///注册时间
@property (nonatomic, weak) UILabel *registeredTimeLabel;

///手机号
@property (nonatomic, weak) UILabel *mobileLabel;


///累计收益
@property (nonatomic, weak) UILabel *totalIncomeLabel;
///乐分
@property (nonatomic, weak) UILabel *leScoreLabel;
@end


@implementation GC_RecommendedBusinessTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_RecommendedBusinessTableViewCell";
    GC_RecommendedBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_RecommendedBusinessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(145);
}


///初始化
-(void)initDefault
{
    [self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(32));
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(12));
        make.width.mas_equalTo(FITSCALE(84/2));
        make.height.mas_equalTo(FITSCALE(84/2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(11));
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(20));
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-150));
    }];
    
    
    [self.registeredTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(20));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.centerY.equalTo(self.registeredTimeLabel);
    }];
    
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(20));
        make.top.equalTo(self.registeredTimeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));

    }];
    
    
    [self.totalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(20));
        make.top.equalTo(self.registeredTimeLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
        //make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-14));
    }];
    
    [self.leScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalIncomeLabel.mas_right);
        make.centerY.equalTo(self.totalIncomeLabel);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
///审核状态
- (void)setNakedEyeIng
{
    self.mobileLabel.hidden = NO;
    self.statusLabel.hidden = NO;
    self.totalIncomeLabel.hidden = YES;
    self.leScoreLabel.hidden = YES;
    
}

///通过审核
- (void)setPassingNakedEye
{
    self.mobileLabel.hidden = YES;
    self.statusLabel.hidden = YES;
    self.totalIncomeLabel.hidden = NO;
    self.leScoreLabel.hidden = NO;
}



///更新 ui
-(void)setUpdateUiForRecommendSellerRecData:(GC_MResRecommendSellerDataModel*)data
{
    if(data){
        //Seller中不为空，显示seller中的商户
        if(data.seller.storePictureUrl.length > 0 && data.seller.name.length > 0){
            //图标
            [self.iconImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.seller.storePictureUrl] defaultImageName:@""];
            //名称
            self.titleLabel.text = data.seller.name;
        }else{
            //图标
            [self.iconImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.sellerApplication.storePhoto] defaultImageName:@""];
            //名称
            self.titleLabel.text = data.sellerApplication.sellerName;
        }
        
        
        if([data.sellerApplication.applyStatus isEqualToString:@"AUDIT_WAITING"]){          /** 待审核 */
            [self setNakedEyeIng];
            self.statusLabel.text = @"待审核";
            self.mobileLabel.text = [NSString stringWithFormat:@"联系人手机号：%@",data.sellerApplication.contactCellPhone];
        }else if([data.sellerApplication.applyStatus isEqualToString:@"AUDIT_PASSED"]){    /** 审核通过 */
            [self setPassingNakedEye];
            self.leScoreLabel.text = self.leScoreLabel.text = [DATAMODEL.henUtil string:data.totalRecommendLeScore showDotNumber:4];
            
        }else if([data.sellerApplication.applyStatus isEqualToString:@"AUDIT_FAILED"]){    /** 审核退回 */
            [self setNakedEyeIng];
            self.statusLabel.text = @"审核失败";
            self.mobileLabel.text = [NSString stringWithFormat:@"联系人手机号：%@",data.sellerApplication.contactCellPhone];
        }
        
        ///注册时间
        self.registeredTimeLabel.text = [NSString stringWithFormat:@"注册时间：%@",[DATAMODEL.henUtil dateTimeStampToString:data.createDate]];
    }
    
}


#pragma mark -- getter,setter
///图标
- (UIImageView *)iconImageView
{
    if(!_iconImageView){
        UIImageView *iconImage = [UIImageView createImageViewWithName:@""];
        [iconImage makeRadiusForWidth:FITSCALE(84/2)];
        [iconImage setBackgroundColor:kCommonBackgroudColor];
        [self.contentView addSubview:_iconImageView = iconImage];
    }
    return _iconImageView;
}
///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel createLabelWithText:@"大龙火锅" font:kFontSize_34 textColor:kFontColorBlack];
        [self.contentView addSubview:_titleLabel = titleLabel];
    }
    return _titleLabel;
}

///注册时间
- (UILabel *)registeredTimeLabel
{
    if(!_registeredTimeLabel){
        UILabel *label = [UILabel createLabelWithText:@"注册时间：20" font:kFontSize_24 textColor:kFontColorGray];
        [self addSubview:_registeredTimeLabel = label];
    }
    return _registeredTimeLabel;
}

///状态
- (UILabel *)statusLabel
{
    if(!_statusLabel){
        UILabel *label = [UILabel createLabelWithText:@"待审核" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_statusLabel = label];
    }
    return _statusLabel;
}


///手机
- (UILabel *)mobileLabel
{
    if(!_mobileLabel){
        UILabel *label = [UILabel createLabelWithText:@"联系人手机号：1954284444" font:kFontSize_28 textColor:kFontColorBlack];
        label.hidden = YES;
        [self.contentView addSubview:_mobileLabel = label];
    }
    return _mobileLabel;
}



///累计收益
- (UILabel *)totalIncomeLabel
{
    if(!_totalIncomeLabel){
        UILabel *totalIncomeLabel = [UILabel createLabelWithText:@"累计收益乐分：" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_totalIncomeLabel = totalIncomeLabel];
    }
    return _totalIncomeLabel;
}

///乐分
- (UILabel *)leScoreLabel
{
    if(!_leScoreLabel){
        UILabel *leScoreLabel = [UILabel createLabelWithText:@"0" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_leScoreLabel = leScoreLabel];
    }
    return _leScoreLabel;
}


@end
