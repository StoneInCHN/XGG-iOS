//
//  HV_PayManager.h
//  dentistry
//
//  Created by mini3 on 16/5/16.
//  Copyright © 2016年 hentica. All rights reserved.
//
/*
alipay 
 1,依赖系统库
 CoreMotion.framework
 CFNetwork.framework
 SystemConfiguration.framework
 CoreTelephony.framework
 QuartzCore.framework
 CoreGraphics.framework
 2,配置URL Scheme
 项目名_myAlipay
wxpay
 配置第三方平台URL Scheme
 微信	微信appKey	wxdc1e388c3822c80b
UPPay
 1,依赖系统库
 CFNetwork.framework、ＳystemConfiguration.framework 、libz、
 2,添加一个URL Types回调协议
 myUPPay
 3、http请求设置
 需要在工程对应的plist文件中添加NSAppTransportSecurity  Dictionary 并同时设置里面NSAllowsArbitraryLoads 属性值为 YES
 4、添加协议白名单
 对应的plist文件中，添加LSApplicationQueriesSchemes  Array并加入uppaysdk、uppaywallet、uppayx1、uppayx2、uppayx3五个item
*/

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "QL_BusinessModel.h"

typedef NS_ENUM( NSInteger ,PayResultType) {
    payResultTypeSuccess,
    payResultTypeFailed
};

typedef void(^PayResultBlock)(PayResultType index);
typedef void(^IAPSignTheCheckBlock)(NSString *productId, NSString *tradeNo, NSString *receipt, NSString *orderId);

@interface Hen_PayManager : NSObject

+ (instancetype)sharedManager;

///初始化支付
- (void)initPay;

/// 支付宝支付
- (void)alipayActionWithPayInfoModel:(QL_PayInfoDataModel *)model;

/// 支付宝钱包支付回调
-(void)onAlipayOpenURL:(NSURL *)url;

/// 微信支付
- (void)wxpayActionWithPayInfoModel:(QL_PayInfoDataModel *)model;

/// 微信支付回调
-(void)onWXPayResp:(BaseResp*)resp;

/// 银联支付
- (void)unionPayWithPayInfoModel:(Hen_OrderPayInfoDataModel *)model andViewController:(UIViewController *)viewController;

/// 银联支付回调
-(void)onUPPayOpenURL:(NSURL *)url;

///IAP支付
- (void)iapPayWithPayInfoModel:(Hen_OrderPayInfoDataModel *)model;

///设置支付回调
- (void)setPayResultBlock:(PayResultBlock)block;
///设置iap验签回调
- (void)setiapPayResultBlock:(IAPSignTheCheckBlock)block;

@end
