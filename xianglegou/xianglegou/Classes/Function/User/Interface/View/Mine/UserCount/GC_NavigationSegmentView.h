//
//  GC_NavigationSegmentView.h
//  Rebate
//
//  Created by mini3 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  乐分和乐豆 自定义选择
//

#import <UIKit/UIKit.h>

///代理
@protocol GC_NavigationSegmentDelegate

@optional

///当前选中项
- (void)customNavigationSegmentCurrentItem:(NSInteger)item;

@end

@interface GC_NavigationSegmentView : UIView

///代理
@property(nonatomic, assign) id<GC_NavigationSegmentDelegate> delegate;

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
///设置默认字体和选中字体颜色
-(void)setDefaultFontColor:(UIColor*)defaultColor andSelectFontColor:(UIColor*)selectColor;
///设置上分界线显隐
-(void)setTopLineImageViewHidden:(BOOL)hidden;
///设置下分界线显隐
-(void)setBottomLineImageViewHidden:(BOOL)hidden;

@end
