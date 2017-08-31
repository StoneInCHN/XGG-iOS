//
//  GC_AmountDateFilterBoxView.h
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  日期筛选 - BoxView
//

#import <UIKit/UIKit.h>

@interface GC_AmountDateFilterBoxView : UIView

///完成 回调
@property (nonatomic, copy) void(^onFinshBlock)(NSString *begDate, NSString *endDate);

///开始日期
@property (nonatomic, strong) NSString *begDate;
///结束日期
@property (nonatomic, strong) NSString *endDate;

///显示
- (void)showView;
@end
