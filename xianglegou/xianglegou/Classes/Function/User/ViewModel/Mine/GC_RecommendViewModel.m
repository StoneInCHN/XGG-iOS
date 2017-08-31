//
//  GC_RecommendViewModel.m
//  Rebate
//
//  Created by mini3 on 17/4/7.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  推荐 数据请求
//

#import "GC_RecommendViewModel.h"

@implementation GC_RecommendViewModel
///获取用户二维码信息 方法
-(void)getQrCodeDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getQrCode dictionaryParam:self.qrCodeParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.qrCodeData = [[GC_MResQrCodeDataModel alloc] initWithDictionary:msg];
            
            
            if(resultBlock){
                resultBlock(code, desc, self.qrCodeData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}


///获取用户推荐记录 方法
-(void)getRecommendRecDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getRecommendRec dictionaryParam:self.recommendRecParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResRecommendRecDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.recommendRecParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.recommendRecDatas removeAllObjects];
            }
            
            [self.recommendRecDatas addObjectsFromArray:resultArray];
            
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


///业务员获取推荐商家列表 方法
- (void)getRecommendSellerRecDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getRecommendSellerRec dictionaryParam:self.recommendSellerParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResRecommendSellerDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.recommendSellerParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.recommendSellerDatas removeAllObjects];
            }
            
            [self.recommendSellerDatas addObjectsFromArray:resultArray];
            
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
///获取用户二维码信息 参数
- (NSMutableDictionary *)qrCodeParam
{
    if(!_qrCodeParam){
        _qrCodeParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_qrCodeParam setObject:@"" forKey:@"userId"];
        //用户token
        [_qrCodeParam setObject:@"" forKey:@"token"];
    }
    return _qrCodeParam;
}
///获取用户二维码信息 数据
- (GC_MResQrCodeDataModel *)qrCodeData
{
    if(!_qrCodeData){
        _qrCodeData = [[GC_MResQrCodeDataModel alloc] initWithDictionary:@{}];
    }
    return _qrCodeData;
}


///获取用户推荐记录 参数
- (NSMutableDictionary *)recommendRecParam
{
    if(!_recommendRecParam){
        _recommendRecParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //用户ID
        [_recommendRecParam setObject:@"" forKey:@"userId"];
        //用户token
        [_recommendRecParam setObject:@"" forKey:@"token"];
        //分页：页数
        [_recommendRecParam setObject:@"" forKey:@"pageNumber"];
        //分页：每页大小
        [_recommendRecParam setObject:NumberOfPages forKey:@"pageSize"];
    }
    return _recommendRecParam;
}


///获取用户推荐记录 数据
- (NSMutableArray<GC_MResRecommendRecDataModel *> *)recommendRecDatas
{
    if(!_recommendRecDatas){
        _recommendRecDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _recommendRecDatas;
}


///业务员获取推荐商家列表 参数
- (NSMutableDictionary *)recommendSellerParam
{
    if(!_recommendSellerParam){
        _recommendSellerParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_recommendSellerParam setObject:@"" forKey:@"userId"];
        [_recommendSellerParam setObject:@"" forKey:@"token"];
        [_recommendSellerParam setObject:@"" forKey:@"pageNumber"];
        [_recommendSellerParam setObject:NumberOfPages forKey:@"pageSize"];
    }
    return _recommendSellerParam;
}

///业务员获取推荐商家列表 数据
- (NSMutableArray<GC_MResRecommendSellerDataModel *> *)recommendSellerDatas
{
    if(!_recommendSellerDatas){
        _recommendSellerDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _recommendSellerDatas;
}
@end
