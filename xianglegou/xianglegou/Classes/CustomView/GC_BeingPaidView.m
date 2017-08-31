//
//  GC_BeingPaidView.m
//  xianglegou
//
//  Created by mini3 on 2017/7/10.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BeingPaidView.h"
#import "BFSTimerextension.h"
#import "GC_CustomProgressLoadingView.h"

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@interface GC_BeingPaidView ()<BFSTimerextensionDelegate>

///时间显示
@property (nonatomic, weak) UILabel *countdownLabel;
///正在刷新状态
@property (nonatomic, weak) UILabel *refreshLabel;

///计时工具
@property (nonatomic, strong) BFSTimerextension *timeTool;

///时间长度
@property (nonatomic, assign) NSInteger countdown;
///蒙层
@property (nonatomic, strong) UIView *maskView;

///顶部View
@property (nonatomic, weak) UIView *topView;
@end

@implementation GC_BeingPaidView

- (GC_CustomProgressLoadingView *)HUD{
    
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}


- (void)setHUD:(GC_CustomProgressLoadingView *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)hideHud{
    [[self HUD] hide];
}


- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

///初始化
- (void)initDefault
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(400));
    
    self.center = CGPointMake(kMainScreenWidth / 2, kMainScreenHeight / 2);
    
    self.backgroundColor = [UIColor clearColor];
    [self loadSubViewAndConstraints];
    
}

///加载子视图及约束
-(void)loadSubViewAndConstraints
{
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(30));
        make.centerX.equalTo(self);
    }];
    
    
    [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-30));
        make.centerX.equalTo(self);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

///显示
- (void)BeingPayShow
{
    
    self.maskView.alpha = 0.1f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.maskView];
    
    self.alpha = 0.0f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        GC_CustomProgressLoadingView *HUD = [[GC_CustomProgressLoadingView alloc] init];
        [self addSubview:HUD];
        [HUD show];
        [HUD mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [self setHUD:HUD];
        
        self.countdown = 5;
        [self.timeTool startTimer:1 repeats:YES];
    }];
    
    
    
//    UIView *view = [[UIApplication sharedApplication].delegate window];
//    self.frame = CGRectMake(0, 64 + HEIGHT_TRANSFORMATION(100), kMainScreenWidth, HEIGHT_TRANSFORMATION(500));
//    [view addSubview:self.maskView];
//    [view addSubview:self];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.frame = CGRectMake(0, 64 + HEIGHT_TRANSFORMATION(100), kMainScreenWidth, HEIGHT_TRANSFORMATION(500));
//        self.maskView.alpha = 0.2;
//        
//        self.maskView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
//        
//    } completion:^(BOOL finished) {
//        GC_CustomProgressLoadingView *HUD = [[GC_CustomProgressLoadingView alloc] init];
//        [self addSubview:HUD];
//        [HUD show];
//        [HUD mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//        }];
//        [self setHUD:HUD];
//        
//        
//        self.countdown = 5;
//        [self.timeTool startTimer:1 repeats:YES];
//    }];
}


- (void)timerfucntionCall
{
    if(self.countdown == 0){
        [self dismissBoxView];
    }
    
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld",self.countdown];
    self.countdown -- ;
}


- (void)dismissBoxView {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0f;
        self.maskView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.countdown = 0;
        [self.timeTool stopTimer];
        [[self HUD] hide];
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
        
        if(self.onSuccessBlock){
            self.onSuccessBlock();
        }
    }];
    
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.frame = CGRectMake(0, 64 + HEIGHT_TRANSFORMATION(100), kMainScreenWidth, HEIGHT_TRANSFORMATION(500));
//        self.maskView.alpha = 0;
//        
//        self.maskView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
//    } completion:^(BOOL finished) {
//        self.countdown = 0;
//        [self.timeTool stopTimer];
//        [[self HUD] hide];
//        [self removeFromSuperview];
//        [self.maskView removeFromSuperview];
//    }];
}



#pragma mark -- getter,setter
- (UILabel *)countdownLabel
{
    if(!_countdownLabel){
        UILabel *label = [UILabel createLabelWithText:@"5" font:kFontSize_34 textColor:kFontColorRed];
        [self addSubview:_countdownLabel = label];
    }
    return _countdownLabel;
}

///刷新
- (UILabel *)refreshLabel
{
    if(!_refreshLabel){
        UILabel *label = [UILabel createLabelWithText:@"正在刷新状态..." font:kFontSize_28 textColor:kFontColorBlack];
        [self addSubview:_refreshLabel = label];
    }
    return _refreshLabel;
}

///计时工具
- (BFSTimerextension *)timeTool
{
    if(!_timeTool){
        _timeTool = [[BFSTimerextension alloc] init];
        _timeTool.delegate = self;
    }
    return _timeTool;
}

///蒙层
- (UIView *)maskView
{
    if(!_maskView){
        _maskView = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) backgroundColor:[UIColor blackColor]];
        
//        _maskView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
//        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}


- (UIView *)topView
{
    if(!_topView){
        UIView *view = [UIView createViewWithBackgroundColor:KCommonRedBgColor];
        [self addSubview:_topView = view];
        
        
    }
    return _topView;
}


@end
