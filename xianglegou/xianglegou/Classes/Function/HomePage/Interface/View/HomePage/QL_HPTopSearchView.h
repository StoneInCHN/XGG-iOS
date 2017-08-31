//
//  QL_HPTopSearchView.h
//  Rebate
//
//  Created by mini2 on 17/3/20.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 首页顶部搜索view
//

#import <UIKit/UIKit.h>

@interface QL_HPTopSearchView : UIView

///城市选择回调
@property(nonatomic, copy) void(^onCityChooiceBlock)();

///更新城市名
- (void)updateCityName;

@end
