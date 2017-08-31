//
//  QL_UPCInfoTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 发表评价--信息cell
//

#import "Hen_BaseTableViewCell.h"
#import "GC_UserOrderInfoModel.h"

@interface QL_UPCInfoTableViewCell : Hen_BaseTableViewCell

///评分回调
@property(nonatomic, copy) void(^onCommentScoreBlock)(NSInteger star);

///是否编辑
@property(nonatomic, assign) BOOL isEdit;

///更新 ui
-(void)setUpdateUiForOrderUnderUserData:(GC_MResOrderUnderUserDataModel*)data;

///服务评分
@property (nonatomic, strong) NSString *score;

///更新 ui
-(void)setUpdateUiForEvaluateByOrderData:(GC_MResEvaluateByOrderDataModel*)data;
@end
