//
//  GC_BankBindingRequestDataModel.h
//  xianglegou
//
//  Created by mini3 on 2017/5/24.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_BankBindingRequestDataModel : Hen_JsonModel

@end


#pragma mark -- 银行卡四元素校验 请求参数

@interface GC_VerifyBankCardRequestDataModel : Hen_JsonModel
///登录用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///持卡人姓名
@property (nonatomic, strong) NSString *ownerName;
//银行卡号
@property (nonatomic, strong) NSString *cardNum;
//身份证号
@property (nonatomic, strong) NSString *idCard;
//预留手机号
@property (nonatomic, strong) NSString *reservedMobile;

@end


#pragma mark -- 添加银行卡 请求参数

@interface GC_AddBankCardRequestDataModel : Hen_JsonModel

///登录用户ID
@property (nonatomic, strong) NSString *userId;

///用户token
@property (nonatomic, strong) NSString *token;

///短信验证码
@property (nonatomic, strong) NSString *smsCode;

///持卡人姓名
@property (nonatomic, strong) NSString *ownerName;

///身份证号
@property (nonatomic, strong) NSString *idCard;

///银行卡号
@property (nonatomic, strong) NSString *cardNum;

///银行名称
@property (nonatomic, strong) NSString *bankName;

///银行卡类型
@property (nonatomic, strong) NSString *cardType;

///是否为默认银行卡
@property (nonatomic, strong) NSString *isDefault;

///银行卡图标
@property (nonatomic, strong) NSString *bankLogo;

///预留手机号
@property (nonatomic, strong) NSString *reservedMobile;

@end



#pragma mark -- 银行绑定输入 相关信息

@interface GC_InputBandCardInfoRequestDataModel : Hen_JsonModel
///持卡人姓名
@property (nonatomic, strong) NSString *ownerName;
///银行卡号
@property (nonatomic, strong) NSString *cardNum;
///身份证号
@property (nonatomic, strong) NSString *idCard;
///预留手机号
@property (nonatomic, strong) NSString *reservedMobile;
///银行名称
@property (nonatomic, strong) NSString *bankName;
///是否为默认银行卡
@property (nonatomic, strong) NSString *isDefault;
///银行卡图标
@property (nonatomic, strong) NSString *bankLogo;
///银行卡类型
@property (nonatomic, strong) NSString *cardType;

@end
