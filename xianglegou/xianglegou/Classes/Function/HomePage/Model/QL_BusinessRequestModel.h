//
//  QL_BusinessRequestModel.h
//  Rebate
//
//  Created by mini2 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface QL_BusinessRequestModel : Hen_JsonModel

@end

#pragma mark -- 商家列表请求数据

@interface QL_BusinessListRequestDataModel : Hen_JsonModel

///所在位置纬度
@property(nonatomic, strong) NSString *latitude;
///所在位置经度
@property(nonatomic, strong) NSString *longitude;
///排序类型
/**距离由近及远
DISTANCEASC,
*好评分由高到低
SCOREDESC,
**收藏由高到低
COLLECTDESC,
** 默认排序（时间先后顺序
DEFAULT*/
@property(nonatomic, strong) NSString *sortType;
///行业类别ID
@property(nonatomic, strong) NSString *categoryId;
///地区ID集合字符串(需传选择地区的id及所有下级地区的id)
@property(nonatomic, strong) NSString *areaIds;
///特色服务
/** 全部 *
ALL,
** WIFI *
WIFI,
** 免费停车 *
FREE_PARKING*/
@property(nonatomic, strong) NSString *featuredService;
///查询关键字
@property(nonatomic, strong) NSString *keyWord;
///分页：页数
@property(nonatomic, strong) NSString *pageNumber;
///分页：每页大小
@property(nonatomic, strong) NSString *pageSize;

@end

#pragma mark -- 商家详情请求数据

@interface QL_BusinessDetailsRequestDataModel : Hen_JsonModel

///用户ID
@property(nonatomic, strong) NSString *userId;
///商家ID
@property(nonatomic, strong) NSString *entityId;
///用户所在位置纬度
@property(nonatomic, strong) NSString *latitude;
///用户所在位置经度
@property(nonatomic, strong) NSString *longitude;

@end

#pragma mark -- 商家评论列表请求数据 

@interface QL_BusinessCommentListRequestDataModel : Hen_JsonModel

///店铺ID
@property(nonatomic, strong) NSString *sellerId;
///分页：页数
@property(nonatomic, strong) NSString *pageNumber;
///分页：每页大小
@property(nonatomic, strong) NSString *pageSize;

@end

#pragma mark -- 获取支付方式请求数据

@interface QL_PayMemmentRequestDataModel : Hen_JsonModel

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSString *configKey;

@end



#pragma mark -- 获取支付相关信息请求数据

@interface GC_PayMentInfoRequestDataModel : Hen_JsonModel
///用户ID
@property (nonatomic, strong) NSString *userId;
///用户token
@property (nonatomic, strong) NSString *token;
///商户ID
@property (nonatomic, strong) NSString *sellerId;
///配置项：支付方式  ("PAYMENTTYPE")
@property (nonatomic, strong) NSString *configKey;

@end

#pragma mark -- 订单支付请求数据

@interface QL_OrderPayRequestDataModel : Hen_JsonModel

///用户ID
@property(nonatomic, strong) NSString *userId;
///用户token
@property(nonatomic, strong) NSString *token;
///支付方式
@property(nonatomic, strong) NSString *payType;
///支付方式ID
@property(nonatomic, strong) NSString *payTypeId;
///支付金额
@property(nonatomic, strong) NSString *amount;
///商户ID
@property(nonatomic, strong) NSString *sellerId;
///是否使用乐豆支付 "true" , "false"
@property(nonatomic, strong) NSString *isBeanPay;
///乐豆抵扣数量
@property (nonatomic, strong) NSString *deductLeBean;
///备注
@property(nonatomic, strong) NSString *remark;

@end
