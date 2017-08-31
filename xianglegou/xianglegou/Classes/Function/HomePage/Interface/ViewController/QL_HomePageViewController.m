//
//  HomePageViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 首页界面
//

#import "QL_HomePageViewController.h"

#import "QL_HPBannerView.h"
#import "QL_HPTopSearchView.h"
#import "QL_HPClassifyTableViewCell.h"
#import "QL_HPBusinessListTableViewCell.h"

#import "QL_BusinessDetailsViewController.h"
#import "QL_BusinessListViewController.h"
#import "QL_BannerDetailsViewController.h"

#import "QL_HomePageViewModel.h"
#import "QL_SettledShopViewModel.h"

@interface QL_HomePageViewController ()<UITableViewDelegate, UITableViewDataSource>

///Banner view
@property(nonatomic, weak) QL_HPBannerView *activeView;
///搜索view
@property(nonatomic, weak) QL_HPTopSearchView *topSearchView;
///内容
@property(nonatomic, weak) UITableView *tableView;

///分类数据
@property(nonatomic, strong) NSMutableArray *classifyDataArray;
///view model
@property(nonatomic, strong) QL_HomePageViewModel *viewModel;

///加载数据
@property(nonatomic, assign) BOOL isLoadData;

@end

@implementation QL_HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    if([self checkLocationJurisdiction]){
        [self checkLocationCity];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self startLocation];
    if(!self.isLoadData){
        self.isLoadData = YES;
        [self.tableView.header beginRefreshingForWaitMoment];
    }else{
        [self loadDataForStart:1 isUpMore:NO];
    }
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
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
}

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.view.backgroundColor = kCommonBackgroudColor;
    
    [self activeView];
    [self topSearchView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.activeView.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
        make.bottom.equalTo(self.view);
    }];
    
    //下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf loadClassifyData];
        [weakSelf loadDataForStart:1 isUpMore:NO];
    }];
    //上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataForStart:weakSelf.viewModel.businessListDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    self.viewModel.businessListParam.pageNumber = [NSString stringWithFormat:@"%ld", (long)start];
    self.viewModel.businessListParam.areaIds = [DATAMODEL.configDBHelper getQuaryCityBusinessListAreaId:DATAMODEL.cityId];
    WEAKSelf;
    //请求
    [self.viewModel getBusinessListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        
        if(isUpMore){
            if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                [weakSelf.tableView.footer noticeNoMoreData];
            }
        }
        
        if([code isEqualToString:@"0000"]){
            [weakSelf.tableView reloadData];
            
            if(weakSelf.viewModel.businessListDatas.count > 0){
                weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
            }else{
                weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
            }
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

///加载分类数据
- (void)loadClassifyData
{
    WEAKSelf;
    QL_SettledShopViewModel *ssViewModel = [[QL_SettledShopViewModel alloc] init];
    [ssViewModel getSellerCategoryWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            [weakSelf.classifyDataArray removeAllObjects];
            [weakSelf.classifyDataArray addObjectsFromArray:msg];
            
            [weakSelf.tableView reloadData];
        }
    }];
    
    //加载banner
    [self.viewModel getBannerDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for(QL_HomePageBannerDataModel *model in weakSelf.viewModel.bannerDatas){
                [array addObject:model.bannerUrl];
            }
            [weakSelf.activeView updateUIForImages:array];
        }
    }];
}

///检查定位权限
- (BOOL)checkLocationJurisdiction
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status){ // 未开启权限
        //提示
        [DATAMODEL.alertManager showCustomButtonTitls:@[@"暂不", @"去设置"] message:@"定位服务未开启，请在系统设置中开启定位服务。"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
        return NO;
    }
    return YES;
}

///检查定位城市
- (void)checkLocationCity
{
    if(DATAMODEL.locationCityName.length > 0 && ![DATAMODEL.locationCityName isEqualToString:DATAMODEL.cityName]){
        // 提示
        [DATAMODEL.alertManager showTwoButtonWithMessage:[NSString stringWithFormat:@"系统定位到您在%@，需要切换至%@吗？", DATAMODEL.locationCityName, DATAMODEL.locationCityName]];
        WEAKSelf;
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){ // 确定
                DATAMODEL.cityId = [DATAMODEL.configDBHelper getCityIdForCityName:DATAMODEL.locationCityName];
                [weakSelf.topSearchView updateCityName];
                [weakSelf.tableView.header beginRefreshing];
//                [weakSelf loadDataForStart:1 isUpMore:NO];
            }
        }];
    }
}

///定位
- (void)startLocation
{
    if(DATAMODEL.isReloadHomeData){
        DATAMODEL.isReloadHomeData = NO;
        
        if([self checkLocationJurisdiction]){
            WEAKSelf;
            //回调
            DATAMODEL.baiduMapUtil.onLocationBlock = ^(NSString *longitude, NSString *latitude){
                if([longitude floatValue] > 0 && [latitude floatValue] > 0){
                    DATAMODEL.longitude = longitude;
                    DATAMODEL.latitude = latitude;
                    
                    [weakSelf loadDataForStart:1 isUpMore:NO];
                }
            };
            DATAMODEL.baiduMapUtil.onLocationCityBlock = ^(NSString* cityName){
                if([[DATAMODEL.userDBHelper getCityId] isEqualToString:@""]){
                    DATAMODEL.cityId = [DATAMODEL.configDBHelper getCityIdForCityName:cityName];
                }
                DATAMODEL.locationCityName = cityName;
                
                [DATAMODEL.baiduMapUtil cleanMap];
                
                [weakSelf checkLocationCity];
            };
            //初始化百度地图
            [DATAMODEL.baiduMapUtil loadLocation];
        }
    }else{
        if([DATAMODEL.longitude isEqualToString:@""] && [DATAMODEL.latitude isEqualToString:@""]){
            WEAKSelf;
            //回调
            DATAMODEL.baiduMapUtil.onLocationBlock = ^(NSString *longitude, NSString *latitude){
                if([longitude floatValue] > 0 && [latitude floatValue] > 0){
                    DATAMODEL.longitude = longitude;
                    DATAMODEL.latitude = latitude;
                    
                    [weakSelf loadDataForStart:1 isUpMore:NO];
                    [DATAMODEL.baiduMapUtil cleanMap];
                }
            };
            //初始化百度地图
            [DATAMODEL.baiduMapUtil loadLocation];
        }
    }
}

