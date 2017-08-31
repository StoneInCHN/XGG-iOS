//
//  QL_ListScreenSegmentView.h
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 列表筛选选择view
//

#import <UIKit/UIKit.h>

///代理
@protocol QL_ListScreenSegmentDelegate

@optional

///当前选中项
- (void)customScreenSegmentCurrentItem:(NSInteger)item andIsSelect:(BOOL)isSelect;

@end

@interface QL_ListScreenSegmentView : UIView

///代理
@property(nonatomic, assign) id<QL_ListScreenSegmentDelegate> delegate;

///当前选项
@property(nonatomic, assign) NSInteger currentItem;

///初始化
-(id)initWithHeight:(CGFloat)height;

///设置item
-(void)setItems:(NSArray*)nameArray;
///设置item名字
- (void)setItem:(NSInteger)item title:(NSString *)title;

///设置上分界线显隐
-(void)setTopLineImageViewHidden:(BOOL)hidden;
///设置下分界线显隐
-(void)setBottomLineImageViewHidden:(BOOL)hidden;

@end
