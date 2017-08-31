//
//  QL_MineAbonusView.m
//  Rebate
//
//  Created by mini2 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_MineAbonusView.h"
#import "GC_MineCountSegmentView.h"
#import "GC_MineIntegralViewController.h"
#import "GC_MineLeMindViewController.h"
#import "GC_MineLeBeansScoreViewController.h"

@interface QL_MineAbonusView()

///信息背景
@property(nonatomic, weak) UIImageView *infoBgImage;
///时间
@property(nonatomic, weak) UILabel *timeLabel;
///乐分  / 分红金额
@property(nonatomic, weak) UILabel *leScoreLabel;
@property (nonatomic, weak) UILabel *unit0Label;

///消费金额
@property(nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, weak) UILabel *unit1Label;


///最高乐分 / 最高分红金额
@property(nonatomic, weak) UILabel *maxLeScorelabel;
@property (nonatomic, weak) UILabel *unit2Label;

///选择
@property(nonatomic, weak) GC_MineCountSegmentView *segmentView;

@property(nonatomic, strong) GC_MResUserInfoDataModel *userInfoData;

///加载圈
@property(nonatomic, weak) UIActivityIndicatorView *indicatorView;

@end

@implementation QL_MineAbonusView

- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

#pragma mark -- private

///初始
- (void)initDefault
{
    self.backgroundColor = [UIColor clearColor];
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    [self.infoBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(FITHEIGHT(396/2));
        make.height.mas_equalTo(FITHEIGHT(446/2));
    }];
    [self segmentView];
}

///更新ui
- (void)updateUIForUserInfoData:(GC_MResUserInfoDataModel *)data
{
    if(data){
        [self.segmentView setItemCount:data.curScore.length > 0 ? [DATAMODEL.henUtil string:data.curScore showDotNumber:2] : @"0.00" index:0];
        [self.segmentView setItemCount:data.curLeMind.length > 0 ? [DATAMODEL.henUtil string:data.curLeMind showDotNumber:0] : @"0" index:1];
        [self.segmentView setItemCount:data.curLeBean.length > 0 ? [DATAMODEL.henUtil string:data.curLeBean showDotNumber:2] : @"0.00" index:2];
        [self.segmentView setItemCount:data.curLeScore.length > 0 ? [DATAMODEL.henUtil string:data.curLeScore showDotNumber:2] : @"0.00" index:3];
    }
    self.userInfoData = data;
}

///更新UI
- (void)updateUIForUserAbonusData:(QL_UserAbonusDataModel *)data
{
    if(data){
        self.timeLabel.text = data.reportDate.length > 0 ? [NSString stringWithFormat:@"%@统计", data.reportDate] : @"暂未统计";
        
        
        if(data.bonusLeScore.length > 0){
            self.leScoreLabel.text = data.bonusLeScore.length > 0 ? [DATAMODEL.henUtil string:data.bonusLeScore showDotNumber:2] : @"0.00";
            self.unit0Label.text = @"元";
        }else{
            self.leScoreLabel.text = @"";
            self.unit0Label.text = @"暂未统计";
        }
        
        
        if(data.consumeTotalAmount.length > 0){
            self.moneyLabel.text = data.consumeTotalAmount.length > 0 ? [DATAMODEL.henUtil string:data.consumeTotalAmount showDotNumber:2] : @"0.00";
            self.unit1Label.text = @"元";
        }else{
            self.moneyLabel.text = @"";
            self.unit1Label.text = @"暂未统计";
        }
        
        
        
        if(data.highBonusLeScore.length > 0){
            self.maxLeScorelabel.text = data.highBonusLeScore.length > 0 ? [DATAMODEL.henUtil string:data.highBonusLeScore showDotNumber:2] : @"0.00";
            self.unit2Label.text = @"元";
        }else{
            self.maxLeScorelabel.text = @"";
            self.unit2Label.text = @"暂未统计";
        }
        
        
    }
}

///显示加载
- (void)showLoading
{
    [self.indicatorView startAnimating];
}

///取消加载
- (void)cancelLoading
{
    [self.indicatorView stopAnimating];
}

#pragma mark -- getter,setter

