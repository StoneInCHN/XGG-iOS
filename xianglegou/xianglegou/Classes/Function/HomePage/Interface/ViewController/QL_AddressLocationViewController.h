//
//  QL_AddressLocationViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 地址定位界面
//

#import "Hen_BaseViewController.h"

@interface QL_AddressLocationViewController : Hen_BaseViewController

///地址
@property(nonatomic, strong) NSString *addressString;
///距离
@property(nonatomic, strong) NSString *distanceString;

///设置经纬度
-(void)setLatitude:(NSString*)latitude andLongitude:(NSString*)longitude;

@end
