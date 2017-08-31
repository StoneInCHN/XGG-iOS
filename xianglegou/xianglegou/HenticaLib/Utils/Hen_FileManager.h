//
//  QL_FileManager.h
//  Weather
//
//  Created by mini2 on 16/8/12.
//  Copyright © 2016年 Weather. All rights reserved.
//
// 文件管理
//

#import <Foundation/Foundation.h>

@interface Hen_FileManager : NSObject

/// 字典数据写入文件
+(void)dictionary:(NSDictionary*)dictionary writeToFile:(NSString*)fileName;

///读取文件
+(NSDictionary*)readDictionaryFile:(NSString*)fileName;

@end
