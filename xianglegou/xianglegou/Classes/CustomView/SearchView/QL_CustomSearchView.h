//
//  QL_CustomSearchView.h
//  MenLi
//
//  Created by mini2 on 16/6/25.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QL_CustomSearchModel : Hen_JsonModel

///名字
@property(nonatomic, strong) NSString *Name;
///ID
@property(nonatomic, strong) NSString *Id;

//中文转的英文
@property (nonatomic, strong) NSString *englishName;

@end

@interface QL_CustomSearchView : UIView

///数据源
@property(nonatomic, strong) NSMutableArray *dataSource;

///选择回调
@property(nonatomic, copy) void(^customSearchChoiceItme)(QL_CustomSearchModel* model);

///点击头部回调
@property(nonatomic, copy) void(^onTableViewHeaderActionBlock)();


///设置搜索占位符
-(void)setSearchBarPlaceholder:(NSString*)placeholder;

///设置顶部固定view 热门城市view
-(void)setTopFixedView:(UIView*)view andHotCityView:(UIView *)hotCityView;
/// Change search bar background
-(void)setChangeSearchBarBackgroundImage:(NSString *)image;
///更新ui
- (void)updateUI;

@end
