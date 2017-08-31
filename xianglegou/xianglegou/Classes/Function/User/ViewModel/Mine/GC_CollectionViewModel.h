//
//  GC_CollectionViewModel.h
//  Rebate
//
//  Created by mini3 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "GC_CollectionModel.h"
#import "GC_CollectionRequestDataModel.h"

@interface GC_CollectionViewModel : Hen_BaseViewModel

///用户收藏列表 参数
@property (nonatomic, strong) GC_CollectionListRequestDataModel *collectionParam;
///用户收藏列表 数据
@property (nonatomic, strong) NSMutableArray<GC_MResCollectionListDataModel*>* collectionDatas;
///用户收藏列表 方法
-(void)getFavoriteSellerListDatasWithResultBlock:(RequestResultBlock)resultBlock;
@end
