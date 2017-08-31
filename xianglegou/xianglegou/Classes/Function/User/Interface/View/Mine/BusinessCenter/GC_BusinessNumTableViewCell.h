//
//  GC_BusinessNumTableViewCell.h
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  个数 - cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_BusinessNumTableViewCell : Hen_BaseTableViewCell

///地区ID
- (void)updateUiForAreaInfo:(NSString *)areaId;

///更新 ui
- (void)updateUiForBusinessCount:(NSString *)count andType:(NSInteger)type;
@end
