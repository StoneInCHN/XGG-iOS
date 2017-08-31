//
//  GC_AddBankCardViewController.h
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseViewController.h"
#import "GC_BankBindingRequestDataModel.h"

@interface GC_AddBankCardViewController : Hen_BaseViewController

///用户名
@property (nonatomic, strong) NSString *actualName;

///是否第一次添加银行卡
@property (nonatomic, assign) BOOL isFirstAdd;

///是否设置未默认银行卡
@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, strong) GC_InputBandCardInfoRequestDataModel *inputData;

@end
