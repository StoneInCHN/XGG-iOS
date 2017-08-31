//
//  UIView+HenticaCreate.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HenticaCreate)

///创建UIView
+(UIView*)createViewWithBackgroundColor:(UIColor*)color;

+(UIView*)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor*)color;

///获取UIView
+(UIView*)getViewForTag:(NSInteger)tag inParentView:(UIView*)view;

///图片圆形
-(void)makeRadiusForWidth:(CGFloat)width;

@end
