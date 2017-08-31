//
//  QL_SSInfoInputTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 入驻店铺--店铺信息输入cell
//

#import "Hen_BaseTableViewCell.h"

@interface QL_SSInfoInputTableViewCell : Hen_BaseTableViewCell

///输入回调
@property(nonatomic, copy) void(^onInfoContentBlock)(NSString *content);

///内容
@property(nonatomic, strong) NSString *content;
///隐藏提示
- (void)hiddenNotice;

@end
