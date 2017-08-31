//
//  UIScrollView+CreateScrollView.h
//  Exam
//
//  Created by mini2 on 16/9/9.
//  Copyright © 2016年 Exam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CreateScrollView)

///创建
+(UIScrollView*)createScrollViewWithDelegateTarget:(id)delegateTarget;

///获取
+(UIScrollView*)getScrollViewForTag:(NSInteger)tag inParentView:(UIView*)view;

@end
