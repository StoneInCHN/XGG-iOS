//
//  GC_MineInformationView.m
//  Rebate
//
//  Created by mini3 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  我的基本信息 view
//

#import "GC_MineInformationView.h"
#import "GC_LoginViewController.h"
#import "GC_MineEditInfoViewController.h"
#import "GC_MineIntegralViewController.h"
#import "GC_MineLeMindViewController.h"
#import "GC_MineLeBeansScoreViewController.h"

@interface GC_MineInformationView ()
///背景图
@property (nonatomic, weak) UIImageView *backgroundImageView;
///头像
@property (nonatomic, weak) UIImageView *headerImageView;
///点击登录
@property (nonatomic, weak) UILabel *clickLoginLabel;
///商家标志
@property (nonatomic, weak) UIImageView *businessSignImageView;
///昵称
@property (nonatomic, weak) UILabel *nameLabel;
///代理商标志
@property (nonatomic, weak) UIImageView *agentSignImageView;
///代理商
@property (nonatomic, weak) UILabel *agentLabel;
///推荐人
@property (nonatomic, weak) UILabel *recommenderLabel;
///手机号
@property (nonatomic, weak) UILabel *mobileLabel;
///修改资料
@property (nonatomic, weak) UIButton *editdataButton;
///一线天
@property (nonatomic, weak) UIImageView *lineViewImageView;

///积分 按钮
@property (nonatomic, weak) UIButton *integralButton;
///积分 数值
@property (nonatomic, weak) UILabel *integralLabel;

///乐心 按钮
@property (nonatomic, weak) UIButton *heartButton;
///乐心 数值
@property (nonatomic, weak) UILabel *heartLabel;

///乐豆 按钮
@property (nonatomic, weak) UIButton *beansButton;
///乐豆 数值
@property (nonatomic, weak) UILabel *beansLabel;

///乐分 按钮
@property (nonatomic, weak) UIButton *minuteButton;
///乐分 数值
@property (nonatomic, weak) UILabel *minuteLabel;

///用户信息 View
@property (nonatomic, weak) UIView *userInfoView;


///当前积分
@property (nonatomic, strong) NSString *curScore;
///总积分
@property (nonatomic, strong) NSString *totalScore;

///当前乐心
@property (nonatomic, strong) NSString *curLeMind;
///总乐心
@property (nonatomic, strong) NSString *totalLeMind;

///当前乐豆
@property (nonatomic, strong) NSString *curLeBean;
///总乐豆
@property (nonatomic, strong) NSString *totalLeBean;

///当前乐分
@property (nonatomic, strong) NSString *curLeScore;
///总乐分
@property (nonatomic, strong) NSString *totalLeScore;
@end

@implementation GC_MineInformationView

- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

- (void)dealloc
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -- private
///初始化
-(void)initDefault
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(479));
    
    [self loadSubViewAndConstraints];
    
}

///加载子视图及其约束
-(void)loadSubViewAndConstraints
{
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(479));
    }];
    
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(100));
        make.left.equalTo(self).offset(FITWITH(44/2));
        make.width.mas_equalTo(FITSCALE(160/2));
        make.height.mas_equalTo(FITSCALE(160/2));
    }];
    
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.left.equalTo(self.headerImageView.mas_right);
        make.centerY.equalTo(self.headerImageView);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(220));
    }];
    
    
    [self.clickLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImageView);
        make.left.equalTo(self.headerImageView.mas_right).offset(FITWITH(44/2));
    }];

    [self.businessSignImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        ///make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(84));
        make.top.equalTo(self.userInfoView);
        //make.left.equalTo(self.headerImageView.mas_right).offset(WIDTH_TRANSFORMATION(24));
        make.left.equalTo(self.userInfoView).offset(WIDTH_TRANSFORMATION(24));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(85));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(33));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.businessSignImageView.mas_right).offset(WIDTH_TRANSFORMATION(12));
        make.centerY.equalTo(self.businessSignImageView);
         make.right.equalTo(self).offset(OffSetToRight);
    }];


    [self.agentSignImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.businessSignImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
        //make.left.equalTo(self.headerImageView.mas_right).offset(WIDTH_TRANSFORMATION(24));
        make.left.equalTo(self.userInfoView).offset(WIDTH_TRANSFORMATION(24));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(64));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(152));
    }];

    [self.recommenderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agentSignImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(14));
        //make.left.equalTo(self.headerImageView.mas_right).offset(WIDTH_TRANSFORMATION(24));
        make.left.equalTo(self.userInfoView).offset(WIDTH_TRANSFORMATION(24));
        make.right.equalTo(self).offset(OffSetToRight);
    }];

    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommenderLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
        ///make.left.equalTo(self.headerImageView.mas_right).offset(WIDTH_TRANSFORMATION(24));
        make.left.equalTo(self.userInfoView).offset(WIDTH_TRANSFORMATION(24));
       
    }];

    [self.editdataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-56));
        ///make.centerY.equalTo(self.mobileLabel);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(250));
    }];
    
    [self.lineViewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(350));
        make.width.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    [self.integralButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineViewImageView.mas_bottom);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(128));
        make.width.mas_equalTo(kMainScreenWidth / 4 - 1);
    }];

    
    [self.heartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineViewImageView.mas_bottom);
        make.left.equalTo(self.integralButton.mas_right);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(128));
        make.width.mas_equalTo(kMainScreenWidth / 4);
    }];

    [self.beansButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineViewImageView.mas_bottom);
        make.left.equalTo(self.heartButton.mas_right);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(128));
        make.width.mas_equalTo(kMainScreenWidth / 4);
    }];
    
    [self.minuteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineViewImageView.mas_bottom);
        make.left.equalTo(self.beansButton.mas_right);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(128));
        make.width.mas_equalTo(kMainScreenWidth / 4 - 1);
    }];
}

