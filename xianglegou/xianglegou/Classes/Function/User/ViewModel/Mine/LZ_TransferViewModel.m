//
//  LZ_TransferViewModel.m
//  xianglegou
//
//  Created by mini1 on 2017/8/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "LZ_TransferViewModel.h"

@implementation LZ_TransferViewModel



///用户转账方法
- (void)setUserTransferWithResultBlock:(RequestResultBlock)resultBlock{

    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_transferRebate dictionaryParam:[self.transferModel toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///验证转账方法
-(void)getVerifyReceiverWithResultBlock:(RequestResultBlock)resultBlock{

    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_verifyReceiver dictionaryParam:self.verifyReceiverParam  withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];

}

///用户转账参数
-(LZ_UserTransferRequestDataModel *)transferModel
{

    if(!_transferModel){
    _transferModel = [[LZ_UserTransferRequestDataModel alloc] initWithDictionary:@{}];
        
        
    }
    return _transferModel;

}

- (NSMutableDictionary *)verifyReceiverParam
{
    if(!_verifyReceiverParam){
        _verifyReceiverParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [_verifyReceiverParam setObject:@"" forKey:@"userId"];
        //用户token
        [_verifyReceiverParam setObject:@"" forKey:@"token"];
        
        [_verifyReceiverParam setObject:@"" forKey:@"receiverMobile"];
        
    }
    return _verifyReceiverParam;
}

@end
