//
//  GC_ShopManagetViewModel.h
//  xianglegou
//
//  Created by mini3 on 2017/5/25.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "GC_ShopManagerModel.h"
#import "GC_PaymentListRequestDataModel.h"

@interface GC_ShopManagetViewModel : Hen_BaseViewModel
/// 让利的总金额
@property(nonatomic, strong) NSString *totalRebateAmount;

///店铺货款列表 参数
@property (nonatomic, strong) GC_PaymentListRequestDataModel *paymentListParam;
///店铺货款列表 数据
@property (nonatomic, strong) NSMutableArray<GC_MResPaymentListDataModel *> *paymentListDatas;
///店铺货款列表 方法
- (void)getPaymentListDatasWithResultBlock:(RequestResultBlock)resultBlock;





///货款明细 参数
@property (nonatomic, strong) NSMutableDictionary *paymentDetailParam;
///货款明细 数据
@property (nonatomic, strong) GC_MResPaymentDetailDataModel *paymentDetailData;
///货款明细 方法
- (void)getPaymentDetailDataWithResultBlock:(RequestResultBlock)resultBlock;





///录单自动填充商户信息 参数
@property (nonatomic, strong) NSMutableDictionary *getCurrentSellerInfoParam;
///录单自动填充商户信息 数据
@property (nonatomic, strong) GC_MResCurrentSellerInfoDataModel *getCurrentSellerInfoData;
///录单自动填充商户信息 方法
- (void)getCurrentSellerInfoWithResultBlock:(RequestResultBlock)resultBlock;




///录单根据手机号获取消费者信息 参数
@property (nonatomic, strong) NSMutableDictionary *userInfoByMobileParam;
///录单根据手机号获取消费者信息 数据
@property (nonatomic, strong) GC_MResUserInfoByMobileDataModel *userInfoByMobileData;
///录单根据手机号获取消费者信息 方法
- (void)getUserInfoByMobileDataWithResultBlock:(RequestResultBlock)resultBlock;





///录单加入购物车 参数
@property (nonatomic, strong) NSMutableDictionary *addOrderCartParam;
///录单加入购物车 数据
@property (nonatomic, strong) GC_MResOrderCartAddDataModel *addOrderCartData;
///录单加入购物车 方法
- (void)setAddOrderCartDataWithResultBlock:(RequestResultBlock)resultBlock;





///购物车批量录单 参数
@property (nonatomic, strong) NSMutableDictionary *confirmOrderParam;
///购物车批量录单 数据
@property (nonatomic, strong) GC_MResConfirmOrderCartDataModel *confirmOrderData;
///购物车批量录单 方法
- (void)setConfirmOrderDataWithResultBlock:(RequestResultBlock)resultBlock;




///录单购物车批量删除 参数
@property (nonatomic, strong) NSMutableDictionary *deleteSellerOrderCartParam;
///录单购物车批量删除 方法
- (void)setDeleteSellerOrderCartDataWithResultBlock:(RequestResultBlock)resultBlock;


///立即录单 参数
@property (nonatomic, strong) NSMutableDictionary *generateSellerOrderParam;
///立即录单 数据
@property (nonatomic, strong) GC_MResGenerateSellerOrderDataModel *generateSellerOrderData;
///立即录单 方法
- (void)setGenerateSellerOrderDataWithResultBlock:(RequestResultBlock)resultBlock;




///录单购物车列表 参数
@property (nonatomic, strong) NSMutableDictionary *sellerOrderCartListParam;
///录单购物车列表 数据
@property (nonatomic, strong) NSMutableArray<GC_MResSellerOrderCartListDataModel *> *sellerOrderCartListDatas;
///录单购物车列表 方法
- (void)getSellerOrderCartListDatasWithResultBlock:(RequestResultBlock)resultBlock;


///商户获取录单列表 参数
@property (nonatomic, strong) NSMutableDictionary *sellerOrderListParam;
///商户获取录单列表 数据
@property (nonatomic, strong) NSMutableArray<GC_MResSellerOrderListDataModel *> *sellerOrderListDatas;
///商户获取录单列表 方法
- (void)getSellerOrderListDatasWithResultBlock:(RequestResultBlock)resultBlock;





@end