///更新 ui
-(void)updataUiForUserInfoData:(GC_MResUserInfoDataModel*)data
{
    
    if(DATAMODEL.isLogin){
        if(data){
            [self setIsLoginDisplay:YES];
            
            //头像
            if(data.userPhoto.length <= 0){
                [self.headerImageView setImageForName:@"mine_moren"];
            }else{
                [self.headerImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.userPhoto] defaultImageName:@"mine_moren"];
            }
            
            
            //昵称
            self.nameLabel.text = data.nickName;
            
            //商家信息
            if([data.sellerStatus isEqualToString:@"YES"]){ //是商家
                [self setBusinessmenIsNO:YES];
            }else{  //不是商家
                [self setBusinessmenIsNO:NO];
            }
            //代理信息
            if(data.agent.agencyLevel.length <= 0 || [data.agent.agencyLevel isEqualToString:@""]){ //不是代理
                [self setAgentIsNo:NO];
            }else{
                [self setAgentIsNo:YES];
                
                if([data.agent.agencyLevel isEqualToString:@"PROVINCE"]){       //省代理
                    [self.agentSignImageView setImageForName:@"mine_agent4"];
                    self.agentLabel.text = @"省代理";
                }else if([data.agent.agencyLevel isEqualToString:@"CITY"]){     //市代理
                    [self.agentSignImageView setImageForName:@"mine_agent3"];
                    self.agentLabel.text = @"市代理";
                }else if([data.agent.agencyLevel isEqualToString:@"COUNTY"]){   //县代理
                    [self.agentSignImageView setImageForName:@"mine_agent2"];
                    self.agentLabel.text = @"县代理";
                }else if([data.agent.agencyLevel isEqualToString:@"TOWN"]){
                    [self.agentSignImageView setImageForName:@"mine_agent1"];   //镇代理
                    self.agentLabel.text = @"乡代理";
                }
                
            }
            
            
            //推荐人信息
            if(data.recommender.length <= 0 || [data.recommender isEqualToString:@""]){
                [self setRecommenderIsNo:NO andAgent:data.agent.agencyLevel];
            }else{
                [self setRecommenderIsNo:YES andAgent:data.agent.agencyLevel];
                self.recommenderLabel.text = [NSString stringWithFormat:@"推荐人：%@",data.recommender];
            }
            
            //手机号
            self.mobileLabel.text = data.cellPhoneNum;
            
            
            ///积分
            if(data.curScore.length <= 0 || [data.curScore isEqualToString:@""]){
                data.curScore = @"0";
            }
            
            
            self.integralLabel.text = [DATAMODEL.henUtil string:data.curScore showDotNumber:2];
            
            ///乐心
            if(data.curLeMind.length <= 0 || [data.curLeMind isEqualToString:@""]){
                data.curLeMind = @"0";
            }
            
            self.heartLabel.text = [DATAMODEL.henUtil string:data.curLeMind showDotNumber:0];
            //乐豆
            
            if(data.curLeBean.length <= 0 || [data.curLeBean isEqualToString:@""]){
                data.curLeBean = @"0";
            }
            self.beansLabel.text = [DATAMODEL.henUtil string:data.curLeBean showDotNumber:2];
            //乐分
            if(data.curLeScore.length <= 0 || [data.curLeScore isEqualToString:@""]){
                data.curLeScore = @"0";
            }
            self.minuteLabel.text = [DATAMODEL.henUtil string:data.curLeScore showDotNumber:2];
            
            
            self.curScore = data.curScore;
            if(data.totalScore.length <= 0 || [data.totalScore isEqualToString:@""]){
                data.totalScore = @"0";
            }
            self.totalScore = data.totalScore;
            
            
            self.curLeScore = data.curLeScore;
            if(data.totalLeScore.length <= 0 || [data.totalLeScore isEqualToString:@""]){
                data.totalLeScore = @"0";
            }
            self.totalLeScore = data.totalLeScore;
            
            
            self.curLeMind = data.curLeMind;
            if(data.totalLeMind.length <= 0 || [data.totalLeMind isEqualToString:@""]){
                data.totalLeMind = @"0";
            }
            self.totalLeMind = data.totalLeMind;
            
            
            self.curLeBean = data.curLeBean;
            if(data.totalLeBean.length <= 0 || [data.totalLeBean isEqualToString:@""]){
                data.totalLeBean = @"0";
            }
            self.totalLeBean = data.totalLeBean;
        }
    }else{
        [self setIsLoginDisplay:NO];
        [self.headerImageView setImageForName:@"mine_moren"];
        ///积分
        self.integralLabel.text = @"0.00";
        ///乐心
        self.heartLabel.text = @"0";
        //乐豆
        self.beansLabel.text = @"0.00";
        //乐分
        self.minuteLabel.text = @"0.00";
    }
}


