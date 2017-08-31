//
//  JiuPaiWebViewController.m
//  xianglegou
//
//  Created by lieon on 2017/8/30.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "JiuPaiWebViewController.h"
#import <WebKit/WebKit.h>

@interface JiuPaiWebViewController ()<WKUIDelegate, WKNavigationDelegate>
@property(nonatomic, strong) WKWebView *webView;
@end

@implementation JiuPaiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cleanCacheAndCookie];
}
#pragma mark - UI

- (void)setupUI {
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    [self showHudInView:self.view hint:@""];
}

#pragma mark - Data
- (void)loadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@", self.urlString, self.body];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    NSString * urlString = navigationAction.request.URL.absoluteString;
    if ([urlString hasSuffix:@"www.baidu.com"]) { /// 返回商户，与服务器规定连接是"wwww.baidu.com结尾
        decisionHandler(WKNavigationActionPolicyCancel);
        [self.navigationController popViewControllerAnimated:true];
        if(self.onPayFinish){
            self.onPayFinish();
        }
        return;
    }
     decisionHandler(WKNavigationActionPolicyAllow);
}
@end
