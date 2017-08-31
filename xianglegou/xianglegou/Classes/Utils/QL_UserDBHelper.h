//
//  QL_UserDBHelper.h
//  Exam
//
//  Created by mini2 on 16/9/14.
//  Copyright © 2016年 Exam. All rights reserved.
//
// 用户数据库帮助类
//

#import <Foundation/Foundation.h>
#import "QL_BusinessModel.h"

@interface QL_UserDBHelper : NSObject

///获取搜索历史
- (NSMutableArray<QL_SearchHistoryDataModel *> *)getSearchHistory;
///插入搜索历史
- (void)insertSearchHistoryContent:(NSString *)content time:(NSString *)time;
///删除搜索历史
- (void)deleteSearchHistory;

///获取token
- (NSString *)getToken;
///获取userId
- (NSString *)getUserId;
///获取城市id
- (NSString *)getCityId;
///获取启动次数
- (NSString *)getStartAppCount;
///获取用户手机号
- (NSString *)getUserMoblie;
///更新token
- (void)updateToken:(NSString *)token;
///更新userId
- (void)updateUserId:(NSString *)userId;
///更新城市id
- (void)updateCityId:(NSString *)cityId;
///更新启动次数
- (void)updateAppStartCount;
///更新用户手机号
- (void)updateUserMoblie:(NSString *)mobile;

@end
