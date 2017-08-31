//
//  QL_OrderManagerViewController.m
//  Rebate
//
//  Created by mini2 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_OrderManagerViewController.h"
#import "GC_MineCountSegmentView.h"
#import "QL_OrderManagerTableViewCell.h"

#import "QL_OrderManagerViewModel.h"

#import "QL_ShopOrderDetailsViewController.h"
#import "QL_MineShopViewController.h"
#import "GC_NavigationSegmentView.h"
#import "QL_CustomSegmentView.h"


@interface QL_OrderManagerViewController ()<UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, QL_CustomSegmentDelegate, GC_NavigationSegmentDelegate>

///滑动区域
@property(nonatomic, weak) UIScrollView *scrollView;
///内容
@property(nonatomic, strong) NSMutableArray *tableViewArray;
///选择
@property(nonatomic, weak) GC_MineCountSegmentView *segmentView;

///view model
@property(nonatomic, strong) QL_OrderManagerViewModel *viewModel;

///订单类型选择
@property(nonatomic, strong) GC_NavigationSegmentView *navSegmentView;



///订单状态选择
@property (nonatomic, weak) QL_CustomSegmentView *statusSegmentView;

@end

@implementation QL_OrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    [self startLoadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDataForStart:1 isUpMore:NO];
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
    [self.navSegmentView removeFromSuperview];
    [self setNavSegmentView:nil];
}


///点击返回按钮
- (void)onGoBackClick:(id)sender
{
    if(self.paySuccess){
        [self onReturnMineShopInfo];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///返回 我的店铺
- (void)onReturnMineShopInfo
{
    for(UIViewController *vc in self.navigationController.viewControllers){
        if([vc isKindOfClass:QL_MineShopViewController.class]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
//    self.navigationItem.title = @"订单管理";
    self.navigationItem.titleView = self.navSegmentView;
    
    [self segmentView];
    

    [self.statusSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(70));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.statusSegmentView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    

    
    for (NSInteger i = 0; i < 2; i ++) {
        
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.frame = CGRectMake(i*kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight- self.segmentView.frame.size.height- self.statusSegmentView.frame.size.height - 64);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scrollView addSubview:tableView];
        
        __weak typeof(tableView) weakTableView = tableView;
        [self.tableViewArray addObject:weakTableView];
        
        
        //下拉刷新
        WEAKSelf;
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [tableView.footer resetNoMoreData];
            [weakSelf loadDataForStart:1 isUpMore:NO];
        }];
        //上拉加载更多
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataForStart:weakSelf.viewModel.orderListDatas.count / [NumberOfPages integerValue] + 1  isUpMore:YES];
        }];
        [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
        tableView.footer = footer;
    }
    
    
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    self.viewModel.orderListParam.pageNumber = [NSString stringWithFormat:@"%ld", (long)start];
    self.viewModel.orderListParam.userId = DATAMODEL.userInfoData.id;
    
    self.viewModel.orderListParam.token = DATAMODEL.token;
    
    
    self.viewModel.orderListParam.entityId = self.shopInfoData.id;
    
    if(self.shopInfoData.id.length <= 0){
        self.viewModel.orderListParam.entityId = DATAMODEL.sellerId;
    }
    
    
    
    
    WEAKSelf;
    //请求
    [self.viewModel getOrderListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        UITableView *tableView = weakSelf.tableViewArray[weakSelf.navCurrentItem];
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
        
        if(isUpMore){
            if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                [tableView.footer noticeNoMoreData];
            }
        }
        
        if([code isEqualToString:@"0000"]){
            [tableView reloadData];
            
            if(weakSelf.viewModel.orderListDatas.count > 0){
                tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
            }else{
                tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
            }
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}



