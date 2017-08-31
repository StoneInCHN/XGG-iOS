//
//  QL_SearchViewIndexView.h
//  L09-UITableview01
//
//  Created by Harvey on 16/1/24.
//  Copyright © 2016年 mini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedIndexBlock)(NSString *title, NSInteger index);

@interface QL_SearchViewIndexView : UIView

@property (nonatomic, assign) CGFloat indexFontSize; /**< 字体大小 */
@property (nonatomic, strong) UIColor *indexColor;       /**< 字体颜色*/
@property (nonatomic, strong) UIColor *indexBackGroundColor;   /**< 背景颜色 */

@property (nonatomic, strong) UIView *inditorView;      /**< 指示View */

- (void)setSelectedBlock:(SelectedIndexBlock)selectedIndexBlock;

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray;

-(instancetype)initWithTitleArray:(NSArray*)titleArray;

-(void)updateButtonConstraints;

@end
