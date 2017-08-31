//
//  QL_WaiteViewController.m
//  MenLi
//
//  Created by mini2 on 16/7/13.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "QL_WaiteViewController.h"
#import "RebateTabBarViewController.h"

@interface QL_WaiteViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *startImage;

///是否进入主页
@property(nonatomic, assign) BOOL isEnterIndex;
///是否更新
@property(nonatomic, assign) BOOL isUpdate;

/// 定时器
@property (nonatomic, strong) NSTimer  * timer;
@property(nonatomic, assign) NSInteger countdown;

@end

@implementation QL_WaiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([[DATAMODEL.userDBHelper getStartAppCount] isEqualToString:@""]){
        [self loadFirstStartWelcome];
    }else{
        [self loadStart];
    }
    
    [self checkAppUpdate];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadFirstStartWelcome
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    scrollView.delegate = self;
    // 是否反弹
    scrollView.bounces = YES;
    // 是否分页
    scrollView.pagingEnabled = YES;
    // 是否滚动
    scrollView.scrollEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    // 设置indicator风格
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 提示用户,Indicators flash
    [scrollView flashScrollIndicators];
    // 是否同时运动,lock
    scrollView.directionalLockEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
    [self.view addSubview:scrollView];
    
    for(NSInteger i = 0; i < 3; i++){
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, scrollView.frame.size.height);
        
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome%ld", (long)i+1]];

        if(i == 2){
            // 给活动图片添手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTapGestureHandler:)];
            image.userInteractionEnabled = YES;
            [image addGestureRecognizer:tap];
        }
        [scrollView addSubview:image];
    }
}

-(void)loadStart
{
    self.startImage = [UIImageView createImageViewWithName:@"startPng3"];
    [self.view addSubview:self.startImage];
    
    [self.startImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
        make.center.equalTo(self.view);
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshRestTime:) userInfo:nil repeats:YES];
}

///检查更新
-(void)checkAppUpdate
{
//    //检查更新
//    [[MessageManager shareMessageManager] checkAppIsUpdateAPPID:DATAMODEL.configDataModel.iosAppId andBlock:^(BOOL isUpdate, id updateInfo) {
//        if(isUpdate){
//            self.isUpdate = YES;
//            [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要更新版本吗？"];
//            WEAKSelf;
//            [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
//                if(buttonIndex == 0){
//                    [DATAMODEL.htcUtil toAppStore:updateInfo appId:DATAMODEL.configDataModel.iosAppId];
//                }
//                
//                //进入主页
//                [weakSelf enterIndex];
//            }];
//        }
//    }];
}

///进入主页
-(void)enterIndex
{
    if(!self.isEnterIndex){
        self.isEnterIndex = YES;
        
        [[[UIApplication sharedApplication] delegate] window].rootViewController = [[RebateTabBarViewController alloc] init];
    }
}

///倒计时回调
- (void)refreshRestTime:(NSTimer *)timer
{
    self.countdown++;
    if(self.countdown > 2 && !self.isUpdate){
        [self enterIndex];
    }
}

#pragma mark -- Response Handler

- (void)indexTapGestureHandler:(UITapGestureRecognizer *)tap
{
    [DATAMODEL.userDBHelper updateAppStartCount];
    
    [self enterIndex];
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > kMainScreenWidth * 2){
        
        [DATAMODEL.userDBHelper updateAppStartCount];
        
        [self enterIndex];
    }
}

@end
