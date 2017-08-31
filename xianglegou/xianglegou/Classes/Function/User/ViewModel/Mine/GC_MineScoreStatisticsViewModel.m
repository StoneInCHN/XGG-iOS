//
//  GC_MineScoreStatisticsViewModel.m
//  Rebate
//
//  Created by mini3 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_MineScoreStatisticsViewModel.h"

@implementation GC_MineScoreStatisticsViewModel
///用户积分 方法
-(void)getUsetScoreRecWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_scoreRec dictionaryParam:self.scoreRecParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSMutableDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResScoreRecDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.scoreRecParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.scoreRecDatas removeAllObjects];
            }
            
            [self.scoreRecDatas addObjectsFromArray:resultArray];
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}



///用户乐心 方法
-(void)getUserLeMindRecWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_leMindRec dictionaryParam:self.leMindRecParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSMutableDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResLeMindRecDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.leMindRecParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.leMindRecDatas removeAllObjects];
            }
            
            [self.leMindRecDatas addObjectsFromArray:resultArray];
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
            
        }else{  //失败
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}


///用户乐分 方法
-(void)getUserLeScoreRecDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_leScoreRec dictionaryParam:self.leScoreRecParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSMutableDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResLeScoreRecDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.leScoreRecParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.leScoreRecDatas removeAllObjects];
            }
            
            [self.leScoreRecDatas addObjectsFromArray:resultArray];
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}

///用户乐豆 方法
-(void)getUserLeBeanRecDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_leBeanRec dictionaryParam:self.leBeanRecParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSMutableDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResLeBeanRecDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.leBeanRecParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.leBeanRecDatas removeAllObjects];
            }
            [self.leBeanRecDatas addObjectsFromArray:resultArray];
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);       
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}




///获取提现信息 方法
-(void)getWithdrawInfoDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getWithdrawInfo dictionaryParam:self.withdrawInfoParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.withdrawInfoData = [[GC_MResWithdrawInfoDataModel alloc] initWithDictionary:msg];
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}



///用户确认提现 方法
-(void)setWithdrawConfirDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_withdrawConfirm dictionaryParam:[self.withdrawConfirmParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///用户获取默认银行卡 方法
- (void)getDefaultCardDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:bankCard_getDefaultCard dictionaryParam:self.defaultCardParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.defaultCardData = [[GC_MResDefaultCardDataModel alloc] initWithDictionary:msg];
            
            
            if(resultBlock){
                resultBlock(code, desc, self.defaultCardData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}

///验证支付密码 方法
-(void)setVerifyPayPwdDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_verifyPayPwd dictionaryParam:self.verifyPayPwdParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}

#pragma mark -- getter,setter
///用户积分 参数
- (NSMutableDictionary *)scoreRecParam
{
    if(!_scoreRecParam){
        _scoreRecParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_scoreRecParam setObject:@"" forKey:@"userId"];
        //用户token
        [_scoreRecParam setObject:@"" forKey:@"token"];
        //分页：页数
        [_scoreRecParam setObject:@"1" forKey:@"pageNumber"];
        //分页：每页大小
        [_scoreRecParam setObject:NumberOfPages forKey:@"pageSize"];
    }
    return _scoreRecParam;
}

