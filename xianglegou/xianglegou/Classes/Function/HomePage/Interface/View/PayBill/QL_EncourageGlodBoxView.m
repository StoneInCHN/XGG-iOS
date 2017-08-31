//
//  QL_EncourageGlodBoxView.m
//  Rebate
//
//  Created by mini2 on 2017/4/26.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_EncourageGlodBoxView.h"
#import "GC_MineLeBeansScoreViewController.h"
#import "QL_UserOrderDetailsViewController.h"

@interface QL_EncourageGlodBoxView()

///蒙层
@property (nonatomic, strong) UIImageView *maskImageView;
///背景图
@property(nonatomic, strong) UIView *bgView;
///标题
@property(nonatomic, strong) UILabel *titleLabel;
///关闭按钮
@property(nonatomic, strong) UIButton *closeButton;
///信息
@property(nonatomic, strong) UILabel *contentLabel;

///订单id
@property(nonatomic, strong) NSString *orderId;

@end

@implementation QL_EncourageGlodBoxView

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
    
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    self.frame = [UIScreen mainScreen].bounds;
    
    //背景
    self.bgView = [UIImageView createImageViewWithName:@"public_remind_frame1"];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = kFontColorWhite;
    self.titleLabel.font = kFontSize_34;
    //文字居中显示
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //默认值
    self.titleLabel.text = @"恭喜您！获得一笔鼓励奖";
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).offset(HEIGHT_TRANSFORMATION(-200));
    }];
    
    //信息
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = kFontColorRed;
    self.contentLabel.font = kFontSize_72;
    [self.bgView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).with.offset(HEIGHT_TRANSFORMATION(-390));
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(HEIGHT_TRANSFORMATION(210));
        make.right.equalTo(self.bgView);
        make.width.equalTo(@(WIDTH_TRANSFORMATION(200)));
        make.height.equalTo(@(HEIGHT_TRANSFORMATION(90)));
    }];
    
    //提示
    UIButton *noticeButton = [UIButton createNoBgButtonWithTitle:@"查看累计乐豆" target:self action:@selector(onNoticeClickAction:)];
    noticeButton.titleLabel.font = kFontSize_28;
    [noticeButton setTitleColor:kFontColorWhite forState:UIControlStateNormal];
    [self addSubview:noticeButton];
    [noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).offset(HEIGHT_TRANSFORMATION(-30));
    }];
    NSMutableAttributedString *tncString = [[NSMutableAttributedString alloc]initWithString:@"查看累计乐豆"];
    // 下划线
    [tncString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){0,[tncString length]}];
    //此时如果设置字体颜色要这样
    [tncString addAttribute:NSForegroundColorAttributeName value:kCommonWhiteBg  range:NSMakeRange(0,[tncString length])];
    //设置下划线颜色
    [tncString addAttribute:NSUnderlineColorAttributeName value:kCommonWhiteBg range:(NSRange){0,[tncString length]}];
    noticeButton.titleLabel.attributedText = tncString;
}

///显示
-(void)showForEncourageAmount:(NSString *)encourageAmount andOrderId:(NSString *)orderId
{
    self.orderId = orderId;
    
    
    
    NSString *str = [NSString stringWithFormat:@"%@ 乐豆", [DATAMODEL.henUtil string:encourageAmount showDotNumber:4]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSFontAttributeName value:kFontSize_72 range:NSMakeRange(0, str.length-3)];
    [attrStr addAttribute:NSFontAttributeName value:kFontSize_34 range:NSMakeRange(str.length-3, 3)];
    self.contentLabel.attributedText = attrStr;
    
    [self show];
}

///显示
- (void)show
{
    self.maskImageView.alpha = 0.5f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.maskImageView];
    
    self.alpha = 0.0f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

///取消
-(void)cancel{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0f;
        self.maskImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskImageView removeFromSuperview];
    }];
}

#pragma mark -- event response

///按钮关闭事件
-(void)onCloseClickAction:(UIButton*)sender
{
    [self cancel];
    
    //跳转到订单详情
    QL_UserOrderDetailsViewController *odVC = [[QL_UserOrderDetailsViewController alloc] init];
    odVC.hidesBottomBarWhenPushed = YES;
    odVC.orderId = self.orderId;
    odVC.enterType = 1;
    
    [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:odVC animated:YES];
}

///点击提示
- (void)onNoticeClickAction:(id)sender
{
    GC_MineLeBeansScoreViewController *leBeanScore = [[GC_MineLeBeansScoreViewController alloc] init];
    leBeanScore.hidesBottomBarWhenPushed = YES;
    //回调
    leBeanScore.onBackBlock = ^{
        [self show];
    };
    
    leBeanScore.currentItem = 1;
//    leBeanScore.curLeBean = DATAMODEL.userInfoData.curLeBean;
//    leBeanScore.totalLeBean = DATAMODEL.userInfoData.totalLeBean;
//    
//    leBeanScore.curLeScore = DATAMODEL.userInfoData.curLeScore;
//    leBeanScore.totalLeScore = DATAMODEL.userInfoData.totalLeScore;
    
    [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:leBeanScore animated:YES];
    
    [self cancel];
}

#pragma mark -- getter,setter

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskImageView.image = [UIImage imageNamed:@"public_mongolia_layer"];
        _maskImageView.backgroundColor = [UIColor blackColor];
        _maskImageView.alpha = 0;
    }
    return _maskImageView;
}

-(UIButton*)closeButton
{
    if(!_closeButton){
        _closeButton = [UIButton createButtonWithTitle:@"" normalImage:@"public_remind_close2" pressImage:@"public_remind_close2" target:self action:@selector(onCloseClickAction:)];
    }
    return _closeButton;
}

@end
