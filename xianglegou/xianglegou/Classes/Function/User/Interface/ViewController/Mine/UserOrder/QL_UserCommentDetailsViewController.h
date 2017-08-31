//
//  QL_UserCommentDetailsViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 评价详情界面
//

#import "Hen_BaseViewController.h"
#import "GC_UserOrderInfoModel.h"

@interface QL_UserCommentDetailsViewController : Hen_BaseViewController
///订单数据
@property (nonatomic, strong) GC_MResOrderUnderUserDataModel *orderData;
///返回回调
@property (nonatomic, copy) void(^onBackClickBlock)();

///发表  1、刚发表
@property (nonatomic, assign) NSInteger publicState;
@end
