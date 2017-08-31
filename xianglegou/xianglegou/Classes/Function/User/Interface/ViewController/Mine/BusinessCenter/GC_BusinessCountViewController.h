//
//  GC_BusinessCountViewController.h
//  xianglegou
//
//  Created by mini3 on 2017/7/8.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  营业中心 数目
//

#import "Hen_BaseViewController.h"

@interface GC_BusinessCountViewController : Hen_BaseViewController

///地区Id
@property (nonatomic, strong) NSString *areaId;
///营业类型
@property (nonatomic, assign) NSInteger businessType;
@end
