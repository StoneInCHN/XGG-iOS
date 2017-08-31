//
//  QL_HotCityView.h
//  Rebate
//
//  Created by mini2 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 热门城市view
//

#import <UIKit/UIKit.h>

@interface QL_HotCityViewCollectionViewCell : Hen_BaseCollectionViewCell

///选择回调
@property(nonatomic, copy) void(^onClickBlock)();

///内容
@property(nonatomic, strong) NSString *content;
///是否选择
@property(nonatomic, assign) BOOL isSelect;

@end

@interface QL_HotCityView : UIView

///选择回调
@property(nonatomic, copy) void(^onSelectBlock)(NSString *cityId);
///数据加载完回调
@property(nonatomic, copy) void(^onDataLoadFinishBlock)();

///加载热门城市数据
- (void)loadHotCityData;

@end
