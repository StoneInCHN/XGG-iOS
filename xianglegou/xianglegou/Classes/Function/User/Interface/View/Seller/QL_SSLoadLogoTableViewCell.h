//
//  QL_SSLoadLogoTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 入驻店铺--上传logo图片cell
//

#import "Hen_BaseTableViewCell.h"

@interface QL_SSLoadLogoTableViewCell : Hen_BaseTableViewCell

///图片采集回调
@property(nonatomic, copy) void(^onPhotoCollectBlock)(UIImage *images);

@end