///商家判断
- (void)setBusinessmenIsNO:(BOOL)isNo
{
    if(isNo){   //是商家
        self.businessSignImageView.hidden = NO;
        [self.businessSignImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(WIDTH_TRANSFORMATION(85));
        }];
        
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.businessSignImageView.mas_right).offset(WIDTH_TRANSFORMATION(12));
        }];
    }else{      //不是商家
        self.businessSignImageView.hidden = YES;
        [self.businessSignImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.businessSignImageView.mas_right).offset(WIDTH_TRANSFORMATION(0));
        }];

    }
}


///代理商 判断
- (void)setAgentIsNo:(BOOL)isNo
{
    if(isNo){
        self.agentSignImageView.hidden = NO;
        [self.agentSignImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(64));
        }];
        
        [self.recommenderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.agentSignImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(14));
        }];
    }else{
        self.agentSignImageView.hidden = YES;
        [self.agentSignImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.businessSignImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
            make.height.mas_equalTo(0);
        }];
        
        [self.recommenderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.agentSignImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(0));
        }];
    }
}

///推荐人的有无
- (void)setRecommenderIsNo:(BOOL)isNo andAgent:(NSString*)agent
{
    //代理高度
    CGFloat agentHeight = 0;
    //推荐高度
    CGFloat recommenderHeight = 0;
    //代理判断
    if(agent.length <= 0 || [agent isEqualToString:@""]){
        agentHeight = 0;
    }else{
        agentHeight = HEIGHT_TRANSFORMATION(64)+ HEIGHT_TRANSFORMATION(14);
    }
    
    if(isNo){
        self.recommenderLabel.hidden = NO;
        [self.mobileLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recommenderLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(16));
        }];
        ///self.recommenderLabel.frame.size.height
        recommenderHeight = HEIGHT_TRANSFORMATION(32) + HEIGHT_TRANSFORMATION(16);
    }else{
        self.recommenderLabel.hidden = YES;
        [self.mobileLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recommenderLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(-32));
        }];
        recommenderHeight = 0;
    }
    
    CGFloat height = HEIGHT_TRANSFORMATION(33) + HEIGHT_TRANSFORMATION(16) + agentHeight + recommenderHeight + HEIGHT_TRANSFORMATION(32);
    
    [self.userInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

///是否登录
-(void)setIsLoginDisplay:(BOOL)isLogin
{
    if(isLogin){        //登陆成功
        self.clickLoginLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.recommenderLabel.hidden = NO;
        self.mobileLabel.hidden = NO;
        self.editdataButton.hidden = NO;
    }else{              //未登陆
        self.clickLoginLabel.hidden = NO;
        self.businessSignImageView.hidden = YES;
        self.nameLabel.hidden = YES;
        self.agentSignImageView.hidden = YES;
        self.recommenderLabel.hidden = YES;
        self.mobileLabel.hidden = YES;
        self.editdataButton.hidden = YES;
    }
}

///判断是否登录
-(BOOL)checkIsLogin
{
    if(!DATAMODEL.isLogin){
        GC_LoginViewController *lVC = [[GC_LoginViewController alloc] init];
        lVC.hidesBottomBarWhenPushed = YES;
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:lVC animated:YES];
    }
    return DATAMODEL.isLogin;
}



