//
//  GC_RecommendModel.h
//  Rebate
//
//  Created by mini3 on 17/4/7.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  推荐数据
//

#import "Hen_JsonModel.h"

@interface GC_RecommendModel : Hen_JsonModel

@end



#pragma mark -- 二维码数据信息

@interface GC_MResQrCodeDataModel : Hen_JsonModel
///二维码 信息
@property (nonatomic, strong) NSString *qrImage;

///分享地址
@property (nonatomic, strong) NSString *recommendUrl;

///下载地址
@property (nonatomic, strong) NSString *downloadUrl;
@end


#pragma mark -- 推荐用户信息

@interface GC_MResRecommendEndUserDataModel : Hen_JsonModel
///商家昵称
@property (nonatomic, strong) NSString *sellerName;
///用户昵称
@property (nonatomic, strong) NSString *nickName;
///用户图片
@property (nonatomic, strong) NSString *userPhoto;
///创建时间
@property (nonatomic, strong) NSString *createDate;
@end

#pragma mark -- 推荐记录数据 信息

@interface GC_MResRecommendRecDataModel : Hen_JsonModel
///推荐用户信息
@property (nonatomic, strong) GC_MResRecommendEndUserDataModel *endUser;
///ID
@property (nonatomic, strong) NSString *id;
///此人为推荐人带来的累计乐分收益
@property (nonatomic, strong) NSString *totalRecommendLeScore;

@end




#pragma mark -- 商户信息

///推荐商家信息
@interface GC_MResSellerApplicationDataModel : Hen_JsonModel
///商户名
@property (nonatomic, strong) NSString *sellerName;
///ID
@property (nonatomic, strong) NSString *id;
///商家图片
@property (nonatomic, strong) NSString *storePhoto;
///审核状态
/** 待审核 */
//AUDIT_WAITING,

/** 审核通过 */
//AUDIT_PASSED,

/** 审核退回 */
//AUDIT_FAILED
@property (nonatomic, strong) NSString *applyStatus;
///联系人手机号
@property (nonatomic, strong) NSString *contactCellPhone;

///失败原因
@property (nonatomic, strong) NSString *notes;

@end


#pragma mark -- 业务员获取推荐商家列表 数据

@interface GC_MResRecommendSellerDataModel : Hen_JsonModel
///商户信息
@property (nonatomic, strong) GC_MResSellerDataModel *seller;

///商户信息
@property (nonatomic, strong) GC_MResSellerApplicationDataModel *sellerApplication;
///id
@property (nonatomic, strong) NSString *id;
///收益乐分
@property (nonatomic, strong) NSString *totalRecommendLeScore;
///创建时间
@property (nonatomic, strong) NSString *createDate;
@end
