//
//  QL_PayPasswordInputView.h
//  Rebate
//
//  Created by mini2 on 17/4/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 支付密码输入view
//

#import <UIKit/UIKit.h>

@interface QL_PayPasswordInputView : UIView

///输入完成回调
@property(nonatomic, copy) void(^onInputFinishBlock)(NSString *password);

///显示
- (void)showView;

@end
