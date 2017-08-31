//
//  QL_UserOrderDetailsTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 用户订单详情--详情cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_UserOrderInfoModel.h"
#import "QL_ShopModel.h"

@interface QL_UserOrderDetailsTableViewCell : Hen_BaseTableViewCell

///更新ui
- (void)setUpdateUiForOrderUnderUserData:(GC_MResOrderUnderUserDataModel*)data;

///更新UI
- (void)updateUIForShopOrderListData:(QL_ShopOrderListDataModel *)data;

///设置下一步显隐
- (void)setNextImageHidden:(BOOL)hidden;

///是否结算
@property (nonatomic, strong) NSString *isClearing;
@end
