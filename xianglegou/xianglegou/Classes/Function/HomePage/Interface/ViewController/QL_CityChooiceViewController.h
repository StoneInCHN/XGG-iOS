//
//  QL_CityChooiceViewController.h
//  Peccancy
//
//  Created by mini2 on 16/10/26.
//  Copyright © 2016年 Peccancy. All rights reserved.
//
// 城市选择界面
//

#import "Hen_BaseViewController.h"
#import "QL_CustomSearchView.h"

@interface QL_CityChooiceViewController : Hen_BaseViewController

///点击回调
@property(nonatomic, copy) void(^onChoiceItemBlock)(QL_AreaDataModel *data);

///标题
@property(nonatomic, strong) NSString *barTitel;

@end