///开始加载数据
-(void)startLoadData
{
    if(self.tableViewArray.count <= 0){
        return;
    }
    
    if(self.navCurrentItem == 0){           //买单
        
        
        
        self.viewModel.orderListParam.isSallerOrder = @"false";
        
        [self.statusSegmentView setItems:@[@"全部",@"已支付",@"已完成",@"结算中",@"已结算"]];
        
        
        
        [self.segmentView setItems:@[@"支付订单总数", @"支付总额(元)", @"未结算(元)"]];
        if(self.shopInfoData){
            [self.segmentView setItemCount:self.shopInfoData.totalOrderNum index:0];
            
            NSString *totalOrderAmount=self.shopInfoData.totalOrderAmount.length > 0 ? [DATAMODEL.henUtil string:self.shopInfoData.totalOrderAmount showDotNumber:2] : @"0.00";
            NSString *unClearingAmount= self.shopInfoData.unClearingAmount.length > 0 ? [DATAMODEL.henUtil string:self.shopInfoData.unClearingAmount showDotNumber:2] : @"0.00";
            [self.segmentView setItemCount:totalOrderAmount index:1];
            [self.segmentView setItemCount:unClearingAmount index:2];
        }
        
        [self.statusSegmentView setSelectItem:self.currentItem];
        
        
//        [((UITableView*)self.tableViewArray[0]).header beginRefreshing];
        
        
    }else if(self.navCurrentItem == 1){     //录单
        self.viewModel.orderListParam.isClearing = @"";
        self.viewModel.orderListParam.isSallerOrder = @"true";
        
        [self.statusSegmentView setItems:@[@"全部",@"未支付",@"已支付",@"已完成"]];
        
        
        
        [self.segmentView setItems:@[@"支付订单总数", @"支付总额(元)"]];
        if(self.shopInfoData){
            
            [self.segmentView setItemCount:self.shopInfoData.totalSellerOrderNum.length <= 0 ? @"0" : self.shopInfoData.totalSellerOrderNum index:0];
            
          NSString *totalSellerOrderAmount =  self.shopInfoData.totalSellerOrderAmount.length > 0 ? [DATAMODEL.henUtil string:self.shopInfoData.totalSellerOrderAmount showDotNumber:2] : @"0.00";
            [self.segmentView setItemCount: totalSellerOrderAmount index:1];
        }
    
        
        [self.statusSegmentView setSelectItem:self.checkCurrentItem];
//        [((UITableView*)self.tableViewArray[1]).header beginRefreshing];
    }
}


#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //订单详情
    QL_ShopOrderDetailsViewController *sodVC = [[QL_ShopOrderDetailsViewController alloc] init];
    sodVC.hidesBottomBarWhenPushed = YES;
    
    sodVC.isClearing = self.viewModel.orderListParam.isClearing;
    sodVC.orderData = self.viewModel.orderListDatas[indexPath.section];
    
    [self.navigationController pushViewController:sodVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.orderListDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QL_OrderManagerTableViewCell getCellHeightForIsSallerOrder:self.viewModel.orderListDatas[indexPath.section].isSallerOrder andStatus:self.viewModel.orderListDatas[indexPath.section].status];
    
//    return [QL_OrderManagerTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return CGFLOAT_MIN;
    }
    return HEIGHT_TRANSFORMATION(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return nil;
    }
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(10)) backgroundColor:kCommonBackgroudColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_OrderManagerTableViewCell *cell = [QL_OrderManagerTableViewCell cellWithTableView:tableView];
    
    cell.currentItem = self.currentItem;
    cell.isClearing = self.viewModel.orderListParam.isClearing;
    
    cell.viewModel = self.viewModel;
    [cell updateUIForData:self.viewModel.orderListDatas[indexPath.section]];
    
    
    WEAKSelf;
    cell.onDelSuccess = ^{
        [((UITableView*)weakSelf.tableViewArray[1]).header beginRefreshing];
    };
    
    return cell;
}

#pragma mark -- GC_NavigationSegmentDelegate  买单 录单选择
- (void)customNavigationSegmentCurrentItem:(NSInteger)item
{
    self.navCurrentItem = item;
    
    [self startLoadData];
}

