//
//  HV_AreaPicker.h
//  MenLi
//
//  Created by mini3 on 16/7/19.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QL_ConfigDataModel.h"

@interface QL_AreaRequestDataModel : Hen_JsonModel

///用户ID
@property(nonatomic, strong) NSString *userId;
///用户token
@property(nonatomic, strong) NSString *token;
///地区ID entityId不传值时,查询所有顶级地区;传值时查询该ID的地区的下级城市
@property(nonatomic, strong) NSString *entityId;

@end

@interface QL_AreaPickerView : UIView

///选择回调
@property(nonatomic, copy) void(^onAreaPickerSelectBlock)(NSMutableDictionary *selectedDict);

///视图出现 && 刷新
-(void)showPickerView;

// 设置选中的地方
-(void)setFirstSelectedBy:(NSArray *)select;
// 设置选中的地方
-(void)setFirstSelectedByAreaId:(NSString *)areaId;

@end
