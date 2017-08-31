//
//  QL_ConfigDBHelper.h
//  Peccancy
//
//  Created by mini2 on 16/10/17.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QL_ConfigDataModel.h"

@interface QL_ConfigDBHelper : NSObject

///获取城市id
-(NSString*)getCityIdForCityName:(NSString*)cityName;
///获取城市名字
-(NSString*)getCityNameForCityId:(NSString*)cityId;

///获取省
- (NSMutableArray<QL_AreaDataModel*>*) getProvinceDatas;
///获取城市
-(NSMutableArray<QL_AreaDataModel*>*) getCityDatas;
///获取地区数据
- (NSMutableArray<QL_AreaDataModel*>*)getAreaDatasForParentId:(NSString *)parentId;
///获取地区数据
- (QL_AreaDataModel *)getAreaDataForId:(NSString *)areaId;
///获取查询城市商家列表地区id
- (NSString *)getQuaryCityBusinessListAreaId:(NSString *)cityId;
///获取省市区名字
- (NSString *)getProvinceCityAreaNameForAreaId:(NSString *)areaId;

/// 获取文件md5
+(NSString*)getFileMD5:(NSString*)filePath;

/// 下载地区数据库
+(void)downloadAraeDB:(NSString*)fileName url:(NSString*)urlString;

@end
