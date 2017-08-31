//
//  LZ_TransferViewModel.h
//  xianglegou
//
//  Created by mini1 on 2017/8/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "LZ_TransferRequestDataModel.h"

@interface LZ_TransferViewModel : Hen_BaseViewModel

///转账请求参数
@property (nonatomic ,strong) LZ_UserTransferRequestDataModel *transferModel;

///用户转账方法
- (void)setUserTransferWithResultBlock:(RequestResultBlock)resultBlock;


///验证转账用户参数
@property (nonatomic, strong) NSMutableDictionary *verifyReceiverParam;
///验证转账用户
-(void)getVerifyReceiverWithResultBlock:(RequestResultBlock)resultBlock;

@end
