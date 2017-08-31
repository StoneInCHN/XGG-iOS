//
//  LZ_TransferRequestDataModel.h
//  xianglegou
//
//  Created by mini1 on 2017/8/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface LZ_TransferRequestDataModel : Hen_JsonModel

@end


///用户转账请求参数
@interface LZ_UserTransferRequestDataModel : Hen_JsonModel

///用户ID
@property (nonatomic ,strong) NSString *userId;

///用户token
@property (nonatomic ,strong) NSString  *token;

///转账类型    乐心  LE_MIND,     乐豆  LE_BEAN,  乐分  LE_SCORE
@property (nonatomic ,strong) NSString *transType;

///短信验证码
@property (nonatomic ,strong ) NSString *smsCode;

//转账接收手机号
@property (nonatomic ,strong ) NSString *cellPhoneNum;

//转账数量
@property (nonatomic ,strong ) NSString *amount;

@end
