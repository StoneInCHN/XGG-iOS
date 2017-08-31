//
//  GC_MineMessageModel.h
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  我的信息 -- Model
//

#import "Hen_JsonModel.h"

@interface GC_MineMessageModel : Hen_JsonModel

@end


#pragma mark -- 代理商信息

@interface GC_MResAgentDataModel : Hen_JsonModel
///代理商 类型
@property (nonatomic, strong) NSString *agencyLevel;
///代理地区 名称
@property (nonatomic, strong) NSString *areaName;
///代理地区 ID
@property (nonatomic, strong) NSString *areaId;
@end

#pragma mark -- 地区信息

@interface GC_MResAreaDataModel : Hen_JsonModel
///地区名称
@property (nonatomic, strong) NSString *name;
///地区id
@property (nonatomic, strong) NSString *id;
@end

#pragma mark -- 用户信息

@interface GC_MResUserInfoDataModel : Hen_JsonModel
///地区信息
@property (nonatomic, strong) GC_MResAreaDataModel *area;
///代理商  返回"agent": {}， 用户不是代理商
@property (nonatomic, strong) GC_MResAgentDataModel *agent;


///当前积分
@property (nonatomic, strong) NSString *curScore;
///总积分
@property (nonatomic, strong) NSString *totalScore;

///当前乐心
@property (nonatomic, strong) NSString *curLeMind;
///总乐心
@property (nonatomic, strong) NSString *totalLeMind;

///当前乐豆
@property (nonatomic, strong) NSString *curLeBean;
///总乐豆
@property (nonatomic, strong) NSString *totalLeBean;

///当前乐分
@property (nonatomic, strong) NSString *curLeScore;
///总乐分
@property (nonatomic, strong) NSString *totalLeScore;



///头像
@property (nonatomic, strong) NSString *userPhoto;
///店铺信息 sellerStatus=NO表示用户无店铺,且无申请记录；sellerStatus=YES表示用户申请已经通过，拥有店铺；sellerStatus=AUDIT_WAITING表示用户申请店铺请求正在审核中；sellerStatus= AUDIT_FAILED表示用户申请店铺请求审核失败，
@property (nonatomic, strong) NSString *sellerStatus;
///昵称
@property (nonatomic, strong) NSString *nickName;
///电话号码
@property (nonatomic, strong) NSString *cellPhoneNum;
///用户Id
@property (nonatomic, strong) NSString *id;

///是否绑定 微信
@property (nonatomic, strong) NSString *isBindWeChat;
///是否设置密码
@property (nonatomic, strong) NSString *isSetLoginPwd;
///是否设置支付密码
@property (nonatomic, strong) NSString *isSetPayPwd;


///applyId 该字段需要在手机端记录，同一用户再次提交店铺入驻申请记录时需传此ID到接口
@property (nonatomic, strong) NSString *applyId;
///推荐人
@property (nonatomic, strong) NSString *recommender;

///微信昵称
@property (nonatomic, strong) NSString *wechatNickName;


///业务员判断    1、是业务员
@property (nonatomic, strong) NSString *isSalesman;

///实名认证判断
@property (nonatomic, strong) NSString *isAuth;

///业务员 电话
@property (nonatomic, strong) NSString *salesmanCellphone;

///入驻失败字段
@property (nonatomic, strong) NSString *failReason;

///是否有银行卡
@property (nonatomic, strong) NSString *isOwnBankCard;


///业务员上传商家权限是否开启
@property (nonatomic, strong) NSString *isSalesmanApply;




@end



#pragma mark -- 商品信息
@interface GC_MResSellerDataModel : Hen_JsonModel
///名称
@property (nonatomic, strong) NSString *name;
///图片地址
@property (nonatomic, strong) NSString *storePictureUrl;
@end

#pragma mark -- 用户积分数据

@interface GC_MResScoreRecDataModel : Hen_JsonModel
///商品信息
@property (nonatomic, strong) GC_MResSellerDataModel *seller;
///Id
@property (nonatomic, strong) NSString *id;
///回扣积分
@property (nonatomic, strong) NSString *rebateScore;
///当前积分
@property (nonatomic, strong) NSString *userCurScore;
///创建时间
@property (nonatomic, strong) NSString *createDate;
///支付方式
@property (nonatomic, strong) NSString *paymentType;
@end

#pragma mark -- 用户乐心数据

@interface GC_MResLeMindRecDataModel : Hen_JsonModel
///积分
@property (nonatomic, strong) NSString *score;
///增加心量
@property (nonatomic, strong) NSString *amount;
///id
@property (nonatomic, strong) NSString *id;
///当前乐心
@property (nonatomic, strong) NSString *userCurLeMind;

