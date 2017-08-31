//
//  QL_BDCommentTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 商家详情--评论cell
//

#import "Hen_BaseTableViewCell.h"
#import "QL_BusinessModel.h"

@interface QL_BDCommentTableViewCell : Hen_BaseTableViewCell

///更新高度回调
@property(nonatomic, copy) void(^onUpdateHeightBlock)();

///更新UI
- (void)updateUIForData:(QL_BusinessCommentListDataModel *)data;

@end
