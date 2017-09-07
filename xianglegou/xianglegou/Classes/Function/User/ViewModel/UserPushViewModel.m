//
//  UserPushViewModel.m
//  xianglegou
//
//  Created by lieon on 2017/9/4.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "UserPushViewModel.h"

@interface UserPushViewModel ()
@property (nonatomic, strong) SetupPushRequestParam * pushParam;

@end

@implementation UserPushViewModel

- (void)uploadPushRegisterId {
    self.pushParam.userId = DATAMODEL.userId;
    self.pushParam.token = DATAMODEL.token;
    self.pushParam.jpushRegId = DATAMODEL.registerId;
    [self setupPushWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
    }];
}

- (void)setPushSwitch:(BOOL)isOn {
    self.pushParam.userId = DATAMODEL.userId;
    self.pushParam.token = DATAMODEL.token;
    self.pushParam.msgSwitch = isOn == true ? @"true": @"false";
    [[Hen_MessageManager shareMessageManager] requestWithAction:pushMsgSwitch
                                                dictionaryParam:self.pushParam.toDictionary withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
                                                    
                                                }];
}

#pragma mark -- private

- (void)setupPushWithResultBlock:(RequestResultBlock)resultBlock {
    [[Hen_MessageManager shareMessageManager] requestWithAction:set_pushId
                                                dictionaryParam:self.pushParam.toDictionary withResultBlock:resultBlock];
}

#pragma mark -- getter

- (SetupPushRequestParam *)pushParam {
    if (!_pushParam) {
        _pushParam = [[SetupPushRequestParam alloc]init];
    }
    return _pushParam;
}
@end
