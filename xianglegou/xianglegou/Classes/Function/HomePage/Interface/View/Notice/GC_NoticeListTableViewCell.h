//
//  GC_NoticeListTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/7.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  通知 -- cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_NoticeModel.h"

@interface GC_NoticeListTableViewCell : Hen_BaseTableViewCell

///更新 ui
-(void)setUpdateUiForNoticesMsgData:(GC_MResNoticesMsgDataModel*)data;
@end
