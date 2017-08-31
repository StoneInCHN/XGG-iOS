//
//  QL_BannerDetailsTableViewCell.h
//  Rebate
//
//  Created by mini2 on 17/4/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseTableViewCell.h"
#import "QL_BusinessModel.h"

@interface QL_BannerDetailsTableViewCell : Hen_BaseTableViewCell

///更新UI
- (void)updateUIForData:(QL_HomePageBannerDataModel *)data;

@end