///信息背景
- (UIImageView *)infoBgImage
{
    if(!_infoBgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"rebate_details_bg"];
        [self addSubview:_infoBgImage = image];
        
        //时间
        UILabel *timeLabel = [UILabel createLabelWithText:@" " font:kFontSize_28 textColor:kFontColorWhite];
        [image addSubview:_timeLabel = timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(image);
            make.top.equalTo(image).offset(FITHEIGHT(52/2));
        }];
        
        
        //分红金额提示
        UILabel *leScoreNoticeLabel = [UILabel createLabelWithText:@"分红金额：" font:kFontSize_28];
        [image addSubview:leScoreNoticeLabel];
        [leScoreNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(image).offset(FITHEIGHT(160/2));
        }];
        UILabel *unitLabel0 = [UILabel createLabelWithText:@"元" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_unit0Label = unitLabel0];
        [unitLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leScoreNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
        }];
        //分红金额
        UILabel *leScoreLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_leScoreLabel = leScoreLabel];
        [leScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leScoreNoticeLabel);
            make.right.equalTo(unitLabel0.mas_left);
        }];
        
        
        UIImageView *line1 = [UIImageView createImageViewWithName:@"public_line"];
        [image addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leScoreNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
            make.right.equalTo(unitLabel0).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
            make.top.equalTo(leScoreNoticeLabel.mas_bottom).offset(FITHEIGHT(14/2));
        }];
        
        
        //消费金额提示
        UILabel *moneyNoticeLabel = [UILabel createLabelWithText:@"总消费金额：" font:kFontSize_28];
        [image addSubview:moneyNoticeLabel];
        [moneyNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(leScoreNoticeLabel.mas_bottom).offset(FITHEIGHT(50/2));
        }];
        UILabel *unitLabel = [UILabel createLabelWithText:@"元" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_unit1Label = unitLabel];
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(moneyNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
        }];
        //消费金额
        UILabel *moneyLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_moneyLabel = moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(moneyNoticeLabel);
            make.right.equalTo(unitLabel.mas_left);
        }];
        
        
        
        UIImageView *line2 = [UIImageView createImageViewWithName:@"public_line"];
        [image addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
            make.right.equalTo(unitLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
            make.top.equalTo(moneyNoticeLabel.mas_bottom).offset(FITHEIGHT(14/2));
        }];
        //最高分红金额提示
        UILabel *maxLeScoreNoticeLabel = [UILabel createLabelWithText:@"最高分红金额：" font:kFontSize_28];
        [image addSubview:maxLeScoreNoticeLabel];
        [maxLeScoreNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(moneyNoticeLabel.mas_bottom).offset(FITHEIGHT(50/2));
        }];
        
        UILabel *unitLabel2 = [UILabel createLabelWithText:@"元" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_unit2Label = unitLabel2];
        [unitLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(maxLeScoreNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
        }];
        
        //最高分红金额
        UILabel *maxLeScoreLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_maxLeScorelabel = maxLeScoreLabel];
        [maxLeScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(maxLeScoreNoticeLabel);
            make.right.equalTo(unitLabel2.mas_left);
        }];
        
        
        //加载
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidesWhenStopped = YES;
        [image addSubview:_indicatorView = indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.left.equalTo(timeLabel.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
        }];
    }
    return _infoBgImage;
}

///选择
- (GC_MineCountSegmentView *)segmentView
{
    if(!_segmentView){
        GC_MineCountSegmentView *view = [[GC_MineCountSegmentView alloc] initWithHeight:FITHEIGHT(130/2)];
        view.frame = CGRectMake(0, kMainScreenHeight - 50 - HEIGHT_TRANSFORMATION(76) - FITHEIGHT(130/2), kMainScreenWidth, FITHEIGHT(130/2));
        view.lineMargin = 35;
        [view setTopLineImageViewHidden:YES];
        [view setBottomLineImageViewHidden:YES];
        [view setItems:@[@"积分", @"乐心", @"乐豆", @"乐分"] andLineImageName:@"rebate_line"];
        [view setBgColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"rebate_bg_yellow"]]];
        [view setItemCount:@"0" index:0];
        [view setItemCount:@"0" index:1];
        [view setItemCount:@"0" index:2];
        [view setItemCount:@"0" index:3];
        //回调
        view.onSelectedBlock = ^(NSInteger item){
            if(item == 0){ // 积分
                GC_MineIntegralViewController *integral = [[GC_MineIntegralViewController alloc] init];
                integral.hidesBottomBarWhenPushed = YES;
                integral.curScore = self.userInfoData.curScore;
                integral.totalScore = self.userInfoData.totalScore;
                
                [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:integral animated:YES];
            }else if(item == 1){ // 乐心
                GC_MineLeMindViewController *leMind = [[GC_MineLeMindViewController alloc] init];
                leMind.hidesBottomBarWhenPushed = YES;
//                leMind.curLeMind = self.userInfoData.curLeMind;
//                leMind.totalLeMind = self.userInfoData.totalLeMind;
                [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:leMind animated:YES];
            }else if(item == 2){ // 乐豆
                GC_MineLeBeansScoreViewController *leBeanScore = [[GC_MineLeBeansScoreViewController alloc] init];
                leBeanScore.hidesBottomBarWhenPushed = YES;
                
                leBeanScore.currentItem = 1;
//                leBeanScore.curLeBean = self.userInfoData.curLeBean;
//                leBeanScore.totalLeBean = self.userInfoData.totalLeBean;
//                
//                leBeanScore.curLeScore = self.userInfoData.curLeScore;
//                leBeanScore.totalLeScore = self.userInfoData.totalLeScore;
                
                [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:leBeanScore animated:YES];
            }else if(item == 3){ // 乐分
                GC_MineLeBeansScoreViewController *leBeanScore = [[GC_MineLeBeansScoreViewController alloc] init];
                leBeanScore.hidesBottomBarWhenPushed = YES;
                
                leBeanScore.currentItem = 0;
//                leBeanScore.curLeBean = self.userInfoData.curLeBean;
//                leBeanScore.totalLeBean = self.userInfoData.totalLeBean;
//                
//                leBeanScore.curLeScore = self.userInfoData.curLeScore;
//                leBeanScore.totalLeScore = self.userInfoData.totalLeScore;
                
                [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:leBeanScore animated:YES];
            }
        };
        [self addSubview:_segmentView = view];
    }
    return _segmentView;
}


@end
