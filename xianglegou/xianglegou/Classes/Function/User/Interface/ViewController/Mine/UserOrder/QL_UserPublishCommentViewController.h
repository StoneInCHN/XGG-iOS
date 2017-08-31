//
//  QL_UserPublishCommentViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 发布评价界面
//

#import "Hen_BaseViewController.h"
#import "GC_UserOrderInfoModel.h"

@interface QL_UserPublishCommentViewController : Hen_BaseViewController
///订单数据
@property (nonatomic, strong) GC_MResOrderUnderUserDataModel *orderData;

///发表评论成功
@property (nonatomic, copy) void(^onPublishedSuccessBlock)();
@end
