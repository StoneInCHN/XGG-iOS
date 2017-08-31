//
//  UITableView+CreateTableView.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UITableView+CreateTableView.h"

@implementation UITableView (CreateTableView)

///创建
+ (UITableView *)createTableViewWithDelegateTarget:(id)delegateTarget
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = kCommonBackgroudColor;
    tableView.delegate = delegateTarget;
    tableView.dataSource = delegateTarget;
    
    return tableView;
}

///创建
+ (UITableView *)createTableViewWithDelegateTarget:(id)delegateTarget andTableViewStyle:(UITableViewStyle)tableViewStyle
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableViewStyle];
    tableView.delegate = delegateTarget;
    tableView.dataSource = delegateTarget;
    tableView.backgroundColor = kCommonBackgroudColor;
    
    return tableView;
}

///获取
+ (UITableView *)getTableViewForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UITableView *tableView = (UITableView*)[view viewWithTag:tag];
    
    return tableView;
}

///设置cell自动适配
- (void)setCellAutoAdaptationForEstimatedRowHeight:(CGFloat)rowHeight
{
    //iOS 8开始的自适应高度，可以不需要实现定义高度的方法
    //预设高度
    self.estimatedRowHeight = rowHeight;
    self.rowHeight = UITableViewAutomaticDimension;
}

@end
