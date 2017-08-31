//
//  QL_AllCommentViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 全部评价界面
//

#import "Hen_BaseViewController.h"

@interface QL_AllCommentViewController : Hen_BaseViewController

///商家id
@property(nonatomic, strong) NSString *sellerId;
///评分
@property(nonatomic, strong) NSString *commentScore;

@end
