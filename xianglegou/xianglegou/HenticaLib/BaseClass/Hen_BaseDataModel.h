//
//  Hen_BaseDataModel.h
//  Peccancy
//
//  Created by mini2 on 16/11/10.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hen_AlertManager.h"
#import "Hen_ProgressManager.h"
#import "Hen_Util.h"

@interface Hen_BaseDataModel : NSObject

///弹出对话框管理
@property (nonatomic, strong) Hen_AlertManager *alertManager;
///加载提示管理
@property (nonatomic, strong) Hen_ProgressManager *progressManager;
///工具类
@property(nonatomic, strong) Hen_Util *henUtil;

@end
