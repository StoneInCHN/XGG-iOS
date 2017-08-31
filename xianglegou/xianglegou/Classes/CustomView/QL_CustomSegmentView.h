//
//  QL_CustomSegmentView.h
//  Ask
//
//  Created by mini2 on 16/11/17.
//  Copyright © 2016年 Ask. All rights reserved.
//
// 自定义选择view
//

#import <UIKit/UIKit.h>

///代理
@protocol QL_CustomSegmentDelegate

@optional

///当前选中项
- (void)customSegmentCurrentItem:(NSInteger)item;

@end

@interface QL_CustomSegmentView : UIView

///代理
@property(nonatomic, assign) id<QL_CustomSegmentDelegate> delegate;

///当前选项
@property(nonatomic, assign) NSInteger currentItem;

///初始化
-(id)initWithHeight:(CGFloat)height;

///设置item
-(void)setItems:(NSArray*)nameArray;
///设置item
-(void)setUnLineItems:(NSArray*)nameArray;
///设置item名字
- (void)setItem:(NSInteger)item title:(NSString *)title;
///设置选中项
-(void)setSelectItem:(NSInteger)item;
///设置UIScrollView（需要滑动要设置）
-(void)setScrollView:(UIScrollView*)scrollView;
///设置默认，选中字体
- (void)setDefaultFont:(UIFont *)defaultFont selectFont:(UIFont *)selectFont;

///设置上分界线显隐
-(void)setTopLineImageViewHidden:(BOOL)hidden;
///设置下分界线显隐
-(void)setBottomLineImageViewHidden:(BOOL)hidden;

@end
