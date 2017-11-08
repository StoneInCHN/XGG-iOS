//
//  MallViewController.m
//  xianglegou
//
//  Created by lieon on 2017/10/17.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "MallViewController.h"
#import <WebKit/WebKit.h>

@interface MallViewController ()<WKUIDelegate, WKNavigationDelegate>
@property(nonatomic, strong) WKWebView *webView;

@end

@implementation MallViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cleanCacheAndCookie];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
}
#pragma mark - UI

- (void)resetUI {
    if ([self.view.subviews containsObject:self.webView]) {
        [self.webView removeFromSuperview];
    }
}
- (void)setupUI {
    [self.view addSubview:self.webView];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self showHudInView:self.view hint:@""];
}

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - Data
- (void)loadData {
    NSString * urlString = mall_baseURL;
    NSString * body = [NSString stringWithFormat:@"userid=%@&token=%@&mobile=%@",DATAMODEL.userDBHelper.getUserId,DATAMODEL.userDBHelper.getToken,DATAMODEL.userDBHelper.getUserMoblie];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@", urlString, body];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urlStr);
    NSURL *url = [[ NSURL alloc] initWithString:urlStr];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [_webView loadRequest: [ NSURLRequest requestWithURL:url]];
}


#pragma mark - self method

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

#pragma mark - lazy load

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self hideHud];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest * request = navigationAction.request;
     NSString * reqUrl = navigationAction.request.URL.absoluteString;
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
        
        if (!bSucc) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"未检测到支付宝客户端，请安装后重试。"
                                                          delegate:self
                                                 cancelButtonTitle:@"立即安装"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
    NSURL *downloadUrl = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication]openURL:downloadUrl];
}
@end
