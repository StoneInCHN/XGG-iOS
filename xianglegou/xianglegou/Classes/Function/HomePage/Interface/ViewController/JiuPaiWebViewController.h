//
//  JiuPaiWebViewController.h
//  xianglegou
//
//  Created by lieon on 2017/8/30.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hen_BaseViewController.h"

@interface JiuPaiWebViewController : Hen_BaseViewController
///webView的url
@property (nonatomic, strong) NSString *urlString;
@property(nonatomic, strong) NSString *body;
@property(nonatomic, copy) void(^onPayFinish)();
@end
