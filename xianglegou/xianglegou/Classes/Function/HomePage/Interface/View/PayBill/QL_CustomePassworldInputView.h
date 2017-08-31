//
//  QL_CustomePassworldInputView.h
//  Rebate
//
//  Created by mini2 on 2017/4/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SinglePW_Width  WIDTH_TRANSFORMATION(85)
#define CPIView_Height  HEIGHT_TRANSFORMATION(85)

@interface QL_CustomePassworldInputView : UIView

///输入完成回调
@property(nonatomic, copy) void(^onInputFinishBlock)(NSString *password);

///显示
- (void)showForPassword:(NSString *)password;
///取消
- (void)cancel;
///完成
- (void)finish;

@end
