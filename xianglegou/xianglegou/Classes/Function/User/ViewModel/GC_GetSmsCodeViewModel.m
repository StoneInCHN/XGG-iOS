//
//  GC_GetSmsCodeViewModel.m
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_GetSmsCodeViewModel.h"

@implementation GC_GetSmsCodeViewModel

///发送短信 方法
- (void)getSmsCodeWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_getSmsCode dictionaryParam:self.smsCodeParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}

#pragma mark -- getter,setter

///发送短信 参数
- (NSMutableDictionary *)smsCodeParam
{
    if(!_smsCodeParam){
        _smsCodeParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        //手机号
        [_smsCodeParam setObject:@"" forKey:@"cellPhoneNum"];
        //短信验证码类型 注册：REG, 登录：LOGIN, 找回密码：RESETPWD, 修改登录密码：UPDATELOGINPWD, 修改支付密码：UPDATEPAYPWD 银行预留手机号验证 ：RESERVEDMOBILE
        
        [_smsCodeParam setObject:@"" forKey:@"smsCodeType"];
    }
    return _smsCodeParam;
}

@end
