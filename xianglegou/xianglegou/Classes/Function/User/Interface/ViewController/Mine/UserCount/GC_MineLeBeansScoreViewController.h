//
//  GC_MineLeBeansScoreViewController.h
//  Rebate
//
//  Created by mini3 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  乐分 乐豆 界面
//

#import "Hen_BaseViewController.h"

@interface GC_MineLeBeansScoreViewController : Hen_BaseViewController

///返回回调
@property(nonatomic, copy) void(^onBackBlock)();

///当前选择 0：乐分；1：乐豆
@property(nonatomic, assign) NSInteger currentItem;

/////当前乐豆
//@property (nonatomic, strong) NSString *curLeBean;
/////总乐豆
//@property (nonatomic, strong) NSString *totalLeBean;
//
/////当前乐分
//@property (nonatomic, strong) NSString *curLeScore;
/////总乐分
//@property (nonatomic, strong) NSString *totalLeScore;
@end
