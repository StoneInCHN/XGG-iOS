//
//  QL_SettledShopViewModel.h
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 入驻商铺view model
//

#import "Hen_BaseViewModel.h"
#import "QL_ShopModel.h"
#import "QL_ShopRequestDataModel.h"

@interface QL_SettledShopViewModel : Hen_BaseViewModel

///入驻参数
@property(nonatomic, strong) QL_SettledShopRequestDataModel *settledParam;
///logo图片
@property(nonatomic, strong) UIImage *logoImage;
///营业执照图片
@property(nonatomic, strong) UIImage *businessLicenseImage;
///环境照片
@property(nonatomic, strong) NSMutableArray *environmentalPhotos;
///承诺书
@property(nonatomic, strong) NSMutableArray *commitmentPhotos;

///行业类别数据
@property(nonatomic, strong) NSMutableArray<QL_SellerCategoryDataModel *> *sellerCategoryDatas;

///获取店铺的行业类别
- (void)getSellerCategoryWithResultBlock:(RequestResultBlock)resultBlock;
///入驻
- (void)settledShopWithResultBlock:(RequestResultBlock)resultBlock;

///获取类别信息
- (NSString *)getTypeInfo;




///验证手机号是否已注册会员或成为商家 参数
@property (nonatomic, strong) NSMutableDictionary *verifyMobileParam;
///验证手机号是否已注册会员或成为商家 方法
- (void)setEndUserVerifyMobileDataWithResultBlock:(RequestResultBlock)resultBlock;


@end
