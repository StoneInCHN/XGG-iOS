//
//  Hen_ProgressManager.h
//  MedicalMember
//
//  Created by mini2 on 16/3/9.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Hen_ProgressManager : NSObject

- (void)showPayHud:(NSString *)hint;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end
