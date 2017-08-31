//
//  QL_OrderManagerViewController.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 订单管理界面
//

#import "Hen_BaseViewController.h"
#import "QL_ShopModel.h"

@interface QL_OrderManagerViewController : Hen_BaseViewController

///商家信息
@property(nonatomic, strong) QL_ShopInformationDataModel *shopInfoData;


///进入方式
@property (nonatomic, assign) BOOL paySuccess;

///当前选择
@property(nonatomic, assign) NSInteger navCurrentItem;
///订单状态
@property(nonatomic, assign) NSInteger currentItem;

///录单订单状态
@property(nonatomic, assign) NSInteger checkCurrentItem;
@end
