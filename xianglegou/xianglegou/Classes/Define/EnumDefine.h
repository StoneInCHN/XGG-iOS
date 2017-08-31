//
//  EnumDefine.h
//  CRM
//
//  Created by mini2 on 16/6/15.
//  Copyright © 2016年 hentica. All rights reserved.
//

#ifndef EnumDefine_h
#define EnumDefine_h

///CRM类型
typedef NS_ENUM(NSInteger, CRMDetailsType){
    kCRMDetailsTypeOfCustomer = 1,  // 客户
    kCRMDetailsTypeOfContacts,      // 联系人
};

///订单状态
typedef NS_ENUM(NSInteger, OrderStatus){
    kOrderStatusOfPay = 10,         // 待支付
    kOrderStatusOfHandle = 20,      // 正在处理
    kOrderStatusOfUploadFiles = 30, // 重传资料
    kOrderStatusOfBack = 40,        // 申请退款
    kOrderStatusOfSuccess = 50,     // 完成
    kOrderStatusOfFailed = 60,      // 关闭
    
};

#endif /* EnumDefine_h */
