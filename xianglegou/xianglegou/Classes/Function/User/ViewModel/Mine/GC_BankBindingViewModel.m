//
//  GC_BankBindingViewModel.m
//  xianglegou
//
//  Created by mini3 on 2017/5/24.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BankBindingViewModel.h"

@implementation GC_BankBindingViewModel

///实名认证 方法
- (void)setCardFrontPic:(UIImage *)cardFrontPic andCardBackPic:(UIImage *)cardBackPic setDoIdentityAuthDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestIdentityWithAction:endUser_doIdentityAuth dictionaryParam:self.doIdentityAuthParam cardFrontPic:cardFrontPic cardBackPic:cardBackPic withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
       
        if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
    }];
}






///用户银行卡列表 方法
-(void)getMyCardListDatasWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:bankCard_myCardList dictionaryParam:self.myCardListParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (NSDictionary *dic in msg) {
                [resultArray addObject:[[GC_MResBankCardMyCardListDataModel alloc] initWithDictionary:dic]];
            }
            
            if([[self.myCardListParam objectForKey:@"pageNumber"] isEqualToString:@"1"]){
                [self.myCardListDatas removeAllObjects];
            }
            
            [self.myCardListDatas addObjectsFromArray:resultArray];
            
            if(resultBlock){
                resultBlock(code, desc, resultArray, page);
            }
            
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, page);
            }
        }
    }];
}



///获取用户身份证信息 方法
- (void)getIdCardInfoDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:bankCard_getIdCard dictionaryParam:self.idCardInfoParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.idCardInfoData = [[GC_MResIdCardInfoDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.idCardInfoData, page);
            }
            
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
}



///银行卡四元素校验 方法
-(void)setVerifyBankCardDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:bankCard_verifyCard dictionaryParam:[self.verifyBankCardParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock( code, desc, msg, page);
        }
    }];
}





///获取银行卡 信息
- (void)setUrl:(NSString *)url getBankInfoDataWithResultBlock:(RequestResultBlock)resultBlok
{
    [[Hen_MessageManager shareMessageManager] requestGetWithUrl:url dictionaryParam:self.bankCardInfoParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        self.bankCardInfoData = [[GC_MResBankCardInfoDataModel alloc] initWithDictionary:msg];
        
        if(resultBlok){
            resultBlok(code, desc, self.bankCardInfoData, page);
        }
        
    }];
}



///添加银行卡 方法
-(void)setAddBankCardDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:bankCard_addCard dictionaryParam:[self.addBankCardParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}



///删除银行卡 方法
-(void)setDelBankCardDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:bankCard_delCard dictionaryParam:self.delBankCardParm withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}


///设置默认银行卡 方法
- (void)setUpdateCardDefaultDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:bankCard_updateCardDefault dictionaryParam:self.updateCardDefaultParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
    
}
#pragma mark -- getter,setter
///实名认证 参数
- (NSMutableDictionary *)doIdentityAuthParam
{
    if(!_doIdentityAuthParam){
        _doIdentityAuthParam  = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //用户ID
        [_doIdentityAuthParam setObject:@"" forKey:@"userId"];
        //用户token
        [_doIdentityAuthParam setObject:@"" forKey:@"token"];
        //真实姓名
        [_doIdentityAuthParam setObject:@"" forKey:@"realName"];
        //身份证号码
        [_doIdentityAuthParam setObject:@"" forKey:@"cardNo"];

    }
    return _doIdentityAuthParam;
}


///用户银行卡列表 参数
- (NSMutableDictionary *)myCardListParam
{
    if(!_myCardListParam){
        _myCardListParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //登录用户ID
        [_myCardListParam setObject:@"" forKey:@"userId"];
        
        //用户token
        [_myCardListParam setObject:@"" forKey:@"token"];
        
        //分页：分页大小.
        [_myCardListParam setObject:NumberOfPages forKey:@"pageSize"];
        //分页：页数
        [_myCardListParam setObject:@"" forKey:@"pageNumber"];
        

    }
    return _myCardListParam;
}
///用户银行卡列表 数据
- (NSMutableArray<GC_MResBankCardMyCardListDataModel *> *)myCardListDatas
{
    if(!_myCardListDatas){
        _myCardListDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _myCardListDatas;
}





///获取用户身份证信息 参数
- (NSMutableDictionary *)idCardInfoParam
{
    if(!_idCardInfoParam){
        _idCardInfoParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        [_idCardInfoParam setObject:@"" forKey:@"userId"];
        [_idCardInfoParam setObject:@"" forKey:@"token"];
    }
    return _idCardInfoParam;
}

///获取用户身份证信息 数据
- (GC_MResIdCardInfoDataModel *)idCardInfoData
{
    if(!_idCardInfoData){
        _idCardInfoData = [[GC_MResIdCardInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _idCardInfoData;
}


///银行卡四元素校验 参数

- (GC_VerifyBankCardRequestDataModel *)verifyBankCardParam
{
    if(!_verifyBankCardParam){
        _verifyBankCardParam = [[GC_VerifyBankCardRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _verifyBankCardParam;
}

///添加银行卡 参数
- (GC_AddBankCardRequestDataModel *)addBankCardParam
{
    if(!_addBankCardParam){
        _addBankCardParam = [[GC_AddBankCardRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _addBankCardParam;
}


///删除银行卡 参数
- (NSMutableDictionary *)delBankCardParm
{
    if(!_delBankCardParm){
        _delBankCardParm = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        
        ///登录用户ID
        [_delBankCardParm setObject:@"" forKey:@"userId"];
        
        //用户token
        [_delBankCardParm setObject:@"" forKey:@"token"];
        
        ///银行卡ID
        [_delBankCardParm setObject:@"" forKey:@"entityId"];

    }
    return _delBankCardParm;
}



///银行卡信息 参数
- (NSMutableDictionary *)bankCardInfoParam
{
    if(!_bankCardInfoParam){
        _bankCardInfoParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //卡号
        [_bankCardInfoParam setObject:@"" forKey:@"cardid"];
        //KEY
        [_bankCardInfoParam setObject:@"" forKey:@"key"];
    }
    return _bankCardInfoParam;
}


///银行卡信息 数据
- (GC_MResBankCardInfoDataModel *)bankCardInfoData
{
    if(!_bankCardInfoData){
        _bankCardInfoData = [[GC_MResBankCardInfoDataModel alloc] initWithDictionary:@{}];
    }
    return _bankCardInfoData;
}



///设置默认银行卡 参数
- (NSMutableDictionary *)updateCardDefaultParam
{
    if(!_updateCardDefaultParam){
        _updateCardDefaultParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        //登录用户ID
        [_updateCardDefaultParam setObject:@"" forKey:@"userId"];
        //用户token
        [_updateCardDefaultParam setObject:@"" forKey:@"token"];
        //银行卡ID
        [_updateCardDefaultParam setObject:@"" forKey:@"entityId"];
    }
    return _updateCardDefaultParam;
}
@end
