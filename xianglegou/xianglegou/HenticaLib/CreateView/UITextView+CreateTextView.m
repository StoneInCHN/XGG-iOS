//
//  UITextView+CreateTextView.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UITextView+CreateTextView.h"

@implementation UITextView (CreateTextView)

///创建
+(UITextView*)createTextViewWithDelegateTarget:(id)delegateTarget
{
    UITextView* textView = [[UITextView alloc] init];
    textView.delegate = delegateTarget;
    
    return textView;
}

///获取
+(UITextView*)getTextViewForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UITextView *textView = (UITextView*)[view viewWithTag:tag];
    
    return textView;
}

@end
