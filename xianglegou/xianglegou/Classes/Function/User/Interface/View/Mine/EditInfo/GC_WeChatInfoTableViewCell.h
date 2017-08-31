//
//  GC_WeChatInfoTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  微信信息 cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_WeChatInfoTableViewCell : Hen_BaseTableViewCell

///更新ui
-(void)setUpdateUiForUserDate:(GC_MResUserInfoDataModel*)data;
@end
