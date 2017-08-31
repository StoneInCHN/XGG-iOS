//
//  GC_BankCardListTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  银行卡列表 -- cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_BankBindingModel.h"
#import "GC_BankBindingViewModel.h"

@interface GC_BankCardListTableViewCell : Hen_BaseTableViewCell

///删除成功 回调
@property (nonatomic, copy) void(^onDeleteSuccessBlock)();

///设置默认回调
@property (nonatomic, copy) void(^onSetUpDefault)(NSString *entityId, NSInteger item);

///ViewModel
@property (nonatomic, strong) GC_BankBindingViewModel *viewModel;
///更新UI
-(void)updateUiForMyCardListData:(GC_MResBankCardMyCardListDataModel *)data;


///屏蔽
- (void)setShieldFeatures;

@end
