//
//  QL_MineShopViewViewModel.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_MineShopViewViewModel.h"

@implementation QL_MineShopViewViewModel

///获取店铺信息
- (void)getShopInfoDataWithResultBlock:(RequestResultBlock)resultBlock
{
    //参数
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":DATAMODEL.userInfoData.id, @"token":DATAMODEL.token}];
    [[Hen_MessageManager shareMessageManager] requestWithAction:seller_getSellerInfo dictionaryParam:param  withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            self.shopInfoData = [[QL_ShopInformationDataModel alloc] initWithDictionary:msg];
            
            if(resultBlock){
                resultBlock(code, desc, self.shopInfoData, page);
            }
        }else{
            if(resultBlock){
                resultBlock(code, desc, msg, page);
            }
        }
    }];
}

@end
