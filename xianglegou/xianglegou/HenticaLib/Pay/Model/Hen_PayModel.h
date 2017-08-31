//
//  Hen_PayModel.h
//  Peccancy
//
//  Created by mini2 on 16/11/2.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface Hen_PayModel : Hen_JsonModel

@end

#pragma mark -- 订单支付数据

@interface Hen_OrderPayInfoDataModel : Hen_JsonModel

/// 订单编号
@property(nonatomic, strong) NSString *orderId;
/// 支付方式类型，1 支付宝；2 微信；3 银联；4 问币 100 IAP
@property(nonatomic, assign) NSInteger payType;
/// 支付数据，可以直接调用第三方支付(包括：支付宝支付数据)
@property(nonatomic, strong) NSString *payInfo;

/////////微信支付需要的数据
/// 公众号Id；APP支付为，partnerId
@property(nonatomic, strong) NSString *appId;
///商户号
@property(nonatomic, strong) NSString *partnerId;
/// 时间戳，距离1970-01-01 00:00:00的秒
@property(nonatomic, assign) NSInteger timeStamp;
/// 随机字符串，32位
@property(nonatomic, strong) NSString *nonceStr;
/// 参数为：package;
@property(nonatomic, strong) NSString *packageStr;

// JS支付为：prepay_id=***;APP支付为：Sign=WXPay
@property(nonatomic, strong) NSString *signType; // JS支付直接MD5
@property(nonatomic, strong) NSString *paySign; // 支付数据签名
@property(nonatomic, strong) NSString *prepayId; // 预支付id

////////// 银联
/// 交易号
@property(nonatomic, strong) NSString *tn;
/// 00：正式模式，01：测试模式
@property(nonatomic, strong) NSString *serverMode;

////////// IAP
@property(nonatomic, strong) NSString *iapTradeNo;
@property(nonatomic, strong) NSString *iapProductId;

@end

#pragma mark -- 支付方式数据

@protocol Hen_PaymentDataModel

@end

@interface Hen_PaymentDataModel : Hen_JsonModel

/// 支付方式类型
@property(nonatomic, strong) NSString *type;
/// 支付方式名字
@property(nonatomic, strong) NSString *name;
/// 支付方式图标
@property(nonatomic, strong) NSString *icon;

@end