#pragma mark -- QL_CustomSegmentDelegate 订单状态选择
- (void)customSegmentCurrentItem:(NSInteger)item
{
    
    
    
    
 
    if(self.tableViewArray.count <= 0){
        return;
    }
    
    [self.viewModel.orderListDatas removeAllObjects];
    [((UITableView*)self.tableViewArray[self.navCurrentItem]) reloadData];
    self.viewModel.orderListParam.isClearing = @"";
    
    if(self.navCurrentItem == 0){       //买单
        self.currentItem = item;
        self.viewModel.orderListParam.orderStatus = @"";
        if(item == 0){          //全部
            self.viewModel.orderListParam.orderStatus = @"";
        }else if(item == 1){    //已支付
            self.viewModel.orderListParam.orderStatus = @"PAID";
        }else if(item == 2){    //已完成
            self.viewModel.orderListParam.orderStatus = @"FINISHED";
        }else if(item == 3){    //结算中
            self.viewModel.orderListParam.isClearing = @"false";
        }else if(item == 4){    //已结算
            self.viewModel.orderListParam.isClearing = @"true";
        }
    }else if(self.navCurrentItem == 1){ //录单
        self.checkCurrentItem = item;
        if(item == 0){          //全部
            self.viewModel.orderListParam.orderStatus = @"";
        }else if(item == 1){    //未支付
            self.viewModel.orderListParam.orderStatus = @"UNPAID";
        }else if(item == 2){    //已支付
            self.viewModel.orderListParam.orderStatus = @"PAID";
        }else if(item == 3){    //已完成
            self.viewModel.orderListParam.orderStatus = @"FINISHED";
        }
    }
    
    [((UITableView*)self.tableViewArray[self.navCurrentItem]).header beginRefreshing];
    
}


#pragma mark -- getter,setter
///内容
- (NSMutableArray *)tableViewArray
{
    if(!_tableViewArray){
        _tableViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tableViewArray;
}
///滑动区域
- (UIScrollView *)scrollView
{
    if(!_scrollView){
        UIScrollView *scrollView = [UIScrollView createScrollViewWithDelegateTarget:self];
        [scrollView setContentOffset:CGPointMake(kMainScreenWidth * self.navCurrentItem, 0) animated:YES];
        [self.view addSubview:_scrollView = scrollView];
    }
    return _scrollView;
}

///导航栏选择 View
- (GC_NavigationSegmentView *)navSegmentView
{
    if(!_navSegmentView){
        _navSegmentView = [[GC_NavigationSegmentView alloc] initWithHeight:42.5];
        [_navSegmentView setDefaultFontColor:kFontColorWhite andSelectFontColor:kFontColorWhite];
        [_navSegmentView setTopLineImageViewHidden:YES];
        [_navSegmentView setBottomLineImageViewHidden:YES];
        _navSegmentView.delegate = self;
        [_navSegmentView setUnLineItems:@[@"买单",@"录单"]];
        [_navSegmentView setDefaultFont:kFontSize_28 selectFont:kFontSize_38];
        [_navSegmentView setSelectItem:self.navCurrentItem];
        [_navSegmentView setScrollView:self.scrollView];
    }
    return _navSegmentView;
}


///订单状态选择View
- (QL_CustomSegmentView *)statusSegmentView
{
    if(!_statusSegmentView){
        QL_CustomSegmentView *view = [[QL_CustomSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(70)];
        view.delegate = self;
        
        [self.view addSubview:_statusSegmentView = view];
    }
    return _statusSegmentView;
}


///选择
- (GC_MineCountSegmentView *)segmentView
{
    if(!_segmentView){
        GC_MineCountSegmentView *view = [[GC_MineCountSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(140)];
        view.lineMargin = 35;
        [view setTopLineImageViewHidden:YES];
        [view setBottomLineImageViewHidden:NO];
        
        [self.view addSubview:_segmentView = view];
    }
    return _segmentView;
}

///view model
- (QL_OrderManagerViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_OrderManagerViewModel alloc] init];
    }
    return _viewModel;
}

@end
