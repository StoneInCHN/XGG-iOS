//
//  QL_PayBillViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 买单界面
//

#import "Hen_BaseTableViewController.h"
#import "QL_BusinessModel.h"

@interface QL_PayBillViewController : Hen_BaseTableViewController

///商家数据
@property(nonatomic, strong) QL_BussinessDetialsDataModel *businessData;

///商家id
@property(nonatomic, strong) NSString *sellerId;

@end
