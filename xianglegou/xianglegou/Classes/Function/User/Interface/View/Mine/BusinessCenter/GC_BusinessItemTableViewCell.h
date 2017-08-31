//
//  GC_BusinessItemTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseTableViewCell.h"
#import "GC_BusinessModel.h"

@interface GC_BusinessItemTableViewCell : Hen_BaseTableViewCell

///更新 ui
- (void)updateUiForSellerCount:(GC_MResBusinessCountDataModel *)data;
@end
