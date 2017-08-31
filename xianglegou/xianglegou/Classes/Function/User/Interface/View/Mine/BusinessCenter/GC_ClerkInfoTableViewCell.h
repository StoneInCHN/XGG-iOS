//
//  GC_ClerkInfoTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/7/8.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  业务员 - cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_BusinessModel.h"

@interface GC_ClerkInfoTableViewCell : Hen_BaseTableViewCell

///更新 ui
- (void)updateUiForSalesmanInfoData:(GC_SalesmanInfoDataModel *)data;
@end
