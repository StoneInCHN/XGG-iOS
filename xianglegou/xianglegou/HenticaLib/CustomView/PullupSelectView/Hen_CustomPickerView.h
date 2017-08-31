//
//  QL_CustomPickerView.h
//  CRM
//
//  Created by mini2 on 16/6/7.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -- 选择model

@interface Hen_CustomPickerModel : Hen_JsonModel

@property(nonatomic, strong) NSString *itemId;

@property(nonatomic, strong) NSString *name;

@end

@interface Hen_CustomPickerView : UIView

///选择回调
@property(nonatomic, copy) void(^onCustomPickerSelectBlock)(NSMutableDictionary *selectedDict);

// 第一行不显单元
@property(nonatomic, assign) BOOL firstRowUnShowUnit;

// 视图出现 && 刷新
- (void)showPickerViewWithDataSource:(NSArray<NSMutableArray<Hen_CustomPickerModel*>*>*)dataSource unitArray:(NSArray *)uniArray;

// 设置初始选中的地方
- (void)setFirstSelectedBy:(NSArray<NSString*>*)select;


@end
