//
//  QL_HPClassifyCollectionViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/20.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 首页分类cell--类型cell
//

#import "Hen_BaseCollectionViewCell.h"
#import "QL_ShopModel.h"

@interface QL_HPClassifyItemCollectionViewCell : Hen_BaseCollectionViewCell

///更新ui
- (void)updateUIForData:(QL_SellerCategoryDataModel *)data;

@end

@interface QL_HPClassifyCollectionViewCell : Hen_BaseCollectionViewCell

///更新ui
- (void)updateUIForData:(NSMutableArray *)array;

@end
