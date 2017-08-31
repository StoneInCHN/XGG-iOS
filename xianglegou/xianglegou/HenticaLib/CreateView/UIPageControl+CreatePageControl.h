//
//  UIPageControl+CreatePageControl.h
//  Peccancy
//
//  Created by mini2 on 16/10/8.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPageControl (CreatePageControl)

///创建
+(UIPageControl*)createPageControl;

///获取
+(UIPageControl*)getPageControlForTag:(NSInteger)tag inParentView:(UIView*)view;

@end
