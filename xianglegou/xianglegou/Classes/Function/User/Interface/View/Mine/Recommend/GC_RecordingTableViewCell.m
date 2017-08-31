//
//  GC_RecordingTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_RecordingTableViewCell.h"

@interface GC_RecordingTableViewCell ()
///图标
@property (nonatomic, weak) UIImageView *iconImageView;
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///推荐类型
@property (nonatomic, weak) UILabel *recommendTypeLabel;
///注册时间
@property (nonatomic, weak) UILabel *registeredTimeLabel;


///累计收益
@property (nonatomic, weak) UILabel *totalIncomeLabel;
///乐分
@property (nonatomic, weak) UILabel *leScoreLabel;

@end

@implementation GC_RecordingTableViewCell
///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_RecordingTableViewCell";
    GC_RecordingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_RecordingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    [self.recommendTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-35));
    }];
    
    
    
    [self.registeredTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(WIDTH_TRANSFORMATION(20));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
        make.right.equalTo(self).offset(OffSetToRight);
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

///更新 ui
-(void)setUpdateUiForRecommendRecData:(GC_MResRecommendRecDataModel*)data
{
    if(data){
        
        if(data.totalRecommendLeScore.length <= 0){
            data.totalRecommendLeScore = @"0";
        }
        
        self.leScoreLabel.text = [DATAMODEL.henUtil string:data.totalRecommendLeScore showDotNumber:4];
        [self.iconImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.endUser.userPhoto] defaultImageName:@"mine_head_bg_acquiescent"];
        
        
        self.titleLabel.text = data.endUser.nickName;
        
        if(data.endUser.sellerName.length <= 0 || [data.endUser.sellerName isEqualToString:@""]){
            self.recommendTypeLabel.text = @"会员";
        }else{
            self.recommendTypeLabel.text = @"商家";
        }
        
        self.registeredTimeLabel.text = [NSString stringWithFormat:@"注册时间：%@",[DATAMODEL.henUtil dateTimeStampToString:data.endUser.createDate]];
        
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

///推荐类型
- (UILabel *)recommendTypeLabel
{
    if(!_recommendTypeLabel){
        UILabel *label = [UILabel createLabelWithText:@"会员" font:kFontSize_24 textColor:kFontColorGray];
        [self.contentView addSubview:_recommendTypeLabel = label];
    }
    return _recommendTypeLabel;
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
        UILabel *leScoreLabel = [UILabel createLabelWithText:@"1920" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_leScoreLabel = leScoreLabel];
    }
    return _leScoreLabel;
}
@end
