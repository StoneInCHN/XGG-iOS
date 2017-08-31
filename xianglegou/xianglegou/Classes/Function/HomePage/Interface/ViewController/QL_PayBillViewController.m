//
//  QL_PayBillViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_PayBillViewController.h"
#import "QL_PayBillInfoTableViewCell.h"
#import "QL_PayBillPaymentTableViewCell.h"
#import "QL_PayPasswordInputView.h"
#import "QL_EncourageGlodBoxView.h"
#import "Hen_DeviceUtil.h"
#import "QL_PayBillViewModel.h"
#import "QL_BusinessDetailsViewModel.h"
#import "JiuPaiWebViewController.h"
#import "GC_MineEditPasswordViewController.h"
#import "QL_UserOrderDetailsViewController.h"
#import "QL_FastPayWebViewViewController.h"
#import "GC_LeBeanDeductibleTableViewCell.h"
#import "GC_BeingPaidView.h"
#import "GC_BeingPaidViewController.h"

@interface QL_PayBillViewController ()

///密码支付输入
@property(nonatomic, strong) QL_PayPasswordInputView *payPasswordView;
///鼓励奖弹出框
@property(nonatomic, strong) QL_EncourageGlodBoxView *eGoldBoxView;

///view model
@property(nonatomic, strong) QL_PayBillViewModel *viewModel;
///view model
@property(nonatomic, strong) QL_BusinessDetailsViewModel *businessViewModel;
///是否开启乐豆抵扣
@property (nonatomic, assign) BOOL isLeBeanDeduc;

///验证支付密码方式   1、开启乐豆抵扣 验证  0、乐分支付验证
@property (nonatomic, strong) NSString *payMentType;

///是否验证支付密码
@property (nonatomic, assign) BOOL isVerPayPwd;
@end

@implementation QL_PayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    [self.tableView.header beginRefreshingForWaitMoment];
    //获取RSA key
    [DATAMODEL loadRSAPublickey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- override

///清除数据
- (void)cleanUpData
{
    [self setViewModel:nil];
    [self setBusinessViewModel:nil];
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
    [self.payPasswordView removeFromSuperview];
    [self setPayPasswordView:nil];
}

- (void)onTVCGoBackClick:(id)sender
{
    if(self.sellerId){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [super onTVCGoBackClick:sender];
    }
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"买单";
    self.tableView.backgroundColor = kCommonBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadBusinessData];
        [weakSelf loadPayMentInfoData];
    }];
}

