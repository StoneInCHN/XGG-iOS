//
//  LLJsonModel.m
//  InvorkTrain01
//
//  Created by lyc on 15/4/21.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "Hen_JsonModel.h"
#import <objc/runtime.h>
#import "Hen_JsonClassProperty.h"

@interface Hen_JsonModel();

@property(nonatomic, strong) Hen_JsonClassProperty *classProperty;

@end

@implementation Hen_JsonModel

- (id)initwithJsonString:(NSString *)jsonStr{
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    // JSON解析
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    return [self initWithDictionary:object];
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [self init];
    [self setValueWithDictionary:dic obj:self];
    return self;
}

- (id)initWithSqlite3Stmt:(sqlite3_stmt*)stmt
{
    self = [self init];
    [self setValueWithSqlite3Stmt:stmt obj:self];
    return self;
}

-(NSMutableDictionary*)toDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSArray *arr = [self getAllProperties:[self class]];
    
    for (NSInteger i = 0; i < [arr count]; i++)
    {
        Hen_JsonClassProperty *classProperty = [arr objectAtIndex:i];
        
        id value =  [self performSelector:NSSelectorFromString(classProperty.propertyName)];
        if(value){
            if([classProperty.propertyName isEqualToString:@"token"] || [classProperty.propertyName isEqualToString:@"userId"]){
                [result setObject:value forKey:classProperty.propertyName];
            }else{
                if(![value isEqualToString:@""]){
                    [result setObject:value forKey:classProperty.propertyName];
                }
            }
        }
    }
    
    return result;
}

