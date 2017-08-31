//
//  Gps.m
//  ZhuZheJia
//
//  Created by mini2 on 16/10/8.
//  Copyright © 2016年 ZhuZheJia. All rights reserved.
//

#import "Gps.h"

@implementation Gps

-(id)initWithLat:(double)lat Lon:(double)lon
{
    self = [super init];
    if(self){
        self.wgLat = lat;
        self.wgLon = lon;
    }
    return self;
}

@end
