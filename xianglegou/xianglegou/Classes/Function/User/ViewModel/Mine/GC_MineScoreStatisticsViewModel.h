//
//  GC_MineScoreStatisticsViewModel.h
//  Rebate
//
//  Created by mini3 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  我的积分 、乐分等数据 -- ViewModel
//

#import "Hen_BaseViewModel.h"
#import "GC_ConfirmationRequestDataModel.h"
#import "GC_BankBindingModel.h"

@interface GC_MineScoreStatisticsViewModel : Hen_BaseViewModel

///用户积分 参数
@property (nonatomic, strong) NSMutableDictionary *scoreRecParam;
///用户积分 数据
@property (nonatomic, strong) NSMutableArray<GC_MResScoreRecDataModel*>* scoreRecDatas;
///用户积分 方法
-(void)getUsetScoreRecWithResultBlock:(RequestResultBlock)resultBlock;


///用户乐心 参数
@property (nonatomic, strong) NSMutableDictionary *leMindRecParam;
///用户乐心 数据
@property (nonatomic, strong) NSMutableArray<GC_MResLeMindRecDataModel*>* leMindRecDatas;
///用户乐心 方法
-(void)getUserLeMindRecWithResultBlock:(RequestResultBlock)resultBlock;


///用户乐分 参数
@property (nonatomic, strong) NSMutableDictionary *leScoreRecParam;
///用户乐分 数据
@property (nonatomic, strong) NSMutableArray<GC_MResLeScoreRecDataModel*>* leScoreRecDatas;
///用户乐分 方法
-(void)getUserLeScoreRecDatasWithResultBlock:(RequestResultBlock)resultBlock;


///用户乐豆 参数
@property (nonatomic, strong) NSMutableDictionary *leBeanRecParam;
///用户乐豆 数据
@property (nonatomic, strong) NSMutableArray<GC_MResLeBeanRecDataModel*>* leBeanRecDatas;
///用户乐豆 方法
-(void)getUserLeBeanRecDatasWithResultBlock:(RequestResultBlock)resultBlock;



///获取提现信息 参数
@property (nonatomic, strong) NSMutableDictionary *withdrawInfoParam;
///获取提现信息 数据
@property (nonatomic, strong) GC_MResWithdrawInfoDataModel *withdrawInfoData;
///获取提现信息 方法
-(void)getWithdrawInfoDataWithResultBlock:(RequestResultBlock)resultBlock;



///用户确认提现 参数
@property (nonatomic, strong) GC_UserConfirmationRequestDataModel *withdrawConfirmParam;
///用户确认提现 方法
-(void)setWithdrawConfirDataWithResultBlock:(RequestResultBlock)resultBlock;



///用户获取默认银行卡 参数
@property (nonatomic, strong) NSMutableDictionary *defaultCardParam;
///用户获取默认银行卡 数据
@property (nonatomic, strong) GC_MResDefaultCardDataModel *defaultCardData;
///用户获取默认银行卡 方法
- (void)getDefaultCardDataWithResultBlock:(RequestResultBlock)resultBlock;


///验证支付密码 参数
@property (nonatomic, strong) NSMutableDictionary *verifyPayPwdParam;
///验证支付密码 方法
-(void)setVerifyPayPwdDataWithResultBlock:(RequestResultBlock)resultBlock;


@end
