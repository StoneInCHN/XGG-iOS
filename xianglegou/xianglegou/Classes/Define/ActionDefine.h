//
//  ActionDefine.h
//  CRM
//
//  Created by mini2 on 16/6/15.
//  Copyright © 2016年 hentica. All rights reserved.
//

#ifndef ActionDefine_h
#define ActionDefine_h

#pragma mark -- 用户模块
///获取RSA公钥接口
#define endUser_rsa                     @"/rebate-interface/endUser/rsa.jhtml"
///获取验证码
#define endUser_getSmsCode              @"/rebate-interface/endUser/getSmsCode.jhtml"
///用户注册
#define endUser_reg                     @"/rebate-interface/endUser/reg.jhtml"
///找回用户登录密码
#define endUser_resetPwd                @"/rebate-interface/endUser/resetPwd.jhtml"
///登录接口
#define endUser_login                   @"/rebate-interface/endUser/login.jhtml"
///退出登录接口
#define endUser_logout                  @"/rebate-interface/endUser/logout.jhtml"
///修改用户头像
#define endUser_editUserPhoto           @"/rebate-interface/endUser/editUserPhoto.jhtml"
///修改用户信息（不包括头像，密码）
#define endUser_editUserInfo            @"/rebate-interface/endUser/editUserInfo.jhtml"
///修改用户密码(包括登录密码和支付密码)
#define endUser_updatePwd               @"/rebate-interface/endUser/updatePwd.jhtml"

///变更用户注册手机号
#define endUser_changeRegMobile         @"/rebate-interface/endUser/changeRegMobile.jhtml"

///获取用户信息
#define endUser_getUserInfo             @"/rebate-interface/endUser/getUserInfo.jhtml"
///获取用户二维码信息
#define endUser_getQrCode               @"/rebate-interface/endUser/getQrCode.jhtml"
///获取用户推荐记录
#define endUser_getRecommendRec         @"/rebate-interface/endUser/getRecommendRec.jhtml"
///用户积分记录
#define endUser_scoreRec                @"/rebate-interface/endUser/scoreRec.jhtml"
///获取用户乐心记录
#define endUser_leMindRec               @"/rebate-interface/endUser/leMindRec.jhtml"
///获取用户乐分记录
#define endUser_leScoreRec              @"/rebate-interface/endUser/leScoreRec.jhtml"
///获取用户乐豆记录
#define endUser_leBeanRec               @"/rebate-interface/endUser/leBeanRec.jhtml"

///用户转账
#define endUser_transferRebate          @"/rebate-interface/transferRebate/doTransfer.jhtml"

///验证转账用户
#define endUser_verifyReceiver          @"/rebate-interface/transferRebate/verifyReceiver.jhtml"

///获取所在地区
#define area_selectArea                  @"/rebate-interface/area/selectArea.jhtml"
///业务员申请入驻商户
#define seller_apply                      @"/rebate-interface/seller/apply.jhtml"
///验证手机号是否已注册会员或成为商家
#define endUser_verifyMobile                @"/rebate-interface/endUser/verifyMobile.jhtml"


///获取店铺信息
#define seller_getSellerInfo                @"/rebate-interface/seller/getSellerInfo.jhtml"
///获取店铺二维码信息
#define seller_getQrCode                    @"/rebate-interface/seller/getQrCode.jhtml"
///获取店铺的行业类别
#define seller_getSellerCategory            @"/rebate-interface/seller/getSellerCategory.jhtml"
///修改完善商户信息
#define seller_editInfo                     @"/rebate-interface/seller/editInfo.jhtml"
///获取商家订单列表
#define order_getOrderUnderSeller               @"/rebate-interface/order/getOrderUnderSeller.jhtml"

///删除未支付的录单订单
#define order_delSellerUnpaidOrder          @"/rebate-interface/order/delSellerUnpaidOrder.jhtml"

///根据订单获取评价详情
#define order_getEvaluateByOrder                @"/rebate-interface/order/getEvaluateByOrder.jhtml"
///用户提交评价
#define order_userEvaluateOrder                 @"/rebate-interface/order/userEvaluateOrder.jhtml"
///商家回复用户评价
#define order_sellerReply                       @"/rebate-interface/order/sellerReply.jhtml"

///首页顶部图片
#define banner_hpTop            @"/rebate-interface/banner/hpTop.jhtml"
///首页商家列表
#define seller_list             @"/rebate-interface/seller/list.jhtml"
///商家评论列表
#define seller_evaluateList     @"/rebate-interface/seller/evaluateList.jhtml"
///商家详情
#define seller_detail           @"/rebate-interface/seller/detail.jhtml"
///获取支付方式
#define systemConfig_getConfigByKey @"/rebate-interface/systemConfig/getConfigByKey.jhtml"
///获取支付相关信息
#define order_GetPayInfo        @"/rebate-interface/order/getPayInfo.jhtml"
///订单支付
#define order_pay               @"/rebate-interface/order/pay.jhtml"
///九派支付
#define jiuPaiPay               @"/rebate-interface/jiupai/index.html"
///用户个人分红
#define report_getUserBonusReport   @"/rebate-interface/report/getUserBonusReport.jhtml"
///全国分红
#define report_getNationBonusReport @"/rebate-interface/report/getNationBonusReport.jhtml"



