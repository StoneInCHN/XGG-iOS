//
//  define.h
//  dentistry
//
//  Created by mini2 on 15/12/22.
//  Copyright © 2015年 hentica. All rights reserved.
//

#import "DataModel.h"
#import "ActionDefine.h"
#import "EnumDefine.h"

#import "QL_NothingNoticeView.h"

#import "QL_ConfigDataModel.h"
#import "GC_MineMessageModel.h"

#ifndef define_h
#define define_h

///获取DataModel单例
#define DATAMODEL [DataModel getInstance]

///距离左边边距
#define OffSetToLeft    WIDTH_TRANSFORMATION(30)
///距离右边边距
#define OffSetToRight   WIDTH_TRANSFORMATION(-30)
///通用cell高度
#define CommonCellHeight    HEIGHT_TRANSFORMATION(100)

///分页条数
#define NumberOfPages   @"20"
///图片URL基础地址
#define PngBaseUrl      [NSString stringWithFormat:@"%@/rebate-interface", APP_SERVER]

///商家字体黑色
#define kBussinessFontColorBlack         [UIColor colorWithHexString:@"#000000"]

#endif /* define_h */
