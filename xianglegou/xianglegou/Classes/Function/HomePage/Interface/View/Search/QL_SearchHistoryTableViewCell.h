//
//  QL_SearchHistoryTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/31.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 搜索历史cell
//

#import "Hen_BaseTableViewCell.h"

@interface QL_SearchHistoryTableViewCell : Hen_BaseTableViewCell

///内容
@property(nonatomic, strong) NSString *content;
///时间
@property(nonatomic, strong) NSString *time;

@end
