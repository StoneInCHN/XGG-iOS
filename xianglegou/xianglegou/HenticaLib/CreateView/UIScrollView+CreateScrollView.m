//
//  UIScrollView+CreateScrollView.m
//  Exam
//
//  Created by mini2 on 16/9/9.
//  Copyright © 2016年 Exam. All rights reserved.
//

#import "UIScrollView+CreateScrollView.h"

@implementation UIScrollView (CreateScrollView)

///创建
+(UIScrollView*)createScrollViewWithDelegateTarget:(id)delegateTarget
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = delegateTarget;
    
    return scrollView;
}

///获取
+(UIScrollView*)getScrollViewForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UIScrollView *scrollView = (UIScrollView*)[view viewWithTag:tag];
    
    return scrollView;
}

@end
