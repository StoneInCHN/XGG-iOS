//
//  GC_UserHelpModel.h
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_UserHelpModel : Hen_JsonModel

@end


#pragma mark -- 帮助列表信息

@interface GC_MResUserHelpListDataModel : Hen_JsonModel
///ID
@property (nonatomic, strong) NSString *id;
///标题
@property (nonatomic, strong) NSString *title;
@end


#pragma mark -- 帮助信息

@interface GC_MResUserHelpDetailDataModel : Hen_JsonModel
///ID
@property (nonatomic, strong) NSString *id;
///标题
@property (nonatomic, strong) NSString *title;
///内容
@property (nonatomic, strong) NSString *content;
@end
