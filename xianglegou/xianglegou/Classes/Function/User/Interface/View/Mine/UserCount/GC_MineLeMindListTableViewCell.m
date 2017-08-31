//
//  GC_MineLeMindListTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  乐心列表 -- cell
//


#import "GC_MineLeMindListTableViewCell.h"

@interface GC_MineLeMindListTableViewCell ()
///创建时间
@property (nonatomic, weak) UILabel *creaDateLabel;
///加乐心
@property (nonatomic, weak) UILabel *plusLeMindLabel;
///积分
@property (nonatomic, weak) UILabel *scoreLabel;
///当前乐心
@property (nonatomic, weak) UILabel *userCurLeMindLabel;
@end

@implementation GC_MineLeMindListTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_MineLeMindListTableViewCell";
    GC_MineLeMindListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_MineLeMindListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(120);
}


///初始化
-(void)initDefault
{
    
    ///[self unShowClickEffect];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.creaDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(25));
        make.left.equalTo(self).offset(OffSetToLeft);
    }];
    
    [self.plusLeMindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
        make.centerY.equalTo(self.creaDateLabel);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self.creaDateLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(12));
    }];
    
    [self.userCurLeMindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(OffSetToRight);
        make.centerY.equalTo(self.scoreLabel);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -- getter,setter
///更新ui
-(void)updateUiForLeMindRecData:(GC_MResLeMindRecDataModel*)data
{
    if(data){
        //创建时间
        self.creaDateLabel.text = [DATAMODEL.henUtil dateTimeStampToString:data.createDate];
        //增加心量
        if(data.amount.length <= 0 || [data.amount isEqualToString:@""]){
            data.amount = @"0";
        }
        if([data.amount doubleValue] < 0){
            self.plusLeMindLabel.text = [NSString stringWithFormat:@"%@",[DATAMODEL.henUtil string:data.amount showDotNumber:0]];
        }else{
            self.plusLeMindLabel.text = [NSString stringWithFormat:@"+%@",[DATAMODEL.henUtil string:data.amount showDotNumber:0]];
        }
        
        //积分
//        if((data.score.length <= 0 || [data.score isEqualToString:@""]) && [data.amount integerValue] < 0){
//            self.scoreLabel.text = @"分红满限额扣除乐心";
//        }else{
//            self.scoreLabel.text = @"积分转化乐心";
//            ////self.scoreLabel.text = [NSString stringWithFormat:@"积分：%@",[DATAMODEL.henUtil string:data.score showDotNumber:4]];
//        }
        
        self.scoreLabel.text=data.remark;

        //当前乐心
        if(data.userCurLeMind.length <= 0 || [data.userCurLeMind isEqualToString:@""]){
            data.userCurLeMind = @"0";
        }
        
        self.userCurLeMindLabel.text = [DATAMODEL.henUtil string:data.userCurLeMind showDotNumber:4];
    }
}


#pragma mark -- getter,setter
///创建时间
- (UILabel *)creaDateLabel
{
    if(!_creaDateLabel){
        UILabel *creadate = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_creaDateLabel = creadate];
    }
    return _creaDateLabel;
}

///加乐心数
- (UILabel *)plusLeMindLabel
{
    if(!_plusLeMindLabel){
        UILabel *plusLeMind = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_plusLeMindLabel = plusLeMind];
    }
    return _plusLeMindLabel;
}

///积分
- (UILabel *)scoreLabel
{
    if(!_scoreLabel){
        UILabel *scoreLabel = [UILabel createLabelWithText:@"积分：00" font:kFontSize_28 textColor:kFontColorBlack];
        [self.contentView addSubview:_scoreLabel = scoreLabel];
    }
    return _scoreLabel;
}

///当前乐心数
- (UILabel *)userCurLeMindLabel
{
    if(!_userCurLeMindLabel){
        UILabel *curLeMind = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorRed];
        [self.contentView addSubview:_userCurLeMindLabel = curLeMind];
    }
    return _userCurLeMindLabel;
}
@end
