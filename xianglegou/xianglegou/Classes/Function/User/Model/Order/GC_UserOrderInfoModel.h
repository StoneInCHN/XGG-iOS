//
//  GC_UserOrderInfoModel.h
//  Rebate
//
//  Created by mini3 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_UserOrderInfoModel : Hen_JsonModel

@end


#pragma mark -- 订单的商家信息

@interface GC_MResOrderSellerDataModel : Hen_JsonModel
///名称
@property (nonatomic, strong) NSString *name;
///id
@property (nonatomic, strong) NSString *id;
///地址
@property (nonatomic, strong) NSString *address;
///图片
@property (nonatomic, strong) NSString *storePictureUrl;

@end

#pragma mark -- 用户评价信息
@interface GC_MResEvaluateDataModel : Hen_JsonModel
///用户评价
@property (nonatomic, strong) NSString *content;
///商家回复
@property (nonatomic, strong) NSString *sellerReply;
@end

#pragma mark -- 用户订单信息
@interface GC_MResOrderUnderUserDataModel : Hen_JsonModel
///商家信息
@property (nonatomic, strong) GC_MResOrderSellerDataModel *seller;
///订单金额
@property (nonatomic, strong) NSString *amount;
///备注
@property (nonatomic, strong) NSString *remark;
///ID
@property (nonatomic, strong) NSString *id;
///订单号
@property (nonatomic, strong) NSString *sn;
///返回积分
@property (nonatomic, strong) NSString *userScore;
///评论信息
@property (nonatomic, strong) GC_MResEvaluateDataModel *evaluate;
///创建时间
@property (nonatomic, strong) NSString *createDate;
///订单状态
@property (nonatomic, strong) NSString *status;
///让利金额
@property (nonatomic, strong) NSString *rebateAmount;
///是否是录单
@property (nonatomic, strong) NSString *isSallerOrder;

@end





#pragma mark -- 买家信息

@interface GC_MResEndUserDataModel : Hen_JsonModel
///昵称
@property (nonatomic, strong) NSString *nickName;
///头像
@property (nonatomic, strong) NSString *userPhoto;
@end

#pragma mark -- 订单支付金额信息

@interface GC_MResOrderPayMoneyDataModel : Hen_JsonModel
///支付金额
@property (nonatomic, strong) NSString *amount;
@end

#pragma mark -- 订单获取评价详情信息

@interface GC_MResEvaluateByOrderDataModel : Hen_JsonModel
///服务评分
@property (nonatomic, strong) NSString *score;
///买家信息
@property (nonatomic, strong) GC_MResEndUserDataModel *endUser;
///id
@property (nonatomic, strong) NSString *id;
///上传图片信息
@property (nonatomic, strong) NSMutableArray<NSString*>* evaluateImages;
///用户评价内容
@property (nonatomic, strong) NSString *content;
///订单支付 金额信息
@property (nonatomic, strong) GC_MResOrderPayMoneyDataModel *order;
///商家回复 信息
@property (nonatomic, strong) NSString *sellerReply;
@end
