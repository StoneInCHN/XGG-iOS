//
//  GC_CollectionRequestDataModel.h
//  Rebate
//
//  Created by mini3 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_CollectionRequestDataModel : Hen_JsonModel

@end

#pragma mark -- 收藏列表请求 数据

@interface GC_CollectionListRequestDataModel : Hen_JsonModel

///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///用户所在位置纬度
@property (nonatomic, strong) NSString *latitude;
///用户所在位置经度
@property (nonatomic, strong) NSString *longitude;
///分页：页数
@property (nonatomic, strong) NSString *pageNumber;
///分页：每页大小
@property (nonatomic, strong) NSString *pageSize;
@end
