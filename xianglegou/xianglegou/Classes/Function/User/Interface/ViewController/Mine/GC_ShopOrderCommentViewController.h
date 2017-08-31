//
//  GC_ShopOrderCommentViewController.h
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  商户订单 评论界面
//

#import "Hen_BaseViewController.h"
#import "QL_ShopModel.h"

@interface GC_ShopOrderCommentViewController : Hen_BaseViewController
///订单数据
@property (nonatomic, strong) QL_ShopOrderListDataModel *orderData;

///评论状态 1、未回复 2、已回复
@property (nonatomic, strong) NSString *replyState;


///返回回调
@property (nonatomic, copy) void(^onReturnClickBlock)();
@end
