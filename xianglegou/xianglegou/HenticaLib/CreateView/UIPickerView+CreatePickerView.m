//
//  UIPickerView+CreatePickerView.m
//  Exam
//
//  Created by mini2 on 16/9/8.
//  Copyright © 2016年 Exam. All rights reserved.
//

#import "UIPickerView+CreatePickerView.h"

@implementation UIPickerView (CreatePickerView)

///创建
+(UIPickerView*)createPickerViewWithDelegateTarget:(id)delegateTarget
{
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = delegateTarget;
    pickerView.dataSource = delegateTarget;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    // 显示选中框
    pickerView.showsSelectionIndicator=YES;
    
    return pickerView;
}

///获取
+(UIPickerView*)getPickerViewForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UIPickerView *pickerView = (UIPickerView*)[view viewWithTag:tag];
    
    return pickerView;
}

@end
