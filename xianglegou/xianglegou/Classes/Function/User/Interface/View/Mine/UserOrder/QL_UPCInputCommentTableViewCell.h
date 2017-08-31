//
//  QL_UPCInputCommentTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 发表评价--填写评价cell
//

#import "Hen_BaseTableViewCell.h"

@interface QL_UPCInputCommentTableViewCell : Hen_BaseTableViewCell

///是否编辑
@property(nonatomic, assign) BOOL isEdit;

///评价回调
@property(nonatomic, copy) void(^onCommentContentBlock)(NSString *content);
///图片采集回调
@property(nonatomic, copy) void(^onPhotoCollectBlock)(NSMutableArray *images);

///更新UI
- (void)updateUIForCommentContent:(NSString *)content images:(NSMutableArray *)images;

@end
