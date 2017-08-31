//
//  Hen_BaseNavigationViewController.m
//  FinalWork
//
//  Created by ; on 14/10/29.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "Hen_BaseNavigationViewController.h"
#import "HenticaLib.h"

@interface Hen_BaseNavigationViewController ()

///下划线
@property(nonatomic, strong) UIView *shadowView;

@end

@implementation Hen_BaseNavigationViewController
//xib或代码手写是调用
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupCustomNavigationBar];
    }
    return self;
}

//使用storyboard时自动调用
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCustomNavigationBar];
    }
    
    return self;
}

- (UIViewController*)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

- (void)setupCustomNavigationBar
{
    // Hide the original navigation bar's background
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = YES;
    self.navigationBar.shadowImage = [UIImage new];

    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFontColorBlack, NSForegroundColorAttributeName, [UIFont systemFontOfSize:kFont_38], NSFontAttributeName, nil]];
    
    //[self.navigationBar addSubview:self.bgView];
    //[self.navigationBar sendSubviewToBack:self.bgView];
    [[self.navigationBar.subviews firstObject] insertSubview:self.bgView atIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///设置标题颜色
-(void)setNavigationBarTitleColor:(UIColor*)color
{
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, [UIFont systemFontOfSize:kFont_38], NSFontAttributeName, nil]];
}

///设置背景
-(void)setNavigationBarBgColor:(UIColor*)color
{
    self.bgView.backgroundColor = color;
}

///设置默认背景
-(void)setDefaultBackground
{
    self.bgView.backgroundColor = KCommonRedBgColor;
}

///设置背景显隐
-(void)setBackgroundHidden:(BOOL)hidden
{
    if(hidden){
        if(self.bgView.alpha != 1.0f){
            return;
        }
    }else{
        if(self.bgView.alpha != 0.0f){
            return;
        }
    }
    _backgroundHidden = hidden;
    [UIView animateWithDuration:0.2f animations:^{
        if (hidden) {
            self.bgView.alpha = 0.0f;
        } else {
            self.bgView.alpha = 1.0f;
        }
    } completion:^(BOOL finished) {
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

///设置下划线显隐
-(void)setShadowViewHidden:(BOOL)hidden
{
    self.shadowView.hidden = hidden;
}

///获取背景alpha
-(CGFloat)getBackgroundAlpha
{
    return self.bgView.alpha;
}

#pragma mark ------------------- getter, setter

-(UIView*)bgView
{
    if(!_bgView){
        _bgView = [[UIView alloc] initWithFrame:self.navigationBar.frame];
        _bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64.f);
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bgView.userInteractionEnabled = NO;
        _bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pulic_under_the_bar"]];
        
        // Shadow line
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, 1)];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2f];
        _shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_bgView addSubview:_shadowView];
    }
    return _bgView;
}


@end
