//
//  GC_BankInfoWithdrawTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/28.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseTableViewCell.h"
#import "GC_BankBindingModel.h"

@interface GC_BankInfoWithdrawTableViewCell : Hen_BaseTableViewCell


///更新界面
- (void)updateBankInfoUI:(GC_MResDefaultCardDataModel *)data;
@end