#pragma mark -- action
///修改资料 回调
- (void)onEditDataButtonBlock:(UIButton*)sender
{
    if([self checkIsLogin]){
        GC_MineEditInfoViewController *editInfo = [[GC_MineEditInfoViewController alloc] init];
        editInfo.hidesBottomBarWhenPushed = YES;
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:editInfo animated:YES];
    }
}

///积分 按钮
-(void)onIntegralButtonAction:(UIButton*)sender
{
    if([self checkIsLogin]){
        GC_MineIntegralViewController *integral = [[GC_MineIntegralViewController alloc] init];
        integral.hidesBottomBarWhenPushed = YES;
        integral.curScore = self.curScore;
        integral.totalScore = self.totalScore;
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:integral animated:YES];
    }
    
}

///乐心 按钮
- (void)onHeartButtonAction:(UIButton*)sender
{
    
    if([self checkIsLogin]){
        GC_MineLeMindViewController *leMind = [[GC_MineLeMindViewController alloc] init];
        leMind.hidesBottomBarWhenPushed = YES;
//        leMind.curLeMind = self.curLeMind;
//        leMind.totalLeMind = self.totalLeMind;
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:leMind animated:YES];
    }
    
}

///乐豆 按钮
- (void)onBeansButtonAction:(UIButton*)sender
{
    
    if([self checkIsLogin]){
        GC_MineLeBeansScoreViewController *leBeanScore = [[GC_MineLeBeansScoreViewController alloc] init];
        leBeanScore.hidesBottomBarWhenPushed = YES;
        
        leBeanScore.currentItem = 1;
//        leBeanScore.curLeBean = self.curLeBean;
//        leBeanScore.totalLeBean = self.totalLeBean;
//        
//        leBeanScore.curLeScore = self.curLeScore;
//        leBeanScore.totalLeScore = self.totalLeScore;
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:leBeanScore animated:YES];
        
    }
}

///乐分 按钮
-(void)onMinuteButtonAction:(UIButton*)sender
{
    
    if([self checkIsLogin]){
        GC_MineLeBeansScoreViewController *leBeanScore = [[GC_MineLeBeansScoreViewController alloc] init];
        leBeanScore.hidesBottomBarWhenPushed = YES;
        
        leBeanScore.currentItem = 0;
//        leBeanScore.curLeBean = self.curLeBean;
//        leBeanScore.totalLeBean = self.totalLeBean;
//        
//        leBeanScore.curLeScore = self.curLeScore;
//        leBeanScore.totalLeScore = self.totalLeScore;
        
        [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:leBeanScore animated:YES];
    }
    
}

#pragma mark -- getter,setter
///背景图
- (UIImageView *)backgroundImageView
{
    if(!_backgroundImageView){
        UIImageView *backgroundImage = [UIImageView createImageViewWithName:@"mine_bg"];
        [self addSubview:_backgroundImageView = backgroundImage];
    }
    return _backgroundImageView;
}

///头像
- (UIImageView *)headerImageView
{
    if(!_headerImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_toux"];
        [bgImage makeRadiusForWidth:FITSCALE(180/2)];
        [self addSubview:bgImage];
        
        UIImageView *headerImage = [UIImageView createImageViewWithName:@"mine_moren"];
        [headerImage makeRadiusForWidth:FITSCALE(160/2)];
        [self addSubview:_headerImageView = headerImage];
        
        
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerImage);
            make.width.mas_equalTo(FITSCALE(180/2));
            make.height.mas_equalTo(FITSCALE(180/2));
        }];
        
    }
    return _headerImageView;
}