@property (nonatomic ,strong) NSString *remark;
///创建时间
@property (nonatomic, strong) NSString *createDate;

@end



#pragma mark -- 乐分会员信息

@interface GC_MResLeScoreEndUserDataModel : Hen_JsonModel
///昵称
@property (nonatomic, strong) NSString *nickName;
///头像
@property (nonatomic, strong) NSString *userPhoto;
@end


#pragma mark -- 用户乐分数据

@interface GC_MResLeScoreRecDataModel : Hen_JsonModel

///用户会员信息
@property (nonatomic, strong) GC_MResLeScoreEndUserDataModel *endUser;
///消费商家信息
@property (nonatomic, strong) GC_MResSellerDataModel *seller;

///增加乐分
@property (nonatomic, strong) NSString *amount;
///好友 头像
@property (nonatomic, strong) NSString *recommenderPhoto;
///id
@property (nonatomic, strong) NSString *id;
///当前乐分
@property (nonatomic, strong) NSString *userCurLeScore;
///好友 昵称
@property (nonatomic, strong) NSString *recommender;
///提现审核状态
/** 待审核 */
//AUDIT_WAITING,
/** 审核通过 */
//AUDIT_PASSED,
/** 审核退回 */
//AUDIT_FAILED
@property (nonatomic, strong) NSString *withdrawStatus;

///提现状态
/** 处理中 **/
//PROCESSING,
/** 处理成功 **/
//SUCCESS,
/** 处理失败 **/
//FAILED
@property (nonatomic, strong) NSString *status;



///创建时间
@property (nonatomic, strong) NSString *createDate;

///根据不同的type显示不同的字段内容
/** 乐分消费 */
//CONSUME,

/** 乐心（积分）产生的分红 */
//BONUS,
/** 推荐好友消费返利 */
//RECOMMEND_USER,
/** 推荐店铺收益返利 */
//RECOMMEND_SELLER,
/** 代理商提成 */
//AGENT,
/** 提现 */
//WITHDRAW
@property (nonatomic, strong) NSString *leScoreType;


///说明字段
@property (nonatomic, strong) NSString *remark;
@end


#pragma mark -- 用户乐豆数据

@interface GC_MResLeBeanRecDataModel : Hen_JsonModel
///消费商家信息
@property (nonatomic, strong) GC_MResSellerDataModel *seller;
///
@property (nonatomic, strong) NSString *amount;

///头像
@property (nonatomic ,strong) NSString *recommenderPhoto;
///当前乐豆
@property (nonatomic, strong) NSString *userCurLeBean;

///id
@property (nonatomic, strong) NSString *id;

///乐豆变化类型
/** 乐心分红赠送乐豆 */
//BONUS,
/** 推荐好友消费送乐豆 */
//RECOMMEND_USER,
/** 推荐店铺收益送乐豆 */
//RECOMMEND_SELLER,
/** 消费 */
//CONSUME
//转账*／
//TRANSFER
@property (nonatomic, strong) NSString *type;

@property (nonatomic ,strong) NSString *recommender;
///创建时间
@property (nonatomic, strong) NSString *createDate;


@property (nonatomic ,strong) NSString *remark;


@end



#pragma mark -- 提现信息

@interface GC_MResWithdrawInfoDataModel : Hen_JsonModel

///提现手续费
@property (nonatomic, strong) NSString *transactionFee;
///代理商乐分
@property (nonatomic, strong) NSString *agentLeScore;
///满配置金额才能提现
@property (nonatomic, strong) NSString *minLimitAmount;
///业务员乐分
@property (nonatomic, strong) NSString *incomeLeScore;
///"": "统一提现规则",
@property (nonatomic, strong) NSString *motivateRule;
///"": 1.0665    //会员乐分
@property (nonatomic, strong) NSString *motivateLeScore;


/////用户头像
//@property (nonatomic, strong) NSString *userPhoto;
/////可提现乐分总额
//@property (nonatomic, strong) NSString *avlLeScore;
/////可提现代理商乐分
//@property (nonatomic, strong) NSString *agentLeScore;
/////微信昵称
//@property (nonatomic, strong) NSString *wxNickName;
////可提现商家乐分
//@property (nonatomic, strong) NSString *incomeLeScore;
/////会员提现规则
//@property (nonatomic, strong) NSString *motivateRule;
/////商家提现规则
//@property (nonatomic, strong) NSString *incomeRule;
/////代理商提现规则
//@property (nonatomic, strong) NSString *agentRule;
//////可提现用户乐分
//@property (nonatomic, strong) NSString *motivateLeScore;
//////当前乐分
//@property (nonatomic, strong) NSString *curLeScore;
@end
