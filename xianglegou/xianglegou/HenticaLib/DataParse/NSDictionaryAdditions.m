//
//  NSDictionaryAdditions.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "NSDictionaryAdditions.h"


@implementation NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [self objectForKey:key] == [NSNull null] ? defaultValue 
						: [[self objectForKey:key] boolValue];
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
	return [self objectForKey:key] == [NSNull null] 
				? defaultValue : [[self objectForKey:key] intValue];
}

- (NSInteger)getIntegerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue{
    return [self objectForKey:key] == [NSNull null] ? defaultValue : [[self objectForKey:key] integerValue];
}

- (float)getFloatValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    return [self objectForKey:key] == [NSNull null]
				? defaultValue : [[self objectForKey:key] floatValue];
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
	NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
	return [self objectForKey:key] == [NSNull null] 
		? defaultValue : [[self objectForKey:key] longLongValue];
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
	NSString *string = [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] ? defaultValue : [self objectForKey:key];
    
    if ([[self objectForKey:key] isKindOfClass:[NSString class]]) {
        if (string.length <= 0) {
            string = defaultValue;
        }
    }
    
    return [NSString stringWithFormat:@"%@",string];
}

- (NSURL *)getUrlValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    NSString *url = [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] ?defaultValue : [self objectForKey:key];
    
    return [NSURL URLWithString:url];
}

@end
