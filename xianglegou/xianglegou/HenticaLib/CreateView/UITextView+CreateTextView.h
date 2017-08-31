//
//  UITextView+CreateTextView.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (CreateTextView)

///创建
+(UITextView*)createTextViewWithDelegateTarget:(id)delegateTarget;

///获取
+(UITextView*)getTextViewForTag:(NSInteger)tag inParentView:(UIView*)view;

@end
