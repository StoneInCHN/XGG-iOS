//
//  UIBarButtonItem+CreateBarButtonItem.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UIBarButtonItem+CreateBarButtonItem.h"
#import "UIButton+CreateButton.h"

@implementation UIBarButtonItem (CreateBarButtonItem)

///创建右按钮
+ (UIBarButtonItem*)createRightBarButtonItemWithNormalImage:(NSString*)normalImage pressImage:(NSString*)pressImage target:(id)target action:(SEL)action
{
    UIButton *rightButton = [UIButton createButtonWithTitle:@"" normalImage:normalImage pressImage:pressImage target:target action:action];
    rightButton.frame = CGRectMake(0, 0, 54, 44);
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    item.style = UIBarButtonItemStyleDone;
    
    return item;
}

///创建
+ (UIBarButtonItem*)createBarButtonItemWihNormalImage:(NSString *)normalImage pressImage:(NSString *)pressImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:pressImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:normalImage]];
    button.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

///创建
+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action\
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:action];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  kFontSize_28, NSFontAttributeName, color, NSForegroundColorAttributeName,
                                  nil]  forState:UIControlStateNormal];
    return item;
}

///获取
+ (UIBarButtonItem *)getBarButtonItemForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UIBarButtonItem *barButton = (UIBarButtonItem*)[view viewWithTag:tag];
    
    return barButton;
}

@end
