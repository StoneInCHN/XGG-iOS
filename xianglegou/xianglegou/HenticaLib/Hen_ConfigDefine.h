//
//  Hen_ConfigDefine.h
//  Peccancy
//
//  Created by mini2 on 16/11/15.
//  Copyright © 2016年 Peccancy. All rights reserved.
//
// 配置定义
//

#ifndef Hen_ConfigDefine_h
#define Hen_ConfigDefine_h

///是否开发
#define IsDevelopment   1

#pragma mark -- 服务器地址

///生产环境
//#define APP_SERVER                 @"http://120.77.42.164"
//#define APP_SERVER               @"http://xgg.wa12580.cn"

/// 测试
#define APP_SERVER               @"http://120.78.134.176:8080"


#pragma mark -- 字体颜色
///字体黑色
#define kFontColorBlack         [UIColor colorWithHexString:@"#585657"]
///字体灰色
#define kFontColorGray          [UIColor colorWithHexString:@"#999999"]
///橙色
#define kFontColorOrange        [UIColor colorWithHexString:@"#ff992c"]
///字体蓝色
#define kFontColorBlue          [UIColor colorWithHexString:@"#2d68d1"]
///字体红色
#define kFontColorRed           [UIColor colorWithHexString:@"#e71810"]
///字体白色
#define kFontColorWhite         [UIColor colorWithHexString:@"#ffffff"]
///字体绿色
#define kFontColorGreen         [UIColor colorWithHexString:@"#44d764"]

#pragma mark -- 背景颜色

///通用背景色
#define kCommonBackgroudColor   [UIColor colorWithHexString:@"#f9f9f9"]
///通用白色背景
#define kCommonWhiteBg          [UIColor colorWithHexString:@"#ffffff"]
///通用蓝色背景
#define kCommonBlueBgColor      [UIColor colorWithHexString:@"#2d68d1"]
///通用黄色背景
#define KCommonYellowBgColor    [UIColor colorWithHexString:@"#FEDC25"]
///通用红色背景
#define KCommonRedBgColor       [UIColor colorWithHexString:@"#ff4946"]
#pragma mark -- 第三方appkey，appsecret

///新浪微博
#define SINA_APP_KEY @"333900906"
#define SINA_APP_SECRET @"0fe03f996c725f91d778080f8c38b346"
///QQ
#define QQ_APP_KEY @""
#define QQ_APP_SECRET @""
//#define QQ_APP_KEY @"1105731141"
//#define QQ_APP_SECRET @"2mBDWLfXsfI7gcZp"
///友盟
#define UM_APPKey @"59296daf45297d35c1000e8c"
///微信
#define WX_BASE_URL @"https://api.weixin.qq.com/sns"
#define WX_APP_KEY @"wx8a45d94b37c548c7"
#define WX_APP_SECRET @"34ab52cf4e21871586e4b0e904a70b30"
///微信支付
#define WX_DESCRIPTION  @"xianglegou"


///百度 KEY
#define BD_APP_KEY @"9N7ukVnwgUnvhMEtayLw5UD0xyFtSvHB"
#endif /* Hen_ConfigDefine_h */
