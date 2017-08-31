//
//  QL_SSLoadImageTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 店铺信息--上传图片cell
//


#import "Hen_BaseTableViewCell.h"

@interface QL_SILoadImageTableViewCell : Hen_BaseTableViewCell

///图片采集回调
@property(nonatomic, copy) void(^onPhotoCollectBlock)(NSMutableArray *images);

///最多图片张数
@property(nonatomic, assign) NSInteger maxImageCount;
///标题
@property(nonatomic, strong) NSString *title;

///设置提示显隐
- (void)setNoticeLabelHidden:(BOOL)hidden;
///更新ui
- (void)updateUIForImageArray:(NSMutableArray *)imageArray;

@end
