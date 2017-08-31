//
//  QL_AllAbonusView.m
//  Rebate
//
//  Created by mini2 on 17/3/31.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_AllAbonusView.h"

@interface QL_AllAbonusView()

///全部信息背景
@property(nonatomic, weak) UIImageView *allInfoBgImage;
@property (nonatomic, weak) UIImageView *allNationalInfoBgImage;
///时间
@property(nonatomic, weak) UILabel *allTimeLabel;
///全国消费总额
@property(nonatomic, weak) UILabel *allMoneyLabel;
@property (nonatomic, weak) UILabel *amUnitLabel;

///全国消费人数
@property(nonatomic, weak) UILabel *allPepoleLabel;
@property (nonatomic, weak) UILabel *apUniNumLabel;

///全国联盟商家
@property(nonatomic, weak) UILabel *allBusinessLabel;
@property (nonatomic, weak) UILabel *abUnitLabel;

///分红总金额
@property(nonatomic, weak) UILabel *allHelpMoneyLabel;
@property (nonatomic, weak) UILabel *ahmUnitLabel;

///某天信息背景
@property(nonatomic, weak) UIImageView *dayInfoBgImage;
///时间
@property(nonatomic, weak) UILabel *dayTimeLabel;
///累计分红乐心
@property(nonatomic, weak) UILabel *dayLeHeartLabel;
///累计消费
@property(nonatomic, weak) UILabel *dayMoneyLabel;
@property (nonatomic, weak) UILabel *dmUnitLabel;


///分红乐分
@property(nonatomic, weak) UILabel *dayLeScoreLabel;
///公益金额
@property(nonatomic, weak) UILabel *dayHelpMoneyLabel;

///当日乐心价值
@property (nonatomic, weak) UILabel *dayHappyValueLabel;
@property (nonatomic, weak) UILabel *dhmUnitLabel;

///加载圈
@property(nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property(nonatomic, weak) UIActivityIndicatorView *indicatorView2;

@end

@implementation QL_AllAbonusView

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
    self.frame = CGRectMake(0, 0, kMainScreenWidth, FITHEIGHT(1058/2));
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    [self.allInfoBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(FITHEIGHT(245/2));
        make.height.mas_equalTo(FITHEIGHT(446/2));
    }];
    [self.dayInfoBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.allInfoBgImage.mas_bottom).offset(FITHEIGHT(34/2));
        make.height.mas_equalTo(FITHEIGHT(446/2));
    }];
}

