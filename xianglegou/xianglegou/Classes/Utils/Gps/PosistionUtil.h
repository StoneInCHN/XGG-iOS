//
//  PosistionUtil.h
//  ZhuZheJia
//
//  Created by mini2 on 16/10/8.
//  Copyright © 2016年 ZhuZheJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gps.h"

@interface PosistionUtil : NSObject

+(Gps*)bd09_To_Gcj02:(double)bd_lat lon:(double)bd_lon;

@end
