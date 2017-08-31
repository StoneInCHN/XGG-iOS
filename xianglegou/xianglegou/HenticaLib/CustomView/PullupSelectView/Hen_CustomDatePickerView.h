//
//  QL_CustomDatePickerView.h
//  MenLi
//
//  Created by mini2 on 16/7/2.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hen_CustomDatePickerView : UIView

///回调
@property(nonatomic, copy) void(^onDatePickerReturnBlock)(NSString *dateString);

///显示
-(void)showDatePickerView;
///设置类型
-(void)setDatePickerModel:(UIDatePickerMode)datePickerModel;
// 设置初始选中的地方
- (void)setFirstSelectedByDateString:(NSString*)date;

///最小日期
-(void)setMinDatePickerBy:(NSDate *)minDate;
///最大日期
-(void)setMaxDatePickerBy:(NSDate *)maxDate;

@end