///获取支付方式
- (void)getPaymentData
{
    //参数
    self.viewModel.payMemmentParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.payMemmentParam.token = DATAMODEL.token;
    WEAKSelf;
    //请求
    [self.viewModel getPaymentDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        if([code isEqualToString:@"0000"]){ // 成功
            
            [weakSelf.tableView reloadData];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}


///获取支付相关信息
- (void)loadPayMentInfoData
{
    //参数
    //用户ID
    self.viewModel.payMentInfoParam.userId = DATAMODEL.userInfoData.id;
    ///用户token
    self.viewModel.payMentInfoParam.token = DATAMODEL.token;

    self.viewModel.payMentInfoParam.sellerId = self.businessData.id;
    
    if(self.businessData.id.length <= 0){
        self.viewModel.payMentInfoParam.sellerId = self.sellerId;
    }
    
    ///配置项：支付方式  ("PAYMENTTYPE")
    self.viewModel.payMentInfoParam.configKey = @"PAYMENTTYPE";
    
    WEAKSelf;
    //请求
    [self.viewModel getPayMentInfoDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        if([code isEqualToString:@"0000"]){
            DATAMODEL.userInfoData.curLeScore = weakSelf.viewModel.payMentInfoData.userCurLeScore;
            [weakSelf.tableView reloadData];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

///验证支付密码
- (void)setVerifyPayPassWord
{
    //参数
    //用户ID
    [self.viewModel.verifyPayPwdParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.verifyPayPwdParam setObject:DATAMODEL.token forKey:@"token"];
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    [self.viewModel setVerifyPayPwdDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            if([weakSelf.payMentType isEqualToString:@"1"]){
                weakSelf.isLeBeanDeduc = YES;
                weakSelf.isVerPayPwd = YES;
                weakSelf.viewModel.orderPayParam.isBeanPay = @"true";
                [weakSelf.tableView reloadData];
            }else{
                weakSelf.isVerPayPwd = YES;
                [weakSelf orderPay];
            }
        }else if([code isEqualToString:@"1000"]){// 支付密码错误
            //提示
            [DATAMODEL.alertManager showCustomButtonTitls:@[@"重新输入", @"忘记密码"] message:@"支付密码错误，请重试。"];
            [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
                if(buttonIndex == 0){
                    //显示支付密码输入
                    [weakSelf.payPasswordView showView];
                }else{
                    [weakSelf showPayPasswordChange];
                }
            }];
            
        }else{
            [weakSelf showHint:desc];
        }
    }];
    
}


///获取商家信息
- (void)loadBusinessData
{
    if(self.sellerId && !self.businessData){
        WEAKSelf;
        //请求详情
        [self.businessViewModel getBussinessDetialsDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            if([code isEqualToString:@"0000"]){
                weakSelf.businessData = msg;
                weakSelf.viewModel.payMentInfoParam.sellerId = weakSelf.businessData.id;
                [weakSelf.tableView reloadData];
            }
        }];
    }
}

///订单支付
- (void)orderPay
{
    
    if(self.isLeBeanDeduc){
        if(self.viewModel.orderPayParam.deductLeBean.length <= 0 || [self.viewModel.orderPayParam.deductLeBean floatValue] <= 0){
            [self showHint:@"乐豆抵扣不能为0！"];
            return;
        }
        
        
        if([self.viewModel.orderPayParam.deductLeBean floatValue] > [self.viewModel.orderPayParam.amount floatValue]){
            [self showHint:@"您的乐豆抵扣大于消费金额！"];
            return;
        }
        
        if([self.viewModel.orderPayParam.amount isEqualToString:self.viewModel.orderPayParam.deductLeBean] || [self.viewModel.orderPayParam.amount doubleValue] == [self.viewModel.orderPayParam.deductLeBean doubleValue]){
            self.viewModel.orderPayParam.payType = @"乐豆支付";
            self.viewModel.orderPayParam.payTypeId = @"4";
        }
    }else{
        self.viewModel.orderPayParam.isBeanPay = @"false";
    }
    
    
    //参数
    self.viewModel.orderPayParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.orderPayParam.token = DATAMODEL.token;
    self.viewModel.orderPayParam.sellerId = self.businessData.id;
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    //请求
    [self.viewModel orderPayWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf callThirdPayPlatform];
////            return;
//#warning hihg 测试
//            if([weakSelf.viewModel.payInfoData.encourageAmount floatValue] > 0){
//                //鼓励金
//                [weakSelf.eGoldBoxView showForEncourageAmount:weakSelf.viewModel.payInfoData.encourageAmount andOrderId:weakSelf.viewModel.payInfoData.orderId];
//            }else{
//                //跳转到订单详情
//                [weakSelf toOrderDetails];
//            }
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}


///显示正在支付
- (void)PaySuccessRefreshMenth
{
    GC_BeingPaidViewController *bpVC = [[GC_BeingPaidViewController alloc] init];
    bpVC.hidesBottomBarWhenPushed = YES;
    
    WEAKSelf;
    bpVC.onSuccessBlock = ^{
        if(weakSelf.viewModel.payInfoData.encourageAmount.length > 0 && [weakSelf.viewModel.payInfoData.encourageAmount floatValue] > 0){
            //鼓励金
            [weakSelf.eGoldBoxView showForEncourageAmount:weakSelf.viewModel.payInfoData.encourageAmount andOrderId:weakSelf.viewModel.payInfoData.orderId];
        }else{
            //跳转到订单详情
            [weakSelf toOrderDetails];
        }
    };

    
    [self.navigationController pushViewController:bpVC animated:YES];
    
    
}



///调用第三方支付平台
-(void)callThirdPayPlatform
{
    Hen_PayManager *payManager = [Hen_PayManager sharedManager];
    //支付结果回调
    WEAKSelf;
    [payManager setPayResultBlock:^(PayResultType index) {
        
        if(index == payResultTypeSuccess){
            [weakSelf PaySuccessRefreshMenth];
        }else{
            //提示
            [weakSelf showHint:@"支付失败！"];
        }
    }];
    if([self.viewModel.orderPayParam.payTypeId isEqualToString:@"2"]){ // 支付宝
        [payManager alipayActionWithPayInfoModel:self.viewModel.payInfoData];
    }else if([self.viewModel.orderPayParam.payTypeId isEqualToString:@"1"]){ // 微信
        [payManager wxpayActionWithPayInfoModel:self.viewModel.payInfoData];
    }else if([self.viewModel.orderPayParam.payTypeId isEqualToString:@"4"]){ // 乐豆支付
        
//        if([weakSelf.viewModel.payInfoData.encourageAmount floatValue] > 0){
//            //鼓励金
//            [weakSelf.eGoldBoxView showForEncourageAmount:weakSelf.viewModel.payInfoData.encourageAmount andOrderId:weakSelf.viewModel.payInfoData.orderId];
//        }else{
//            //跳转到订单详情
//            [weakSelf toOrderDetails];
//        }
        [weakSelf PaySuccessRefreshMenth];
        
        [DATAMODEL synchronizationUserInfo];
    }else if([self.viewModel.orderPayParam.payTypeId isEqualToString:@"5"]){    //乐分支付
//        if([weakSelf.viewModel.payInfoData.encourageAmount floatValue] > 0){
//            //鼓励金
//            [weakSelf.eGoldBoxView showForEncourageAmount:weakSelf.viewModel.payInfoData.encourageAmount andOrderId:weakSelf.viewModel.payInfoData.orderId];
//        }else{
//            //跳转到订单详情
//            [weakSelf toOrderDetails];
//        }

        [weakSelf PaySuccessRefreshMenth];
        
        [DATAMODEL synchronizationUserInfo];
    }else if([self.viewModel.orderPayParam.payTypeId isEqualToString:@"3"]){ // 快捷支付
        NSLog(@"*********%@*******", _viewModel.payInfoData.quickPayChannel);
        if ([_viewModel.payInfoData.quickPayChannel isEqualToString:@"0"]) { // 通联支付
            [self allInPayAction];
        } else if ([_viewModel.payInfoData.quickPayChannel isEqualToString:@"1"])  { // 九派支付
            [self jiuPaiPayAction];
        } else {  }
    }
}

///快捷支付完成
- (void)fastPayFinish
{
    //获取订单详情
    //参数
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [param setObject:DATAMODEL.token forKey:@"token"];
    [param setObject:self.viewModel.payInfoData.orderId forKey:@"entityId"];
    //请求
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    [[Hen_MessageManager shareMessageManager] requestWithAction:@"/rebate-interface/order/detail.jhtml" dictionaryParam:param withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){ // 成功
            GC_MResOrderUnderUserDataModel *orderData = [[GC_MResOrderUnderUserDataModel alloc] initWithDictionary:msg];
            if(![orderData.status isEqualToString:@"UNPAID"]){//未支付
//                if([weakSelf.viewModel.payInfoData.encourageAmount floatValue] > 0){
//                    //鼓励金
//                    [weakSelf.eGoldBoxView showForEncourageAmount:weakSelf.viewModel.payInfoData.encourageAmount andOrderId:weakSelf.viewModel.payInfoData.orderId];
//                }else{
//                    //跳转到订单详情
//                    [weakSelf toOrderDetails];
//                }

                [weakSelf PaySuccessRefreshMenth];
            }
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

///显示支付密码修改
- (void)showPayPasswordChange
{
    //跳转
    GC_MineEditPasswordViewController *mepVC = [[GC_MineEditPasswordViewController alloc] init];
    mepVC.hidesBottomBarWhenPushed = YES;
    mepVC.editPwdType = 1;
    //回调
    WEAKSelf;
    mepVC.onEditPaySuccessBlock = ^(NSString *payPwd){
//        weakSelf.viewModel.orderPayParam.payPwd = [DATAMODEL RSAEncryptorString:payPwd];
        
        if([weakSelf.payMentType isEqualToString:@"1"]){
            weakSelf.isLeBeanDeduc = YES;
            weakSelf.isVerPayPwd = YES;
            weakSelf.viewModel.orderPayParam.isBeanPay = @"true";
            [weakSelf.tableView reloadData];
        }else{
            weakSelf.isVerPayPwd = YES;
            [weakSelf orderPay];
        }
    };
    
    [self.navigationController pushViewController:mepVC animated:YES];
}

///跳转到订单详情
- (void)toOrderDetails
{
    QL_UserOrderDetailsViewController *odVC = [[QL_UserOrderDetailsViewController alloc] init];
    odVC.hidesBottomBarWhenPushed = YES;
    odVC.orderId = self.viewModel.payInfoData.orderId;
    odVC.enterType = 1;
    
    [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:odVC animated:YES];
}

/// 通联支付
- (void)allInPayAction {
    QL_FastPayWebViewViewController *fpwvVC = [[QL_FastPayWebViewViewController alloc] init];
    fpwvVC.hidesBottomBarWhenPushed = YES;
    NSString *body = [NSString stringWithFormat:@"inputCharset=%@&pickupUrl=%@&receiveUrl=%@&version=%@&language=%@&signType=%@&merchantId=%@&orderNo=%@&orderAmount=%@&orderCurrency=%@&orderDatetime=%@&productName=%@&ext1=%@&payType=%@&signMsg=%@", self.viewModel.payInfoData.inputCharset, self.viewModel.payInfoData.pickupUrl, self.viewModel.payInfoData.receiveUrl, self.viewModel.payInfoData.version, self.viewModel.payInfoData.language, self.viewModel.payInfoData.signType, self.viewModel.payInfoData.merchantId, self.viewModel.payInfoData.orderNo, self.viewModel.payInfoData.orderAmount, self.viewModel.payInfoData.orderCurrency, self.viewModel.payInfoData.orderDatetime, self.viewModel.payInfoData.productName, self.viewModel.payInfoData.ext1, self.viewModel.payInfoData.payType, self.viewModel.payInfoData.signMsg];
    fpwvVC.urlString = self.viewModel.payInfoData.payH5orderUrl;
    fpwvVC.body = body;
    fpwvVC.pickupUrl = self.viewModel.payInfoData.pickupUrl;
    //回调
    WEAKSelf;
    fpwvVC.onPayFinish = ^{
        [weakSelf fastPayFinish];
    };
    //        [self.navigationController pushViewController:fpwvVC animated:YES];
    [self presentViewController:fpwvVC animated:YES completion:^{
        
    }];
    
    //        NSString *urlStr = [NSString stringWithFormat:@"%@?%@", self.viewModel.payInfoData.payH5orderUrl, body];
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

/// 九派支付
- (void)jiuPaiPayAction {
    JiuPaiWebViewController *fpwvVC = [[JiuPaiWebViewController alloc] init];
     fpwvVC.hidesBottomBarWhenPushed = YES;
    fpwvVC.urlString =  [NSString stringWithFormat:@"%@%@", APP_SERVER, jiuPaiPay];
     NSString *body= [NSString stringWithFormat:@"userId=%@&token=%@&amount=%@&clientIP=%@&goodsName=%@&orderSn=%@", DATAMODEL.userInfoData.id, DATAMODEL.token, _viewModel.orderPayParam.amount, Hen_DeviceUtil.getIPAddress, _businessData.name, _viewModel.payInfoData.out_trade_no];
    //回调
    fpwvVC.body = body;
    WEAKSelf;
    fpwvVC.onPayFinish = ^{
         [weakSelf fastPayFinish];
    };
    [self.navigationController pushViewController:fpwvVC animated:true];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    if(indexPath.section == 2){ // 支付方式
        //检查
        if([self.viewModel.orderPayParam.amount floatValue] <= 0 || self.viewModel.orderPayParam.amount.length <= 0){
            //提示
            [self showHint:@"消费金额不能小于0.01元！"];
            return;
        }
        
        QL_PayMentDataModel *model = self.viewModel.payMentInfoData.payType[indexPath.row];
        
        self.viewModel.orderPayParam.payType = model.configValue;
        self.viewModel.orderPayParam.payTypeId = model.id;
        
        if([model.id isEqualToString:@"5"]){ // 乐分支付
            //判断数量
            if([DATAMODEL.userInfoData.curLeScore doubleValue] < ([self.viewModel.orderPayParam.amount doubleValue] - [self.viewModel.orderPayParam.deductLeBean doubleValue])){
                //提示
                
                [self showHint:[NSString stringWithFormat:@"您的当前乐分为%@,支付失败！",DATAMODEL.userInfoData.curLeScore]];
                return;
            }
            //判断支付密码
            if([DATAMODEL.userInfoData.isSetPayPwd isEqualToString:@"0"]){
                //提示
                [self showHint:@"支付密码暂未设置！"];
                
                [self showPayPasswordChange];
                return;
            }
            
            
            if(self.isVerPayPwd){       //已经验证过支付密码
                [self orderPay];
            }else{
                //显示支付密码输入
                [self.payPasswordView showView];
            }
            
            return;
        }
        [self orderPay];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){ // 信息
        return 1;
    }else if(section == 1){ //乐豆抵扣
        return 1;
    }else if(section == 2){ // 支付方式
        return self.viewModel.payMentInfoData.payType.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){ // 信息
        return [QL_PayBillInfoTableViewCell getCellHeight];
    }else if(indexPath.section == 1){
        if([self.viewModel.payMentInfoData.isBeanPay isEqualToString:@"1"]){
            return [GC_LeBeanDeductibleTableViewCell getCellHeight];
        }else{
            return CGFLOAT_MIN;
        }
    }else if(indexPath.section == 2){ // 支付方式
        return [QL_PayBillPaymentTableViewCell getCellHeight];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2){ // 支付方式
        return HEIGHT_TRANSFORMATION(60);
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 2){ // 支付方式
        return [self paymentView];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){ // 信息
        QL_PayBillInfoTableViewCell *cell = [QL_PayBillInfoTableViewCell cellWithTableView:tableView];
        
        [cell updateUIForData:self.businessData];
        
        [cell setClearButtonHidden:YES];
        WEAKSelf;
        
        //回调
        cell.onPriceInputBlock = ^(NSString *price){
            weakSelf.viewModel.orderPayParam.amount = price;
        };
        cell.onRemarkInputBlock = ^(NSString *remark){
            weakSelf.viewModel.orderPayParam.remark = remark;
        };
        
        return cell;
    }else if(indexPath.section == 1){   //乐豆抵扣
        GC_LeBeanDeductibleTableViewCell *cell = [GC_LeBeanDeductibleTableViewCell cellWithTableView:tableView];
        cell.contentInfo = self.viewModel.payMentInfoData.userCurLeBean;
        cell.placeholder = @"0.0000";
        
        if(![self.viewModel.payMentInfoData.isBeanPay isEqualToString:@"1"]){
            cell.hidden = YES;
        }
        
        HenLog(@"是否支持乐豆抵扣：%@",self.viewModel.payMentInfoData.isBeanPay);
        
        WEAKSelf;           //开启乐豆抵扣 回调
        cell.onSwitchBlock = ^(BOOL isSelected, NSString *isSwitch) {
            if([isSwitch isEqualToString:@"0"]){        //开启乐豆抵扣
                weakSelf.payMentType = @"1";
                //判断支付密码
                if([DATAMODEL.userInfoData.isSetPayPwd isEqualToString:@"0"]){
                    //提示
                    [weakSelf showHint:@"支付密码暂未设置！"];
                    [weakSelf showPayPasswordChange];
                    return;
                }
                if(weakSelf.isVerPayPwd){           //已经验证过支付密码
                    weakSelf.isLeBeanDeduc = YES;
                    weakSelf.viewModel.orderPayParam.isBeanPay = @"true";
                    [weakSelf.tableView reloadData];
                }else{                              //未验证支付密码
                    [weakSelf.payPasswordView showView];
                }
            }else{
                weakSelf.payMentType = @"0";
                weakSelf.isLeBeanDeduc = isSelected;
                weakSelf.viewModel.orderPayParam.isBeanPay = @"false";
                [weakSelf.tableView reloadData];
            }
            
            
        };
        cell.inputInfo = self.viewModel.orderPayParam.deductLeBean;
        //输入乐豆数回调
        cell.onInputTextFieldBlock = ^(NSString *inputStr) {
            weakSelf.viewModel.orderPayParam.deductLeBean = inputStr;
        };
        [cell setTextFieldUserInteractionEnabled:self.isLeBeanDeduc];
        
        [cell setIsOpenleBeanDeDuc:self.isLeBeanDeduc];
        return cell;
    }else if(indexPath.section == 2){ // 支付方式
        QL_PayBillPaymentTableViewCell *cell = [QL_PayBillPaymentTableViewCell cellWithTableView:tableView];
        
        [cell updateUIForData:self.viewModel.payMentInfoData.payType[indexPath.row]];
        
        return cell;
    }
    
    return nil;
}

#pragma mark -- getter,setter

///支付方式
- (UIView *)paymentView
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(60)) backgroundColor:kCommonBackgroudColor];
    
    UILabel *label = [UILabel createLabelWithText:@"支付方式" font:kFontSize_26 textColor:kFontColorRed];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(OffSetToLeft);
    }];
    
    UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
    [view addSubview:lineImage];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.width.equalTo(view);
        make.bottom.equalTo(view);
    }];
    
    return view;
}

