//
//  GC_CollectionModel.h
//  Rebate
//
//  Created by mini3 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_CollectionModel : Hen_JsonModel

@end


#pragma mark -- 收藏类别信息
@interface GC_MResCollectionSellerCategoryDataModel : Hen_JsonModel
///类别名称
@property (nonatomic, strong) NSString *categoryName;
@end

#pragma mark -- 收藏列表数据
@interface GC_MResCollectionListDataModel : Hen_JsonModel
///地址信息
@property (nonatomic, strong) NSString *address;
///距离
@property (nonatomic, strong) NSString *distance;
///消费金额
@property (nonatomic, strong) NSString *unitConsume;
///平均
@property (nonatomic, strong) NSString *avgPrice;
///维度
@property (nonatomic, strong) NSString *latitude;
///折扣
@property (nonatomic, strong) NSString *discount;

@property (nonatomic, strong) NSString *rateScore;

///商户图片
@property (nonatomic, strong) NSString *storePictureUrl;
///商户类别信息
@property (nonatomic, strong) GC_MResCollectionSellerCategoryDataModel *sellerCategory;
@property (nonatomic, strong) NSString *rebateScore;
///商户名称
@property (nonatomic, strong) NSString *name;
///id
@property (nonatomic, strong) NSString *id;
///精度
@property (nonatomic, strong) NSString *longitude;
@end