- (void)setValueWithDictionary:(NSDictionary *)dic obj:(id)obj
{
    
    NSArray *arr = [obj getAllProperties:[obj class]];
    
    for (NSInteger i = 0; i < [arr count]; i++)
    {
        
        Hen_JsonClassProperty *classProperty = [arr objectAtIndex:i];
        
        NSString *key = classProperty.propertyName;
        NSString *kind = classProperty.kind;
        
        //初始化
        Class kindClass =  NSClassFromString(kind);
        if ([kindClass isSubclassOfClass:[Hen_JsonModel class]])
        {   // 如果属性为HtcJsonModel对象的时候
            // new出对象
            id kindObj = [kindClass new];
            // 将new出的对象赋值给现对象中的对象
            [obj setValue:kindObj forKey:key];
        } else if([kindClass isSubclassOfClass:[NSArray class]]){ // 属性为数组
            // 初始化数组
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            // 将对象赋值给现对象中的对象
            [obj setValue:array forKey:key];
        } else if([kindClass isSubclassOfClass:[NSString class]]){
            [obj setValue:@"" forKey:key];
        }
        
        if(![dic isKindOfClass:[NSDictionary class]]){
            continue;
        }
        
        id value = [dic objectForKey:key];
        if([key isEqualToString:@"Description"]){
            value = [dic objectForKey:@"description"];
        }
        
        if ([kindClass isSubclassOfClass:[Hen_JsonModel class]])
        {   // 如果属性为HtcJsonModel对象的时候
            // new出对象
            id kindObj = [kindClass new];
            // 将new出的对象赋值给现对象中的对象
            [obj setValue:kindObj forKey:key];
            // 递归进行遍历
            [obj setValueWithDictionary:value obj:kindObj];
        } else if([kindClass isSubclassOfClass:[NSArray class]]){ // 属性为数组
            // 初始化数组
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            
            @try {
                // 遍历
                for(id child in value){
                    
                    if ([child isKindOfClass:NSDictionary.class] && classProperty.isOptional){
                        //获取model对象
                        Class childKindClass = NSClassFromString(classProperty.protocolName);
                        if(childKindClass){
                            // new出对象
                            id kindObj = [childKindClass new];
                            // 递归进行遍历
                            [obj setValueWithDictionary:child obj:kindObj];
                            // 保存
                            [array addObject:kindObj];
                        }
                    }/*else if([child isKindOfClass:[NSArray class]]){
                        //获取model对象
                        Class childKindClass = NSClassFromString(classProperty.protocolName);
                        if(childKindClass){
                            // new出对象
                            id kindObj = [childKindClass new];
                            // 递归进行遍历
                            [obj setValueWithArray:child forKey:classProperty.propertyName obj:kindObj];
                        }
                    }*/else{
                        [array addObject:child];
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            // 将对象赋值给现对象中的对象
            [obj setValue:array forKey:key];
        } else if([kindClass isSubclassOfClass:[NSString class]]){
            if (value && [NSNull null] != value){
                [obj setValue:[self reviseString:value] forKey:key];
            }else{
                [obj setValue:@"" forKey:key];
            }
        } else {
            if (value && [NSNull null] != value){
                [obj setValue:value forKey:key];
            }
        }
    }
}

- (void)setValueWithArray:(NSMutableArray *)valueArray forKey:(NSString*)key obj:(id)obj
{
    // 初始化数组
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *arr = [obj getAllProperties:[obj class]];
    
    for(Hen_JsonClassProperty *classProperty in arr){
        for(NSInteger i = 0; i < valueArray.count; i++){
            id child = valueArray[i];
            if ([child isKindOfClass:NSDictionary.class]){
                //获取model对象
                Class childKindClass = NSClassFromString(classProperty.protocolName);
                if(childKindClass){
                    // new出对象
                    id kindObj = [childKindClass new];
                    // 递归进行遍历
                    [obj setValueWithDictionary:child obj:kindObj];
                }
                // 保存
                [array addObject:obj];
            }else if([child isKindOfClass:[NSArray class]]){
                //获取model对象
                Class childKindClass = NSClassFromString(classProperty.protocolName);
                if(childKindClass){
                    // new出对象
                    id kindObj = [childKindClass new];
                    // 递归进行遍历
                    [obj setValueWithArray:child forKey:classProperty.propertyName obj:kindObj];
                }
            }else{
                [array addObject:child];
            }
        }
    }
    
    // 将对象赋值给现对象中的对象
    [obj setValue:array forKey:key];
}

- (void)setValueWithSqlite3Stmt:(sqlite3_stmt*)stmt obj:(id)obj
{
    NSArray *arr = [obj getAllProperties:[obj class]];
    
    for (int i = 0; i < [arr count]; i++)
    {
        
        Hen_JsonClassProperty *classProperty = [arr objectAtIndex:i];
        
        NSString *key = classProperty.propertyName;
        NSString *kind = classProperty.kind;
        
        Class kindClass =  NSClassFromString(kind);
        if([kindClass isSubclassOfClass:[NSString class]]){
            [obj setValue:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, i)] forKey:key];
        }else{
            [obj setValue:[NSNumber numberWithInteger:sqlite3_column_int(stmt, i)] forKey:key];
        }
    }
}

// 获取属性和对象种类
- (NSArray *)getAllProperties:(Class)class
{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSMutableArray *classPropertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++)
    {
        Hen_JsonClassProperty *classProperty = [[Hen_JsonClassProperty alloc] init];
        
//        const char *propertyName =property_getName(properties[i]);
//        classProperty.propertyName = [NSString stringWithUTF8String: propertyName];
//        
//        const char *attributes = property_getAttributes(properties[i]);//获取属性类型
//        NSString *attr = [NSString stringWithUTF8String: attributes];
//        NSString *kind = [[attr componentsSeparatedByString:@","] objectAtIndex:0];
//        kind = [kind stringByReplacingOccurrencesOfString:@"T@" withString:@""];
//        kind = [kind stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        [classProperty setKind:kind];
        
        objc_property_t property = properties[i];
        //获取属性名
        const char * name = property_getName(property);
        classProperty.propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        //获取属性类型
        const char * type = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            //it's a float
            [classProperty setKind:@"float"];
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            //it's an int
            [classProperty setKind:@"int"];
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            //it's some sort of object
            [classProperty setKind:@"id"];
        }
        
        if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 2) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
            [classProperty setKind:typeClassName];
        }
        
        [classPropertyArray addObject:classProperty];
    }
    free(properties);
    
    return classPropertyArray;
}

-(Hen_JsonClassProperty*)classProperty{
    if(!_classProperty){
        _classProperty = [[Hen_JsonClassProperty alloc] init];
    }
    return _classProperty;
}

/*!
 @brief 修正浮点型精度丢失
 @param str 传入接口取到的数据
 @return 修正精度后的数据
 */
-(NSString *)reviseString:(id)str
{
    if([str isKindOfClass:[NSNumber class]]){
        //直接传入精度丢失有问题的Double类型
        double conversionValue = [str doubleValue];
        NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
        NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
        return [decNumber stringValue];
    }
    
    return [NSString stringWithFormat:@"%@", str];
}


@end
