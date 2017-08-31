//
//  GC_MineIntegralListTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  积分信息 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_MineIntegralListTableViewCell : Hen_BaseTableViewCell

///更新积分ui
-(void)updateUiForScoreRecData:(GC_MResScoreRecDataModel*)data;

///更新乐分ui
-(void)updateUiForLeScoreRecData:(GC_MResLeScoreRecDataModel*)data;
///更新乐豆ui
-(void)updateUiForLeBeanRecData:(GC_MResLeBeanRecDataModel*)data;
@end
