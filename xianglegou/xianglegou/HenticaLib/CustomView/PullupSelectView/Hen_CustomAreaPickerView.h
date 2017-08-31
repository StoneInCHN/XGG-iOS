//
//  HV_AreaPicker.h
//  MenLi
//
//  Created by mini3 on 16/7/19.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -- 地址model

@interface Hen_AreaPickerModel : Hen_JsonModel

@property (nonatomic, strong) NSString *areaId;
@property (nonatomic, strong) NSString *parentID;
@property (nonatomic, strong) NSString *name;

@end

typedef NS_ENUM(NSInteger , AreaPickerType) {
    AreaPickerTypeProvinceAndCityAndDistrict, //省市区
    AreaPickerTypeProvinceAndCity //省市
};

@interface Hen_CustomAreaPickerView : UIView

///选择回调
@property(nonatomic, copy) void(^onAreaPickerSelectBlock)(NSMutableDictionary *selectedDict);

///设置类型
-(void)setAreaPickerType:(AreaPickerType)pickerType;

///读取地区数据库
-(void)readAreaDB;

///视图出现 && 刷新
-(void)showPickerView;

// 设置选中的地方
-(void)setFirstSelectedBy:(NSArray *)select;

@end
