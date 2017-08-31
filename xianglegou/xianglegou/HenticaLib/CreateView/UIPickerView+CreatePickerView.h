//
//  UIPickerView+CreatePickerView.h
//  Exam
//
//  Created by mini2 on 16/9/8.
//  Copyright © 2016年 Exam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPickerView (CreatePickerView)

///创建
+(UIPickerView*)createPickerViewWithDelegateTarget:(id)delegateTarget;

///获取
+(UIPickerView*)getPickerViewForTag:(NSInteger)tag inParentView:(UIView*)view;

@end
