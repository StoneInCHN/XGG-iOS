//
//  QL_MineOrderTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 我的订单--cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_UserOrderInfoModel.h"

@interface QL_MineOrderTableViewCell : Hen_BaseTableViewCell

///更新 ui
-(void)updateUiForOrderUnderUserData:(GC_MResOrderUnderUserDataModel*)data;

///未支付高度
+ (CGFloat)getCellHeightForUnPaid;
@end
