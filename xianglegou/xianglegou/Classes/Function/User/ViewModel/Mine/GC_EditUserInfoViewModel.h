//
//  GC_EditUserInfoViewModel.h
//  xianglegou
//
//  Created by mini3 on 2017/7/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseViewModel.h"

@interface GC_EditUserInfoViewModel : Hen_BaseViewModel

///更换手机号 参数
@property (nonatomic, strong)NSMutableDictionary *changeMobileParam;
///更换手机号 方法
- (void)setChangeMobileDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
