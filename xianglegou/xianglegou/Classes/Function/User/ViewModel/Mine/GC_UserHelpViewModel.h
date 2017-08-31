//
//  GC_UserHelpViewModel.h
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_BaseViewModel.h"
#import "GC_UserHelpModel.h"

@interface GC_UserHelpViewModel : Hen_BaseViewModel

///获取帮助信息列表 数据
@property (nonatomic, strong) NSMutableArray<GC_MResUserHelpListDataModel*>* userHelpListDatas;
///获取帮助信息列表 方法
-(void)getUserHelpListDatasWithResultBlock:(RequestResultBlock)resultBlock;


///获取帮助详细信息 参数
@property (nonatomic, strong) NSMutableDictionary *userHelpDetailParam;
///获取帮助详细信息 数据
@property (nonatomic, strong) GC_MResUserHelpDetailDataModel *userHelpDetailData;
///获取帮助详细信息 方法
-(void)getUserHelpDetailDataWithResultBlock:(RequestResultBlock)resultBlock;
@end
