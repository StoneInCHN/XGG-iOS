//
//  HTCJsonClassProperty.h
//  CRM
//
//  Created by mini2 on 16/5/27.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hen_JsonClassProperty : NSObject

@property(nonatomic, strong) NSString *propertyName;

@property(nonatomic, strong) NSString *kind;

@property(nonatomic, assign) BOOL isOptional;

@property(nonatomic, strong) NSString *protocolName;

-(void)setKind:(NSString *)kind;

@end
