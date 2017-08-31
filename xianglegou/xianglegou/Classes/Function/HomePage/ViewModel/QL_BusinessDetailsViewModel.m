//
//  QL_BusinessDetailsViewModel.m
//  Rebate
//
//  Created by mini2 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BusinessDetailsViewModel.h"

@implementation QL_BusinessDetailsViewModel

///获取商家评论列表
- (void)getCommentListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:seller_evaluateList dictionaryParam:[self.commentListParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSDictionary *dic in msg){
                [array addObject:[[QL_BusinessCommentListDataModel alloc] initWithDictionary:dic]];
            }
            if([self.commentListParam.pageNumber isEqualToString:@"1"]){
                [self.commentListDatas removeAllObjects];
            }
            [self.commentListDatas addObjectsFromArray:array];
            
            if(resultBlock){
                resultBlock(code, desc, array, [page getStringValueForKey:@"total" defaultValue:@""]);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}

///获取商家详情
- (void)getBussinessDetialsDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:seller_detail dictionaryParam:[self.detialsParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.detailsData = [[QL_BussinessDetialsDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.detailsData, nil);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}

#pragma mark -- getter,setter

///商家评论列表参数
- (QL_BusinessCommentListRequestDataModel *)commentListParam
{
    if(!_commentListParam){
        _commentListParam = [[QL_BusinessCommentListRequestDataModel alloc] initWithDictionary:@{}];
        
        _commentListParam.pageNumber = @"1";
        _commentListParam.pageSize = NumberOfPages;
    }
    return _commentListParam;
}
///商家评论列表数据
- (NSMutableArray<QL_BusinessCommentListDataModel *> *)commentListDatas
{
    if(!_commentListDatas){
        _commentListDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _commentListDatas;
}

///商家详情参数
- (QL_BusinessDetailsRequestDataModel *)detialsParam
{
    if(!_detialsParam){
        _detialsParam = [[QL_BusinessDetailsRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _detialsParam;
}

@end
