//
//  Gps.h
//  ZhuZheJia
//
//  Created by mini2 on 16/10/8.
//  Copyright © 2016年 ZhuZheJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gps : NSObject

@property(nonatomic, assign) double wgLat;

@property(nonatomic, assign) double wgLon;

-(id)initWithLat:(double)lat Lon:(double)lon;

@end