///更新ui
- (void)updateUIForAllAbonusData:(QL_AllAbonusDataModel *)data
{
    if(data){
        //全国消费总金额
        if(data.consumeTotalAmount.length > 0){
            
            self.allMoneyLabel.text = data.consumeTotalAmount.length > 0 ? [DATAMODEL.henUtil string:data.consumeTotalAmount showDotNumber:2] : @"0.00";
            self.amUnitLabel.text = @"元";
        }else{
            self.allMoneyLabel.text = @"";
            self.amUnitLabel.text = @"暂未统计";
        }
        
        
        //全国消费人数
        if(data.consumePeopleNum.length > 0){
            self.apUniNumLabel.text = @"人";
            self.allPepoleLabel.text = data.consumePeopleNum;
            
        }else{
            self.allPepoleLabel.text = @"";
            self.apUniNumLabel.text = @"暂未统计";
        }

        ///联盟商家数
        if(data.sellerNum.length > 0){
            self.allBusinessLabel.text = data.sellerNum.length > 0 ? data.sellerNum : @"0";
            self.abUnitLabel.text = @"家";
        }else{
            self.abUnitLabel.text = @"暂未统计";
            self.allBusinessLabel.text = @"";
        }
        
        
        
        
        //分红金额
        if(data.totalBonus.length > 0){
            self.allHelpMoneyLabel.text = data.totalBonus.length > 0 ? [DATAMODEL.henUtil string:data.totalBonus showDotNumber:2] : @"0.00";
            self.ahmUnitLabel.text = @"元";
        }else{
            self.allHelpMoneyLabel.text = @"";
            self.ahmUnitLabel.text = @"暂未统计";
        }
        
        
        
        self.allTimeLabel.text = data.reportDate.length > 0 ? [NSString stringWithFormat:@"截止%@统计", data.reportDate] : @"暂未统计";
        
        
//        self.dayLeHeartLabel.text = data.leMindByDay.length > 0 ? [DATAMODEL.henUtil string:data.leMindByDay showDotNumber:0] : @"0";
        
        //累计消费
        if(data.consumeByDay.length > 0){
            self.dayMoneyLabel.text = data.consumeByDay.length > 0 ? [DATAMODEL.henUtil string:data.consumeByDay showDotNumber:2] : @"0.00";
            self.dmUnitLabel.text = @"元";
        }else{
            self.dayMoneyLabel.text = @"";
            self.dmUnitLabel.text = @"暂未统计";
        }
        
        
        
        
        
        
        
        //self.dayLeScoreLabel.text = data.bonusLeScoreByDay.length > 0 ? [DATAMODEL.henUtil string:data.bonusLeScoreByDay showDotNumber:2] : @"0.00";
        
        //当日乐心价值
        if(data.calValue.length > 0){
            self.dayHappyValueLabel.text = data.calValue.length > 0 ? [DATAMODEL.henUtil string:data.calValue showDotNumber:2] : @"0.00";
            self.dhmUnitLabel.text = @"元";
        }else{
            self.dayHappyValueLabel.text = @"";
            self.dhmUnitLabel.text = @"暂未统计";
        }
        
        
        
        
        
        
        //分红金额
//        self.dayHelpMoneyLabel.text = data.bonusLeScoreByDay.length > 0 ? [DATAMODEL.henUtil string:data.bonusLeScoreByDay showDotNumber:2] : @"0.00";
        

        
        self.dayTimeLabel.text = data.reportDate.length > 0 ? [NSString stringWithFormat:@"%@统计", data.reportDate] : @"暂未统计";
    }
}

///显示加载
- (void)showLoading
{
    [self.indicatorView startAnimating];
    [self.indicatorView2 startAnimating];
}

///取消加载
- (void)cancelLoading
{
    [self.indicatorView stopAnimating];
    [self.indicatorView2 stopAnimating];
}

#pragma mark -- getter,setter


