//
//  UITextField+CreateTextField.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UITextField+CreateTextField.h"

@implementation UITextField (CreateTextField)

///创建输入框
+(UITextField*)createTextFieldWithPlaceholder:(NSString*)placeholder delegateTarget:(id)delegateTarget
{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.delegate = delegateTarget;
    textField.font = kFontSize_24;
    
    return textField;
}

///创建输入框
+(UITextField*)createTextFieldWithPlaceholder:(NSString*)placeholder placeholderColor:(UIColor *)placeHolderColor delegateTarget:(id)delegateTarget
{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.delegate = delegateTarget;
    textField.font = kFontSize_24;
    [textField setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    return textField;
}

///获取输入框
+(UITextField*)getTextFiledForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UITextField* textField = (UITextField*)[view viewWithTag:tag];
    
    return textField;
}

///更改输入框占位符颜色
-(void)changePlaceholderColor:(UIColor*)placeHolderColor
{
    [self setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
}

@end
