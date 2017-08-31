/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import "GC_CustomProgressLoadingView.h"
#import <objc/runtime.h>
#import "UIColor+HexColor.h"


static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (GC_CustomProgressLoadingView *)HUD{
    
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(GC_CustomProgressLoadingView *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    //UIView *view2 = [[UIApplication sharedApplication].delegate window];
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
//    HUD.color = [UIColor colorWithHexString:@"#c5c5c5"];
//    HUD.labelText = hint;
//    HUD.removeFromSuperViewOnHide = YES;
//    [view addSubview:HUD];
//    [view bringSubviewToFront:HUD];
//    [HUD show:YES];
//    [self setHUD:HUD];

    GC_CustomProgressLoadingView *HUD = [[GC_CustomProgressLoadingView alloc] init];
    [view addSubview:HUD];
    [HUD show];
    HUD.center = view.center;
    [self setHUD:HUD];
}

- (void)showPayHud:(NSString *)hint
{
//    UIView *view2 = [[UIApplication sharedApplication].delegate window];
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view2];
//    HUD.color = [UIColor colorWithHexString:@"#c5c5c5"];
//    HUD.labelText = hint;
//    HUD.removeFromSuperViewOnHide = YES;
//    [view2 addSubview:HUD];
//    [view2 bringSubviewToFront:HUD];
//    [HUD show:YES];
//    [self setHUD:HUD];
    
    UIView *view2 = [[UIApplication sharedApplication].delegate window];
    GC_CustomProgressLoadingView *HUD = [[GC_CustomProgressLoadingView alloc] init];
    [view2 addSubview:HUD];
    [HUD show];
    HUD.center = view2.center;
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint {
    if (hint.length < 1) {
        return;
    }
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.color = [UIColor colorWithHexString:@"#c5c5c5"];
    hud.detailsLabelText = hint;
    hud.margin = 10.f;
    //hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.yOffset = [UIScreen mainScreen].bounds.size.height / 2 - 100;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.color = [UIColor colorWithHexString:@"#c5c5c5"];
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hide];
}

@end
