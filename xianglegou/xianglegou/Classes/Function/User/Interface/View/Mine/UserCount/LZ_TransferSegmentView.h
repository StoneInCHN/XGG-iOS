//
//  GC_TransferSegmentView.h
//  xianglegou
//
//  Created by mini1 on 2017/8/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZ_TransferSegmentView : UIView

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
