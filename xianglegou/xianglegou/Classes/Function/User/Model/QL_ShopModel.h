//
//  QL_ShopModel.h
//  Rebate
//
//  Created by mini2 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface QL_ShopModel : Hen_JsonModel

@end

#pragma mark -- 店铺的行业类别

@interface QL_SellerCategoryDataModel : Hen_JsonModel

///id
@property(nonatomic, strong) NSString *id;
///名字
@property(nonatomic, strong) NSString *categoryName;
///图片
@property(nonatomic, strong) NSString *categoryPicUrl;

@end

#pragma mark -- 店铺地区

@interface QL_ShopAreaDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *id;

@end


#pragma mark -- 店铺信息

@interface QL_ShopInformationDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *address;/// "sdsdsds",
@property(nonatomic, strong) QL_ShopAreaDataModel *area;///地区ID
@property(nonatomic, strong) NSString *avgPrice;/// 12,
@property(nonatomic, strong) NSString *latitude;/// 12,
@property(nonatomic, strong) NSString *Description;/// "dfdfdfdfdfdfdfdfdfdf",
@property(nonatomic, strong) NSString *discount;/// 9.5,
@property(nonatomic, strong) NSString *businessTime;/// "8:00-22:00",
///消费限额总额度
@property(nonatomic, strong) NSString *limitAmountByDay;
///录单订单总金额(元)
@property(nonatomic, strong) NSString *totalSellerOrderAmount;
///消费限额当前额度
@property(nonatomic, strong) NSString *curLimitAmountByDay;
/////商户录单订单总数
@property(nonatomic, strong) NSString *totalSellerOrderNum;
@property(nonatomic, strong) NSString *storePictureUrl;/// "http:",
@property(nonatomic, strong) NSString *favoriteNum;/// 230,
@property(nonatomic, strong) NSMutableArray<NSString> *envImgs;/// [],
@property(nonatomic, strong) NSString *storePhone;/// "1212",
@property(nonatomic, strong) NSString *name;/// "店铺名称",
@property(nonatomic, strong) NSString *featuredService;/// "WIFI",
@property(nonatomic, strong) NSString *totalOrderNum;/// 12,     //商户订单总数
@property(nonatomic, strong) NSString *totalOrderAmount;/// 1000.5,  //订单总金额(元)
@property(nonatomic, strong) NSString *unClearingAmount;/// 500,  //未结算(元)
@property(nonatomic, strong) NSString *id;/// 1,
@property(nonatomic, strong) NSString *longitude;/// 12
@property(nonatomic, strong) NSString *isAuth;      ///判断是否实名认证
///判断是否有银行卡
@property (nonatomic, strong) NSString *isOwnBankCard;
///是否支持乐豆抵扣
@property (nonatomic, strong) NSString *isBeanPay;
@end

#pragma mark -- 商户订单商家信息

@interface QL_ShopOrderShopInfoDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *id;

@end

#pragma mark -- 商户订单买家信息

@interface QL_ShopOrderBuyerInfoDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *nickName;///Andrea",
@property(nonatomic, strong) NSString *cellPhoneNum;//15902823856",
@property(nonatomic, strong) NSString *userPhoto;//null

@end

#pragma mark -- 商家订单评价信息

@interface QL_ShopOrderCommentDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *sellerReply;

@end

#pragma mark -- 商家订单列表

@interface QL_ShopOrderListDataModel : Hen_JsonModel

@property(nonatomic, strong) QL_ShopOrderShopInfoDataModel *seller;
@property(nonatomic, strong) QL_ShopOrderBuyerInfoDataModel *endUser;
@property(nonatomic, strong) NSString *amount;/// 100,
@property(nonatomic, strong) NSString *remark;/// null,
@property(nonatomic, strong) NSString *id;/// 2,
@property(nonatomic, strong) NSString *sn;/// "2017654331",
@property(nonatomic, strong) NSString *userScore;/// 100,
@property(nonatomic, strong) NSString *sellerScore;
@property(nonatomic, strong) QL_ShopOrderCommentDataModel *evaluate;/// {},
@property(nonatomic, strong) NSString *createDate;/// 1493267715000,
///status": "PAID"，表示用户已支付，订单待评价；如果"status": "FINISHED"，"evaluate": {"sellerReply": null},表示用户已评价，商家未回复；如果"status": "FINISHED"，"evaluate": {"sellerReply": "不为null"},表示商已回复用户评价
@property(nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *rebateAmount;
@property (nonatomic, strong) NSString *isSallerOrder;
@property (nonatomic, strong) NSString *isClearing;


@end

#pragma mark -- 商家二维码地区数据

@interface QL_ShopQRAreaDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *fullName;

@end

#pragma mark -- 商家二维码信息

@interface QL_ShopQRCodeInfoDataModel : Hen_JsonModel

@property(nonatomic, strong) QL_ShopQRAreaDataModel *area;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *qrImage;
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *storePictureUrl;
@property(nonatomic, strong) NSString *recommendUrl;

@end


