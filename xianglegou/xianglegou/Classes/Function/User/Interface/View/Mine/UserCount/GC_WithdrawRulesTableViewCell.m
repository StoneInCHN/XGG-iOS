//
//  GC_WithdrawRulesTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  提现规则 -- cell
//


#import "GC_WithdrawRulesTableViewCell.h"

@interface GC_WithdrawRulesTableViewCell ()<UITextViewDelegate>

///提现实际到账
@property (nonatomic, weak) UILabel *actualPriceLabel;


///会员乐分
@property (nonatomic, weak) UILabel *userLeScoreLabel;

///代理商乐分
@property (nonatomic, weak) UILabel *agentsLeScoreLabel;
///业务员乐分
@property (nonatomic, weak) UILabel *clerkLeScoreLabel;

///提示
@property (nonatomic, weak) UILabel *promptLabel;

@property (nonatomic, weak) UILabel *ruleNoticeLabel;
///规则信息
@property (nonatomic, weak) UITextView *rulesInfoTextView;


///规则信息
@property (nonatomic, strong) NSString *rulesInfo;
@end

@implementation GC_WithdrawRulesTableViewCell


///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_WithdrawRulesTableViewCell";
    
    GC_WithdrawRulesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_WithdrawRulesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(520);
}

///获取cell高度
+(CGFloat)getCellHeightForLeScoreInfo:(NSString*)leScoreInfo andURulesInfo:(NSString*)uRuleInfo andBRulesInfo:(NSString*)bRuleInfo
{
    CGFloat worldHeight1 = [[Hen_Util getInstance] calculationHeightForString:leScoreInfo anTextWidth:kMainScreenWidth - WIDTH_TRANSFORMATION(60) anFont:kFontSize_28];
    CGFloat worldHeight2 = [[Hen_Util getInstance] calculationHeightForString:uRuleInfo anTextWidth:kMainScreenWidth - WIDTH_TRANSFORMATION(60) anRowHeight:HEIGHT_TRANSFORMATION(16) anFont:kFontSize_28];
    CGFloat worldHeight3 = [[Hen_Util getInstance] calculationHeightForString:bRuleInfo anTextWidth:kMainScreenWidth - WIDTH_TRANSFORMATION(60) anRowHeight:HEIGHT_TRANSFORMATION(16) anFont:kFontSize_28];
    CGFloat cellHeight = HEIGHT_TRANSFORMATION(45) + worldHeight1 + HEIGHT_TRANSFORMATION(56) + HEIGHT_TRANSFORMATION(46) + worldHeight2 + HEIGHT_TRANSFORMATION(65) + HEIGHT_TRANSFORMATION(46) + worldHeight3 + HEIGHT_TRANSFORMATION(45);
    return cellHeight > HEIGHT_TRANSFORMATION(440) ? cellHeight : HEIGHT_TRANSFORMATION(440);
}



///获取高度
+ (CGFloat)getCellHeightForLeScoreInfo:(NSString *)leScoreInfo andRuleInfo:(NSString*)ruleInfo
{
    CGFloat worldHeight1 = [[Hen_Util getInstance] calculationHeightForString:leScoreInfo anTextWidth:kMainScreenWidth - WIDTH_TRANSFORMATION(60) anFont:kFontSize_28];
    CGFloat worldHeight2 = [[Hen_Util getInstance] calculationHeightForString:ruleInfo anTextWidth:kMainScreenWidth - WIDTH_TRANSFORMATION(60) anFont:kFontSize_28];
    
    CGFloat cellHeight = HEIGHT_TRANSFORMATION(45) + worldHeight1 + HEIGHT_TRANSFORMATION(56) + worldHeight2 + HEIGHT_TRANSFORMATION(56);
    
    return cellHeight > HEIGHT_TRANSFORMATION(300) ? cellHeight : HEIGHT_TRANSFORMATION(300);
}
///初始化
-(void)initDefault
{
    self.backgroundColor = kCommonBackgroudColor;
    [self unShowClickEffect];
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.actualPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(20));
    }];
    
    [self.userLeScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.actualPriceLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(40));
    }];
    
    [self.agentsLeScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.userLeScoreLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
    }];
    
    [self.clerkLeScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.agentsLeScoreLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
        make.top.equalTo(self.clerkLeScoreLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
    }];
    
    
    [self.ruleNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(40));
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
    }];
    
    [self.rulesInfoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(15));
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-15));
        make.top.equalTo(self.ruleNoticeLabel.mas_bottom);
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