///全部信息背景
- (UIImageView *)allNationalInfoBgImage
{
    if(!_allNationalInfoBgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"rebate_details_bg"];
        [self addSubview:_allNationalInfoBgImage = image];
        
        //时间
        UILabel *timeLabel = [UILabel createLabelWithText:@" " font:kFontSize_28 textColor:kFontColorWhite];
        [image addSubview:_allTimeLabel = timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(image);
            make.top.equalTo(image).offset(FITHEIGHT(52/2));
        }];
        //全国消费总额提示
        UILabel *allMoneyNoticeLabel = [UILabel createLabelWithText:@"全国消费总额：" font:kFontSize_28];
        [image addSubview:allMoneyNoticeLabel];
        [allMoneyNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(image).offset(FITHEIGHT(120/2));
        }];
        UILabel *amUnitLabel = [UILabel createLabelWithText:@"元" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_amUnitLabel = amUnitLabel];
        [amUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allMoneyNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
        }];
        //全国消费总额
        UILabel *allMoneyLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_allMoneyLabel = allMoneyLabel];
        [allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allMoneyNoticeLabel);
            make.right.equalTo(amUnitLabel.mas_left);
        }];
        
        
        
        UIImageView *line1 = [UIImageView createImageViewWithName:@"public_line"];
        [image addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allMoneyNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
            make.right.equalTo(amUnitLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
            make.top.equalTo(allMoneyNoticeLabel.mas_bottom).offset(FITHEIGHT(18/2));
        }];
        //全国消费人数提示
        UILabel *allPepoleNoticeLabel = [UILabel createLabelWithText:@"全国消费人数：" font:kFontSize_28];
        [image addSubview:allPepoleNoticeLabel];
        [allPepoleNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(image).offset(FITHEIGHT(200/2));
        }];
        UILabel *apUniNumLabel = [UILabel createLabelWithText:@"人" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_apUniNumLabel = apUniNumLabel];
        
        [apUniNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
            make.centerY.equalTo(allPepoleNoticeLabel);
        }];
        //消费人数
        UILabel *allPepoleLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_allPepoleLabel = allPepoleLabel];
        [allPepoleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allPepoleNoticeLabel);
            make.right.equalTo(apUniNumLabel.mas_left);
            
        }];
        
        
        UIImageView *line2 = [UIImageView createImageViewWithName:@"public_line"];
        [image addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allPepoleNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
            make.right.equalTo(apUniNumLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
            make.top.equalTo(allPepoleNoticeLabel.mas_bottom).offset(FITHEIGHT(18/2));
        }];
        //全国联盟商家提示
        UILabel *allBusinessNoticeLabel = [UILabel createLabelWithText:@"全国联盟商家：" font:kFontSize_28];
        [image addSubview:allBusinessNoticeLabel];
        [allBusinessNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(image).offset(FITHEIGHT(290/2));
        }];
        UILabel *abUnitLabel = [UILabel createLabelWithText:@"家" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_abUnitLabel = abUnitLabel];
        [abUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allBusinessNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
        }];
        //全国联盟商家
        UILabel *allBusinessLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_allBusinessLabel = allBusinessLabel];
        [allBusinessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allBusinessNoticeLabel);
            make.right.equalTo(abUnitLabel.mas_left);
        }];

        
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidesWhenStopped = YES;
        [image addSubview:_indicatorView = indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.left.equalTo(timeLabel.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
        }];
    }
    return _allNationalInfoBgImage;
}



///全部信息背景
- (UIImageView *)allInfoBgImage
{
    if(!_allInfoBgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"rebate_details_bg"];
        [self addSubview:_allInfoBgImage = image];
        
        //时间
        UILabel *timeLabel = [UILabel createLabelWithText:@" " font:kFontSize_28 textColor:kFontColorWhite];
        [image addSubview:_allTimeLabel = timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(image);
            make.top.equalTo(image).offset(FITHEIGHT(52/2));
        }];
        //全国消费总额提示
        UILabel *allMoneyNoticeLabel = [UILabel createLabelWithText:@"全国消费总额：" font:kFontSize_28];
        [image addSubview:allMoneyNoticeLabel];
        [allMoneyNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(image).offset(FITHEIGHT(160/2));
        }];
        UILabel *amUnitLabel = [UILabel createLabelWithText:@"元" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_amUnitLabel = amUnitLabel];
        [amUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allMoneyNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
        }];
        //全国消费总额
        UILabel *allMoneyLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_allMoneyLabel = allMoneyLabel];
        [allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allMoneyNoticeLabel);
            make.right.equalTo(amUnitLabel.mas_left);
        }];
        
        
        
        
        
        UIImageView *line1 = [UIImageView createImageViewWithName:@"public_line"];
        [image addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allMoneyNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
            make.right.equalTo(amUnitLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
            make.top.equalTo(allMoneyNoticeLabel.mas_bottom).offset(FITHEIGHT(14/2));
        }];
        //全国消费人数提示
        UILabel *allPepoleNoticeLabel = [UILabel createLabelWithText:@"全国消费人数：" font:kFontSize_28];
        [image addSubview:allPepoleNoticeLabel];
        [allPepoleNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(allMoneyNoticeLabel.mas_bottom).offset(FITHEIGHT(50/2));
        }];
        UILabel *apUniNumLabel = [UILabel createLabelWithText:@"人" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_apUniNumLabel = apUniNumLabel];
        [apUniNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
            make.centerY.equalTo(allPepoleNoticeLabel);
        }];
        //消费人数
        UILabel *allPepoleLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_allPepoleLabel = allPepoleLabel];
        [allPepoleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allPepoleNoticeLabel);
            make.right.equalTo(apUniNumLabel.mas_left);
            make.right.equalTo(apUniNumLabel.mas_left).priorityLow(1001);
        }];
        
        
        
        UIImageView *line2 = [UIImageView createImageViewWithName:@"public_line"];
        [image addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allPepoleNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
            make.right.equalTo(apUniNumLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
            make.top.equalTo(allPepoleNoticeLabel.mas_bottom).offset(FITHEIGHT(14/2));
        }];
        //全国联盟商家提示
        UILabel *allBusinessNoticeLabel = [UILabel createLabelWithText:@"全国联盟商家：" font:kFontSize_28];
        [image addSubview:allBusinessNoticeLabel];
        [allBusinessNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(allPepoleNoticeLabel.mas_bottom).offset(FITHEIGHT(50/2));
//            make.top.equalTo(image).offset(FITHEIGHT(290/2));
        }];
        UILabel *abUnitLabel = [UILabel createLabelWithText:@"家" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_abUnitLabel = abUnitLabel];
        [abUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allBusinessNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
        }];
        //全国联盟商家
        UILabel *allBusinessLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_allBusinessLabel = allBusinessLabel];
        [allBusinessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(allBusinessNoticeLabel);
            make.right.equalTo(abUnitLabel.mas_left);
        }];
        
        
        
        
