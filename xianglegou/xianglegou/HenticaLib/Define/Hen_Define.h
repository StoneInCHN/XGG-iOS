//
//  define.h
//  dentistry
//
//  Created by mini2 on 15/12/22.
//  Copyright © 2015年 hentica. All rights reserved.
//

#import "Hen_Util.h"

#ifndef Hen_Define_h
#define Hen_Define_h

//获取当前屏幕的宽度
#define kMainScreenWidth ([UIScreen mainScreen].bounds.size.width)
//获取当前屏幕的高度
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

///返回屏幕长宽中较大值
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
///返回屏幕长宽中较小值
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
///判断设配是否为ipad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ipad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
///判断设配是否为iphone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
///判断设配是否为高清屏(分辨率)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
///判断设配为iPhone5及之前更早版本
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0)
///判断设配为iPhone6
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
///判断设配为iPhone6p
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

///宽度转换
#define WIDTH_TRANSFORMATION(width)         [[Hen_Util getInstance].configure widthTransformation:width]
///高度转换
#define HEIGHT_TRANSFORMATION(height)       [[Hen_Util getInstance].configure heightTransformation:height]
///字体转换
#define FONTSIZE_TRANSFORMATION(size)       [[Hen_Util getInstance].configure fontSizeTransformation:size]

///位置宽度适配转换
#define POSITION_WIDTH_FIT_TRANSFORMATION(width)                    [[Hen_Util getInstance].configure positionWidthFitTransformation:width]
///位置高度适配转换
#define POSITION_HEIGHT_FIT_POSITIONFIT_TRANSFORMATION(width)       [[Hen_Util getInstance].configure positionHeightFitTransformation:width]

///宽度适配
#define FITWITH(width)  [[Hen_Util getInstance].configure fitWithWidth:width]
///高度适配
#define FITHEIGHT(height) [[Hen_Util getInstance].configure fitWithHeight:height]
///字体适配
#define FITFONTSIZE(a)  [[Hen_Util getInstance].configure fitWithFontSize:a]
///等比适配
#define FITSCALE(a) [[Hen_Util getInstance].configure fitScale:a]

///弱引用
#define WEAKSelf  __weak typeof(self) weakSelf = self
///强引用
#define STRONGSelf __strong typeof(self) strongSelf = self

///tag值
#define Base_Tag 100

///程序的本地化,引用国际化的文件
#define HenLocalizedString(x) NSLocalizedString(x, @"")

/// 查看代码运行时间
#define TICK NSDate * startTime = [NSDate date];
#define TOCK NSLog(@"Time:%f",-[startTime timeIntervalSinceNow]);

#endif /* define_h */
