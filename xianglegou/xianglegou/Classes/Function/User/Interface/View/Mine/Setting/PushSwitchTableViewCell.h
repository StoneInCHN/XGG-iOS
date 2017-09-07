//
//  PushSwitchTableViewCell.h
//  xianglegou
//
//  Created by lieon on 2017/9/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_BaseTableViewCell.h"

@interface PushSwitchTableViewCell : Hen_BaseTableViewCell
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) void(^switchBlock)(BOOL isOn);
@end
