//
//  GC_LeBeanDeductibleTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/6/27.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  乐豆抵扣 - cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_LeBeanDeductibleTableViewCell : Hen_BaseTableViewCell

///输入回调
@property (nonatomic, copy) void(^onInputTextFieldBlock)(NSString *inputStr);



///开关回调
@property (nonatomic, copy) void (^onSwitchBlock)(BOOL isSelected,NSString *isSwitch);

///占位符
@property (nonatomic, strong) NSString *placeholder;

///内容
@property (nonatomic, strong) NSString *inputInfo;

///内容
@property (nonatomic, strong) NSString *contentInfo;

///是否开启乐豆 抵扣
- (void)setIsOpenleBeanDeDuc:(BOOL)isDeDuc;

///是否禁止输入框的输入功能
-(void)setTextFieldUserInteractionEnabled:(BOOL)isNO;
@end
