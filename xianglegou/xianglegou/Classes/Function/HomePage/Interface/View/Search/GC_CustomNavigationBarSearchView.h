//
//  GC_CustomNavigationBarSearchView.h
//  Ask
//
//  Created by mini3 on 16/11/25.
//  Copyright © 2016年 Ask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GC_CustomNavigationBarSearchView : UIView

///开始搜索回调
@property(nonatomic, copy) void(^onStartSearchBlock)(NSString *searchString);

///设置搜索条背景
-(void)setSearchBarBackgroundImage:(NSString*)imageName;

///设置占位符
-(void)setPlaceholder:(NSString*)placeholder color:(UIColor*)color;

///设置搜索内容字体颜色
-(void)setSearchContentTextColor:(UIColor*)color;

///设置搜索 弹出 键盘
-(void)setEjectKeyboard;
@end