///更新 ui
-(void)setUpdateUiForWithdrawInfoData:(GC_MResWithdrawInfoDataModel*)data andPrice:(NSString *)price
{
    if(data){

        
        if(price.length <= 0){
            self.actualPriceLabel.text = @"提现实际到账：￥0.0000";
        }else{
            double actualPrice = [price doubleValue] - [data.transactionFee doubleValue];
            if(actualPrice > 0){
                self.actualPriceLabel.text = [NSString stringWithFormat:@"提现实际到账：￥%0.4f",actualPrice];
            }else{
                self.actualPriceLabel.text = @"提现实际到账：￥0.0000";
            }
            
        }
        
        
        self.userLeScoreLabel.text = [NSString stringWithFormat:@"会员乐分：%@；",data.motivateLeScore.length <= 0 ? @"0" : data.motivateLeScore];
        
        
        self.rulesInfo = data.motivateRule;
        
        //代理判断
        if(DATAMODEL.userInfoData.agent.agencyLevel.length <= 0 || [DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@""]){ //不是代理
            self.agentsLeScoreLabel.hidden = YES;
            
            [self.clerkLeScoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.agentsLeScoreLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(0));
            }];
        }else{
            
            self.agentsLeScoreLabel.hidden = NO;
            [self.clerkLeScoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.agentsLeScoreLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
            }];
            
            self.agentsLeScoreLabel.text = [NSString stringWithFormat:@"代理商乐分：%@；",data.agentLeScore.length <= 0 ? @"0.0000" : [DATAMODEL.henUtil string:data.agentLeScore showDotNumber:4]];
            
            
        }
        
        
        
        //业务员判断
        if([DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){
            self.clerkLeScoreLabel.hidden = NO;
            self.clerkLeScoreLabel.text = [NSString stringWithFormat:@"业务员乐分：%@；",data.incomeLeScore.length <= 0 ? @"0.0000" : [DATAMODEL.henUtil string:data.incomeLeScore showDotNumber:4]];
            
            
            [self.promptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.clerkLeScoreLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
            }];
            
//            self.rulesInfo = [NSString stringWithFormat:@"%@<p></p>%@",data.motivateRule, data.incomeRule];
        }else{
            self.clerkLeScoreLabel.hidden = YES;
            
            [self.promptLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.clerkLeScoreLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(0));
            }];
        }
        
       
        
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.rulesInfo dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        self.rulesInfoTextView.attributedText = attributedString;
        
    }
}


#pragma mark -- getter,setter

///提现实际到账
- (UILabel *)actualPriceLabel
{
    if(!_actualPriceLabel){
        UILabel *label = [UILabel createLabelWithText:@"提现实际到账：￥0.0000" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_actualPriceLabel = label];
    }
    return _actualPriceLabel;
}

///会员乐分
- (UILabel *)userLeScoreLabel
{
    if(!_userLeScoreLabel){
        UILabel *label = [UILabel createLabelWithText:@"会员乐分：0；" font:kFontSize_28];
        [self.contentView addSubview:_userLeScoreLabel = label];
    }
    return _userLeScoreLabel;
}

///商家乐分
- (UILabel *)clerkLeScoreLabel
{
    if(!_clerkLeScoreLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_clerkLeScoreLabel = label];    }
    return _clerkLeScoreLabel;
}
///代理商乐分
- (UILabel *)agentsLeScoreLabel
{
    if(!_agentsLeScoreLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_agentsLeScoreLabel = label];
    }
    return _agentsLeScoreLabel;
}

////提示
- (UILabel *)promptLabel
{
    if(!_promptLabel){
        UILabel *label = [UILabel createLabelWithText:@"提现预计到账时间为1-3个工作日。" font:kFontSize_28];
        [self.contentView addSubview:_promptLabel = label];
    }
    return _promptLabel;
}


- (UILabel *)ruleNoticeLabel
{
    if(!_ruleNoticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"提现规则：" font:kFontSize_28];
        [self.contentView addSubview:_ruleNoticeLabel = label];
    }
    return _ruleNoticeLabel;
}

///规则
- (UITextView *)rulesInfoTextView
{
    if(!_rulesInfoTextView){
        UITextView *textView = [UITextView createTextViewWithDelegateTarget:self];
        textView.backgroundColor = kCommonBackgroudColor;
        textView.editable = NO;
        textView.font = kFontSize_28;
        [self.contentView addSubview:_rulesInfoTextView = textView];
    }
    return _rulesInfoTextView;
}

@end
