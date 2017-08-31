//
//  GC_ChecklistShoppingCartViewController.h
//  xianglegou
//
//  Created by mini3 on 2017/5/12.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  录单购物车 -- 界面
//

#import "Hen_BaseViewController.h"

@interface GC_ChecklistShoppingCartViewController : Hen_BaseViewController

///商户ID
@property (nonatomic, strong) NSString *sellerId;


///商家信息
@property(nonatomic, strong) QL_ShopInformationDataModel *shopInfoData;
@end
