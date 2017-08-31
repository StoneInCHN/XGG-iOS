//
//  QL_AbonusViewModel.h
//  Rebate
//
//  Created by mini2 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 分红view model
//

#import "Hen_BaseViewModel.h"
#import "QL_AbonusModel.h"

@interface QL_AbonusViewModel : Hen_BaseViewModel

///分红参数
@property(nonatomic, strong) NSMutableDictionary *abonusParam;

///用户分红数据
@property(nonatomic, strong) QL_UserAbonusDataModel *userAbonusData;
///获取用户分红数据
- (void)getUserAbonusDataWithResultBlock:(RequestResultBlock)resultBlock;

///全国分红数据
@property(nonatomic, strong) QL_AllAbonusDataModel *allAbonusData;
///获取全国分红数据
- (void)getAllAbonusDataWithResultBlock:(RequestResultBlock)resultBlock;


@end
