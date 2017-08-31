//
//  QL_MineShopViewController.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_MineShopViewController.h"
#import "QL_MSShopInfoTabelViewCell.h"
#import "QL_MSShopManagerTableViewCell.h"
#import "QL_MineShopViewViewModel.h"

#import "GC_RealNameRZViewController.h"
#import "QL_ShopInformationViewController.h"
#import "QL_OrderManagerViewController.h"
#import "QL_ReceivablesQRCodeViewController.h"
#import "GC_ShopMoneyViewController.h"
#import "GC_ShopRecordViewController.h"
#import "GC_AddBankCardViewController.h"

@interface QL_MineShopViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;

///view model
@property(nonatomic, strong) QL_MineShopViewViewModel *viewModel;

@end

@implementation QL_MineShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    [self.tableView.header beginRefreshingForWaitMoment];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if([DATAMODEL.interfaceSource isEqualToString:@"3"]){ //我的店铺界面
        [self loadData];
    }
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
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"我的店铺";
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    WEAKSelf;
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
}

///加载数据
- (void)loadData
{
    WEAKSelf;
    //请求
    [self.viewModel getShopInfoDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        if([code isEqualToString:@"0000"]){ // 成功
            [weakSelf.tableView reloadData];
            
            DATAMODEL.sellerId = weakSelf.viewModel.shopInfoData.id;
            
            if(![weakSelf.viewModel.shopInfoData.isAuth isEqualToString:@"1"]){
                [weakSelf DetectionRealName];
            }
        }else{
            //提示
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf showHint:desc];
            
        }
    }];
}



- (void)DetectionRealName
{
    [DATAMODEL.alertManager showCustomButtonTitls:@[@"马上认证",@"暂不需要"] message:@"请您先实名认证并添加银行卡，否则会影响收益结算哦！"];
    WEAKSelf;
    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            DATAMODEL.interfaceSource = @"3";
            GC_RealNameRZViewController *rzVC = [[GC_RealNameRZViewController alloc] init];
            rzVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:rzVC animated:YES];
        }
    }];
}


///跳实名认证
- (void)jumpRealName
{
    [DATAMODEL.alertManager showTwoButtonWithMessage:@"请先实名认证并绑定银行卡！"];
    WEAKSelf;
    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            GC_RealNameRZViewController *rzVC = [[GC_RealNameRZViewController alloc] init];
            rzVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:rzVC animated:YES];
        }
    }];

}

///跳添加银行卡
- (void)jumpAddBankInfo
{
    GC_AddBankCardViewController *abVC = [[GC_AddBankCardViewController alloc] init];
    abVC.hidesBottomBarWhenPushed = YES;
    
    abVC.isDefault = YES;
    [self.navigationController pushViewController:abVC animated:YES];
}




///店铺管理点击
- (void)onManagerClick:(NSInteger)item
{
    if(item == 0){ // 订单管理
        QL_OrderManagerViewController *omVC = [[QL_OrderManagerViewController alloc] init];
        omVC.hidesBottomBarWhenPushed = YES;
        omVC.shopInfoData = self.viewModel.shopInfoData;
        
        [self.navigationController pushViewController:omVC animated:YES];
    }else if(item == 1){ // 店铺信息
        QL_ShopInformationViewController *siVC = [[QL_ShopInformationViewController alloc] init];
        siVC.hidesBottomBarWhenPushed = YES;
        siVC.shopInfoData = self.viewModel.shopInfoData;
        //回调
        WEAKSelf;
        siVC.onEditSuccessBlock = ^(){
            [weakSelf.tableView.header beginRefreshingForWaitMoment];
        };
        
        [self.navigationController pushViewController:siVC animated:YES];
    }else if(item == 2){ // 收款二维码
        QL_ReceivablesQRCodeViewController *rrrcVC = [[QL_ReceivablesQRCodeViewController alloc] init];
        rrrcVC.hidesBottomBarWhenPushed = YES;
        rrrcVC.sellerId = self.viewModel.shopInfoData.id;
        
        [self.navigationController pushViewController:rrrcVC animated:YES];
    }else if(item == 3){    //店铺货款
        if([self.viewModel.shopInfoData.isAuth isEqualToString:@"1"]){
            if([self.viewModel.shopInfoData.isOwnBankCard isEqualToString:@"1"]){
                GC_ShopMoneyViewController *smVC = [[GC_ShopMoneyViewController alloc] init];
                smVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:smVC animated:YES];
            }else{
                DATAMODEL.interfaceSource = @"5";
                [self jumpAddBankInfo];
            }
        }else{
            DATAMODEL.interfaceSource = @"5";
            [self jumpRealName];
        }
        
    }else if(item == 4){    //店铺录单

        if([self.viewModel.shopInfoData.isAuth isEqualToString:@"1"]){
            if([self.viewModel.shopInfoData.isOwnBankCard isEqualToString:@"1"]){
                GC_ShopRecordViewController *srVC = [[GC_ShopRecordViewController alloc] init];
                srVC.hidesBottomBarWhenPushed = YES;
                
                srVC.shopInfoData = self.viewModel.shopInfoData;
                [self.navigationController pushViewController:srVC animated:YES];
            }else{
                DATAMODEL.interfaceSource = @"4";
                [self jumpAddBankInfo];
            }
        }else{
            DATAMODEL.interfaceSource = @"4";
            [self jumpRealName];
        }
    }
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.viewModel.shopInfoData){
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return [QL_MSShopInfoTabelViewCell getCellHeight];
    }else{
        return [QL_MSShopManagerTableViewCell getCellHeight];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return HEIGHT_TRANSFORMATION(60);
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return [self tableViewTitle];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        QL_MSShopInfoTabelViewCell *cell = [QL_MSShopInfoTabelViewCell cellWithTableView:tableView];
        
        [cell updateUIForData:self.viewModel.shopInfoData];
        
        return cell;
    }else{
        QL_MSShopManagerTableViewCell *cell = [QL_MSShopManagerTableViewCell cellWithTableView:tableView];
        
        //点击回调
        WEAKSelf;
        cell.onClickItemBlock = ^(NSInteger item){
            [weakSelf onManagerClick:item];
        };
        
        return cell;
    }
    return nil;
}

#pragma mark -- getter,setter

///内容
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///表单标题
- (UIView *)tableViewTitle
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(60)) backgroundColor:kCommonBackgroudColor];
    
    UILabel *label = [UILabel createLabelWithText:@"店铺管理" font:kFontSize_26 textColor:kFontColorRed];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(OffSetToLeft);
    }];
    
    return view;
}

///view model
- (QL_MineShopViewViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_MineShopViewViewModel alloc] init];
    }
    return _viewModel;
}

@end
