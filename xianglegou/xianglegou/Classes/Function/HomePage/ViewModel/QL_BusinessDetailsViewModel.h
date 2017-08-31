//
//  QL_BusinessDetailsViewModel.h
//  Rebate
//
//  Created by mini2 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 商家详情view model
//

#import "Hen_BaseViewModel.h"
#import "QL_BusinessRequestModel.h"
#import "QL_BusinessModel.h"

@interface QL_BusinessDetailsViewModel : Hen_BaseViewModel

///商家评论列表参数
@property(nonatomic, strong) QL_BusinessCommentListRequestDataModel *commentListParam;
///商家评论列表数据
@property(nonatomic, strong) NSMutableArray<QL_BusinessCommentListDataModel *> *commentListDatas;
///获取商家评论列表
- (void)getCommentListDatasWithResultBlock:(RequestResultBlock)resultBlock;

///商家详情参数
@property(nonatomic, strong) QL_BusinessDetailsRequestDataModel *detialsParam;
///商家详情数据
@property(nonatomic, strong) QL_BussinessDetialsDataModel *detailsData;
///获取商家详情
- (void)getBussinessDetialsDataWithResultBlock:(RequestResultBlock)resultBlock;

@end
