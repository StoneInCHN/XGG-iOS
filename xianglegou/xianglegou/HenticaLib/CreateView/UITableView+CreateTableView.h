//
//  UITableView+CreateTableView.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CreateTableView)

///创建
+ (UITableView *)createTableViewWithDelegateTarget:(id)delegateTarget;

///创建
+ (UITableView *)createTableViewWithDelegateTarget:(id)delegateTarget andTableViewStyle:(UITableViewStyle)tableViewStyle;

///获取
+ (UITableView *)getTableViewForTag:(NSInteger)tag inParentView:(UIView*)view;

///设置cell自动适配
- (void)setCellAutoAdaptationForEstimatedRowHeight:(CGFloat)rowHeight;

@end
