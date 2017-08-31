//
//  GC_PayMoneyViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/15.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  支付 -- 界面
//

#import "GC_PayMoneyViewController.h"
#import "QL_PayBillPaymentTableViewCell.h"
#import "QL_PayBillViewModel.h"
#import "QL_OrderManagerViewController.h"
#import "QL_FastPayWebViewViewController.h"
#import "GC_BeingPaidViewController.h"
#import "JiuPaiWebViewController.h"

@interface GC_PayMoneyViewController ()<UITableViewDelegate, UITableViewDataSource>
///TableView
@property (nonatomic, weak) UITableView *tableView;
///ViewModel
@property (nonatomic, strong) QL_PayBillViewModel *viewModel;
@end

@implementation GC_PayMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNavigationItem];
    [self loadSubView];
    
    [self loadTableView];
    [self.tableView.header beginRefreshingForWaitMoment];
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


- (void)onGoBackClick:(id)sender
{
    [DATAMODEL.alertManager showCustomButtonTitls:@[@"马上支付",@"我再想想"] message:@"确定要取消支付吗？"];
    WEAKSelf;
    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
        if(buttonIndex == 1){       //我再想想
            QL_OrderManagerViewController *orderVC = [[QL_OrderManagerViewController alloc] init];
            orderVC.hidesBottomBarWhenPushed = YES;
            
            orderVC.shopInfoData = weakSelf.shopInfoData;
            
            orderVC.paySuccess = YES;
            
            orderVC.navCurrentItem = 1;
            orderVC.checkCurrentItem = 0;
            [weakSelf.navigationController pushViewController:orderVC animated:YES];
        }
    }];
}



#pragma mark -- override
///清除数据
-(void)cleanUpData
{
    
    [self setViewModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
}
#pragma mark -- private
///加载导航栏信息
-(void)loadNavigationItem{
    self.navigationItem.title = HenLocalizedString(@"支付");
}

///加载子视图
-(void)loadSubView
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}


///加载列表信息
-(void)loadTableView
{
    ///下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf loadPaymentDatas];
    }];
}


///加载 支付方式信息
- (void)loadPaymentDatas
{
    
    WEAKSelf;
    //参数
    [self.viewModel getPaymentDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        if([code isEqualToString:@"0000"]){ //成功
            [weakSelf.tableView reloadData];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}


//录单支付
- (void)checklistPay
{
    //参数
    [self.viewModel.paySellerOrderParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.paySellerOrderParam setObject:DATAMODEL.token forKey:@"token"];
    
    
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    [self.viewModel setPaySellerOrderDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf callThirdPayPlatform];
        }else{
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
        QL_OrderManagerViewController *orderVC = [[QL_OrderManagerViewController alloc] init];
        orderVC.hidesBottomBarWhenPushed = YES;
        
        orderVC.shopInfoData = weakSelf.shopInfoData;
        
        orderVC.paySuccess = YES;
        
        orderVC.navCurrentItem = 1;
        orderVC.checkCurrentItem = 2;
        [weakSelf.navigationController pushViewController:orderVC animated:YES];
        
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
        if(index == payResultTypeSuccess){      //支付成功
            [weakSelf PaySuccessRefreshMenth];
        }else{
            //提示
            [weakSelf showHint:@"支付失败！"];
        }
    }];
    
    if([[self.viewModel.paySellerOrderParam objectForKey:@"payTypeId"] isEqualToString:@"2"]){  // 支付宝
        [payManager alipayActionWithPayInfoModel:self.viewModel.paySellerOrderData];
    }else if([[self.viewModel.paySellerOrderParam objectForKey:@"payTypeId"] isEqualToString:@"1"]){    //// 微信
        [payManager wxpayActionWithPayInfoModel:self.viewModel.paySellerOrderData];
    }else if([[self.viewModel.paySellerOrderParam objectForKey:@"payTypeId"] isEqualToString:@"3"]){
        if ([_viewModel.paySellerOrderData.quickPayChannel isEqualToString:@"0"]) { // 通联支付
            [self allInPayAction];
        } else if ([_viewModel.paySellerOrderData.quickPayChannel isEqualToString:@"1"])  { // 九派支付
            [self jiuPaiPayAction];
        } else {  }
        
    }
    
}

