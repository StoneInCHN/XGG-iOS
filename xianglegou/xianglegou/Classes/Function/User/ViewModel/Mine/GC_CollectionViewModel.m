//
//  GC_CollectionViewModel.m
//  Rebate
//
//  Created by mini3 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_CollectionViewModel.h"

@implementation GC_CollectionViewModel

///用户收藏列表 方法
-(void)getFavoriteSellerListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_favoriteSellerList dictionaryParam:[self.collectionParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResCollectionListDataModel alloc] initWithDictionary:dic]];
            }
            
            if([self.collectionParam.pageNumber isEqualToString:@"1"]){
                [self.collectionDatas removeAllObjects];
            }
            [self.collectionDatas addObjectsFromArray:resultArray];
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}
#pragma mark -- getter,setter
///用户收藏列表 参数
- (GC_CollectionListRequestDataModel *)collectionParam
{
    if(!_collectionParam){
        _collectionParam = [[GC_CollectionListRequestDataModel alloc] initWithDictionary:@{}];
        _collectionParam.pageSize = NumberOfPages;
    }
    return _collectionParam;
}

- (NSMutableArray<GC_MResCollectionListDataModel *> *)collectionDatas
{
    if(!_collectionDatas){
        _collectionDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _collectionDatas;
}
@end
