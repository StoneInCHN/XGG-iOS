//
//  QL_MSShopManagerTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 我的店铺--店铺管理cell
//

#import "Hen_BaseTableViewCell.h"

@interface QL_MSShopManagerTableViewCell : Hen_BaseTableViewCell

///点击回调
@property(nonatomic, copy) void(^onClickItemBlock)(NSInteger item);

@end
