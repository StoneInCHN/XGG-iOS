//
//  GC_BankBindingViewModel.h
//  xianglegou
//
//  Created by mini3 on 2017/5/24.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "GC_BankBindingModel.h"
#import "GC_BankBindingRequestDataModel.h"

@interface GC_BankBindingViewModel : Hen_BaseViewModel

///实名认证 参数
@property (nonatomic, strong) NSMutableDictionary *doIdentityAuthParam;
///实名认证 方法
- (void)setCardFrontPic:(UIImage *)cardFrontPic andCardBackPic:(UIImage *)cardBackPic setDoIdentityAuthDataWithResultBlock:(RequestResultBlock)resultBlock;


///用户银行卡列表 参数
@property (nonatomic, strong) NSMutableDictionary *myCardListParam;
///用户银行卡列表 数据
@property (nonatomic, strong) NSMutableArray<GC_MResBankCardMyCardListDataModel *> *myCardListDatas;
///用户银行卡列表 方法
-(void)getMyCardListDatasWithResultBlock:(RequestResultBlock)resultBlock;




///获取用户身份证信息 参数
@property (nonatomic, strong) NSMutableDictionary *idCardInfoParam;
///获取用户身份证信息 数据
@property (nonatomic, strong) GC_MResIdCardInfoDataModel *idCardInfoData;
///获取用户身份证信息 方法
- (void)getIdCardInfoDataWithResultBlock:(RequestResultBlock)resultBlock;



///银行卡四元素校验 参数
@property (nonatomic, strong) GC_VerifyBankCardRequestDataModel *verifyBankCardParam;
///银行卡四元素校验 方法
-(void)setVerifyBankCardDataWithResultBlock:(RequestResultBlock)resultBlock;






///银行卡 参数
@property (nonatomic, strong) NSMutableDictionary *bankCardInfoParam;
///获取银行卡 数据
@property (nonatomic, strong) GC_MResBankCardInfoDataModel *bankCardInfoData;
///获取银行卡 信息
- (void)setUrl:(NSString *)url getBankInfoDataWithResultBlock:(RequestResultBlock)resultBlok;





///添加银行卡 参数
@property (nonatomic, strong) GC_AddBankCardRequestDataModel *addBankCardParam;
///添加银行卡 方法
-(void)setAddBankCardDataWithResultBlock:(RequestResultBlock)resultBlock;


///删除银行卡 参数
@property (nonatomic, strong) NSMutableDictionary *delBankCardParm;
///删除银行卡 方法
-(void)setDelBankCardDataWithResultBlock:(RequestResultBlock)resultBlock;




///设置默认银行卡 参数
@property (nonatomic, strong) NSMutableDictionary *updateCardDefaultParam;
///设置默认银行卡 方法
- (void)setUpdateCardDefaultDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
