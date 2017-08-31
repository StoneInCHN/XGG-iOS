//
//  QL_ConfigDataModel.m
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_ConfigDataModel.h"

@implementation QL_ConfigDataModel

@end

@implementation QL_AreaDataModel

-(id)initWithSqlite3Stmt:(sqlite3_stmt *)stmt
{
    _areaId = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)];
    _fullName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
    _name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
    const char *parentId = (const char *)sqlite3_column_text(stmt, 7);
    if(parentId){
        _parentId = [NSString stringWithUTF8String:parentId];
    }else{
        _parentId = @"";
    }
    _zhName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
    
    return self;
}

@end
