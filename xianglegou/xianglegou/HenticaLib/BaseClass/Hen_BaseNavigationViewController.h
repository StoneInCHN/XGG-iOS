//
//  Hen_BaseNavigationViewController.h
//  FinalWork
//
//  Created by Geforceyu on 14/10/29.
//  Copyright (c) 2014年 rimi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Hen_BaseNavigationViewController : UINavigationController

///背景
@property(nonatomic, strong) UIView *bgView;

///背景显隐
@property(nonatomic, assign, readonly) BOOL backgroundHidden;

///设置标题颜色
-(void)setNavigationBarTitleColor:(UIColor*)color;

///设置背景
-(void)setNavigationBarBgColor:(UIColor*)color;

///设置默认背景
-(void)setDefaultBackground;

///设置背景显隐
-(void)setBackgroundHidden:(BOOL)hidden;

///设置下划线显隐
-(void)setShadowViewHidden:(BOOL)hidden;

///获取背景alpha
-(CGFloat)getBackgroundAlpha;

@end