///用户积分 数据
- (NSMutableArray<GC_MResScoreRecDataModel *> *)scoreRecDatas
{
    if(!_scoreRecDatas){
        _scoreRecDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _scoreRecDatas;
}

///用户乐心 参数
- (NSMutableDictionary *)leMindRecParam
{
    if(!_leMindRecParam){
        _leMindRecParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
       [_leMindRecParam setObject:@"" forKey:@"userId"];
        //用户token
        [_leMindRecParam setObject:@"" forKey:@"token"];
        //分页：页数
        [_leMindRecParam setObject:@"" forKey:@"pageNumber"];
        //分页：每页大小
        [_leMindRecParam setObject:NumberOfPages forKey:@"pageSize"];
    }
    return _leMindRecParam;
}

///用户乐心 数据
- (NSMutableArray<GC_MResLeMindRecDataModel *> *)leMindRecDatas
{
    if(!_leMindRecDatas){
        _leMindRecDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _leMindRecDatas;
}



///用户乐分 参数
- (NSMutableDictionary *)leScoreRecParam
{
    if(!_leScoreRecParam){
        _leScoreRecParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_leScoreRecParam setObject:@"" forKey:@"userId"];
        //用户token
        [_leScoreRecParam setObject:@"" forKey:@"token"];
        //乐分类型
        /** 乐分消费 CONSUME, */
        /** 分红 BONUS, */
        /** 好友 RECOMMEND_USER,*/
        /** 业务员 RECOMMEND_SELLER,*/
        /** 代理商 AGENT,*/
        /** 提现 WITHDRAW*/
        //乐分类型
        [_leScoreRecParam setObject:@"" forKey:@"leScoreType"];
        
        //分页：页数
        [_leScoreRecParam setObject:@"" forKey:@"pageNumber"];
        //分页：每页大小
        [_leScoreRecParam setObject:NumberOfPages forKey:@"pageSize"];
    }
    return _leScoreRecParam;
}

///用户乐分 数据
- (NSMutableArray<GC_MResLeScoreRecDataModel *> *)leScoreRecDatas
{
    if(!_leScoreRecDatas){
        _leScoreRecDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _leScoreRecDatas;
}

///用户乐豆 参数
- (NSMutableDictionary *)leBeanRecParam
{
    if(!_leBeanRecParam){
        _leBeanRecParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //用户ID
        [_leBeanRecParam setObject:@"" forKey:@"userId"];
        //用户token
        [_leBeanRecParam setObject:@"" forKey:@"token"];
        //分页：页数
        [_leBeanRecParam setObject:@"" forKey:@"pageNumber"];
        //分页：每页大小
        [_leBeanRecParam setObject:NumberOfPages forKey:@"pageSize"];
    }
    return _leBeanRecParam;
}

///用户乐豆 数据
-(NSMutableArray<GC_MResLeBeanRecDataModel *> *)leBeanRecDatas
{
    if(!_leBeanRecDatas){
        _leBeanRecDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _leBeanRecDatas;
}




///获取提现信息 参数
- (NSMutableDictionary *)withdrawInfoParam
{
    if(!_withdrawInfoParam){
        _withdrawInfoParam = [[NSMutableDictionary alloc] initWithCapacity:0];
    
        //用户ID
        [_withdrawInfoParam setObject:@"" forKey:@"userId"];
        //用户token
        [_withdrawInfoParam setObject:@"" forKey:@"token"];
    }
    return _withdrawInfoParam;
}

///获取提现信息 参数

- (GC_UserConfirmationRequestDataModel *)withdrawConfirmParam
{
    if(!_withdrawConfirmParam){
        _withdrawConfirmParam = [[GC_UserConfirmationRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _withdrawConfirmParam;
}



///获取提现信息 数据
- (GC_MResWithdrawInfoDataModel *)withdrawInfoData
{
    if(!_withdrawInfoData){
        _withdrawInfoData = [[GC_MResWithdrawInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _withdrawInfoData;
}

///用户获取默认银行卡 参数
- (NSMutableDictionary *)defaultCardParam
{
    if(!_defaultCardParam){
        _defaultCardParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //token
        [_defaultCardParam setObject:@"" forKey:@"token"];
        //userId
        [_defaultCardParam setObject:@"" forKey:@"userId"];
    }
    return _defaultCardParam;
}

///用户获取默认银行卡 数据
- (GC_MResDefaultCardDataModel *)defaultCardData
{
    if(!_defaultCardData){
        _defaultCardData = [[GC_MResDefaultCardDataModel alloc] initWithDictionary:@{}];
    }
    return _defaultCardData;
}

///验证支付密码 参数
- (NSMutableDictionary *)verifyPayPwdParam
{
    if(!_verifyPayPwdParam){
        _verifyPayPwdParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //用户ID
        [_verifyPayPwdParam setObject:@"" forKey:@"userId"];
        //用户token
        [_verifyPayPwdParam setObject:@"" forKey:@"token"];
        //支付密码(rsa加密)
        [_verifyPayPwdParam setObject:@"" forKey:@"password"];
    }
    return _verifyPayPwdParam;
}
@end
