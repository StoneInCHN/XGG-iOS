//
//  GC_SettingTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseTableViewCell.h"

@interface GC_SettingTableViewCell : Hen_BaseTableViewCell

///图标
@property (nonatomic, strong) NSString *icon;
///标题
@property (nonatomic, strong) NSString *title;
///内容
@property (nonatomic, strong) NSString *content;
@end
