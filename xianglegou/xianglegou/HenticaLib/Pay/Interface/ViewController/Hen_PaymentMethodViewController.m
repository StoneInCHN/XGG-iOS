//
//  QL_PaymentMethodViewController.m
//  Peccancy
//
//  Created by mini2 on 16/10/20.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_PaymentMethodViewController.h"
#import "Hen_PayViewModel.h"
#import "Hen_PaymentMethodTableViewCell.h"
#import "Hen_PayManager.h"

@interface Hen_PaymentMethodViewController ()

///view model
@property(nonatomic, strong) Hen_PayViewModel *viewModel;

@end

@implementation Hen_PaymentMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = kCommonBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.title = @"支付方式";
    [self loadData];
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
-(void)cleanUpData
{
}

///清除强引用视图
-(void)cleanUpStrongSubView
{
}

-(void)onTVCGoBackClick:(id)sender
{
    if(self.onBackActionBlock){
        self.onBackActionBlock(self);
    }
}

#pragma mark -- private

-(void)loadData
{
    if(self.paymentList.count <= 0){
        //显示加载
        [self showPayHud:@""];
        WEAKSelf;
        [self.viewModel getOpenPaymentWithResultBlock:^(NSString *errCode, NSString *errMsg, id data, id page) {
            //取消加载
            [weakSelf hideHud];
            if([errCode isEqualToString:@"0"]){ // 成功
                weakSelf.paymentList = data;
                [weakSelf.tableView reloadData];
            }else{
                //提示
                [weakSelf showHint:errMsg];
            }
        }];
    }
}

///支付
-(void)payForData:(Hen_PaymentDataModel*)data
{
    //参数
    [self.viewModel.orderPayParam setObject:data.type forKey:@"payType"];
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.viewModel orderPayWithResultBlock:^(NSString *errCode, NSString *errMsg, id data, id page) {
        //取消加载
        [weakSelf hideHud];
        if([errCode isEqualToString:@"0"]){ // 成功
            [weakSelf callThirdPayPlatform];
        }else{
            //提示
            [weakSelf showHint:errMsg];
        }
    }];
}

///调用第三方支付平台
-(void)callThirdPayPlatform
{
    Hen_PayManager *payManager = [Hen_PayManager sharedManager];
    //支付结果回调
    WEAKSelf;
    [payManager setPayResultBlock:^(PayResultType index) {
        if(index == payResultTypeSuccess){
            if(weakSelf.onPayFinishBlock){
                weakSelf.onPayFinishBlock(YES);
            }
        }else{
            if(weakSelf.onPayFinishBlock){
                weakSelf.onPayFinishBlock(NO);
            }
        }
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    if(self.viewModel.orderPayData.payType == 1){ // 支付宝
        [payManager alipayActionWithPayInfoModel:self.viewModel.orderPayData];
    }else if(self.viewModel.orderPayData.payType == 2){ // 微信
        [payManager wxpayActionWithPayInfoModel:self.viewModel.orderPayData];
    }else if(self.viewModel.orderPayData.payType == 3){ // 银联
        [payManager unionPayWithPayInfoModel:self.viewModel.orderPayData andViewController:self];
    }
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //数据
    Hen_PaymentDataModel *model = self.paymentList[indexPath.row];
    [self payForData:model];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paymentList.count;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Hen_PaymentMethodTableViewCell getCellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(10);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(10)) backgroundColor:kCommonBackgroudColor];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Hen_PaymentMethodTableViewCell *cell = [Hen_PaymentMethodTableViewCell cellWithTableView:tableView];
    
    //数据
    Hen_PaymentDataModel *model = self.paymentList[indexPath.row];
    cell.icon = model.icon;
    cell.title = model.name;
    
    cell.topShortLineImage.hidden = NO;
    if(indexPath.row == 0){
        cell.topLongLineImage.hidden = NO;
    }else if(indexPath.row == self.paymentList.count-1){
        cell.bottomLongLineImage.hidden = NO;
    }
    
    return cell;
}

#pragma mark -- getter,setter

-(Hen_PayViewModel*)viewModel
{
    if(!_viewModel){
        _viewModel = [[Hen_PayViewModel alloc] init];
    }
    return _viewModel;
}

-(void)setOrderId:(NSString *)orderId
{
    _orderId = orderId;
    [self.viewModel.orderPayParam setObject:orderId forKey:@"orderId"];
}

@end
