//
//  GC_FinishButtonTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  完成按钮 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_FinishButtonTableViewCell : Hen_BaseTableViewCell

///完成 按钮回调
@property (nonatomic, copy) void(^onFinshBlock)(NSInteger item);


///隐藏 协议按钮
-(void)setProtocolHidden:(BOOL)hidden;
@end
