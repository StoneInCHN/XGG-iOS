//
//  Hen_FontDefine.h
//  CRM
//
//  Created by mini2 on 16/5/26.
//  Copyright © 2016年 hentica. All rights reserved.
//
// 字体定义
//

#import "UIColor+HexColor.h"

#ifndef Hen_FontDefine_h
#define Hen_FontDefine_h

///字体名字
#define kfontName           @"FZLanTingHeiS-UL-GB"

///自定义字体大小
#define CustomNameFontSize(n, s)    [UIFont fontWithName:n size:FITFONTSIZE(s)]
///自定义字体大小
#define CustomFontSize(s)           CustomNameFontSize(kfontName, FITFONTSIZE(s))
///系统字体大小
#define SystemFontSize(s)           [UIFont systemFontOfSize:FONTSIZE_TRANSFORMATION(s)]

#pragma mark ------------------ 字体大小
///示意图100号
#define kFontSize_100        SystemFontSize(100)
///示意图100号
#define kFontSize_72        SystemFontSize(72)
///示意图50号
#define kFontSize_52        SystemFontSize(52)
///示意图50号
#define kFontSize_50        SystemFontSize(50)
///示意图38号
#define kFontSize_38        SystemFontSize(38)
///示意图38号
#define kFontSize_36        SystemFontSize(36)
///示意图34号
#define kFontSize_34        SystemFontSize(34)
///示意图32号
#define kFontSize_32        SystemFontSize(32)
///示意图30号
#define kFontSize_30        SystemFontSize(30)
///示意图28号
#define kFontSize_28        SystemFontSize(28)
///示意图26号
#define kFontSize_26        SystemFontSize(26)
///示意图24号
#define kFontSize_24        SystemFontSize(24)
///示意图22号
#define kFontSize_22        SystemFontSize(22)
///示意图20号
#define kFontSize_20        SystemFontSize(20)
///示意图18号
#define kFontSize_18        SystemFontSize(18)
///示意图12号
#define kFontSize_12        SystemFontSize(12)

///示意图100号
#define kFont_100        FONTSIZE_TRANSFORMATION(100)
///示意图38号
#define kFont_38        FONTSIZE_TRANSFORMATION(38)
///示意图36号
#define kFont_36        FONTSIZE_TRANSFORMATION(36)
///示意图34号
#define kFont_34        FONTSIZE_TRANSFORMATION(34)
///示意图34号
#define kFont_32        FONTSIZE_TRANSFORMATION(32)
///示意图30号
#define kFont_30        FONTSIZE_TRANSFORMATION(30)
///示意图28号
#define kFont_28        FONTSIZE_TRANSFORMATION(28)
///示意图26号
#define kFont_26        FONTSIZE_TRANSFORMATION(26)
///示意图24号
#define kFont_24        FONTSIZE_TRANSFORMATION(24)
///示意图22号
#define kFont_22        FONTSIZE_TRANSFORMATION(22)
///示意图20号
#define kFont_20        FONTSIZE_TRANSFORMATION(20)
///示意图16号
#define kFont_16        FONTSIZE_TRANSFORMATION(16)

#endif /* fontDefine_h */