///获取用户订单
#define order_getOrderUnderUser         @"/rebate-interface/order/getOrderUnderUser.jhtml"


///用户收藏列表
#define endUser_favoriteSellerList      @"/rebate-interface/endUser/favoriteSellerList.jhtml"


///获取消息列表
#define message_getMsgList              @"/rebate-interface/message/getMsgList.jhtml"
///阅读消息
#define message_readMessage             @"/rebate-interface/message/readMessage.jhtml"
///删除消息
#define message_deleteMsgs              @"/rebate-interface/message/deleteMsgs.jhtml"
///获取配置数据信息
#define settingConfig_getConfigByKey    @"/rebate-interface/settingConfig/getConfigByKey.jhtml"
///获取帮助信息列表
#define settingConfig_userHelpList      @"/rebate-interface/settingConfig/userHelpList.jhtml"
///获取帮助信息详情
#define settingConfig_userHelpDetail    @"/rebate-interface/settingConfig/userHelpDetail.jhtml"


///微信授权获取openid
#define endUser_doAuthByWechat          @"/rebate-interface/endUser/doAuthByWechat.jhtml"

///微信解除授权清空openid
#define endUser_cancelAuthByWechat      @"/rebate-interface/endUser/cancelAuthByWechat.jhtml"
///验证支付密码
#define endUser_verifyPayPwd            @"/rebate-interface/endUser/verifyPayPwd.jhtml"

///获取提现信息
#define endUser_getWithdrawInfo         @"/rebate-interface/endUser/getWithdrawInfo.jhtml"

///用户确认提现
#define endUser_withdrawConfirm         @"/rebate-interface/endUser/withdrawConfirm.jhtml"



///实名认证
#define endUser_doIdentityAuth          @"/rebate-interface/endUser/doIdentityAuth.jhtml"

///银行卡四元素校验
#define bankCard_verifyCard             @"/rebate-interface/bankCard/verifyCard.jhtml"

///添加银行卡
#define bankCard_addCard                @"/rebate-interface/bankCard/addCard.jhtml"
///用户银行卡列表
#define bankCard_myCardList             @"/rebate-interface/bankCard/myCardList.jhtml"

///删除银行卡
#define bankCard_delCard                @"/rebate-interface/bankCard/delCard.jhtml"

///获取用户默认银行卡
#define bankCard_getDefaultCard         @"/rebate-interface/bankCard/getDefaultCard.jhtml"
///设置默认银行卡
#define bankCard_updateCardDefault      @"/rebate-interface/bankCard/updateCardDefault.jhtml"
///获取用户身份证信息
#define bankCard_getIdCard              @"/rebate-interface/bankCard/getIdCard.jhtml"


///业务员获取推荐商家列表
#define endUser_getRecommendSellerRec   @"/rebate-interface/endUser/getRecommendSellerRec.jhtml"
///自动填充商户信息
#define endUser_getCurrentSellerInfo    @"/rebate-interface/endUser/getCurrentSellerInfo.jhtml"
///根据手机号获取消费者信息
#define endUser_getUserInfoByMobile     @"/rebate-interface/endUser/getUserInfoByMobile.jhtml"
///录单加入购物车
#define sellerOrderCart_add             @"/rebate-interface/sellerOrderCart/add.jhtml"
///购物车批量录单
#define sellerOrderCart_confirmOrder    @"/rebate-interface/sellerOrderCart/confirmOrder.jhtml"
///录单购物车删除
#define sellerOrderCart_delete          @"/rebate-interface/sellerOrderCart/delete.jhtml"

///立即录单
#define order_generateSellerOrder       @"/rebate-interface/order/generateSellerOrder.jhtml"
///录单支付(包括立即录单和购物车批量录单后的支付)
#define order_paySellerOrder            @"/rebate-interface/order/paySellerOrder.jhtml"
///录单购物车列表
#define sellerOrderCart_list            @"/rebate-interface/sellerOrderCart/list.jhtml"
///商户获取录单列表
#define order_getSallerOrder            @"/rebate-interface/order/getSallerOrder.jhtml"

///店铺货款列表
#define seller_paymentList              @"/rebate-interface/seller/paymentList.jhtml"
///货款明细
#define seller_paymentDetail            @"/rebate-interface/seller/paymentDetail.jhtml"


///营业中心交易额
#define agent_consumeAmountReport       @"/rebate-interface/agent/consumeAmountReport.jhtml"
///营业中心商家数
#define agent_sellerCountReport         @"/rebate-interface/agent/sellerCountReport.jhtml"
///营业中心消费者数
#define agent_endUserCountReport        @"/rebate-interface/agent/endUserCountReport.jhtml"
///营业中心业务员数
#define agent_salesmanCountReport       @"/rebate-interface/agent/salesmanCountReport.jhtml"

/// 设置推送ID
#define set_pushId                      @"/rebate-interface/common/setJpushId.jhtml"

#endif /* ActionDefine_h */
