//
//  QL_PayBillInfoTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 买单--信息cell
//

#import "Hen_BaseTableViewCell.h"
#import "QL_BusinessModel.h"

@interface QL_PayBillInfoTableViewCell : Hen_BaseTableViewCell

///价格输入回调
@property(nonatomic, copy) void(^onPriceInputBlock)(NSString *price);
///备注输入回调
@property(nonatomic, copy) void(^onRemarkInputBlock)(NSString *remark);
///清空按钮 类型
-(void)setClearButtonHidden:(BOOL)hidden;
///更新
- (void)updateUIForData:(QL_BussinessDetialsDataModel *)data;

@end
