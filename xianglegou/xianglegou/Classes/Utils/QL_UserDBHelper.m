//
//  QL_UserDBHelper.m
//  Exam
//
//  Created by mini2 on 16/9/14.
//  Copyright © 2016年 Exam. All rights reserved.
//

#import "QL_UserDBHelper.h"
#import <sqlite3.h>

//搜索历史表
#define UserSearchHistory   @"user_search_history"
//用户信息表
#define UserAchievement     @"user_info"
//配置表
#define ConfigInfo          @"config_info"

@interface QL_UserDBHelper(){
    sqlite3 *db;
}

@end

@implementation QL_UserDBHelper

-(id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    
    return self;
}

///初始化
-(void)initDefault
{
    //打开数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"user.sqlite"];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    //搜索历史
    NSString *sql1 = [NSString stringWithFormat:@"CREATE TABLE %@('content' TEXT, 'time' TEXT,'addTime' INTEGER)", UserSearchHistory];
    [self execSql:sql1];
    //用户信息表
    NSString *sql2 = [NSString stringWithFormat:@"CREATE TABLE %@('araeId' TEXT, 'araeName' TEXT,'agencyLevel' TEXT,'curScore' TEXT,'totalScore' TEXT,'curLeMind' TEXT,'totalLeMind' TEXT,'curLeBean' TEXT,'totalLeBean' TEXT,'curLeScore' TEXT,'totalLeScore' TEXT,'userPhoto' TEXT,'sellerStatus' TEXT,'nickName' TEXT,'cellPhoneNum' TEXT,'id' TEXT,'applyId' TEXT,'recommender' TEXT)", UserAchievement];
    [self execSql:sql2];
    //配置数据
    NSString *sql3 = [NSString stringWithFormat:@"CREATE TABLE %@('cityId' TEXT, 'token' TEXT, 'appCount' TEXT, 'userMoblie' TEXT, 'userId' TEXT)", ConfigInfo];
    if([self execSql:sql3]){
        // 插入配置数据
        NSString *insertConfigSql = [NSString stringWithFormat:@"INSERT INTO %@ (cityId,token,appCount,userMoblie,userId) VALUES ('','','','','')", ConfigInfo];
        [self execSql:insertConfigSql];
    }
}

///执行sql语句
-(BOOL)execSql:(NSString*)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"数据库操作数据失败! -- %s", err);
        return NO;
    }
    return YES;
}

///获取搜索历史
- (NSMutableArray<QL_SearchHistoryDataModel *> *)getSearchHistory
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY addTime DESC", UserSearchHistory];
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            QL_SearchHistoryDataModel *model = [[QL_SearchHistoryDataModel alloc] initWithSqlite3Stmt:stmt];
            [array addObject:model];
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    
    return array;
}

///插入搜索历史
- (void)insertSearchHistoryContent:(NSString *)content time:(NSString *)time
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where content = '%@'", UserSearchHistory, content];
    sqlite3_stmt *stmt = NULL;
    int status = sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    BOOL isHaveRecorde = NO;
    if (status == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            isHaveRecorde = YES;
        }
        sqlite3_finalize(stmt);
    } else {
        sqlite3_finalize(stmt);
    }
    
    //获取时间戳
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[date timeIntervalSince1970];
    
    if(!isHaveRecorde){
        // 插入
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (content,time,addTime) VALUES ('%@','%@','%ld')", UserSearchHistory, content, time, (long)[[NSString stringWithFormat:@"%f", a] integerValue]];
        [self execSql:sql];
    }else{
        //更新
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set time='%@',addTime='%ld' where content='%@'", UserSearchHistory, time, (long)[[NSString stringWithFormat:@"%f", a] integerValue], content];
        [self execSql:updateSql];
    }
}

///删除搜索历史
- (void)deleteSearchHistory
{
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@", UserSearchHistory];
    [self execSql:deleteSql];
}

///获取token
- (NSString *)getToken
{
    NSString *result = @"";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT token FROM %@", ConfigInfo];
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

///获取userId
- (NSString *)getUserId
{
    NSString *result = @"";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT userId FROM %@", ConfigInfo];
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

///获取城市id
- (NSString *)getCityId
{
    NSString *result = @"";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT cityId FROM %@", ConfigInfo];
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

///获取启动次数
- (NSString *)getStartAppCount
{
    NSString *result = @"";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT appCount FROM %@", ConfigInfo];
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

///获取用户手机号
- (NSString *)getUserMoblie
{
    NSString *result = @"";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT userMoblie FROM %@", ConfigInfo];
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

///更新token
- (void)updateToken:(NSString *)token
{
    //更新
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set token = '%@'", ConfigInfo, token];
    [self execSql:updateSql];
}

///更新userId
- (void)updateUserId:(NSString *)userId
{
    //更新
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set userId = '%@'", ConfigInfo, userId];
    [self execSql:updateSql];
}

///更新城市id
- (void)updateCityId:(NSString *)cityId
{
    //更新
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set cityId = '%@'", ConfigInfo, cityId];
    [self execSql:updateSql];
}

///更新启动次数
- (void)updateAppStartCount
{
    //更新
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set appCount = 1", ConfigInfo];
    [self execSql:updateSql];
}

///更新用户手机号
- (void)updateUserMoblie:(NSString *)mobile
{
    //更新
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set userMoblie = '%@'", ConfigInfo, mobile];
    [self execSql:updateSql];
}

@end
