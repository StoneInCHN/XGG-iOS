//
//  QL_HPBusinessListTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/13.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 首页--推荐商家列表cell
//

#import "Hen_BaseTableViewCell.h"
#import "QL_BusinessModel.h"
#import "GC_CollectionModel.h"

@interface QL_HPBusinessListTableViewCell : Hen_BaseTableViewCell

///更新ui
- (void)updateUIForData:(QL_BusinessListDataModel *)data;

///更新收藏列表数据ui
-(void)setUpdateUiForCollectionListData:(GC_MResCollectionListDataModel*)data;
@end
