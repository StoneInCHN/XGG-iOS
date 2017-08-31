//
//  QLAlterDialog.h
//  MedicalMember
//
//  Created by mini2 on 16/3/2.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <UIKit/UIKit.h>

///按钮点击回调
typedef void(^QLAlterDialogButtonClickBlock)(NSInteger buttonIndex);


@interface Hen_AlterDialog : UIView

@property(nonatomic, copy)QLAlterDialogButtonClickBlock clickBlock;

///设置按钮
-(void)setButtonTitles:(NSArray*)titles;
///设置内容
-(void)setContentString:(NSString*)content;

///设置按钮点击回调
-(void)setButtonClickBlock:(QLAlterDialogButtonClickBlock)block;

///显示
-(void)show;

@end
