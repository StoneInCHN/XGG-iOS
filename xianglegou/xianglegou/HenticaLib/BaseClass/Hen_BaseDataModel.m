//
//  Hen_BaseDataModel.m
//  Peccancy
//
//  Created by mini2 on 16/11/10.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_BaseDataModel.h"

@implementation Hen_BaseDataModel

#pragma mark -- private

- (Hen_AlertManager *)alertManager {
    if (!_alertManager) {
        _alertManager = [[Hen_AlertManager alloc] init];
    }
    return _alertManager;
}

- (Hen_ProgressManager*)progressManager{
    if(!_progressManager){
        _progressManager = [[Hen_ProgressManager alloc] init];
    }
    return _progressManager;
}

-(Hen_Util*)henUtil
{
    if(!_henUtil){
        _henUtil = [Hen_Util getInstance];
    }
    return _henUtil;
}

@end
