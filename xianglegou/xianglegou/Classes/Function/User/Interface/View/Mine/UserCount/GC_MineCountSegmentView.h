//
//  GC_MineCountSegmentView.h
//  Rebate
//
//  Created by mini3 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  我的计数 -- 分割显示
//

#import <UIKit/UIKit.h>

@interface GC_MineCountSegmentView : UIView

///初始化
-(id)initWithHeight:(CGFloat)height;

///设置item
-(void)setItems:(NSArray*)nameArray;
///设置item
-(void)setItems:(NSArray*)nameArray andLineImageName:(NSString *)lineName;

///设置数目
-(void)setItemCount:(NSString*)count index:(NSInteger)index;

///设置上分界线显隐
-(void)setTopLineImageViewHidden:(BOOL)hidden;
///设置下分界线显隐
-(void)setBottomLineImageViewHidden:(BOOL)hidden;

///设置背景
- (void)setBgColor:(UIColor *)color;


///选择Block
@property (nonatomic, copy)void(^onSelectedBlock)(NSInteger item);

@property (nonatomic, assign) NSInteger lineMargin;
@end
