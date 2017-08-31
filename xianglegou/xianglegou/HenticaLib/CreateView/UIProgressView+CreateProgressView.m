//
//  UIProgressView+CreateProgressView.m
//  Ask
//
//  Created by mini2 on 16/12/30.
//  Copyright © 2016年 Ask. All rights reserved.
//

#import "UIProgressView+CreateProgressView.h"

@implementation UIProgressView (CreateProgressView)

///创建ProgressView
+(UIProgressView*)createProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置进度条颜色
    progressView.trackTintColor = kCommonBackgroudColor;
    //设置进度条上进度的颜色
    progressView.progressTintColor = kFontColorBlack;
    
    return progressView;
}

///获取ProgressView
+(UIProgressView*)getProgressViewForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UIProgressView *subView = [view viewWithTag:tag];
    
    return subView;
}

@end
