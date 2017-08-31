//
//  UILabel+CreateLabel.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CreateLabel)

///创建文本 text:文本 font:字体 tag:tag
+ (UILabel *)createLabelWithText:(NSString*)text font:(UIFont*)font;


///创建文本 text:文本 font:字体 textColor:文本颜色 tag:tag
+ (UILabel *)createLabelWithText:(NSString*)text font:(UIFont*)font textColor:(UIColor*)color;

///获取文本 tag:tag inParentView:父视图
+ (UILabel *)getLabelForTag:(NSInteger)tag inParentView:(UIView*)view;

///文本自动折行设置
- (void)lableAutoLinefeed;

///字体加粗
- (void)fontBoldForSize:(CGFloat)size;

///只限数值字体加粗
- (void)limitNumberFontBlodInString:(NSString *)string;

///只限数值字体加粗
- (void)limitNumberFontBlodInString:(NSString *)string andFont:(UIFont *)font;

///只限数值改变字体颜色
- (void)limitNumberString:(NSString *)string changeColor:(UIColor *)color;

@end
