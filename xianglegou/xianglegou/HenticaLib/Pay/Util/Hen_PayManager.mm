//
//  HV_PayManager.m
//  dentistry
//
//  Created by mini3 on 16/5/16.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import "Hen_PayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"
#import "Hen_IAPPay.h"

Hen_PayManager *_payManager = nil;

@interface Hen_PayManager ()

@property (nonatomic, copy) PayResultBlock block;

@property(nonatomic, copy) IAPSignTheCheckBlock iapBlock;

@end

@implementation Hen_PayManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _payManager = [[Hen_PayManager alloc] init];
    });
    return _payManager;
}

///初始化支付
- (void)initPay
{
}

/// 支付宝支付
- (void)alipayActionWithPayInfoModel:(QL_PayInfoDataModel *)model
{
    [[AlipaySDK defaultService] payOrder:model.orderStr fromScheme:@"xianglegouMyAlipay" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if ([[resultDic getStringValueForKey:@"resultStatus" defaultValue:@""] isEqualToString:@"9000"]) {  // 支付成功
            NSLog(@"支付成功！");
            if (_block) {
                _block(payResultTypeSuccess);
            }
        } else { // 支付失败
            if (_block) {
                _block(payResultTypeFailed);
            }
        }
    }];
}

/// 支付宝钱包支付回调
-(void)onAlipayOpenURL:(NSURL *)url
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        if([[resultDic getStringValueForKey:@"resultStatus" defaultValue:@""] isEqualToString:@"9000"]){ // 支付成功
            NSLog(@"支付成功！");
            if (_block) {
                _block(payResultTypeSuccess);
            }
        }else{ // 支付失败
            if (_block) {
                _block(payResultTypeFailed);
            }
        }
    }];
}

/// 微信支付
- (void)wxpayActionWithPayInfoModel:(QL_PayInfoDataModel *)model
{
    //微信支付
    [WXApi registerApp:model.appid withDescription:WX_DESCRIPTION];
    
    //调起微信支付
    PayReq* req = [[PayReq alloc] init];
    //req.openID      = model.appId;
    req.partnerId   = model.partnerid;
    req.prepayId    = model.prepayid;
    req.nonceStr    = model.noncestr;
    req.timeStamp   = (int)model.timestamp;
    req.package     = model.package;
    req.sign        = model.sign;
    [WXApi sendReq:req];
}

/// 银联支付
- (void)unionPayWithPayInfoModel:(Hen_OrderPayInfoDataModel *)model andViewController:(UIViewController *)viewController
{
    [[UPPaymentControl defaultControl] startPay:model.tn fromScheme:@"myUPPay" mode:model.serverMode viewController:viewController];
}

/// 微信支付回调
-(void)onWXPayResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                if (_block) {
                    _block(payResultTypeSuccess);
                }
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                if (_block) {
                    _block(payResultTypeFailed);
                }
                break;
        }
    }
}

/// 银联支付回调
-(void)onUPPayOpenURL:(NSURL *)url
{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        //结果code为成功
        if([code isEqualToString:@"success"]) {
            if (_block) {
                _block(payResultTypeSuccess);
            }
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            if (_block) {
                _block(payResultTypeFailed);
            }
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            if (_block) {
                _block(payResultTypeFailed);
            }
        }
    }];
}
///IAP支付
- (void)iapPayWithPayInfoModel:(Hen_OrderPayInfoDataModel *)model
{
    Hen_IAPPay *iapPay = [Hen_IAPPay sharedIAPPay];
    [iapPay openIAPPayForProductId:model.iapProductId];
    //回调
    iapPay.onPayBlock = ^(NSString *status, NSString *receipt){
        if([status isEqualToString:@"0"]){ // 交易成功
            //验签
            if(_iapBlock){
                _iapBlock(model.iapProductId, model.iapTradeNo, receipt, model.orderId);
            }
        }else{
            if (_block) {
                _block(payResultTypeFailed);
            }
        }
    };
}

- (void)setPayResultBlock:(PayResultBlock)block
{
    _block = block;
}

///设置iap验签回调
- (void)setiapPayResultBlock:(IAPSignTheCheckBlock)block
{
    _iapBlock = block;
}

@end
