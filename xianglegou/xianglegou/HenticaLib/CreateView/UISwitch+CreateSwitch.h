//
//  UISwitch+CreateSwitch.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (CreateSwitch)

///创建
+ (UISwitch *)createSwitchButtonWithTintColor:(UIColor *)tintColor target:(id)target action:(SEL)action;

///获取
+(UISwitch*)getSwitchForTag:(NSInteger)tag inParentView:(UIView*)view;

@end
