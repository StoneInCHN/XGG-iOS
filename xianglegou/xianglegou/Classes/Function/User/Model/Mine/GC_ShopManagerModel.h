//
//  GC_ShopManagerModel.h
//  xianglegou
//
//  Created by mini3 on 2017/5/25.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "Hen_JsonModel.h"

@interface GC_ShopManagerModel : Hen_JsonModel

@end

#pragma mark -- 店铺货款列表 数据

@interface GC_MResPaymentListDataModel : Hen_JsonModel
///货款编码
@property (nonatomic, strong) NSString *clearingSn;
///是否结算
@property (nonatomic, strong) NSString *isClearing;
///收益乐分
@property (nonatomic, strong) NSString *amount;
///id
@property (nonatomic, strong) NSString *id;
///创建时间
@property (nonatomic, strong) NSString *createDate;

@end


#pragma mark -- 银行卡信息

@interface GC_MResBankCardDataModel : Hen_JsonModel
///银行卡号
@property (nonatomic, strong) NSString *cardNum;
///银行卡类型
@property (nonatomic, strong) NSString *cardType;
///银行名称
@property (nonatomic, strong) NSString *bankName;
///银行Logo
@property (nonatomic, strong) NSString *bankLogo;
@end



@interface GC_MResPayMentOrderModel : Hen_JsonModel

///消费金额
@property (nonatomic, strong) NSString *amount;
///订单编号
@property (nonatomic, strong) NSString *sn;

///让利金额
@property (nonatomic, strong) NSString *rebateAmount;
///商家收益
@property (nonatomic, strong) NSString *sellerIncome;

///商家折扣
@property (nonatomic, strong) NSString *sellerDiscount;
///创建时间
@property (nonatomic, strong) NSString *createDate;

@end



#pragma mark -- 货款订单信息

@protocol GC_MResPayMentOrdersDataModel

@end

@interface GC_MResPayMentOrdersDataModel : Hen_JsonModel

@property (nonatomic, strong) GC_MResPayMentOrderModel *order;

@end




#pragma mark -- 货款明细

@interface GC_MResPaymentDetailDataModel : Hen_JsonModel

///总收益
@property (nonatomic, strong) NSString *totalOrderAmount;
///银行卡信息
@property (nonatomic, strong) GC_MResBankCardDataModel *bankCard;
///货款编号
@property (nonatomic, strong) NSString *clearingSn;

///是否收益
@property (nonatomic, strong) NSString *isClearing;

///实际收益
@property (nonatomic, strong) NSString *amount;
///订单信息
@property (nonatomic, strong) NSMutableArray<GC_MResPayMentOrdersDataModel> *orders;

///ID
@property (nonatomic, strong) NSString *id;
///创建时间
@property (nonatomic, strong) NSString *createDate;

@end





#pragma mark -- 录单自动填充商户信息

@interface GC_MResCurrentSellerInfoDataModel : Hen_JsonModel
///店铺法人，未实名认证时该字段为空
@property (nonatomic, strong) NSString *realName;
///店铺地址
@property (nonatomic, strong) NSString *address;
///店铺名称
@property (nonatomic, strong) NSString *name;
///商家折扣
@property (nonatomic, strong) NSString *discount;
///购物车中录单数量
@property (nonatomic, strong) NSString *cartCount;
///ID
@property (nonatomic, strong) NSString *id;
@end



#pragma mark -- 根据手机号获取消费者信息

@interface GC_MResUserInfoByMobileDataModel : Hen_JsonModel
///消费者姓名
@property (nonatomic, strong) NSString *realName;
///消费者昵称
@property (nonatomic, strong) NSString *nickName;
///ID
@property (nonatomic, strong) NSString *id;
///电话
@property (nonatomic, strong) NSString *cellPhoneNum;
@end


#pragma mark -- 录单加入购物车

@interface GC_MResOrderCartAddDataModel : Hen_JsonModel
///数量
@property (nonatomic, strong) NSString *count;
@end

#pragma mark -- 购物车批量录单

@interface GC_MResConfirmOrderCartDataModel : Hen_JsonModel
///订单编号
@property (nonatomic, strong) NSString *orderSn;

@end

#pragma mark -- 立即录单

@interface GC_MResGenerateSellerOrderDataModel : Hen_JsonModel

///订单编号
@property (nonatomic, strong) NSString *orderSn;
///订单ID
@property (nonatomic, strong) NSString *orderId;
@end


#pragma mark -- 录单支付

@interface GC_MResPaySellerOrderDataModel : Hen_JsonModel
@property (nonatomic, strong) NSString *out_trade_no;

@property (nonatomic, strong) NSString *package;

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *prepayid;
@property (nonatomic, strong) NSString *partnerid;
@property (nonatomic, strong) NSString *noncestr;
@property (nonatomic, strong) NSString *timestamp;
@end




#pragma mark -- 消费者 信息

@interface GC_MResChecklistEndUserDataModel : Hen_JsonModel

///昵称
@property (nonatomic, strong) NSString *nickName;
///联系电话
@property (nonatomic, strong) NSString *cellPhoneNum;

@end

#pragma mark -- 录单购物车列表

@interface GC_MResSellerOrderCartListDataModel : Hen_JsonModel
///消费者信息
@property (nonatomic, strong) GC_MResChecklistEndUserDataModel *endUser;

///消费
@property (nonatomic, strong) NSString *amount;
///让利金额
@property (nonatomic, strong) NSString *rebateAmount;
///ID
@property (nonatomic, strong) NSString *id;
///创建时间
@property (nonatomic, strong) NSString *createDate;


///是否选中
@property (nonatomic, assign) BOOL isSelected;
@end



#pragma mark -- 商户录单列表

@interface GC_MResSellerOrderListDataModel : Hen_JsonModel

///消费者信息
@property (nonatomic, strong) GC_MResChecklistEndUserDataModel *endUser;
///消费金额
@property (nonatomic, strong) NSString *amount;
///让利金额
@property (nonatomic, strong) NSString *rebateAmount;
///商户收益
@property (nonatomic, strong) NSString *sellerIncome;
///ID
@property (nonatomic, strong) NSString *id;
///编号
@property (nonatomic, strong) NSString *sn;
///创建时间
@property (nonatomic, strong) NSString *createDate;
///状态
@property (nonatomic, strong) NSString *status;
@end
