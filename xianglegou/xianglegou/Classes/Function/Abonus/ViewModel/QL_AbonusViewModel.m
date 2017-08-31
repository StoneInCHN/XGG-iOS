//
//  QL_AbonusViewModel.m
//  Rebate
//
//  Created by mini2 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_AbonusViewModel.h"

@implementation QL_AbonusViewModel

///获取用户分红数据
- (void)getUserAbonusDataWithResultBlock:(RequestResultBlock)resultBlock
{
    NSString *requestId = [[Hen_MessageManager shareMessageManager] requestWithAction:report_getUserBonusReport dictionaryParam:self.abonusParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            self.userAbonusData = [[QL_UserAbonusDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.userAbonusData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
    
    [[Hen_MessageManager shareMessageManager] addUnToLoginRequestId:requestId];
}

///获取全国分红数据
- (void)getAllAbonusDataWithResultBlock:(RequestResultBlock)resultBlock
{
    NSString *requestId = [[Hen_MessageManager shareMessageManager] requestWithAction:report_getNationBonusReport dictionaryParam:self.abonusParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            self.allAbonusData = [[QL_AllAbonusDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.userAbonusData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
    
    [[Hen_MessageManager shareMessageManager] addUnToLoginRequestId:requestId];
}

#pragma mark -- getter,setter

///分红参数
- (NSMutableDictionary *)abonusParam
{
    if(!_abonusParam){
        _abonusParam = [NSMutableDictionary dictionaryWithCapacity:0];
        
        //用户ID
        [_abonusParam setObject:@"" forKey:@"userId"];
        //用户token
        [_abonusParam setObject:@"" forKey:@"token"];
    }
    return _abonusParam;
}

@end
