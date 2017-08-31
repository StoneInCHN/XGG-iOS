//
//  QL_BusinessModel.h
//  Rebate
//
//  Created by mini2 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"
#import "QL_ShopModel.h"

@interface QL_BusinessModel : Hen_JsonModel

@end

#pragma mark -- 首页banner数据

@interface QL_HomePageBannerDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *bannerUrl;// "dsd",
@property(nonatomic, strong) NSString *bannerName;// "2222",
@property(nonatomic, strong) NSString *id;// 2
@property(nonatomic, strong) NSString *title;// null,
@property(nonatomic, strong) NSString *content;// null,
@property(nonatomic, strong) NSString *createDate;// 1490608065000


@end

#pragma mark -- 商家列表数据

@interface QL_BusinessListDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *business_time;
@property(nonatomic, strong) NSString *rebateUserScore;//;/// 100,
@property(nonatomic, strong) NSString *address;//;/// null,
@property(nonatomic, strong) NSString *distance;//;/// "0.24",
@property(nonatomic, strong) NSString *unitConsume;//;/// 100,
@property(nonatomic, strong) NSString *latitude;//;/// 30.55319,
@property(nonatomic, strong) NSString *sellerName;//;/// "中和加油站",
@property(nonatomic, strong) NSString *Description;//;/// null,
@property(nonatomic, strong) NSString *rateScore;//;/// 5,
@property(nonatomic, strong) NSString *avg_price;//;/// 220,
@property(nonatomic, strong) NSString *storePictureUrl;//;/// "http:",
@property(nonatomic, strong) NSString *featured_service;//;/// "0",  //"0;///全部,"1" :WIFI,"2;///免费停车,null 无
@property(nonatomic, strong) NSString *categoryName;//;/// "KTV",
@property(nonatomic, strong) NSString *sellerId;//;/// 2,
@property(nonatomic, strong) NSString *storePhone;//;/// "1212",
@property(nonatomic, strong) NSString *favorite_num;//;/// 500, //收藏数
@property(nonatomic, strong) NSString *longitude;//;/// 104.076231
///判断商家是否支持乐豆支付
@property(nonatomic, strong) NSString *isBeanPay;
@end

#pragma mark -- 用户信息

@interface QL_EndUserDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *nickName;// "Andrea",
@property(nonatomic, strong) NSString *userPhoto;// null

@end

#pragma mark -- 图片数据

@protocol QL_EvaluateImageDataModel

@end

@interface QL_EvaluateImageDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *title;// null,
@property(nonatomic, strong) NSString *source;// "http://127.0.0.1:4001/dfdf/dfdf.jpg",
@property(nonatomic, strong) NSString *large;//: null,
@property(nonatomic, strong) NSString *medium;//: null,
@property(nonatomic, strong) NSString *thumbnail;//: null,
@property(nonatomic, strong) NSString *order;//: null

@end

#pragma mark -- 商家评论列表数据

@interface QL_BusinessCommentListDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *score;   //评分
@property(nonatomic, strong) QL_EndUserDataModel *endUser;
@property(nonatomic, strong) NSString *id; //1
@property(nonatomic, strong) NSMutableArray<QL_EvaluateImageDataModel> *evaluateImages;
@property(nonatomic, strong) NSString *content;// "wewes",
@property(nonatomic, strong) NSString *createDate;// 1490589315000,
@property(nonatomic, strong) NSString *sellerReply;// "商家的回复。。。。。。"


@end

#pragma mark -- 商家详情数据

@interface QL_BussinessDetialsDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *address;/// null,
@property(nonatomic, strong) NSString *distance;/// "0.22",
@property(nonatomic, strong) NSString *unitConsume;/// 100,
@property(nonatomic, strong) NSString *avgPrice;/// 100,
@property(nonatomic, strong) NSString *latitude;/// 30.55418,
@property(nonatomic, strong) NSString *Description;/// null,
@property(nonatomic, strong) NSString *discount;/// 9.5,
@property(nonatomic, strong) NSString *userCollected;/// true,
@property(nonatomic, strong) NSString *businessTime;/// null,
@property(nonatomic, strong) NSString *storePictureUrl;/// "http:",
@property(nonatomic, strong) QL_SellerCategoryDataModel *sellerCategory;
@property(nonatomic, strong) NSString *rebateScore;/// 50,
@property(nonatomic, strong) NSString *favoriteNum;/// 230,
@property(nonatomic, strong) NSMutableArray<NSString> *envImgs;
@property(nonatomic, strong) NSString *storePhone;/// "1212",
@property(nonatomic, strong) NSString *name;// "花园加油站",
@property(nonatomic, strong) NSString *id;// 1
@property(nonatomic, strong) NSString *featuredService;/// "WIFI",
@property(nonatomic, strong) NSString *longitude;/// 104.075239
@property(nonatomic, strong) NSString *rateScore;
@property(nonatomic, strong) NSString *isBeanPay;
@end

