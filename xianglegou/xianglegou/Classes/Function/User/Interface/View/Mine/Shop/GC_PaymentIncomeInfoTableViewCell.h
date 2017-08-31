//
//  GC_PaymentIncomeInfoTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  货款收益 -- cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_ShopManagerModel.h"

@interface GC_PaymentIncomeInfoTableViewCell : Hen_BaseTableViewCell

///更新 ui
- (void)updateUIForPayMentDetailsData:(GC_MResPaymentDetailDataModel *)data;

@end
