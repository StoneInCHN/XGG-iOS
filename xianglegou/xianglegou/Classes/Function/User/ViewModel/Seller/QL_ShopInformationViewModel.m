//
//  QL_ShopInformationViewModel.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_ShopInformationViewModel.h"

@implementation QL_ShopInformationViewModel

///修改商户信息
- (void)editShopInfoWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestApplyWithAction:seller_editInfo dictionaryParam:[self.editParam toDictionary] storePicture:self.logoImage licenseImg:nil envImgs:self.environmentalPhotos commitmentImgs:nil withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, nil, nil);
        }
    }];
}

#pragma mark -- getter,setter

///修改商户信息参数
- (QL_EditShopRequestDataModel *)editParam
{
    if(!_editParam){
        _editParam = [[QL_EditShopRequestDataModel alloc] initWithDictionary:@{}];
        
        _editParam.avgPrice = @"1";
    }
    return _editParam;
}

@end
