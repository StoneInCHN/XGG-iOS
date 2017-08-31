//
//  QL_BusinessListViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 商家列表界面
//

#import "Hen_BaseViewController.h"
#import "QL_HomePageViewModel.h"

@interface QL_BusinessListViewController : Hen_BaseViewController

///搜索 内容
@property (nonatomic, strong) NSString *searchContent;
///分类id
@property(nonatomic, strong) NSString *categoryId;

///view model
@property(nonatomic, strong) QL_HomePageViewModel *viewModel;

@end
