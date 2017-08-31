//
//  QL_SettledShopViewModel.m
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SettledShopViewModel.h"

@implementation QL_SettledShopViewModel

///获取店铺的行业类别
- (void)getSellerCategoryWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:seller_getSellerCategory dictionaryParam:@{} withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            [self.sellerCategoryDatas removeAllObjects];
            for(NSDictionary *dic in msg){
                [self.sellerCategoryDatas addObject:[[QL_SellerCategoryDataModel alloc] initWithDictionary:dic]];
            }
            
            if(resultBlock){
                resultBlock(code, desc, self.sellerCategoryDatas, nil);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, nil, nil);
            }
        }
    }];
}

///入驻
- (void)settledShopWithResultBlock:(RequestResultBlock)resultBlock
{
    
    [[Hen_MessageManager shareMessageManager] requestApplyWithAction:seller_apply dictionaryParam:[self.settledParam toDictionary] storePicture:self.logoImage licenseImg:self.businessLicenseImage envImgs:self.environmentalPhotos commitmentImgs:self.commitmentPhotos withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, nil, nil);
        }
    }];
}


///获取类别信息
- (NSString *)getTypeInfo
{
    if(self.settledParam.categoryId.length > 0){
        for(QL_SellerCategoryDataModel *model in self.sellerCategoryDatas){
            if([self.settledParam.categoryId isEqualToString:model.id]){
                return model.categoryName;
            }
        }
    }
    return @"行业类别";
}


///验证手机号是否已注册会员或成为商家 方法
- (void)setEndUserVerifyMobileDataWithResultBlock:(RequestResultBlock)resultBlock
{
    [[Hen_MessageManager shareMessageManager] requestWithAction:endUser_verifyMobile dictionaryParam:self.verifyMobileParam withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if(resultBlock){
            resultBlock(code, desc, msg, page);
        }
    }];
}



#pragma mark -- getter,setter

///请求参数
- (QL_SettledShopRequestDataModel *)settledParam
{
    if(!_settledParam){
        _settledParam = [[QL_SettledShopRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _settledParam;
}

///行业类别数据
- (NSMutableArray<QL_SellerCategoryDataModel *> *)sellerCategoryDatas
{
    if(!_sellerCategoryDatas){
        _sellerCategoryDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _sellerCategoryDatas;
}


///验证手机号是否已注册会员或成为商家 参数
- (NSMutableDictionary *)verifyMobileParam
{
    if(!_verifyMobileParam){
        _verifyMobileParam = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        
        //用户ID
        [_verifyMobileParam setObject:@"" forKey:@"userId"];
        
        //用户token
        [_verifyMobileParam setObject:@"" forKey:@"token"];
        
        //待验证的手机号
        [_verifyMobileParam setObject:@"" forKey:@"cellPhoneNum"];
        

    }
    return _verifyMobileParam;
}

@end
