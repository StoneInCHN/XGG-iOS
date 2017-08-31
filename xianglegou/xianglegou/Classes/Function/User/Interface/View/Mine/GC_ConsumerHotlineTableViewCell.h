//
//  GC_ConsumerHotlineTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  客服电话 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_ConsumerHotlineTableViewCell : Hen_BaseTableViewCell
///电话
@property (nonatomic, strong) NSString *customerMobile;
///服务时间
@property (nonatomic, strong) NSString *serviceTime;
@end
