//
//  Hen_IAPPay.h
//  Ask
//
//  Created by mini2 on 17/2/23.
//  Copyright © 2017年 Ask. All rights reserved.
//
/*
 加入依赖系统库
    StoreKit.framework
 */

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

///缓存
@interface Hen_IAPPayCacheModel : NSObject

//已经处理了的支付结果
@property (nonatomic, strong) NSMutableArray *mDealedTransaction;

//获取一个实例
+ (Hen_IAPPayCacheModel *)sharedIAPPayCacheModel;

//已经处理了的支付结果
- (void)addTransaction:(id)anObject;
- (bool)checkTransaction:(SKPaymentTransaction *)pTransaction;

@end

@interface Hen_IAPPay : NSObject

///支付回调 status：0，交易成功；1，交易失败
@property(nonatomic, copy) void(^onPayBlock)(NSString *status, NSString *receipt);

//获取一个单实例
+ (Hen_IAPPay *)sharedIAPPay;

//打开IAP支付
- (bool)openIAPPayForProductId:(NSString *)productId;

@end
