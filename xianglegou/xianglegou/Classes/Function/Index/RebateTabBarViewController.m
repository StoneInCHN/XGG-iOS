//
//  RebateTabBarViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 主界面
//

#import "RebateTabBarViewController.h"

#import "QL_HomePageViewController.h"
#import "QL_AbonusViewController.h"
#import "GC_MineViewController.h"
#import "MallViewController.h"
#import "GC_LoginViewController.h"

@interface RebateTabBarViewController ()<UITabBarControllerDelegate>
@end

@implementation RebateTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubView];
}

- (void)viewWillDisappear:(BOOL)animated {
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

///加载子视图
- (void)loadSubView
{
    UIViewController *nav0 = [[Hen_BaseNavigationViewController alloc] initWithRootViewController:[[QL_HomePageViewController alloc] init]];
    UIViewController *nav1 = [[Hen_BaseNavigationViewController alloc] initWithRootViewController:[[QL_AbonusViewController alloc] init]];
     UIViewController *nav2 = [[Hen_BaseNavigationViewController alloc] initWithRootViewController:[[MallViewController alloc] init]];
    UIViewController *nav3 = [[Hen_BaseNavigationViewController alloc] initWithRootViewController:[[GC_MineViewController alloc] init]];
    // MallViewController
    NSArray *itemTitles = @[@"首页",
                            @"分红",
                             @"商城",
                            @"我的"];
    
    self.viewControllers = @[nav0, nav1, nav2, nav3];
    self.tabBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    
    //tabbbr颜色
    [self.tabBar setBarTintColor:[UIColor colorWithHexString:@"#f3f3f3"]];
    self.tabBar.translucent = NO;
    //设置跳转是隐藏
    self.hidesBottomBarWhenPushed = YES;
    //设置选中项
    [self setSelectedIndex:0];
    //代理
    self.delegate = self;
    
    //设置图片
    //@"quickplay_tabbar_normal.png"
    NSArray *imageName = @[@"public_tool_bar_icon_homepage",
                           @"public_tool_bar_icon_bonus",
                            @"public_tool_bar_icon_mall",
                           @"public_tool_bar_icon_mine"];
    //@"quickplay_tabbar_select.png"
    NSArray *selectImageName = @[@"public_tool_bar_icon_homepage_choose",
                                 @"public_tool_bar_icon_bonus_choose",
                                  @"public_tool_bar_icon_mall_choose",
                                 @"public_tool_bar_icon_mine_choose"];
    
    for (int i = 0; i < self.tabBar.items.count; i ++) {
        UITabBarItem *barItem = self.tabBar.items[i];
        //设置字体和颜色
        barItem.title = itemTitles[i];
        //正常字体
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontColorBlack,NSForegroundColorAttributeName,kFontSize_24,NSFontAttributeName, nil] forState:UIControlStateNormal];
        //选中字体
        [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontColorRed,NSForegroundColorAttributeName,kFontSize_24,NSFontAttributeName, nil] forState:UIControlStateSelected];
        //正常图标
        barItem.image = [[UIImage imageNamed:imageName[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //barItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        //选中图标
        barItem.selectedImage = [[UIImage imageNamed:selectImageName[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    //分界线
    UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
    [self.view addSubview:lineImage];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}

#pragma mark -- UITabBarControllerDelegate

///UITabbarcontroller实现点击某个指定的tabbaritem后不跳转 ,实现代理UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [tabBarController.viewControllers objectAtIndex:1]){ // 1 分红 2 商城
        //判断是否登录
        if(!DATAMODEL.isLogin){
            GC_LoginViewController *lVC = [[GC_LoginViewController alloc] init];
            lVC.hidesBottomBarWhenPushed = YES;
            //回调
            lVC.onLoginSuccessBlock = ^(){
                //延迟0.2s
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UITabBarController *tabbar = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
                    tabbar.selectedIndex = 1;
                });
            };
            
            [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:lVC animated:YES];
            return NO;
        }
    } else if(viewController == [tabBarController.viewControllers objectAtIndex:2]) {
        //判断是否登录
        if(!DATAMODEL.isLogin){
            GC_LoginViewController *lVC = [[GC_LoginViewController alloc] init];
            lVC.hidesBottomBarWhenPushed = YES;
            //回调
            lVC.onLoginSuccessBlock = ^(){
                //延迟0.2s
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UITabBarController *tabbar = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
                    tabbar.selectedIndex = 2;
                });
            };
            
            [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:lVC animated:YES];
            return NO;
        } else {
            if (  [[DATAMODEL.henUtil getCurrentViewController] isKindOfClass:MallViewController.class] ){
                    MallViewController * mallVC = (MallViewController*)[DATAMODEL.henUtil getCurrentViewController];
                    [mallVC loadData];
            }
        }
        
    }
    return YES;
}

@end
