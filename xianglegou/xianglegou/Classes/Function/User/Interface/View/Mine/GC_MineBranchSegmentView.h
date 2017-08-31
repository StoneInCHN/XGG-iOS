//
//  GC_MineBranchSegmentView.h
//  Rebate
//
//  Created by mini3 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  乐分 乐星 积分选择
//

#import <UIKit/UIKit.h>

@interface GC_MineBranchSegmentView : UIView
///点击回调
@property(nonatomic, copy) void(^onButtonClickBlock)(NSInteger item);
///初始化
-(id)initWithHeight:(CGFloat)height;
///设置item
-(void)setItems:(NSArray*)nameArray;
///设置数目
-(void)setItemCount:(NSString*)count index:(NSInteger)index;

@end