#pragma mark -- 支付方式数据

@protocol QL_PayMentDataModel

@end

@interface QL_PayMentDataModel : Hen_JsonModel

///微信是1，支付宝是2，翼支付是3，乐豆是4
@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *configValue;

@end


#pragma mark -- 支付方式相关信息

@interface GC_PayMentInfoDataModel : Hen_JsonModel

///支付方式
@property (nonatomic, strong) NSMutableArray<QL_PayMentDataModel> *payType;

///用户当前乐豆
@property (nonatomic, strong) NSString *userCurLeBean;
///isBeanPay为true表示后台开启了乐豆抵扣且该商家支持乐豆抵扣;为false表示后台关闭乐豆抵扣或商家不支持乐豆抵扣,页面不显示
@property (nonatomic, strong) NSString *isBeanPay;
///用户乐分余额
@property (nonatomic, strong) NSString *userCurLeScore;


@end


#pragma mark -- 支付数据

@interface QL_PayInfoDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *encourageAmount;///;/// 0.95,
//微信
@property(nonatomic, assign) NSInteger timestamp;/// "0411114032",
@property(nonatomic, strong) NSString *noncestr;/// "9BE9A87C564C424090D2235120E9B995",
@property(nonatomic, strong) NSString *out_trade_no;/// "201704113535",
@property(nonatomic, strong) NSString *package;/// "Sign=WXPay",
@property(nonatomic, strong) NSString *appid;/// "wx75b0585936937e4a",
@property(nonatomic, strong) NSString *sign;/// "90DE007D45CD2B880DBBF29E2B1BA210",
@property(nonatomic, strong) NSString *partnerid;/// "1249451301",
@property(nonatomic, strong) NSString *prepayid;/// "wx2017041111403184b68f18050456534116"
//支付宝
@property(nonatomic, strong) NSString *orderStr;
@property(nonatomic, strong) NSString *orderId;
@property(nonatomic, strong) NSString *payinfo; // 通联支付宝h5
// 快捷支付：通联支付，九派渠道支付
@property(nonatomic, strong) NSString *quickPayChannel; ///  快捷支付类型 "0"：通联支付，"1": 九派渠道,
/// 通联支付
@property(nonatomic, strong) NSString *inputCharset;/// "1",
@property(nonatomic, strong) NSString *pickupUrl;/// "http://www.baidu.com",
@property(nonatomic, strong) NSString *receiveUrl;/// "http://118.190.83.191:10001/rebate-interface/payNotify/notify_allinpay_H5.jhtml",
@property(nonatomic, strong) NSString *version;/// "v1.0",
@property(nonatomic, strong) NSString *language;/// "1",
@property(nonatomic, strong) NSString *signType;/// "0",
@property(nonatomic, strong) NSString *merchantId;/// "008510154113610",
@property(nonatomic, strong) NSString *orderNo;/// "201705259898",
@property(nonatomic, strong) NSString *orderAmount;/// "300",
@property(nonatomic, strong) NSString *orderCurrency;/// "0",
@property(nonatomic, strong) NSString *orderDatetime;/// "20170525164958",
@property(nonatomic, strong) NSString *productName;/// "川西坝子1（西南店）",
@property(nonatomic, strong) NSString *ext1;/// "<USER>170525863749065</USER>",
@property(nonatomic, strong) NSString *payType;/// "33",
@property(nonatomic, strong) NSString *signMsg;/// "313925b4f532dae42a5a5c2fddf333ba",
@property(nonatomic, strong) NSString *payH5orderUrl;/// "https://cashier.allinpay.com/mobilepayment/mobile/SaveMchtOrderServlet.action"
/// 九派渠道支付

@end

#pragma mark -- 搜索历史

@interface QL_SearchHistoryDataModel : Hen_JsonModel

///内容
@property(nonatomic, strong) NSString *content;
///时间
@property(nonatomic, strong) NSString *time;

@end

#pragma mark -- 热门城市数据

@interface QL_HotCityDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *cityName;// "成都市",
@property(nonatomic, strong) NSString *cityId;// 2280


@end
