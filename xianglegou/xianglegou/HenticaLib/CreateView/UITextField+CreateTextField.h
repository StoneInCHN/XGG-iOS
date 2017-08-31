//
//  UITextField+CreateTextField.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CreateTextField)

///创建输入框
+(UITextField*)createTextFieldWithPlaceholder:(NSString*)placeholder delegateTarget:(id)delegateTarget;

///创建输入框
+(UITextField*)createTextFieldWithPlaceholder:(NSString*)placeholder placeholderColor:(UIColor *)placeHolderColor delegateTarget:(id)delegateTarget;

///获取输入框
+(UITextField*)getTextFiledForTag:(NSInteger)tag inParentView:(UIView*)view;

///更改输入框占位符颜色
-(void)changePlaceholderColor:(UIColor*)placeHolderColor;

@end