///密码支付输入
- (QL_PayPasswordInputView *)payPasswordView
{
    if(!_payPasswordView){
        _payPasswordView = [[QL_PayPasswordInputView alloc] init];
        //回调
        WEAKSelf;
        _payPasswordView.onInputFinishBlock = ^(NSString *password){
//            weakSelf.viewModel.orderPayParam.payPwd = [DATAMODEL RSAEncryptorString:password];
            //支付密码(rsa加密)
            [weakSelf.viewModel.verifyPayPwdParam setObject:[DATAMODEL RSAEncryptorString:password] forKey:@"password"];
            
            [weakSelf setVerifyPayPassWord];
        };
    }
    return _payPasswordView;
}

///鼓励奖弹出框
- (QL_EncourageGlodBoxView *)eGoldBoxView
{
    if(!_eGoldBoxView){
        _eGoldBoxView = [[QL_EncourageGlodBoxView alloc] init];
    }
    return _eGoldBoxView;
}

///view model
- (QL_PayBillViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_PayBillViewModel alloc] init];
    }
    return _viewModel;
}

///view model
- (QL_BusinessDetailsViewModel *)businessViewModel
{
    if(!_businessViewModel){
        _businessViewModel = [[QL_BusinessDetailsViewModel alloc] init];
    }
    return _businessViewModel;
}

- (void)setSellerId:(NSString *)sellerId
{
    _sellerId = sellerId;
    ///商户ID
    self.viewModel.payMentInfoParam.sellerId = sellerId;
    self.businessViewModel.detialsParam.userId = DATAMODEL.userInfoData.id;
    self.businessViewModel.detialsParam.entityId = sellerId;
    self.businessViewModel.detialsParam.latitude = DATAMODEL.latitude;
    self.businessViewModel.detialsParam.longitude = DATAMODEL.longitude;
}

@end
