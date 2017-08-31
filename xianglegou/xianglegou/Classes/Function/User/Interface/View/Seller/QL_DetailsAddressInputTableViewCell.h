//
//  QL_DetailsAddressInputTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/14.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 详细地址输入cell
//

#import "Hen_BaseTableViewCell.h"

@interface QL_DetailsAddressInputTableViewCell : Hen_BaseTableViewCell

///标题
@property(nonatomic, strong) NSString *title;
///信息
@property(nonatomic, strong) NSString *info;
///占位符
@property(nonatomic, strong) NSString *placeholder;

///输入完成回调
@property(nonatomic, copy) void(^onInputFinishBlock)(NSString *inputStr);
///输入改变回调
@property(nonatomic, copy) void(^onInputChangeBlock)(NSString *inputStr);
///点击定位回调
@property(nonatomic, copy) void(^onLocationBlock)();

///禁用TextView
- (void)setDisabledTextViewIsNo:(BOOL)isNO;

///定位 按钮是否隐藏
- (void)setPositioningHidden:(BOOL)isHidden;
@end
