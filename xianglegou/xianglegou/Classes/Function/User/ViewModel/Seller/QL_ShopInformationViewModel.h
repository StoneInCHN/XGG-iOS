//
//  QL_ShopInformationViewModel.h
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 店铺信息
//

#import "Hen_BaseViewModel.h"
#import "QL_ShopModel.h"
#import "QL_ShopRequestDataModel.h"

@interface QL_ShopInformationViewModel : Hen_BaseViewModel

///修改商户信息参数
@property(nonatomic, strong) QL_EditShopRequestDataModel *editParam;
///logo图片
@property(nonatomic, strong) UIImage *logoImage;
///环境照片
@property(nonatomic, strong) NSMutableArray *environmentalPhotos;

///修改商户信息
- (void)editShopInfoWithResultBlock:(RequestResultBlock)resultBlock;

@end
