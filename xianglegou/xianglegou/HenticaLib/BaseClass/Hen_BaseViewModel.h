//
//  BaseViewModel.h
//  CRM
//
//  Created by mini2 on 16/5/30.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hen_MessageManager.h"

///结果回调
typedef void(^ResultBlock)(NSString* errCode, NSString* errMsg);
///缓存回调
typedef void(^CacheBlock)();

@interface Hen_BaseViewModel : NSObject

@end
