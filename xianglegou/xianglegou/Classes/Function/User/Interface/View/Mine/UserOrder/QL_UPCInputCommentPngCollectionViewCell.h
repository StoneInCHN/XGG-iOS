//
//  QL_UPCInputCommentPngCollectionViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 发表评价--填写评价图片cell
//

#import "Hen_BaseCollectionViewCell.h"

@interface QL_UPCInputCommentPngCollectionViewCell : Hen_BaseCollectionViewCell

///删除回调
@property(nonatomic, copy) void(^onDeleteBlock)();
///图片下载回调
@property(nonatomic, copy) void(^onPngDownloadBlock)(UIImage *image, NSInteger item);

///更新ui
- (void)updateUIForImage:(id)image;
///更新ui
- (void)updateUIForImage:(id)imageData andItem:(NSInteger)item;

///删除按钮显隐
- (void)setDeleteButtonHidden:(BOOL)hidden;

@end
