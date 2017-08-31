//
//  QL_OrderManagerTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 订单管理cell
//

#import "Hen_BaseTableViewCell.h"
#import "QL_ShopModel.h"
#import "QL_OrderManagerViewModel.h"

@interface QL_OrderManagerTableViewCell : Hen_BaseTableViewCell

@property (nonatomic, assign)NSInteger currentItem;

///更新ui
- (void)updateUIForData:(QL_ShopOrderListDataModel *)data;

///获取cell高度 根据 订单类型  订单状态
+(CGFloat)getCellHeightForIsSallerOrder:(NSString *)isSallerOrder andStatus:(NSString *)status;

///ViewModel
@property (nonatomic, strong) QL_OrderManagerViewModel *viewModel;


///删除成功 回调
@property (nonatomic, copy) void(^onDelSuccess)();


///结算状态
@property (nonatomic, strong) NSString *isClearing;
@end
