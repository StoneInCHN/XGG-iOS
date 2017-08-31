//
//  QL_BDInformationTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 商家详情--店铺简介cell
//

#import "Hen_BaseTableViewCell.h"
#import "QL_BusinessModel.h"

@interface QL_BDInformationTableViewCell : Hen_BaseTableViewCell

///更新UI
- (void)updateUIForData:(QL_BussinessDetialsDataModel *)data;

@end
