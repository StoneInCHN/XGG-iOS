//
//  QL_PayBillViewModel.h
//  Rebate
//
//  Created by mini2 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 买单view model
//

#import "Hen_BaseViewModel.h"
#import "QL_BusinessRequestModel.h"
#import "QL_BusinessModel.h"
#import "GC_ShopManagerModel.h"

@interface QL_PayBillViewModel : Hen_BaseViewModel

///获取支付方式参数
@property(nonatomic, strong) QL_PayMemmentRequestDataModel *payMemmentParam;
///支付方式数据
@property(nonatomic, strong) NSMutableArray<QL_PayMentDataModel *> *payMentDatas;
///获取支付方式
- (void)getPaymentDatasWithResultBlock:(RequestResultBlock)resultBlock;



///获取支付相关信息 参数
@property (nonatomic, strong) GC_PayMentInfoRequestDataModel *payMentInfoParam;
///获取支付相关信息 数据
@property (nonatomic, strong) GC_PayMentInfoDataModel *payMentInfoData;
///获取支付相关信息 方法
- (void)getPayMentInfoDataWithResultBlock:(RequestResultBlock)resultBlock;



///订单支付参数
@property(nonatomic, strong) QL_OrderPayRequestDataModel *orderPayParam;
///支付数据
@property(nonatomic, strong) QL_PayInfoDataModel *payInfoData;
///订单支付
- (void)orderPayWithResultBlock:(RequestResultBlock)resultBlock;



///录单支付 参数
@property (nonatomic, strong) NSMutableDictionary *paySellerOrderParam;
///录单支付 数据
@property (nonatomic, strong) QL_PayInfoDataModel *paySellerOrderData;
///录单支付 方法
- (void)setPaySellerOrderDataWithResultBlock:(RequestResultBlock)resultBlock;


///验证支付密码 参数
@property (nonatomic, strong) NSMutableDictionary *verifyPayPwdParam;
///验证支付密码 方法
-(void)setVerifyPayPwdDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
