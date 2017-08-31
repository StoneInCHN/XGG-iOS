//
//  GC_ShopOrderCommentViewModel.m
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_ShopOrderCommentViewModel.h"

@implementation GC_ShopOrderCommentViewModel

///商家回复用户评价 方法
-(void)setSellerReplyDataWithResuleBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_sellerReply dictionaryParam:self.sellerReplyParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///根据订单获取评价详情 方法
-(void)getEvaluateByOrderDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:order_getEvaluateByOrder dictionaryParam:[self.evaluateByOrderParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.evaluateByOrderData = [[GC_MResEvaluateByOrderDataModel alloc] initWithDictionary:msg];
            if(resultBlock){
                resultBlock(code, desc, self.evaluateByOrderData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
}

#pragma mark -- getter,setter
///商家回复用户评价 参数
- (NSMutableDictionary *)sellerReplyParam
{
    if(!_sellerReplyParam){
        _sellerReplyParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_sellerReplyParam setObject:@"" forKey:@"userId"];
        //用户token
        [_sellerReplyParam setObject:@"" forKey:@"token"];
        //评价记录ID
        [_sellerReplyParam setObject:@"" forKey:@"entityId"];
        //商家回复
        [_sellerReplyParam setObject:@"" forKey:@"sellerReply"];
    }
    return _sellerReplyParam;
}


///根据订单获取评价详情 参数
- (GC_GetEvaluateByOrderRequestDataModel *)evaluateByOrderParam
{
    if(!_evaluateByOrderParam){
        _evaluateByOrderParam = [[GC_GetEvaluateByOrderRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _evaluateByOrderParam;
}

///根据订单获取评价详情 方法
- (GC_MResEvaluateByOrderDataModel *)evaluateByOrderData
{
    if(!_evaluateByOrderData){
        _evaluateByOrderData = [[GC_MResEvaluateByOrderDataModel alloc] initWithDictionary:@{}];
    }
    return _evaluateByOrderData;
}
@end
