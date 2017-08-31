//
//  UIButton+CreateButton.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CreateButton)

///创建
+(UIButton*)createButtonWithTitle:(NSString*)title backgroundNormalImage:(NSString*)normalImage backgroundPressImage:(NSString*)pressImage target:(id)target action:(SEL)action;

///创建
+(UIButton*)createButtonWithTitle:(NSString*)title normalImage:(NSString*)normalImage pressImage:(NSString*)pressImage target:(id)target action:(SEL)action;

///创建
+(UIButton*)createNoBgButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

///获取
+(UIButton*)getButtonForTag:(NSInteger)tag inParentView:(UIView*)view;

///设置标题
-(void)setTitle:(NSString*)title;

///设置字体颜色
-(void)setTitleClor:(UIColor*)color;

@end