#pragma mark -- event response

- (void)onMoreBusinessAction:(id)sender
{
    QL_BusinessListViewController *blVC = [[QL_BusinessListViewController alloc] init];
    blVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:blVC animated:YES];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1){ // 推荐
        QL_BusinessDetailsViewController *bdVC = [[QL_BusinessDetailsViewController alloc] init];
        bdVC.hidesBottomBarWhenPushed = YES;
        bdVC.sellerId = self.viewModel.businessListDatas[indexPath.row].sellerId;
        
        [self.navigationController pushViewController:bdVC animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1){ // 推荐
        return self.viewModel.businessListDatas.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){ // 分类
        return [QL_HPClassifyTableViewCell getCellHeight];
    }else if(indexPath.section == 1){ // 推荐
        return [QL_HPBusinessListTableViewCell getCellHeight];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0){ // 分类
        return HEIGHT_TRANSFORMATION(10);
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 0){ // 分类
        return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(10)) backgroundColor:kCommonBackgroudColor];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1){ // 推荐
        return HEIGHT_TRANSFORMATION(78);
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1){ // 推荐
        return [self tableViewTitleView];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){ // 分类
        QL_HPClassifyTableViewCell *cell = [QL_HPClassifyTableViewCell cellWithTableView:tableView];
        
        [cell updateUIForData:self.classifyDataArray];

        return cell;
    }else if(indexPath.section == 1){ // 推荐
        QL_HPBusinessListTableViewCell *cell = [QL_HPBusinessListTableViewCell cellWithTableView:tableView];
        
        //分界线
        cell.topLongLineImage.hidden = NO;
        if(self.viewModel.businessListDatas.count > 0){
            [cell updateUIForData:self.viewModel.businessListDatas[indexPath.row]];
        }
        
        return cell;
    }
    return nil;
}

#pragma mark -- getter,setter

///Banner view
- (QL_HPBannerView *)activeView
{
    if(!_activeView){
        QL_HPBannerView *view = [[QL_HPBannerView alloc] initWithHeight:HEIGHT_TRANSFORMATION(346)];
        [self.view addSubview:_activeView = view];
        //回调
        WEAKSelf;
        view.onPngClickBlock = ^(NSInteger item){
            //详情
            QL_BannerDetailsViewController *bdVC = [[QL_BannerDetailsViewController alloc] init];
            bdVC.hidesBottomBarWhenPushed = YES;
            bdVC.bannerData = weakSelf.viewModel.bannerDatas[item];
            
            [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:bdVC animated:YES];
        };
    }
    return _activeView;
}

///搜索view
- (QL_HPTopSearchView *)topSearchView
{
    if(!_topSearchView){
        QL_HPTopSearchView *view = [[QL_HPTopSearchView alloc] init];
        [self.view addSubview:_topSearchView = view];
        WEAKSelf;
        //回调
        view.onCityChooiceBlock = ^(){
            [weakSelf.viewModel.businessListDatas removeAllObjects];
            
            [weakSelf.tableView.header beginRefreshingForWaitMoment];
        };
    }
    return _topSearchView;
}

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
- (UIView *)tableViewTitleView
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(78)) backgroundColor:kCommonWhiteBg];
    
    UIImageView *image = [UIImageView createImageViewWithName:@"homepage_recommend_red"];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view);
    }];
    UILabel *label = [UILabel createLabelWithText:@"推荐商家" font:kFontSize_28];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(OffSetToLeft);
    }];
    
    UILabel *moreLabel = [UILabel createLabelWithText:@"查看更多" font:kFontSize_24];
    [view addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(WIDTH_TRANSFORMATION(-40));
    }];
    UIImageView *nextImage = [UIImageView createImageViewWithName:@"public_next"];
    [view addSubview:nextImage];
    [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(WIDTH_TRANSFORMATION(-14));
    }];
    
    UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
    [view addSubview:lineImage];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.width.equalTo(view);
        make.top.equalTo(view);
    }];
    
    //点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMoreBusinessAction:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

///分类数据
- (NSMutableArray *)classifyDataArray
{
    if(!_classifyDataArray){
        _classifyDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _classifyDataArray;
}

///view model
- (QL_HomePageViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_HomePageViewModel alloc] init];
        
        _viewModel.businessListParam.latitude = DATAMODEL.latitude;
        _viewModel.businessListParam.longitude = DATAMODEL.longitude;
        //按距离优先
        _viewModel.businessListParam.sortType = @"DISTANCEASC";
    }
    return _viewModel;
}

@end
