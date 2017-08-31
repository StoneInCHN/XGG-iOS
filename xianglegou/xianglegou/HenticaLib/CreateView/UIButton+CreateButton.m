//
//  UIButton+CreateButton.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UIButton+CreateButton.h"

@implementation UIButton (CreateButton)

///创建
+(UIButton*)createButtonWithTitle:(NSString*)title backgroundNormalImage:(NSString*)normalImage backgroundPressImage:(NSString*)pressImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:pressImage] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:pressImage] forState:UIControlStateSelected];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = kFontSize_28;
    [button setTitleColor:kFontColorBlack forState:UIControlStateNormal];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

///创建
+(UIButton*)createButtonWithTitle:(NSString*)title normalImage:(NSString*)normalImage pressImage:(NSString*)pressImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:pressImage] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:pressImage] forState:UIControlStateSelected];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = kFontSize_28;
    [button setTitleColor:kFontColorBlack forState:UIControlStateNormal];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

///创建
+(UIButton*)createNoBgButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = kFontSize_28;
    [button setTitleColor:kFontColorBlack forState:UIControlStateNormal];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

///获取
+(UIButton*)getButtonForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UIButton *button = (UIButton*)[view viewWithTag:tag];
    
    return button;
}

///设置标题
-(void)setTitle:(NSString*)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

///设置字体颜色
-(void)setTitleClor:(UIColor*)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

@end
