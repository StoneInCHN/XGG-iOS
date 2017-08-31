//
//  UIView+HenticaCreate.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UIView+HenticaCreate.h"

@implementation UIView (HenticaCreate)

///创建UIView
+(UIView*)createViewWithBackgroundColor:(UIColor*)color
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    
    return view;
}

+(UIView*)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor*)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    return view;
}

///获取UIView
+(UIView*)getViewForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UIView *subView = [view viewWithTag:tag];
    
    return subView;
}

///图片圆形
-(void)makeRadiusForWidth:(CGFloat)width
{
    //告诉layer将位于它之下的layer都遮住
    self.layer.masksToBounds = YES;
    //设置layer的圆角，刚好是自身宽度的一半，这样就成了圆
    self.layer.cornerRadius = width*0.5;
    //设置边框宽度
    self.layer.borderWidth = 0;
    //设置边框颜色
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
