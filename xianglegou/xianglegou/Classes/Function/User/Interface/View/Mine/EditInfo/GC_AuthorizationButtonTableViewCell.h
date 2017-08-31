//
//  GC_AuthorizationButtonTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  授权按钮 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_AuthorizationButtonTableViewCell : Hen_BaseTableViewCell
///解除授权 回调
@property (nonatomic, copy) void(^onDeauthorizeBlock)(NSInteger item);
///重新授权 回调
@property (nonatomic, copy) void(^onReauthorizationBlock)(NSInteger item);

@end
