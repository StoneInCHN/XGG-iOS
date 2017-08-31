//
//  GC_MineViewController.m
//  Rebate
//
//  Created by mini3 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  首页界面
//

#import "GC_MineViewController.h"

#import "GC_MineInformationView.h"

#import "GC_MineItemTableViewCell.h"
#import "GC_ConsumerHotlineTableViewCell.h"

#import "GC_LoginViewController.h"
#import "QL_MineCollectionViewController.h"
#import "QL_MineOrderViewController.h"
#import "QL_SettledShopViewController.h"
#import "GC_SettingViewController.h"
#import "GC_RecommendPoliteViewController.h"
#import "QL_MineShopViewController.h"
#import "GC_SettingConfigViewController.h"
#import "GC_UserHelpListViewController.h"
#import "GC_MineBankCardViewController.h"
#import "GC_RealNameRZViewController.h"
#import "GC_RecommendedBusinessViewController.h"
#import "GC_ShopReviewViewController.h"
#import "GC_BusinessCenterViewController.h"

#import "GC_MineMessageViewModel.h"
#import "GC_ConfigurationViewModel.h"

#import "GC_BeingPaidView.h"

@interface GC_MineViewController ()<UITableViewDelegate, UITableViewDataSource>

///基本信息 View
@property (nonatomic, weak) GC_MineInformationView *mineInfoView;

///TableView
@property (nonatomic, weak) UITableView *tableView;


///DataSource
@property (nonatomic, strong) NSMutableArray *dataSource;


///ViewModel
@property (nonatomic, strong) GC_MineMessageViewModel *viewModel;

///配置ViewModel
@property (nonatomic, strong) GC_ConfigurationViewModel *configViewModel;


///客服电话
@property (nonatomic, strong) NSString *customerMobile;

///服务时间
@property (nonatomic, strong) NSString *serviceTime;
@end

@implementation GC_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    [self loadTableView];
    
    [self.tableView.header beginRefreshingForWaitMoment];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self loadMineMessageData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    [self.dataSource removeAllObjects];
    [self setDataSource:nil];
    
    [self setViewModel:nil];
    
    [self setConfigViewModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    
}




#pragma mark -- private
///加载子视图
- (void)loadSubView
{
    self.view.backgroundColor = kCommonBackgroudColor;
    
    [self.mineInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.mineInfoView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}


///加载列表数据
- (void)loadTableView
{
    WEAKSelf;
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadCustomerPhoto];
        [weakSelf loadMineMessageData];
    }];
}

///加载我的 数据
-(void)loadMineMessageData
{
    
//    [self showPayHud:@"正在刷新状态..."];
    //参数
    [self.viewModel.userInfoParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.userInfoParam setValue:DATAMODEL.token forKey:@"token"];
    //请求
    WEAKSelf;
    [self.viewModel getUserInfoWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        
        if(![code isEqualToString:@"0000"]){    //失败
            [weakSelf.viewModel setUserInfoData:nil];
            [weakSelf clearUserInfoData];
            ////[weakSelf showHint:desc];
        }
        
        [weakSelf.mineInfoView updataUiForUserInfoData:weakSelf.viewModel.userInfoData];
        
        [weakSelf.tableView reloadData];
    }];
}


///加载配置 电话
-(void)loadCustomerPhoto
{
    //参数
    [self.configViewModel.configParam setObject:@"CUSTOMER_PHONE" forKey:@"configKey"];
    //请求
    WEAKSelf;
    [self.configViewModel getConfigurationDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            weakSelf.customerMobile = weakSelf.configViewModel.configurationData.configValue;
            weakSelf.serviceTime = desc;
            [weakSelf.tableView reloadData];
        }
        
    }];
}

///清楚数据
-(void)clearUserInfoData
{
    DATAMODEL.isLogin = NO;
    [DATAMODEL setToken:@""];
    [DATAMODEL setUserInfoData:nil];
}

