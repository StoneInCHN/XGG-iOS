//
//  Hen_BaseViewController.h
//  dentistry
//
//  Created by mini2 on 15/12/22.
//  Copyright © 2015年 hentica. All rights reserved.
//

#import "Hen_BaseViewController.h"
#import "Hen_BaseNavigationViewController.h"
#import "HenticaLib.h"

@interface Hen_BaseViewController ()

@end

@implementation Hen_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setExclusiveTouch:YES];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadNavigationBarBackground];
    [self loadNavigationBackButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.navigationController.viewControllers count] == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            [self cleanUpData];
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            [self cleanUpStrongSubView];
            
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

-(void)dealloc
{
#if IsDevelopment
    NSLog(@"*****************ViewController已释放！");
#endif
}

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

///加载navigationBar背景
-(void)loadNavigationBarBackground
{
    [((Hen_BaseNavigationViewController*)self.navigationController) setDefaultBackground];
    [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:NO];
    [self.navigationController.navigationBar setTintColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarTitleColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:NO];
}

///加载返回按钮
-(void)loadNavigationBackButton
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    WEAKSelf;
    
    UIImage *searchimage=[UIImage imageNamed:@"base_navigation_icon_back"];
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(onGoBackClick:)];
    barbtn.image=searchimage;
    self.navigationItem.leftBarButtonItem=barbtn;
    self.navigationItem.hidesBackButton = YES;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)weakSelf;
    }
}

///点击返回按钮
-(void)onGoBackClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 子类必须重写并实现

///清除数据
-(void)cleanUpData
{

}

///清除强引用视图
-(void)cleanUpStrongSubView
{
    
}

@end
