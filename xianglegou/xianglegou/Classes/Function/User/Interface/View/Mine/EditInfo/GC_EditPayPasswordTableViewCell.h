//
//  GC_EditPayPasswordTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  修改支付密码 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_EditPayPasswordTableViewCell : Hen_BaseTableViewCell
///输入完成回调
@property(nonatomic, copy) void(^onInputFinishBlock)(NSString *password);

///标题信息
@property (nonatomic, strong) NSString *titleInfo;
@end
