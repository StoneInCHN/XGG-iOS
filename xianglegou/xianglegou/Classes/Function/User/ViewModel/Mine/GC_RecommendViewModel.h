//
//  GC_RecommendViewModel.h
//  Rebate
//
//  Created by mini3 on 17/4/7.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  推荐 数据请求
//

#import "Hen_BaseViewModel.h"
#import "GC_RecommendModel.h"

@interface GC_RecommendViewModel : Hen_BaseViewModel


///获取用户二维码信息 参数
@property (nonatomic, strong) NSMutableDictionary *qrCodeParam;
///获取用户二维码信息 数据
@property (nonatomic, strong) GC_MResQrCodeDataModel *qrCodeData;
///获取用户二维码信息 方法
-(void)getQrCodeDataWithResultBlock:(RequestResultBlock)resultBlock;



///获取用户推荐记录 参数
@property (nonatomic, strong) NSMutableDictionary *recommendRecParam;
///获取用户推荐记录 数据
@property (nonatomic, strong) NSMutableArray<GC_MResRecommendRecDataModel*>* recommendRecDatas;
///获取用户推荐记录 方法
-(void)getRecommendRecDatasWithResultBlock:(RequestResultBlock)resultBlock;


///业务员获取推荐商家列表 参数
@property (nonatomic, strong) NSMutableDictionary *recommendSellerParam;
///业务员获取推荐商家列表 数据
@property (nonatomic, strong) NSMutableArray<GC_MResRecommendSellerDataModel*> *recommendSellerDatas;
///业务员获取推荐商家列表 方法
- (void)getRecommendSellerRecDatasWithResultBlock:(RequestResultBlock)resultBlock;

@end
