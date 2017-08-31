//
//  CustomTabBarViewController.m
//  FinalWork
//
//  Created by Geforceyu on 14/10/29.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import "Hen_BaseTabBarViewController.h"

@interface Hen_BaseTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation Hen_BaseTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setExclusiveTouch:YES];
}

@end
