//
//  GC_BeingPaidView.h
//  xianglegou
//
//  Created by mini3 on 2017/7/10.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GC_BeingPaidView : UIView

///回调成功
@property (nonatomic, copy) void(^onSuccessBlock)();

///显示
- (void)BeingPayShow;
@end
