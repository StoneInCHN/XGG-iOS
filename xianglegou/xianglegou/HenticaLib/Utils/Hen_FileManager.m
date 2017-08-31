//
//  QL_FileManager.m
//  Weather
//
//  Created by mini2 on 16/8/12.
//  Copyright © 2016年 Weather. All rights reserved.
//

#import "Hen_FileManager.h"

@implementation Hen_FileManager

/// 字典数据写入文件
+(void)dictionary:(NSDictionary*)dictionary writeToFile:(NSString*)fileName
{
    if(!dictionary){
        return;
    }
    
    NSString *filePath = [self getFilePathForFileName:fileName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data =  [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        //往文件中写入数据
        [data writeToFile:filePath atomically:YES];
    });
}

///读取文件
+(NSDictionary*)readDictionaryFile:(NSString*)fileName
{
    NSDictionary *result;
    
    NSString *filePath = [self getFilePathForFileName:fileName];
    //检查附件是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        //从filePath中读取出数据
        NSData *data = [NSData dataWithContentsOfFile:filePath options:0 error:NULL];
        
        // 初始化解析错误
        NSError *error = nil;
        result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    }
    
    return result;
}

///获取文件路径
+(NSString*)getFilePathForFileName:(NSString*)fileName
{
    //保存的路径
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    //生成在该路径下的文件
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return filePath;
}

@end