///点击登陆
-(void)onLoginTapGestureHandler:(id)sender
{

    if(!DATAMODEL.isLogin){
        GC_LoginViewController *login = [[GC_LoginViewController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}

///判断是否登录
-(BOOL)checkIsLogin
{
    if(!DATAMODEL.isLogin){
        GC_LoginViewController *lVC = [[GC_LoginViewController alloc] init];
        lVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:lVC animated:YES];
    }
    return DATAMODEL.isLogin;
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == self.dataSource.count){
        GC_ConsumerHotlineTableViewCell *cell = [GC_ConsumerHotlineTableViewCell cellWithTableView:tableView];
        cell.customerMobile = self.customerMobile;
        cell.serviceTime = self.serviceTime;
        cell.bottomLongLineImage.hidden = NO;
        return cell;
    }else{
        GC_MineItemTableViewCell *cell = [GC_MineItemTableViewCell cellWithTableView:tableView];
        cell.titleInfo = self.dataSource[indexPath.section][indexPath.row];
        cell.bottomLongLineImage.hidden = NO;
        if(indexPath.row == 0){
            cell.topLongLineImage.hidden = NO;
        }
        
        NSString *title = self.dataSource[indexPath.section][indexPath.row];
        if([title isEqualToString:@"我是业务员"]){
            if([DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){
                cell.topLongLineImage.hidden = NO;
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
        }
        
        if([title isEqualToString:@"我是商家"]){
            if([DATAMODEL.userInfoData.sellerStatus isEqualToString:@"NO"] || !DATAMODEL.isLogin){
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
        }else if([title isEqualToString:@"我是代理商"]){
            if(self.viewModel.userInfoData.agent.agencyLevel.length > 0){
                cell.hidden = NO;
            }else{
                cell.hidden = YES;
            }
        }
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == self.dataSource.count){
        return [GC_ConsumerHotlineTableViewCell getCellHeight];
    }
    
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    if([title isEqualToString:@"我是业务员"]){
        if(![DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){
            return CGFLOAT_MIN;
        }
    }
    
    if([title isEqualToString:@"我是商家"]){
        if([DATAMODEL.userInfoData.sellerStatus isEqualToString:@"NO"] || !DATAMODEL.isLogin){
           return CGFLOAT_MIN;
        }
    }
    
    if([title isEqualToString:@"我是代理商"]){
        if(self.viewModel.userInfoData.agent.agencyLevel.length <= 0){
            return CGFLOAT_MIN;
        }
    }
    
    return [GC_MineItemTableViewCell getCellHeight];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == self.dataSource.count){
        return 1;
    }
    return ((NSMutableArray*)self.dataSource[section]).count;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if([DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"] || [DATAMODEL.userInfoData.sellerStatus isEqualToString:@"YES"]){
            return HEIGHT_TRANSFORMATION(10);
        }else{
            return CGFLOAT_MIN;
        }
    }else if(section == self.dataSource.count){
        return CGFLOAT_MIN;
    }else{
        return HEIGHT_TRANSFORMATION(10);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == self.dataSource.count){         //客服电话
        [DATAMODEL.henUtil customerPhone:self.customerMobile];
    }else{
        NSString *title = self.dataSource[indexPath.section][indexPath.row];
        if([title isEqualToString:@"推荐有礼"]){
            if([self checkIsLogin]){
                GC_RecommendPoliteViewController *recommendPolite = [[GC_RecommendPoliteViewController alloc] init];
                recommendPolite.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:recommendPolite animated:YES];
            }
        }else if([title isEqualToString:@"我的订单"]){
            if([self checkIsLogin]){
                QL_MineOrderViewController *moVC = [[QL_MineOrderViewController alloc] init];
                moVC.hidesBottomBarWhenPushed = YES;
            
                [self.navigationController pushViewController:moVC animated:YES];
            }
        }else if([title isEqualToString:@"我是商家"]){
            if([self checkIsLogin]){
                if([DATAMODEL.userInfoData.sellerStatus isEqualToString:@"YES"]){ //拥有店铺
                    QL_MineShopViewController *msVC = [[QL_MineShopViewController alloc] init];
                    msVC.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:msVC animated:YES];
                }else if([DATAMODEL.userInfoData.sellerStatus isEqualToString:@"AUDIT_WAITING"]){  //表示用户申请店铺请求正在审核中
                    GC_ShopReviewViewController *srVC = [[GC_ShopReviewViewController alloc] init];
                    
                    srVC.hidesBottomBarWhenPushed = YES;
                    
                    srVC.isReview = 1;
                    [self.navigationController pushViewController:srVC animated:YES];
                    
                    
                    
                }else if([DATAMODEL.userInfoData.sellerStatus isEqualToString:@"AUDIT_FAILED"]){   //表示用户申请店铺请求审核失败
                    
                    GC_ShopReviewViewController *srVC = [[GC_ShopReviewViewController alloc] init];
                    
                    srVC.hidesBottomBarWhenPushed = YES;
                    
                    srVC.isReview = 2;
                    [self.navigationController pushViewController:srVC animated:YES];
                    
                    
                }
            }
        }else if([title isEqualToString:@"我的收藏"]){
            if([self checkIsLogin]){
                QL_MineCollectionViewController *mcVC = [[QL_MineCollectionViewController alloc] init];
                mcVC.hidesBottomBarWhenPushed = YES;
            
                [self.navigationController pushViewController:mcVC animated:YES];
            }
        }else if([title isEqualToString:@"用户帮助"]){
            GC_UserHelpListViewController *uhVC = [[GC_UserHelpListViewController alloc] init];
            uhVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:uhVC animated:YES];
        }else if([title isEqualToString:@"关于我们"]){
            GC_SettingConfigViewController *scVC = [[GC_SettingConfigViewController alloc] init];
            scVC.hidesBottomBarWhenPushed = YES;
            scVC.titleInfo = @"关于我们";
            scVC.configKey = @"ABOUT_US";
            [self.navigationController pushViewController:scVC animated:YES];
        }else if([title isEqualToString:@"设置"]){
            GC_SettingViewController *setting = [[GC_SettingViewController alloc] init];
            setting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setting animated:YES];
        }else if([title isEqualToString:@"我的银行卡"]){

            if([self checkIsLogin]){
                if([self.viewModel.userInfoData.isAuth isEqualToString:@"1"]){
                    GC_MineBankCardViewController *mbcVC = [[GC_MineBankCardViewController alloc] init];
                    mbcVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mbcVC animated:YES];
                }else{          //绑定银行卡
                    
                    WEAKSelf;
                    [DATAMODEL.alertManager showTwoButtonWithMessage:@"绑定银行卡请先实名认证！"];
                    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
                        if(buttonIndex == 0){
                            DATAMODEL.interfaceSource = @"1";
                            GC_RealNameRZViewController *rnzVC = [[GC_RealNameRZViewController alloc] init];
                            rnzVC.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:rnzVC animated:YES];
                        }
                    }];
                    
                    
                    
                }
            }
            
        }else if([title isEqualToString:@"我是业务员"]){
            GC_RecommendedBusinessViewController *rbVC = [[GC_RecommendedBusinessViewController alloc] init];
            
            rbVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rbVC animated:YES];
        }else if([title isEqualToString:@"我是代理商"]){
            GC_BusinessCenterViewController *bcVC = [[GC_BusinessCenterViewController alloc] init];
            bcVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bcVC animated:YES];
        }
    }
}

#pragma mark -- getter,setter
///基本信息 View
- (GC_MineInformationView *)mineInfoView
{
    if(!_mineInfoView){
        GC_MineInformationView *infoView = [[GC_MineInformationView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLoginTapGestureHandler:)];
        infoView.userInteractionEnabled = YES;
        [infoView addGestureRecognizer:tap];
        
        [self.view addSubview:_mineInfoView = infoView];
    }
    return _mineInfoView;
}

///TableView
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///DataSouce
- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataSource addObjectsFromArray:@[@[@"我是商家",@"我是业务员",@"我是代理商"],@[@"推荐有礼",@"我的银行卡",@"我的订单",@"我的收藏"],@[@"用户帮助",@"关于我们",@"设置"]]];
    }
    return _dataSource;
}

- (GC_MineMessageViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_MineMessageViewModel alloc] init];
    }
    return _viewModel;
}

- (GC_ConfigurationViewModel *)configViewModel
{
    if(!_configViewModel){
        _configViewModel = [[GC_ConfigurationViewModel alloc] init];
    }
    return _configViewModel;
}
@end
