//
//  QL_SILogoTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 店铺信息--logo信息cell
//

#import "Hen_BaseTableViewCell.h"

@interface QL_SILogoTableViewCell : Hen_BaseTableViewCell

///图片采集回调
@property(nonatomic, copy) void(^onPhotoCollectBlock)(UIImage *images);

///更新UI
- (void)updateUIForImage:(id)image;

@end
