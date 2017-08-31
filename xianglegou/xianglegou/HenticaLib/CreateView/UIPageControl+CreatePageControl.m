//
//  UIPageControl+CreatePageControl.m
//  Peccancy
//
//  Created by mini2 on 16/10/8.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "UIPageControl+CreatePageControl.h"

@implementation UIPageControl (CreatePageControl)

///创建
+(UIPageControl*)createPageControl
{
    UIPageControl *page = [[UIPageControl alloc] init];
    
    return page;
}

///获取
+(UIPageControl*)getPageControlForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UIPageControl *page = [view viewWithTag:tag];
    
    return page;
}

@end