//        UIImageView *line3 = [UIImageView createImageViewWithName:@"public_line"];
//        [image addSubview:line3];
//        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(allBusinessNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
//            make.right.equalTo(abUnitLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
//            make.top.equalTo(allBusinessNoticeLabel.mas_bottom).offset(FITHEIGHT(18/2));
//        }];
//        //分红总金额提示
//        UILabel *allHelpMoneyNoticeLabel = [UILabel createLabelWithText:@"分红金额：" font:kFontSize_28];
//        [image addSubview:allHelpMoneyNoticeLabel];
//        [allHelpMoneyNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
//            make.top.equalTo(image).offset(FITHEIGHT(370/2));
//        }];
//        UILabel *ahmUnitLabel = [UILabel createLabelWithText:@"元" font:kFontSize_28 textColor:kFontColorRed];
//        [image addSubview:_ahmUnitLabel = ahmUnitLabel];
//        [ahmUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(allHelpMoneyNoticeLabel);
//            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
//        }];
//        //分红总金额
//        UILabel *allHelpMoneyLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
//        [image addSubview:_allHelpMoneyLabel = allHelpMoneyLabel];
//        [allHelpMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(allHelpMoneyNoticeLabel);
//            make.right.equalTo(ahmUnitLabel.mas_left);
//        }];
        
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidesWhenStopped = YES;
        [image addSubview:_indicatorView = indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.left.equalTo(timeLabel.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
        }];
        
    }
    return _allInfoBgImage;
}

///某天信息背景
- (UIImageView *)dayInfoBgImage
{
    if(!_dayInfoBgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"rebate_details_bg"];
        [self addSubview:_dayInfoBgImage = image];
        
        //时间
        UILabel *timeLabel = [UILabel createLabelWithText:@" " font:kFontSize_28 textColor:kFontColorWhite];
        [image addSubview:_dayTimeLabel = timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(image);
            make.top.equalTo(image).offset(FITHEIGHT(52/2));
        }];
        
        
        
        
