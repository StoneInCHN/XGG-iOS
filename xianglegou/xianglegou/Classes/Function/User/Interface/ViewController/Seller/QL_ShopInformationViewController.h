//
//  QL_ShopInformationViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 店铺信息界面
//

#import "Hen_BaseViewController.h"
#import "QL_ShopModel.h"

@interface QL_ShopInformationViewController : Hen_BaseViewController

///修改成功回调
@property(nonatomic, copy) void(^onEditSuccessBlock)();

///商家信息
@property(nonatomic, strong) QL_ShopInformationDataModel *shopInfoData;

@end
