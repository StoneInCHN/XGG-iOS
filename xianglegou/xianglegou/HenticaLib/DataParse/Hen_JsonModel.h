//
//  LLJsonModel.h
//  InvorkTrain01
//
//  Created by lyc on 15/4/21.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@protocol NSString
@end

@interface Hen_JsonModel : NSObject

- (id)initwithJsonString:(NSString *)jsonStr;

- (id)initWithDictionary:(NSDictionary *)dic;

- (id)initWithSqlite3Stmt:(sqlite3_stmt *)stmt;

- (NSMutableDictionary *)toDictionary;

@end
