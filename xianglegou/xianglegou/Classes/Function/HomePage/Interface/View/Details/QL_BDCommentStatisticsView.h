//
//  QL_BDCommentStatisticsView.h
//  Rebate
//
//  Created by mini2 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 商家详情--评论统计view
//

#import <UIKit/UIKit.h>

@interface QL_BDCommentStatisticsView : UIView

///星级
@property(nonatomic, strong) NSString *starScore;
///总数
@property(nonatomic, strong) NSString *commentTotal;

///隐藏下一步
- (void)hiddenNextImage;

@end