///用户信息View
- (UIView *)userInfoView
{
    if(!_userInfoView){
        UIView *view = [UIView createViewWithBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:_userInfoView = view];
    }
    return _userInfoView;
}

///点击登录
- (UILabel *)clickLoginLabel
{
    if(!_clickLoginLabel){
        UILabel *loginLabel = [UILabel createLabelWithText:HenLocalizedString(@"点击登录") font:kFontSize_28 textColor:kFontColorWhite];
        [self addSubview:_clickLoginLabel = loginLabel];
    }
    return _clickLoginLabel;
}


///商家标志
- (UIImageView *)businessSignImageView
{
    if(!_businessSignImageView){
        UIImageView *businessSignImage = [UIImageView createImageViewWithName:@"homepage_main_sell"];
        businessSignImage.hidden = YES;
        [self addSubview:_businessSignImageView = businessSignImage];
        
        UILabel *label = [UILabel createLabelWithText:@"商家" font:kFontSize_22 textColor:kFontColorRed];
        [businessSignImage addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(businessSignImage);
        }];
    }
    return _businessSignImageView;
}

///昵称
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *nameLabel = [UILabel createLabelWithText:@"" font:kFontSize_34 textColor:kFontColorWhite];
        nameLabel.hidden = YES;
        [self addSubview:_nameLabel = nameLabel];
    }
    return _nameLabel;
}

///代理商
- (UIImageView *)agentSignImageView
{
    if(!_agentSignImageView){
        UIImageView *agentSignImage = [UIImageView createImageViewWithName:@"mine_agent3"];
        
        agentSignImage.hidden = YES;
        //代理商
        UILabel *agentLabel = [UILabel createLabelWithText:@"市代理" font:kFontSize_26 textColor:kFontColorWhite];
        [agentSignImage addSubview:_agentLabel = agentLabel];
        
        [agentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(agentSignImage);
            make.right.equalTo(agentSignImage).offset(WIDTH_TRANSFORMATION(-15));
        }];
        
        [self addSubview:_agentSignImageView = agentSignImage];
    }
    return _agentSignImageView;
}

///推荐人
- (UILabel *)recommenderLabel
{
    if(!_recommenderLabel){
        UILabel *recommenderLabel = [UILabel createLabelWithText:@"推荐人：" font:kFontSize_28 textColor:kFontColorWhite];
        recommenderLabel.hidden = YES;
        [self addSubview:_recommenderLabel = recommenderLabel];
    }
    return _recommenderLabel;
}

///手机号
- (UILabel *)mobileLabel
{
    if(!_mobileLabel){
        UILabel *mobileLabel = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorWhite];
        mobileLabel.hidden = YES;
        [self addSubview:_mobileLabel = mobileLabel];
    }
    return _mobileLabel;
}

///修改资料
- (UIButton *)editdataButton
{
    if(!_editdataButton){
        UIButton *editButton = [UIButton createNoBgButtonWithTitle:HenLocalizedString(@"修改资料") target:self action:@selector(onEditDataButtonBlock:)];
        editButton.titleLabel.font = kFontSize_28;
        [editButton setTitleClor:kFontColorWhite];
        
        editButton.hidden = YES;
        [self addSubview:_editdataButton = editButton];
        
        UIImageView *nextImage = [UIImageView createImageViewWithName:@"public_next_white"];
        [editButton addSubview:nextImage];
        
        [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(editButton);
            make.left.equalTo(editButton.mas_right).offset(WIDTH_TRANSFORMATION(10));
        }];
        
    }
    return _editdataButton;
}

///一线天
- (UIImageView *)lineViewImageView
{
    if(!_lineViewImageView){
        UIImageView *lineImage = [UIImageView createImageViewWithName:@"mine_line"];
        [self addSubview:_lineViewImageView = lineImage];
    }
    return _lineViewImageView;
}

///积分 按钮
- (UIButton *)integralButton
{
    if(!_integralButton){
        UIButton *integralButton = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onIntegralButtonAction:)];
        
        UILabel *label = [UILabel createLabelWithText:@"积分" font:kFontSize_28 textColor:kFontColorWhite];
        [integralButton addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(integralButton).offset(HEIGHT_TRANSFORMATION(35));
            make.centerX.equalTo(integralButton);
        }];
        
        
        UILabel *integral = [UILabel createLabelWithText:@"0" font:kFontSize_24 textColor:kFontColorWhite];
        [integral setTextAlignment:NSTextAlignmentCenter];
        [integralButton addSubview:_integralLabel = integral];
        
        [integral mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(HEIGHT_TRANSFORMATION(8));
            make.centerX.equalTo(integralButton);
            make.left.equalTo(integralButton).offset(WIDTH_TRANSFORMATION(10));
            make.right.equalTo(integralButton).offset(WIDTH_TRANSFORMATION(-10));
        }];
        
        [self addSubview:_integralButton = integralButton];
    }
    return _integralButton;
}

