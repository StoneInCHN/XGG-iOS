//
//  PosistionUtil.m
//  ZhuZheJia
//
//  Created by mini2 on 16/10/8.
//  Copyright © 2016年 ZhuZheJia. All rights reserved.
//

#import "PosistionUtil.h"

const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double x_pi = M_PI * 3000.0 / 180.0;

@implementation PosistionUtil

+(Gps*)bd09_To_Gcj02:(double)bd_lat lon:(double)bd_lon
{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return [[Gps alloc] initWithLat:gg_lat Lon:gg_lon];
}

@end
