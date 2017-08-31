//
//  QL_SIBusinessHoursTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  店铺信息--营业时段cell
//

#import "Hen_BaseTableViewCell.h"

@interface QL_SIBusinessHoursTableViewCell : Hen_BaseTableViewCell

///选择回调
@property(nonatomic, copy) void(^onSelectBlock)(NSString *businessHours);

///更新UI
- (void)updateUIForTime:(NSString *)time;

@end