//        //累计分红乐心提示
//        UILabel *dayLeHeartNoticeLabel = [UILabel createLabelWithText:@"累计分红乐心：" font:kFontSize_28];
//        [image addSubview:dayLeHeartNoticeLabel];
//        [dayLeHeartNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
//            make.top.equalTo(image).offset(FITHEIGHT(160/2));
//        }];
//        //累计分红乐心
//        UILabel *dayLeHeartLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
//        [image addSubview:_dayLeHeartLabel = dayLeHeartLabel];
//        [dayLeHeartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(dayLeHeartNoticeLabel);
//            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-72));
//        }];
//        UIImageView *line1 = [UIImageView createImageViewWithName:@"public_line"];
//        [image addSubview:line1];
//        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(dayLeHeartNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
//            make.right.equalTo(dayLeHeartLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
//            make.top.equalTo(dayLeHeartNoticeLabel.mas_bottom).offset(FITHEIGHT(14/2));
//        }];
        
        
        //累计消费提示
        UILabel *dayMoneyNoticeLabel = [UILabel createLabelWithText:@"累计消费：" font:kFontSize_28];
        [image addSubview:dayMoneyNoticeLabel];
        [dayMoneyNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(image).offset(FITHEIGHT(180/2));
        }];
        UILabel *dmUnitLabel = [UILabel createLabelWithText:@"元" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_dmUnitLabel = dmUnitLabel];
        [dmUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dayMoneyNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
        }];
        
        //累计消费
        UILabel *dayMoneyLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_dayMoneyLabel = dayMoneyLabel];
        [dayMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dayMoneyNoticeLabel);
            make.right.equalTo(dmUnitLabel.mas_left);
        }];
        
        
    
        UIImageView *line2 = [UIImageView createImageViewWithName:@"public_line"];
        [image addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dayMoneyNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
            make.right.equalTo(dmUnitLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
            make.top.equalTo(dayMoneyNoticeLabel.mas_bottom).offset(FITHEIGHT(14/2));
        }];
        
        
//        //分红乐分提示
//        UILabel *dayLeScoreNoticeLabel = [UILabel createLabelWithText:@"分红乐豆：" font:kFontSize_28];
//        [image addSubview:dayLeScoreNoticeLabel];
//        [dayLeScoreNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
//            make.top.equalTo(image).offset(FITHEIGHT(290/2));
//        }];
//        
//        
//        //分红乐分
//        UILabel *dayLeScoreLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
//        [image addSubview:_dayLeScoreLabel = dayLeScoreLabel];
//        [dayLeScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(dayLeScoreNoticeLabel);
//            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-72));
//        }];
        
        
        
        
        
//        UIImageView *line3 = [UIImageView createImageViewWithName:@"public_line"];
//        [image addSubview:line3];
//        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(dayLeScoreNoticeLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
//            make.right.equalTo(dayLeScoreLabel).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
//            make.top.equalTo(dayLeScoreNoticeLabel.mas_bottom).offset(FITHEIGHT(18/2));
//        }];
        
        
        
        
        
        
        //当日乐心价值提示
        UILabel *dayHelpMoneyNoticeLabel = [UILabel createLabelWithText:@"当日乐心价值：" font:kFontSize_28];
        [image addSubview:dayHelpMoneyNoticeLabel];
        [dayHelpMoneyNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(72));
            make.top.equalTo(dayMoneyNoticeLabel.mas_bottom).offset(FITHEIGHT(50/2));
        }];
        UILabel *dhmUnitLabel = [UILabel createLabelWithText:@"元" font:kFontSize_28 textColor:kFontColorRed];
        [image addSubview:_dhmUnitLabel = dhmUnitLabel];
        [dhmUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dayHelpMoneyNoticeLabel);
            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-68));
            //            make.left.equalTo(allHelpMoneyLabel.mas_right);
        }];
        //当日乐心价值
        UILabel *allHelpMoneyLabel = [UILabel createLabelWithText:@"0" font:kFontSize_38 textColor:kFontColorRed];
        [image addSubview:_dayHappyValueLabel = allHelpMoneyLabel];
        [allHelpMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(dayHelpMoneyNoticeLabel);
            make.right.equalTo(dhmUnitLabel.mas_left);
//            make.right.equalTo(image).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-98));
        }];
        
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidesWhenStopped = YES;
        [image addSubview:_indicatorView2 = indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.left.equalTo(timeLabel.mas_right).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
        }];
    }
    return _dayInfoBgImage;
}

@end
