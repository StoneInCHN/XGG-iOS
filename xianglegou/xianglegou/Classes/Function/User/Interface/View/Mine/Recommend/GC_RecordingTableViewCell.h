//
//  GC_RecordingTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  推荐记录 -- cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_RecommendModel.h"

@interface GC_RecordingTableViewCell : Hen_BaseTableViewCell

///更新 ui
-(void)setUpdateUiForRecommendRecData:(GC_MResRecommendRecDataModel*)data;
@end
