//
//  QL_HPAcitiveView.h
//  Rebate
//
//  Created by mini2 on 17/3/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 首页Banner view
//

#import <UIKit/UIKit.h>

@interface QL_HPBannerView : UIView

///图片点击回调
@property(nonatomic, copy) void(^onPngClickBlock)(NSInteger item);

///是否定时轮播
@property(nonatomic, assign) BOOL isTimingCarousel;

///初始化
-(id)initWithHeight:(CGFloat)height;

///更新UI
- (void)updateUI;

///更新UI
- (void)updateUIForImages:(NSMutableArray *)images;

///设置圆点显隐
- (void)setPageHidden:(BOOL)hidden;


///判断是否支持乐豆抵扣
- (void)setIsBeanPay:(NSString *)isBeanPay;
@end
