//
//  GC_ShopReplyCommentTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  商家回复评价 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_ShopReplyCommentTableViewCell : Hen_BaseTableViewCell
///内容
@property(nonatomic, strong) NSString *content;
///占位符
@property(nonatomic, strong) NSString *placeholder;
///最多字数
@property(nonatomic, assign) NSInteger maxCount;

///输入完成回调
@property(nonatomic, copy) void(^onInputFinishBlock)(NSString *inputStr);

///回复信息输入 的显隐
- (void)setSellerReplyInputHidden:(BOOL)hidden;

///商家回复内容
@property (nonatomic, strong) NSString *sellerReplyInfo;
@end