///乐心 按钮
- (UIButton *)heartButton
{
    if(!_heartButton){
        UIButton *heartButton = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onHeartButtonAction:)];
        
        UILabel *label = [UILabel createLabelWithText:@"乐心" font:kFontSize_28 textColor:kFontColorWhite];
        [heartButton addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(heartButton).offset(HEIGHT_TRANSFORMATION(35));
            make.centerX.equalTo(heartButton);
        }];
        
        UILabel *heart = [UILabel createLabelWithText:@"0" font:kFontSize_24 textColor:kFontColorWhite];
        
        [heart setTextAlignment:NSTextAlignmentCenter];
        [heartButton addSubview:_heartLabel = heart];
        
        [heart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(HEIGHT_TRANSFORMATION(8));
            make.centerX.equalTo(heartButton);
            make.left.equalTo(heartButton).offset(WIDTH_TRANSFORMATION(10));
            make.right.equalTo(heartButton).offset(WIDTH_TRANSFORMATION(-10));
        }];
        
        
        UIImageView *leftLine = [UIImageView createImageViewWithName:@"public_line2"];
        [heartButton addSubview:leftLine];
        
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(heartButton);
            make.centerY.equalTo(heartButton);
        }];
        
        UIImageView *rightLine = [UIImageView createImageViewWithName:@"public_line2"];
        [heartButton addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(heartButton);
            make.centerY.equalTo(heartButton);
        }];
        
        [self addSubview:_heartButton = heartButton];
    }
    return _heartButton;
}


///乐豆 按钮
- (UIButton *)beansButton
{
    if(!_beansButton){
        UIButton *beansButton = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onBeansButtonAction:)];
        
        UILabel *label = [UILabel createLabelWithText:@"乐豆" font:kFontSize_28 textColor:kFontColorWhite];
        [beansButton addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(beansButton).offset(HEIGHT_TRANSFORMATION(35));
            make.centerX.equalTo(beansButton);
        }];
        
        UILabel *beans = [UILabel createLabelWithText:@"0" font:kFontSize_24 textColor:kFontColorWhite];
        [beans setTextAlignment:NSTextAlignmentCenter];
        [beansButton addSubview:_beansLabel = beans];
        
        [beans mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(HEIGHT_TRANSFORMATION(8));
            make.centerX.equalTo(beansButton);
            make.left.equalTo(beansButton).offset(WIDTH_TRANSFORMATION(10));
            make.right.equalTo(beansButton).offset(WIDTH_TRANSFORMATION(-10));
        }];
        
        
        
        UIImageView *rightLine = [UIImageView createImageViewWithName:@"public_line2"];
        [beansButton addSubview:rightLine];
        
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(beansButton);
            make.centerY.equalTo(beansButton);
        }];
        
        [self addSubview:_beansButton = beansButton];
    }
    return _beansButton;
}



///乐分 按钮
- (UIButton *)minuteButton
{
    if(!_minuteButton){
        UIButton *minuteButton = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onMinuteButtonAction:)];
        
        
        UILabel *label = [UILabel createLabelWithText:@"乐分" font:kFontSize_28 textColor:kFontColorWhite];
        [minuteButton addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(minuteButton).offset(HEIGHT_TRANSFORMATION(35));
            make.centerX.equalTo(minuteButton);
        }];
        
        UILabel *minute = [UILabel createLabelWithText:@"0" font:kFontSize_24 textColor:kFontColorWhite];
        [minute setTextAlignment:NSTextAlignmentCenter];
        [minuteButton addSubview:_minuteLabel = minute];
        
        [minute mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(HEIGHT_TRANSFORMATION(8));
            make.centerX.equalTo(minuteButton);
            make.left.equalTo(minuteButton).offset(WIDTH_TRANSFORMATION(10));
            make.right.equalTo(minuteButton).offset(WIDTH_TRANSFORMATION(-10));
        }];
        
        [self addSubview:_minuteButton = minuteButton];
    }
    return _minuteButton;
}
@end
