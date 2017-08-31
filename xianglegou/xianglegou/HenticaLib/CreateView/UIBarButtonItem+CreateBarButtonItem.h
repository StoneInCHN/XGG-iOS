//
//  UIBarButtonItem+CreateBarButtonItem.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CreateBarButtonItem)

///创建右按钮
+ (UIBarButtonItem*)createRightBarButtonItemWithNormalImage:(NSString*)normalImage pressImage:(NSString*)pressImage target:(id)target action:(SEL)action;

///创建
+ (UIBarButtonItem*)createBarButtonItemWihNormalImage:(NSString *)normalImage pressImage:(NSString *)pressImage target:(id)target action:(SEL)action;

///创建
+ (UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor*)color target:(id)target action:(SEL)action;

///获取
+ (UIBarButtonItem *)getBarButtonItemForTag:(NSInteger)tag inParentView:(UIView*)view;

@end