/// 通联支付
- (void)allInPayAction {
    WEAKSelf;
    QL_FastPayWebViewViewController *fpwvVC = [[QL_FastPayWebViewViewController alloc] init];
    fpwvVC.hidesBottomBarWhenPushed = YES;
    
    NSString *body = [NSString stringWithFormat:@"inputCharset=%@&pickupUrl=%@&receiveUrl=%@&version=%@&language=%@&signType=%@&merchantId=%@&orderNo=%@&orderAmount=%@&orderCurrency=%@&orderDatetime=%@&productName=%@&ext1=%@&payType=%@&signMsg=%@", self.viewModel.paySellerOrderData.inputCharset, self.viewModel.paySellerOrderData.pickupUrl, self.viewModel.paySellerOrderData.receiveUrl, self.viewModel.paySellerOrderData.version, self.viewModel.paySellerOrderData.language, self.viewModel.paySellerOrderData.signType, self.viewModel.paySellerOrderData.merchantId, self.viewModel.paySellerOrderData.orderNo, self.viewModel.paySellerOrderData.orderAmount, self.viewModel.paySellerOrderData.orderCurrency, self.viewModel.paySellerOrderData.orderDatetime, self.viewModel.paySellerOrderData.productName, self.viewModel.paySellerOrderData.ext1, self.viewModel.paySellerOrderData.payType, self.viewModel.paySellerOrderData.signMsg];
    fpwvVC.urlString = self.viewModel.paySellerOrderData.payH5orderUrl;
    fpwvVC.body = body;
    fpwvVC.pickupUrl = self.viewModel.paySellerOrderData.pickupUrl;
    //回调
    fpwvVC.onPayFinish = ^{
        [weakSelf PaySuccessRefreshMenth];
    };
    
    [self presentViewController:fpwvVC animated:YES completion:^{
        
    }];
}

/// 九派支付
- (void)jiuPaiPayAction {
    WEAKSelf;
    JiuPaiWebViewController *fpwvVC = [[JiuPaiWebViewController alloc] init];
    fpwvVC.hidesBottomBarWhenPushed = YES;
    fpwvVC.urlString =  [NSString stringWithFormat:@"%@%@", APP_SERVER, jiuPaiPay];
    NSString *body= [NSString stringWithFormat:@"userId=%@&token=%@&amount=%@&clientIP=%@&goodsName=%@&orderSn=%@", DATAMODEL.userInfoData.id, DATAMODEL.token, _amount, Hen_DeviceUtil.getIPAddress, _goodsName, _sn];
    //回调
    fpwvVC.onPayFinish = ^{
       [weakSelf PaySuccessRefreshMenth];
    };
    fpwvVC.body = body;
     [self.navigationController pushViewController:fpwvVC animated:true];
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_PayBillPaymentTableViewCell *cell = [QL_PayBillPaymentTableViewCell cellWithTableView:tableView];
    
    QL_PayMentDataModel *model = self.viewModel.payMentDatas[indexPath.row];
    [cell updateUIForData:model];
    if([model.id isEqualToString:@"4"] || [model.id isEqualToString:@"5"]){
        cell.hidden = YES;
    }
    
    
    cell.bottomLongLineImage.hidden = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_PayMentDataModel *model = self.viewModel.payMentDatas[indexPath.row];
    if([model.id isEqualToString:@"4"] || [model.id isEqualToString:@"5"]){
        return CGFLOAT_MIN;
    }

    return [QL_PayBillPaymentTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.payMentDatas.count;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QL_PayMentDataModel *model = self.viewModel.payMentDatas[indexPath.row];
    
    //支付方式
    [self.viewModel.paySellerOrderParam setObject:model.configValue forKey:@"payType"];
    //支付方式id
    [self.viewModel.paySellerOrderParam setObject:model.id forKey:@"payTypeId"];
    
    //录单支付
    [self checklistPay];
}




#pragma mark -- getter,setter
///TableView
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kCommonBackgroudColor;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///ViewModel
- (QL_PayBillViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_PayBillViewModel alloc] init];
    }
    return _viewModel;
}

- (void)setSellerId:(NSString *)sellerId
{
    _sellerId = sellerId;
    [self.viewModel.paySellerOrderParam setObject:sellerId forKey:@"sellerId"];
}


//订单编号
- (void)setSn:(NSString *)sn
{
    _sn = sn;
    [self.viewModel.paySellerOrderParam setObject:sn forKey:@"sn"];
}
@end
