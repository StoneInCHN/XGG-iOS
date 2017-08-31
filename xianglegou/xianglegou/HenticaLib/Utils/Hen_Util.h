//
//  HTC_Util.h
//  CRM
//
//  Created by mini2 on 16/5/25.
//  Copyright © 2016年 hentica. All rights reserved.
//
// 工具类
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Hen_Configure.h"

@interface Hen_Util : NSObject

///iOS设配 适配配置
@property(nonatomic, strong) Hen_Configure* configure;

////初始化一个单实例
+ (Hen_Util *)getInstance;

///获取系统日期
-(NSString*)getSystemDate;
///获取系统时间
-(NSString*)getSystemTime;
///获取当前系统日期时间
-(NSString*)getSystemDateTime;

///日期字符串转Date
-(NSDate*)dateStringToDate:(NSString*)dateString;
///时间字符串转Date
-(NSDate*)timeStringToDate:(NSString*)timeString;
///日期时间字符串转Date
-(NSDate*)dateTimeToDateTime:(NSString*)dateTimeString;


/// date转日期字符串
- (NSString *)dateToString:(NSDate *)date;
/// date转时间字符串
- (NSString *)timeToString:(NSDate *)timeDate;
/// date转日期时间字符串
- (NSString *)dateTimeToString:(NSDate *)dateTime;

/// 比较日期大小默认会比较到秒
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

/// 时间戳转换
- (NSString *)timeStampToString:(NSString *)timeStamp;

/// 时间戳转换（含 年月日 时分）
- (NSString *)dateTimeStampToString:(NSString *)dateTimeStamp;
/// 日期 转 时间戳
- (NSString *)dateTimeSecondStampToString:(NSString *)dateTimeSecondString;
///把中文转换成英文
- (NSString *)changeChineseToEnglishBy:(NSString *)string;

///获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentViewController;

/// 计算字符串宽度
- (CGFloat)calculateWidthForString:(NSString *)string andTextHeight:(CGFloat)height anFont:(UIFont*)font;

///计算字符串高度
-(CGFloat)calculationHeightForString:(NSString *)string anTextWidth:(CGFloat)widthText anFont:(UIFont*)font;

///计算字符串高度
-(CGFloat)calculationHeightForString:(NSString *)string anTextWidth:(CGFloat)widthText anRowHeight:(CGFloat)rowHeight anFont:(UIFont*)font;

///图片缩放 scaleSize:缩放大小
- (UIImage *)scaleImage:(UIImage *)image toScale:(CGSize)scaleSize;

///图片缩放 maxEdge:最大边
- (UIImage *)scaleImage:(UIImage *)image maxEdge:(CGFloat)maxEdge;

///图片旋转
- (UIImage *)fixOrientation:(UIImage *)aImage;

/// 拉伸图片 top > 顶端盖高度 bottom > 底端盖高度 left > 左端盖宽度 right > 右端盖宽度
- (UIImage *)stretchImageWithImage:(UIImage *)originalImage
                               top:(CGFloat)top
                            bottom:(CGFloat)bottom
                              left:(CGFloat)left
                             right:(CGFloat)right;

// 根据图片url获取图片尺寸
-(CGSize)getImageSizeWithURL:(id)imageURL;

//获取视频封面，本地视频，网络视频都可以用
- (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL;

///自定UIImage长宽
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

///异步加载
-(void)asynchronousLoadingBlock:(void(^)())loadBlock finishBlock:(void(^)())finishBlock;

///点击显示大图
-(void)clickShowBigPicture:(NSMutableArray*)imageArray forView:(UIView*)view andCurrentTouch:(NSInteger)item;

///跳转到appStroe
- (void)toAppStore:(NSDictionary*)appInfo appId:(NSString*)appId;

///客服电话
-(void)customerPhone:(NSString *)phone;

///获取显示字符串后面位数
- (NSString*)getStringLastThree:(NSString*)string andCharNum:(NSInteger)charNum;
///获取显示字符串前5位
- (NSString*)getStringBeforeFive:(NSString*)string;
///字符串显示小数
- (NSString *)string:(NSString *)string showDotNumber:(NSInteger)dot;

///小数点格式化：如果有两位小数不为0则保留两位小数，如果有一位小数不为0则保留一位小数，否则显示整数
- (NSString *)formatFloat:(float)f;

///字符串替换
- (NSString *)replaceString:(NSString *)replaceString replaceedString:(NSString *)replaceedString resourceString:(NSString *)resourceString;

///是否纯数字
- (BOOL)isPureInt:(NSString*)string;

///判断是否为几位小数
-(BOOL)isFourMath:(NSString *)string len:(NSString *)len;

///判断一个数是否是另一数的整数倍
-(BOOL)judgeStr:(NSString *)str1 with:(NSString *)str2;
@end
