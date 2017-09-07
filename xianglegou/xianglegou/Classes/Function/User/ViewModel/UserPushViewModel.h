//
//  UserPushViewModel.h
//  xianglegou
//
//  Created by lieon on 2017/9/4.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "SetupPushRequestParam.h"

@interface UserPushViewModel : Hen_BaseViewModel
/// 上传regiterId
- (void)uploadPushRegisterId;
/// 设置消息推送开关
- (void)setPushSwitch: (BOOL)isOn;
@end
