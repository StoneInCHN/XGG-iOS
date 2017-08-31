//
//  Hen_IAPPay.m
//  Ask
//
//  Created by mini2 on 17/2/23.
//  Copyright © 2017年 Ask. All rights reserved.
//

#import "Hen_IAPPay.h"
#import <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation Hen_IAPPayCacheModel

//获取一个实例
+ (Hen_IAPPayCacheModel*)sharedIAPPayCacheModel
{
    static Hen_IAPPayCacheModel* pPayDataModel = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        pPayDataModel = [[self alloc] init];
    });
    
    return pPayDataModel;
}

//已经处理了的支付结果
- (void)addTransaction:(id)anObject
{
    if (!_mDealedTransaction) {
        _mDealedTransaction = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (anObject)
    {
        [self.mDealedTransaction addObject:anObject];
    }
}

- (bool)checkTransaction:(SKPaymentTransaction *)pTransaction
{
    if (!self.mDealedTransaction) {
        return false;
    }
    
    return [self.mDealedTransaction containsObject:pTransaction];
}


@end

@interface Hen_IAPPay()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

///product id
@property(nonatomic, strong) NSString *productId;

@end

@implementation Hen_IAPPay

//获取一个单实例
+ (Hen_IAPPay *)sharedIAPPay
{
    static Hen_IAPPay* pPayIAPUtil = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        pPayIAPUtil = [[self alloc] init];
    });
    
    return pPayIAPUtil;
}

-(id) init{
    
    // 设置购买队列的监听器
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    
    return self;
}

//打开IAP支付
- (bool)openIAPPayForProductId:(NSString *)productId
{
    if (![self CheckNetwork]) {
        [DATAMODEL.alertManager showNetworkErrorMessage:@"网络连接错误！"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
            }
        }];
        return false;
    }
    
    if (productId) {
        
        self.productId = productId;
        
        if ([SKPaymentQueue canMakePayments]) {
            
            [DATAMODEL.progressManager showPayHud:@"获取支付信息..."];
    
            SKProductsRequest* pRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:productId]];
            pRequest.delegate = self;
            [pRequest start];
        } else {
            [DATAMODEL.alertManager showOneButtonWithMessage:@"无法进行应用内购买！"];
            [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
                if(buttonIndex == 0){
                }
            }];
        }
    } else {
        [DATAMODEL.alertManager showOneButtonWithMessage:@"订单错误，请重新尝试！"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
            }
        }];
    }
    
    return true;
}

// Sent immediately before -requestDidFinish:
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [DATAMODEL.progressManager hideHud];
    
    SKProduct *pProduct = [[response products]lastObject];
    if (!pProduct) {
        // 商品不存在
        [DATAMODEL.alertManager showOneButtonWithMessage:@"商品不存在，请重新尝试！"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
            }
        }];
        return;
    }
    
    [DATAMODEL.progressManager showPayHud:@"正在支付中..."];
    
    SKPayment* pPayMent = [SKPayment paymentWithProduct:pProduct];
    [[SKPaymentQueue defaultQueue]addPayment:pPayMent];
}
//////////////////////////////////////////////////////////////////////////////////////
// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction* pTranscation in transactions)
    {
        if ([[Hen_IAPPayCacheModel sharedIAPPayCacheModel] checkTransaction:pTranscation]) {
            continue;
        }
        switch (pTranscation.transactionState) {
            case SKPaymentTransactionStatePurchasing:    // Transaction is being added to the server queue.
            { //交易正在进行
                break;
            }
            case SKPaymentTransactionStatePurchased:     // Transaction is in queue, user has been charged.  Client should complete the transaction.
            { //交易完成
                [self CompletedPurchaseTransaction:pTranscation];
                break;
            }
            case SKPaymentTransactionStateFailed:        // Transaction was cancelled or failed before being added to the server queue.
            { //交易失败
                [self HandFailedTransaction:pTranscation];
                break;
            }
            case SKPaymentTransactionStateRestored:       // Transaction was restored from user's purchase history.  Client should complete the transaction.
            { //已经购买
                [self CompletedPurchaseTransaction:pTranscation];
                break;
            }
                
            default:
                break;
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//交易完成
-(void)CompletedPurchaseTransaction:(SKPaymentTransaction*)pTransaction
{
    [DATAMODEL.progressManager hideHud];
    
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    /**
    BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
    BASE64是可以编码和解码的
    */
    NSString* receipt = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    if(self.onPayBlock){
        self.onPayBlock(@"0", receipt);
    }
    
    // 将交易从交易队列中删除
    [[SKPaymentQueue defaultQueue] finishTransaction:pTransaction];
}
//交易失败
-(void)HandFailedTransaction:(SKPaymentTransaction*)pTransaction
{
    [DATAMODEL.progressManager hideHud];
    
    [[Hen_IAPPayCacheModel sharedIAPPayCacheModel] addTransaction:pTransaction];
    
    if (pTransaction.error.code != SKErrorPaymentCancelled) {
        [DATAMODEL.alertManager showOneButtonWithMessage:@"支付失败，请重新尝试！"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
            }
        }];
    }
    
    if(self.onPayBlock){
        self.onPayBlock(@"1", @"");
    }
    
    // 将交易从交易队列中删除
    [[SKPaymentQueue defaultQueue]finishTransaction:pTransaction];
}

//检查网络
-(bool)CheckNetwork
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef pSCNetworkReachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags pFlags;
    
    bool pRetriFlag = SCNetworkReachabilityGetFlags(pSCNetworkReachabilityRef, &pFlags);
    
    if (!pRetriFlag) {
        return false;
    }
    
    bool isReachable = pFlags & kSCNetworkFlagsReachable;
    bool needConnetion = pFlags & kSCNetworkFlagsConnectionRequired;
    
    
    return (isReachable && !needConnetion) ? true : false;
}

@end
