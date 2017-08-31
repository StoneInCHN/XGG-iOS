//
//  QL_SettledShopViewController.h
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 入驻商铺界面
//

#import "Hen_BaseViewController.h"

@interface QL_SettledShopViewController : Hen_BaseViewController

///是否审核中
@property(nonatomic, assign) BOOL isAuditing;
///是否审核失败
@property(nonatomic, assign) BOOL isAuditeFail;


///商家电话
@property (nonatomic, strong) NSString *shopMobile;

///商户Id
@property (nonatomic, strong) NSString *shopId;

///失败原因
@property (nonatomic, strong) NSString *failureReason;
@end
