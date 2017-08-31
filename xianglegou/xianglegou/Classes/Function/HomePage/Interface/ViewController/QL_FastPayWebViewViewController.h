//
//  QL_FastPayWebViewViewController.h
//  xianglegou
//
//  Created by mini2 on 2017/5/27.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseViewController.h"

@interface QL_FastPayWebViewViewController : Hen_BaseViewController
///webView的url
@property (nonatomic, strong) NSString *urlString;
@property(nonatomic, strong) NSString *body;
@property(nonatomic, strong) NSString *pickupUrl;
@property(nonatomic, copy) void(^onPayFinish)();
@end
