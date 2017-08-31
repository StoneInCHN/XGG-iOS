//
//  GC_EditUserInfoViewModel.m
//  xianglegou
//
//  Created by mini3 on 2017/7/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_EditUserInfoViewModel.h"

@implementation GC_EditUserInfoViewModel

///更换手机号 方法
- (void)setChangeMobileDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_changeRegMobile dictionaryParam:self.changeMobileParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}

#pragma mark -- getter,setter
///更换手机号 参数
- (NSMutableDictionary *)changeMobileParam
{
    if(!_changeMobileParam){
        _changeMobileParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        
        //用户ID
        [_changeMobileParam setObject:@"" forKey:@"userId"];
        
        //用户token
        [_changeMobileParam setObject:@"" forKey:@"token"];
        
        //验证码
        [_changeMobileParam setObject:@"" forKey:@"smsCode"];
        
        //变更后手机号
        [_changeMobileParam setObject:@"" forKey:@"cellPhoneNum"];

        
    }
    return _changeMobileParam;
}
@end
