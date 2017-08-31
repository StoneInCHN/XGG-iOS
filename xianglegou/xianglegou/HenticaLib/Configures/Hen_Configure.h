//
//  Configure.h
//  FireFlyReader
//
//  Created by runner on 15/7/13.
//  Copyright (c) 2015年 wangjiwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ipad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


@interface Hen_Configure : NSObject

//阅读配置
@property (nonatomic, assign) CGFloat beginFontSize;


//适配UI
@property (nonatomic, assign) CGFloat fontSize;     //字体大小
@property (nonatomic, assign) CGFloat height;       //高度
@property (nonatomic, assign) CGFloat width;        //宽

@property (nonatomic, assign) CGFloat scale_width;   //宽度缩放
@property (nonatomic, assign) CGFloat scale_height; //高度缩放

@property (nonatomic, assign) CGFloat scale;        //缩放

+ (Hen_Configure *)shareConfigure;

//字体大小适配
- (CGFloat)fitWithFontSize:(CGFloat )size;
//高度适配
- (CGFloat)fitWithHeight:(CGFloat )height;
//宽度适配
- (CGFloat)fitWithWidth:(CGFloat )width;
//等比适配
- (CGFloat)fitScale:(CGFloat)a;

///宽度转换
- (CGFloat)widthTransformation:(CGFloat)width;
///高度转换
- (CGFloat)heightTransformation:(CGFloat)height;
///字体转换
- (CGFloat)fontSizeTransformation:(CGFloat)size;

///位置宽度适配转换
- (CGFloat)positionWidthFitTransformation:(CGFloat)width;
///位置高度适配转换
- (CGFloat)positionHeightFitTransformation:(CGFloat)height;

@end
