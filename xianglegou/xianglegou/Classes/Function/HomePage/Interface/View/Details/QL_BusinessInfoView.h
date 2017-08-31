//
//  QL_BusinessInfoView.h
//  Rebate
//
//  Created by mini2 on 17/3/21.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 商家信息view
//

#define BI_SegmentHeight   HEIGHT_TRANSFORMATION(70)
#define BI_ViewHeight      HEIGHT_TRANSFORMATION(800)

#import <UIKit/UIKit.h>
#import "QL_BusinessModel.h"

@interface QL_BusinessInfoView : UIView

///选择回调
@property(nonatomic, copy) void(^onSelectItemBlock)(NSInteger item);
///地址回调
@property(nonatomic, copy) void(^onAddressBlock)();

///更新ui
- (void)updateUIForData:(QL_BussinessDetialsDataModel *)data;
///更新图片
- (void)updatePngForImageArray:(NSMutableArray *)imageArray;

@end
