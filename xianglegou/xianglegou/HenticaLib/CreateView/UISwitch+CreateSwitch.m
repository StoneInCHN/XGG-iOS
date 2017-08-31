//
//  UISwitch+CreateSwitch.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UISwitch+CreateSwitch.h"

@implementation UISwitch (CreateSwitch)

///创建
+ (UISwitch *)createSwitchButtonWithTintColor:(UIColor *)tintColor target:(id)target action:(SEL)action
{
    UISwitch *switchButton = [[UISwitch alloc] init];
    switchButton.onTintColor = kFontColorBlue;
    
    [switchButton addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    return switchButton;
}

///获取
+(UISwitch*)getSwitchForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UISwitch *switchBt = (UISwitch*)[view viewWithTag:tag];
    
    return switchBt;
}

@end
