//
//  GC_BankBindingModel.h
//  xianglegou
//
//  Created by mini3 on 2017/5/24.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_BankBindingModel : Hen_JsonModel

@end



#pragma mark -- 用户银行卡列表

@interface GC_MResBankCardMyCardListDataModel : Hen_JsonModel
///银行卡号
@property (nonatomic, strong) NSString *cardNum;
///是否是默认银行卡
@property (nonatomic, strong) NSString *isDefault;
///银行卡类型
@property (nonatomic, strong) NSString *cardType;
///银行卡 Log
@property (nonatomic, strong) NSString *bankLogo;
///银行卡名称
@property (nonatomic, strong) NSString *bankName;
///银行卡ID
@property (nonatomic, strong) NSString *id;

@end



#pragma mark -- 获取用户身份证信息

@interface GC_MResIdCardInfoDataModel : Hen_JsonModel
///真实姓名
@property (nonatomic, strong) NSString *realName;
///身份证 号
@property (nonatomic, strong) NSString *idCardNo;
///id
@property (nonatomic, strong) NSString *id;

@end



#pragma mark -- 银行卡 信息

@interface GC_MResBankCardInfoResultDataModel : Hen_JsonModel
///	银行归属
@property (nonatomic, strong) NSString *bank;
///卡类型
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *nature;
@property (nonatomic, strong) NSString *kefu;
///银行logo，
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *info;
@end

#pragma mark -- 银行卡 信息

@interface GC_MResBankCardInfoDataModel : Hen_JsonModel

///返回说明
@property (nonatomic, strong) NSString *reason;
///银行卡信息
@property (nonatomic, strong) GC_MResBankCardInfoResultDataModel *result;
///返回码
@property (nonatomic, strong) NSString *error_code;
@end


#pragma mark -- 获取用户默认银行卡 数据

@interface GC_MResDefaultCardDataModel : Hen_JsonModel
///卡号
@property (nonatomic, strong) NSString *cardNum;
///是否是默认
@property (nonatomic, strong) NSString *isDefault;
///卡号
@property (nonatomic, strong) NSString *idCard;
///类型
@property (nonatomic, strong) NSString *cardType;
///名称
@property (nonatomic, strong) NSString *bankName;
///ID
@property (nonatomic, strong) NSString *id;
///图片
@property (nonatomic, strong) NSString *bankLogo;
@end


