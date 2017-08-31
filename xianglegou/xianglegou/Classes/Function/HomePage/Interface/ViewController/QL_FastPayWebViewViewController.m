//
//  QL_FastPayWebViewViewController.m
//  xianglegou
//
//  Created by mini2 on 2017/5/27.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "QL_FastPayWebViewViewController.h"
#import "QL_CustomWebView.h"

@interface QL_FastPayWebViewViewController ()<UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) QL_CustomWebView *webView;

@property(nonatomic, assign) BOOL isPageAction;

@end

@implementation QL_FastPayWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@", self.urlString, self.body];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[ NSURL alloc] initWithString:urlStr];
    [self.webView  loadRequest:[ NSURLRequest requestWithURL:url]]; //习惯采用loadRequest方式，你可采用其他方式
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hideHud];
    [self cleanCacheAndCookie];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- override

///清除数据
-(void)cleanUpData
{
}

///清除强引用视图
-(void)cleanUpStrongSubView
{
    [self.webView removeFromSuperview];
    [self setWebView:nil];
}

#pragma mark -- private

- (void)loadSubView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#008cdb"];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

/// 返回
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.onPayFinish){
            self.onPayFinish();
        }
    }];
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showPayHud:@""];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeFormSubmitted){
        NSLog(@"---------UIWebViewNavigationTypeLinkClicked");
        NSString *urlString = [[request URL] absoluteString];
        if([urlString isEqualToString:[NSString stringWithFormat:@"%@/", self.pickupUrl]]){
            //返回
            [self goBack];
            return NO;
        }
    }else if(navigationType == UIWebViewNavigationTypeLinkClicked){
        self.isPageAction = YES;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideHud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideHud];
}

#pragma mark -- getter, setter

- (QL_CustomWebView *)webView {
    if (!_webView) {
        _webView = [[QL_CustomWebView alloc] init];
        _webView.delegate = self;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fakeTapGestureHandler:)];
        [tapGestureRecognizer setDelegate:self];
        [_webView.scrollView addGestureRecognizer:tapGestureRecognizer];
    }
    return _webView;
}

#pragma mark -- event response

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    CGPoint tapPoint = [touch locationInView:_webView];
    if(tapPoint.x < 60 && tapPoint.y < 50){
        NSLog(@"%f, %f",tapPoint.x, tapPoint.y);
        
        //延迟0.3s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(!self.isPageAction){
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }else{
                self.isPageAction = NO;
            }
        });
    }
    
    return YES;// Return NO to prevent html document from receiving the touch event.
}

- (void)fakeTapGestureHandler:(id)sender
{
    
}

@end
