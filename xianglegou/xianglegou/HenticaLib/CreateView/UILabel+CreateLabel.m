//
//  UILabel+CreateLabel.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UILabel+CreateLabel.h"

@implementation UILabel (CreateLabel)

///创建文本
+(UILabel*)createLabelWithText:(NSString*)text font:(UIFont*)font
{
    UILabel *label = [self createLabelWithText:text font:font textColor:kFontColorBlack];
    
    return label;
}

+(UILabel*)createLabelWithText:(NSString*)text font:(UIFont*)font textColor:(UIColor*)color
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = color;
    
    return label;
}

///获取文本
+(UILabel*)getLabelForTag:(NSInteger)tag  inParentView:(UIView*)view
{
    UILabel* label = (UILabel*)[view viewWithTag:tag];
    
    return label;
}

///文本自动折行设置
-(void)lableAutoLinefeed
{
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
}

///字体加粗
- (void)fontBoldForSize:(CGFloat)size
{
    self.font = [UIFont boldSystemFontOfSize:size];
}

///只限数值字体加粗
- (void)limitNumberFontBlodInString:(NSString *)string
{
    //数字加粗
    NSString *content = string;
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-3]} range:NSMakeRange(i, 1)];
        }
        
    }
    self.attributedText = attributeString;
}

///只限数值字体加粗
- (void)limitNumberFontBlodInString:(NSString *)string andFont:(UIFont *)font
{
    //数字加粗
    NSString *content = string;
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-3], NSFontAttributeName:font} range:NSMakeRange(i, 1)];
        }
        
    }
    self.attributedText = attributeString;
}

///只限数值改变字体颜色
- (void)limitNumberString:(NSString *)string changeColor:(UIColor *)color
{
    NSString *content = string;
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(i, 1)];
        }
        
    }
    self.attributedText = attributeString;
}

@end
