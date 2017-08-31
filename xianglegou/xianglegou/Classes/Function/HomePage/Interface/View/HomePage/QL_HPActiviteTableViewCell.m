//
//  QL_HPActiviteTableViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/13.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_HPActiviteTableViewCell.h"

@implementation QL_HPActiviteTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_HPActiviteTableViewCell";
    QL_HPActiviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_HPActiviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(292);
}

///初始化
- (void)initDefault
{
    self.backgroundColor = kCommonWhiteBg;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    
}

@end
