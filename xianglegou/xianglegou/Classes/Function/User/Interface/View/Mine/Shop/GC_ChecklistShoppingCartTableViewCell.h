//
//  GC_ChecklistShoppingCartTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/12.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  录单购物车
//

#import "Hen_BaseTableViewCell.h"
#import "GC_ShopManagerModel.h"

@interface GC_ChecklistShoppingCartTableViewCell : Hen_BaseTableViewCell

///更新UI
- (void)updateUiForSellerOrderCartListData:(GC_MResSellerOrderCartListDataModel *)data;

///选中状态改变
-(void)setIsSelectedState:(BOOL)isSelected;

//选中回调
@property (nonatomic, copy) void(^onIsSelectedBlock)(BOOL isSelected ,NSInteger item);

///删除按钮 回调
@property (nonatomic, copy) void(^onDeletedUIButtonBlock)(NSInteger item, NSString *orderId);
@end
