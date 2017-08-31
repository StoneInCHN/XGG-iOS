//
//  GC_GetSmsCodeViewModel.h
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"

@interface GC_GetSmsCodeViewModel : Hen_BaseViewModel
///发送短信 参数
@property (nonatomic, strong) NSMutableDictionary *smsCodeParam;
///发送短信 方法
-(void)getSmsCodeWithResultBlock:(RequestResultBlock)resultBlock;
@end
