//
//  Hen_Configure.h
//  FireFlyReader
//
//  Created by runner on 15/7/13.
//  Copyright (c) 2015年 wangjiwu. All rights reserved.
//

#import "Hen_Configure.h"

#define DWIDTH  (750/2)              //设计时使用宽度
#define DHEIGHT (1334/2)             //设计时使用高度

static Hen_Configure *_shareConfigure = nil;

@implementation Hen_Configure

+ (Hen_Configure *)shareConfigure {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shareConfigure = [[self alloc] init];
    });
    
    return _shareConfigure;
}

- (instancetype)init {
    self =  [super init];
    if (self) {
        
        self.fontSize = [UIFont systemFontSize];
        self.width = 320.f;
        self.height = 568.f;
    }
    
    return self;
}

- (CGFloat)scale_width
{
    CGFloat width = DWIDTH;
    
    if (IS_IPHONE_4_OR_LESS) {
        width = 320;
    }else if (IS_IPHONE_5){
        width = 320;
    }else if (IS_IPHONE_6){
        width = 375;
    }else if (IS_IPHONE_6P){
        width = 375;
    }else if (IS_IPAD)
    {
        width = 768;
    }
    
    CGFloat scale = width / DWIDTH;
    
    return scale;
    
}

- (CGFloat)scale_height {
    CGFloat height = DHEIGHT;
    if (IS_IPHONE_4_OR_LESS) {
        height = 480;
    }else if (IS_IPHONE_5){
        height = 568;
    }else if (IS_IPHONE_6){
        height = 667;
    }else if (IS_IPHONE_6P){
        height = 667;
    }else if (IS_IPAD)
    {
        height = 1024;
    }
    
    CGFloat scale = height / DHEIGHT;
    
    return scale;
}

- (CGFloat)scale {
    
    return self.scale_width < self.scale_height ? self.scale_width : self.scale_height;
    
}

//字体大小适配
- (CGFloat)fitWithFontSize:(CGFloat )size
{
    if (IS_IPAD) {
        return size * 1.25;
    }
    
    return size * self.scale_width;
}

//高度适配
- (CGFloat)fitWithHeight:(CGFloat )height
{
    return height* self.scale_height;
}

//宽度适配
- (CGFloat)fitWithWidth:(CGFloat )width
{
    return width * self.scale_width;
}

//等比适配
- (CGFloat)fitScale:(CGFloat)a
{
    return a * self.scale;
}

///宽度转换
- (CGFloat)widthTransformation:(CGFloat)width
{
    //转换
    CGFloat tw = width / 2;
    //适配
    if (IS_IPAD) {
        return tw * self.scale_width;
    }
    return tw;
//    return tw * self.scale_width;
}

///高度转换
- (CGFloat)heightTransformation:(CGFloat)height
{
    //转换
    CGFloat th = height / 2;
    //适配
    if (IS_IPAD) {
        return th * self.scale_height;
    }
    return th;
//    return th * self.scale_height;
}

///字体转换
- (CGFloat)fontSizeTransformation:(CGFloat)size
{
    //转换
    CGFloat tf = size / 2;
    if (IS_IPAD) {
        return tf * 1.25;
    }
    
    return tf;
    //    return tf * self.scale;
}

///位置宽度适配转换
- (CGFloat)positionWidthFitTransformation:(CGFloat)width
{
    //转换
    CGFloat tw = width / 2;
    //适配
    return tw * self.scale_width;
}

///位置高度适配转换
- (CGFloat)positionHeightFitTransformation:(CGFloat)height
{
    //转换
    CGFloat th = height / 2;
    //适配
    if (IS_IPAD) {
        return th * self.scale_height;
    }
    return th;// * self.scale_height;
}

@end
