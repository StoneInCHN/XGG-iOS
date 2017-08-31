//
//  GC_WDHeadInfoTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  提现 -- 头像信息
//

#import "Hen_BaseTableViewCell.h"

@interface GC_WDHeadInfoTableViewCell : Hen_BaseTableViewCell
///更新ui
-(void)setUpdateForWithdrawInfoData:(GC_MResWithdrawInfoDataModel*)data;
@end
