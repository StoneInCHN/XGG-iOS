//
//  CustomTableViewController.h
//  dentistry
//
//  Created by mini2 on 16/1/27.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hen_BaseTableViewController : UITableViewController

///加载navigationBar背景
-(void)loadNavigationBarBackground;
///加载返回按钮
-(void)loadNavigationBackButton;
///点击返回按钮
-(void)onTVCGoBackClick:(id)sender;

#pragma mark -- 子类必须重写并实现
///清除数据
-(void)cleanUpData;
///清除强引用视图
-(void)cleanUpStrongSubView;

@end
