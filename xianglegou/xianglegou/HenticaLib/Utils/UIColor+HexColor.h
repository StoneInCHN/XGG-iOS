//
//  UIColor+HexColor.h
//  safety
//
//  Created by mini3 on 16/1/21.
//  Copyright © 2016年 jiwuwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
/// 通过字符串获取颜色 如：#FFFFFF
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
