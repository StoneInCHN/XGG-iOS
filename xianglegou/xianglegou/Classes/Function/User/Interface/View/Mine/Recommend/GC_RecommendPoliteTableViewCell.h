//
//  GC_RecommendPoliteTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  推荐有礼 -- cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_RecommendModel.h"

@interface GC_RecommendPoliteTableViewCell : Hen_BaseTableViewCell
///分享按钮 回调
@property (nonatomic, copy) void(^onShareItClickBlock) (NSInteger item);
///分享下载链接 回调
@property (nonatomic, copy) void(^onShareItDownloadlinkBlock) (NSInteger item);

///更新 ui
- (void)setUpdateUiForQrCodeData:(GC_MResQrCodeDataModel*)data;
@end
