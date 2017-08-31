//
//  AlertManager.h
//  Vpn
//
//  Created by jiwuwang on 15/9/28.
//  Copyright (c) 2015年 jiwuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hen_AlterDialog.h"

typedef void(^returnBlcok)(NSInteger buttonIndex);

@interface Hen_AlertManager : NSObject

@property (nonatomic, copy)   returnBlcok   eventBlock;

///跳转事件
- (void)setActionEventBoloc:(returnBlcok)eventBlock;

///显示两个按钮对话框（确定，取消）message：提示信息
-(void)showTwoButtonWithMessage:(NSString*)message;

///显示一个按钮对话框（确定） message：提示信息
-(void)showOneButtonWithMessage:(NSString*)message;

///显示自定义按钮对话框 buttonTitles：需要显示按钮名数组 message：提示信息
-(void)showCustomButtonTitls:(NSArray*)buttonTitles
                     message:(NSString*)message;

///显示网路错误
-(void)showNetworkErrorMessage:(NSString*)message;

@end
