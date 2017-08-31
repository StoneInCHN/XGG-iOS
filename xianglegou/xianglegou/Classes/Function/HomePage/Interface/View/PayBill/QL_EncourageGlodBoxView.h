//
//  QL_EncourageGlodBoxView.h
//  Rebate
//
//  Created by mini2 on 2017/4/26.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 鼓励金弹出框
//

#import <UIKit/UIKit.h>

@interface QL_EncourageGlodBoxView : UIView

///显示
-(void)showForEncourageAmount:(NSString *)encourageAmount andOrderId:(NSString *)orderId;

///显示
- (void)show;

@end
