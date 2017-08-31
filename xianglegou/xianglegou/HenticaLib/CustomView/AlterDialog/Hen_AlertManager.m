//
//  AlertManager.m
//  Vpn
//
//  Created by jiwuwang on 15/9/28.
//  Copyright (c) 2015年 jiwuwang. All rights reserved.
//

#import "Hen_AlertManager.h"
#import "NSDictionaryAdditions.h"


@interface Hen_AlertManager ()

@property (nonatomic, strong) Hen_AlterDialog *alertView;

@property (nonatomic, strong) Hen_AlterDialog *networkErrorAlertView;

@end

@implementation Hen_AlertManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setActionEventBoloc:(returnBlcok)eventBlock
{
    self.eventBlock = eventBlock;
}

///显示两个按钮对话框（取消, 确定）message：提示信息
-(void)showTwoButtonWithMessage:(NSString*)message{
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:0];
    [buttons addObject:@"确定"];
    [buttons addObject:@"取消"];
    
    [self.alertView setButtonTitles:buttons];
    __weak typeof(self) weakSelf = self;
    [self.alertView setButtonClickBlock:^(NSInteger buttonIndex) {
        if(weakSelf.eventBlock){
            weakSelf.eventBlock(buttonIndex);
        }
    }];
    [self.alertView setContentString:message];
    [self.alertView show];
}

///显示一个按钮对话框（确定） message：提示信息
-(void)showOneButtonWithMessage:(NSString*)message{
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:0];
    [buttons addObject:@"确定"];
    
    [self.alertView setButtonTitles:buttons];
    __weak typeof(self) weakSelf = self;
    [self.alertView setButtonClickBlock:^(NSInteger buttonIndex) {
        if(weakSelf.eventBlock){
            weakSelf.eventBlock(buttonIndex);
        }
    }];
    [self.alertView setContentString:message];
    [self.alertView show];
}

///显示自定义按钮对话框 buttonTitles：需要显示按钮名数组 message：提示信息
-(void)showCustomButtonTitls:(NSArray*)buttonTitles
                     message:(NSString*)message{
    [self.alertView setButtonTitles:buttonTitles];
    __weak typeof(self) weakSelf = self;
    [self.alertView setButtonClickBlock:^(NSInteger buttonIndex) {
        if(weakSelf.eventBlock){
            weakSelf.eventBlock(buttonIndex);
        }
    }];
    [self.alertView setContentString:message];
    [self.alertView show];
}


-(Hen_AlterDialog*)alertView{
    if(!_alertView){
        _alertView = [[Hen_AlterDialog alloc] init];
    }
    return _alertView;
}

///显示网路错误
-(void)showNetworkErrorMessage:(NSString*)message{
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:0];
    [buttons addObject:@"确定"];
    
    [self.networkErrorAlertView setButtonTitles:buttons];
    __weak typeof(self) weakSelf = self;
    [self.networkErrorAlertView setButtonClickBlock:^(NSInteger buttonIndex) {
        if(weakSelf.eventBlock){
            weakSelf.eventBlock(buttonIndex);
        }
    }];
    [self.networkErrorAlertView setContentString:message];
    [self.networkErrorAlertView show];
}

-(Hen_AlterDialog*)networkErrorAlertView{
    if(!_networkErrorAlertView){
        _networkErrorAlertView = [[Hen_AlterDialog alloc] init];
    }
    return _networkErrorAlertView;
}

@end



