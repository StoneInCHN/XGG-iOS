//
//  QL_SIOtherServiceTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 店铺信息--其他服务
//

#import "Hen_BaseTableViewCell.h"

@interface QL_SIOtherServiceTableViewCell : Hen_BaseTableViewCell

///选择回调
@property(nonatomic, copy) void(^onSelectBlock)(NSString *select);

///更新ui
- (void)updateUIForService:(NSString *)service;

@end
