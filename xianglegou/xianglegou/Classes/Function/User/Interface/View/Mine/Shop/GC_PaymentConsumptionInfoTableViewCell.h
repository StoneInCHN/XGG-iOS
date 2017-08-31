//
//  GC_PaymentConsumptionInfoTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  货款消费 -- cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_ShopManagerModel.h"

@interface GC_PaymentConsumptionInfoTableViewCell : Hen_BaseTableViewCell

///更新ui
- (void)updateUiForPayMentOrdersData:(GC_MResPayMentOrdersDataModel *)data;
@end
