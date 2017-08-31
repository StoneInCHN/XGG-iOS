//
//  GC_MineLeMindListTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  乐心列表 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_MineLeMindListTableViewCell : Hen_BaseTableViewCell

///更新ui
-(void)updateUiForLeMindRecData:(GC_MResLeMindRecDataModel*)data;
@end
