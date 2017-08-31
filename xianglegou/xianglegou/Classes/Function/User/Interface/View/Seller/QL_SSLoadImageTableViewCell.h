//
//  QL_SSLoadImageTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 入驻店铺--上传图片cell
//


#import "Hen_BaseTableViewCell.h"

@interface QL_SSLoadImageTableViewCell : Hen_BaseTableViewCell

///图片采集回调
@property(nonatomic, copy) void(^onPhotoCollectBlock)(NSMutableArray *images);

///最多图片张数
@property(nonatomic, assign) NSInteger maxImageCount;
///标题
@property(nonatomic, strong) NSString *title;

///提示
@property (nonatomic ,strong) NSString *notice;

///设置提示显隐
- (void)setNoticeLabelHidden:(BOOL)hidden;

@end
