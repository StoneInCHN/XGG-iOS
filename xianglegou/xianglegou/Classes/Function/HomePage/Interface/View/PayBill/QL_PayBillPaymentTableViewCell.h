//
//  QL_PayBillPaymentTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 买单--支付方式cell
//

#import "Hen_BaseTableViewCell.h"
#import "QL_BusinessModel.h"

@interface QL_PayBillPaymentTableViewCell : Hen_BaseTableViewCell

///更新ui
- (void)updateUIForData:(QL_PayMentDataModel *)data;

@end
