//
//  GC_IdentityCardInfoTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  身份证 - cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_IdentityCardInfoTableViewCell : Hen_BaseTableViewCell
///正面照片 回调
@property (nonatomic, copy) void(^onPositivePicBlock)(UIImage *image);
///背面照片 回调
@property (nonatomic, copy) void(^onBackPicBlock)(UIImage *image);

@end
