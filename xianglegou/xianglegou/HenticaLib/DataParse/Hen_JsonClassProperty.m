//
//  HTCJsonClassProperty.m
//  CRM
//
//  Created by mini2 on 16/5/27.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import "Hen_JsonClassProperty.h"

@implementation Hen_JsonClassProperty

-(void)setKind:(NSString *)kind{
    if([kind rangeOfString:@"<"].location != NSNotFound){ // 包含<，说明是数组，且传入协议
        _isOptional = YES;
        NSArray *temp = [kind componentsSeparatedByString:@"<"];
        _kind = temp.firstObject;
        _protocolName = [temp.lastObject componentsSeparatedByString:@">"].firstObject;
    }else{
        _kind = kind;
    }
}

@end
