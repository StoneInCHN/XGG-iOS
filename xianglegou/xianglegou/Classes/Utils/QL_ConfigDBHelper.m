//
//  QL_ConfigDBHelper.m
//  Peccancy
//
//  Created by mini2 on 16/10/17.
//  Copyright © 2016年 Peccancy. All rights reserved.
//
// 配置数据库帮助类
//

#import "QL_ConfigDBHelper.h"
#import <sqlite3.h> 

@interface QL_ConfigDBHelper(){
    sqlite3 *db;
}

@end

@implementation QL_ConfigDBHelper

-(id)init
{
    self = [super init];
    if(self){
        [self opentDB];
    }
    return self;
}

///打开数据库
-(void)opentDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"area.db"];
    
    if (sqlite3_open([dbPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
}

///执行sql语句
-(void)execSql:(NSString*)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"数据库操作数据失败! -- %s", err);
    }
}

///关闭数据库
-(void)closeDB
{
    sqlite3_close(db);
}

///获取城市id
-(NSString*)getCityIdForCityName:(NSString*)cityName
{
    NSString* result = @"";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT id FROM rm_area WHERE name = '%@'", cityName];
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            result = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    
    return result;
}

///获取城市名字
-(NSString*)getCityNameForCityId:(NSString*)cityId
{
    NSString* result = @"";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM rm_area WHERE id = '%@'", cityId];
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            result = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    
    return result;
}
///获取省
- (NSMutableArray<QL_AreaDataModel*>*) getProvinceDatas
{
    NSMutableArray<QL_AreaDataModel*>* result = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *sql = @"SELECT * FROM rm_area WHERE parent is NULL";
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            QL_AreaDataModel *model = [[QL_AreaDataModel alloc] initWithSqlite3Stmt:stmt];
            
            [result addObject:model];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    
    return result;
}

///获取城市
-(NSMutableArray<QL_AreaDataModel*>*)getCityDatas
{
    NSMutableArray<QL_AreaDataModel*>* result = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *sql = @"SELECT * FROM rm_area WHERE is_city = 1";
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            QL_AreaDataModel *model = [[QL_AreaDataModel alloc] initWithSqlite3Stmt:stmt];
            
            [result addObject:model];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    
    return result;
}

///获取地区数据
- (NSMutableArray<QL_AreaDataModel*>*)getAreaDatasForParentId:(NSString *)parentId
{
    NSMutableArray<QL_AreaDataModel*>* result = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM rm_area WHERE parent = '%@'", parentId];
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            QL_AreaDataModel *model = [[QL_AreaDataModel alloc] initWithSqlite3Stmt:stmt];
            
            [result addObject:model];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    
    return result;
}

///获取地区数据
- (QL_AreaDataModel *)getAreaDataForId:(NSString *)areaId
{
    QL_AreaDataModel *result;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM rm_area WHERE id = '%@'", areaId];
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            result = [[QL_AreaDataModel alloc] initWithSqlite3Stmt:stmt];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    
    return result;
}

///获取查询城市商家列表地区id
- (NSString *)getQuaryCityBusinessListAreaId:(NSString *)cityId
{
    NSString *result = [NSString stringWithFormat:@"%@,", cityId];
    
    //获取地区数据
    NSMutableArray<QL_AreaDataModel*>* areaArray = [self getAreaDatasForParentId:DATAMODEL.cityId];
    for(QL_AreaDataModel *model in areaArray){
        result = [result stringByAppendingFormat:@"%@,", model.areaId];
    }
    result = [result substringToIndex:result.length - 1];
    
    return result;
}

///获取省市区名字
- (NSString *)getProvinceCityAreaNameForAreaId:(NSString *)areaId
{
    QL_AreaDataModel *areaData = [self getAreaDataForId:areaId];
   
    return areaData.fullName;
}

/// 获取文件md5
+(NSString*)getFileMD5:(NSString*)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

/// 下载地区数据库
+(void)downloadAraeDB:(NSString*)fileName url:(NSString*)urlString
{
    //下载附件
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:url];
    
    //下载缓存文件
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    NSString*downPath =[documentsDirectory stringByAppendingPathComponent:@"car_peccancy_config_temp.db"];
    //文件管理
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    if([fileManager fileExistsAtPath:downPath]){
        //删除文件
        [fileManager removeItemAtPath:downPath error:&error];
    }
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:downPath append:NO];
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"--------下载地区数据库成功!-----------");
        //关闭数据库
        [DATAMODEL.configDBHelper closeDB];
        
        //文件管理
        NSFileManager*fileManager =[NSFileManager defaultManager];
        NSError*error;
        if([fileManager fileExistsAtPath:fileName]){
            //删除文件
            [fileManager removeItemAtPath:fileName error:&error];
        }
        //拷贝
        [fileManager copyItemAtPath:downPath toPath:fileName error:&error];
        
        //打开数据
        [DATAMODEL.configDBHelper opentDB];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //下载失败
        NSLog(@"--------下载地区数据库失败!-----------");
    }];
    
    [operation start];
}


@end
