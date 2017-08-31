//
//  GC_BeingPaidViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/7/10.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BeingPaidViewController.h"
#import "BFSTimerextension.h"
#import "GC_CustomProgressLoadingView.h"

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@interface GC_BeingPaidViewController ()<BFSTimerextensionDelegate>

///时间显示
@property (nonatomic, weak) UILabel *countdownLabel;
///正在刷新状态
@property (nonatomic, weak) UILabel *refreshLabel;

///计时工具
@property (nonatomic, strong) BFSTimerextension *timeTool;

///时间长度
@property (nonatomic, assign) NSInteger countdown;

///topView
@property (nonatomic, weak) UIView *topView;

@end

@interface GC_BeingPaidViewController ()

@end

@implementation GC_BeingPaidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 禁用返回手势
    WEAKSelf;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)weakSelf;
    }
    
    [self loadSubView];
    
    [self BeingPayShow];
    
    
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO; //YES：允许右滑返回  NO：禁止右滑返回
}

///清除数据
-(void)cleanUpData
{
    [self setTimeTool:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"正在支付";
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    self.view.backgroundColor = kCommonWhiteBg;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(550));
    }];

    
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(120));
        make.centerX.equalTo(self.view);
    }];
    
    
    [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.topView).offset(HEIGHT_TRANSFORMATION(-120));
    }];
}


///加载返回按钮
-(void)loadNavigationBackButton
{
    
    
}


- (GC_CustomProgressLoadingView *)HUD{
    
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}


- (void)setHUD:(GC_CustomProgressLoadingView *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)hideHud{
    [[self HUD] hide];
}



///显示
- (void)BeingPayShow
{
    GC_CustomProgressLoadingView *HUD = [[GC_CustomProgressLoadingView alloc] init];
    [self.view addSubview:HUD];
    [HUD show];
    [HUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView);
    }];
    [self setHUD:HUD];
    
    self.countdown = 5;
    [self.timeTool startTimer:1 repeats:YES];
}

- (void)timerfucntionCall
{
    if(self.countdown == 0){
        [self dismissBoxView];
    }
    
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld",self.countdown];
    self.countdown -- ;
}

- (void)dismissBoxView
{
    self.countdown = 0;
    [self.timeTool stopTimer];
    [[self HUD] hide];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    if(self.onSuccessBlock){
        self.onSuccessBlock();
    }
    
    
    
}


#pragma mark -- getter,setter
- (UILabel *)countdownLabel
{
    if(!_countdownLabel){
        UILabel *label = [UILabel createLabelWithText:@"5" font:kFontSize_34 textColor:kFontColorRed];
        [self.view addSubview:_countdownLabel = label];
    }
    return _countdownLabel;
}

///刷新
- (UILabel *)refreshLabel
{
    if(!_refreshLabel){
        UILabel *label = [UILabel createLabelWithText:@"正在刷新状态..." font:kFontSize_28 textColor:kFontColorBlack];
        [self.view addSubview:_refreshLabel = label];
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

- (UIView *)topView
{
    if(!_topView){
        UIView *view = [UIView createViewWithBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_topView = view];
    }
    return _topView;
}

@end
