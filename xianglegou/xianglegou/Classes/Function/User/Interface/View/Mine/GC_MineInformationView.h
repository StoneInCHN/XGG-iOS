//
//  GC_MineInformationView.h
//  Rebate
//
//  Created by mini3 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  我的基本信息 view
//

#import <UIKit/UIKit.h>

@interface GC_MineInformationView : UIView

///更新 ui
-(void)updataUiForUserInfoData:(GC_MResUserInfoDataModel*)data;
@end
