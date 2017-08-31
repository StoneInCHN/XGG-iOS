//
//  GC_RecommendedBusinessTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  推荐商家 -- cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_RecommendModel.h"

@interface GC_RecommendedBusinessTableViewCell : Hen_BaseTableViewCell

///更新 ui
-(void)setUpdateUiForRecommendSellerRecData:(GC_MResRecommendSellerDataModel*)data;
@end
