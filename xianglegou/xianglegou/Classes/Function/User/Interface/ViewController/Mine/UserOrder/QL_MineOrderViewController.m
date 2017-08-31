//
//  QL_MineOrderViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 我的订单界面
//

#import "QL_MineOrderViewController.h"
#import "QL_CustomSegmentView.h"
#import "QL_MineOrderTableViewCell.h"

#import "QL_UserOrderDetailsViewController.h"
#import "GC_OrderUnderUserViewModel.h"
#import "RebateTabBarViewController.h"
#import "GC_NavigationSegmentView.h"

@interface QL_MineOrderViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource ,QL_CustomSegmentDelegate, GC_NavigationSegmentDelegate>

///导航栏选择 View
@property (nonatomic, strong) GC_NavigationSegmentView *navSegmentView;

///选择view
@property(nonatomic, weak) QL_CustomSegmentView *segmentView;
///滑动区域
@property(nonatomic, weak) UIScrollView *scrollView;
///内容
@property(nonatomic, strong) NSMutableArray *tableViewArray;

///当前选择 0：全部；1：未支付；2：待评价；3：已完成
@property(nonatomic, assign) NSInteger currentItem;

///当前选择订单类型

@property (nonatomic, assign) NSInteger navCurrentItem;

///VIew Model
@property (nonatomic, strong) GC_OrderUnderUserViewModel *viewModel;
@end

@implementation QL_MineOrderViewController

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
    for(UITableView *tableView in self.tableViewArray){
        [tableView removeFromSuperview];
    }
    [self.tableViewArray removeAllObjects];
    [self setTableViewArray:nil];
    
    
    [self.navSegmentView removeFromSuperview];
    [self setNavSegmentView:nil];
}

- (void)onGoBackClick:(id)sender
{
    if(self.enterType == 1){
        RebateTabBarViewController *iVC = [[RebateTabBarViewController alloc] init];
        [iVC setSelectedIndex:2];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = iVC;
    }else{
        [super onGoBackClick:sender];
    }
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
//    self.navigationItem.title = HenLocalizedString(@"我的订单");
    self.navigationItem.titleView = self.navSegmentView;
    self.view.backgroundColor = kCommonBackgroudColor;

    [self segmentView];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.segmentView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    for(NSInteger i = 0; i < 2; i++){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.frame = CGRectMake(i*kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight-self.segmentView.frame.size.height-64);
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
            
            if(weakSelf.currentItem == 0){          //全部
                [weakSelf loadDataForStart:weakSelf.viewModel.allOrderDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
            }else if(weakSelf.currentItem == 1){    //未支付
                [weakSelf loadDataForStart:weakSelf.viewModel.unpaidOrderDatas.count / [NumberOfPages integerValue] isUpMore:YES];
            }else if(weakSelf.currentItem == 2){    //待评价
                [weakSelf loadDataForStart:weakSelf.viewModel.paidOrderDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
            }else if(weakSelf.currentItem == 3){    //已完成
                [weakSelf loadDataForStart:weakSelf.viewModel.finshOrderDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
            }
                
        }];
        [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
        tableView.footer = footer;
    }
}

///开始加载数据
-(void)startLoadData
{
    if(self.tableViewArray.count <= 0){
        return;
    }
    
    
    if(self.navCurrentItem == 0){          //买单
        self.viewModel.orderParam.isSallerOrder = @"false";
//        if(self.viewModel.allOrderDatas.count <= 0){
            [((UITableView*)self.tableViewArray[0]).header beginRefreshing];
//        }
    }else if(self.navCurrentItem == 1){    //录单
        self.viewModel.orderParam.isSallerOrder = @"true";
//        if(self.viewModel.allOrderDatas.count <= 0){
            [((UITableView*)self.tableViewArray[1]).header beginRefreshing];
//        }
    }
    
    
//    if(self.currentItem == 0){ // 买单
//        if(self.viewModel.allOrderDatas.count <= 0){
//            [((UITableView*)self.tableViewArray[0]).header beginRefreshing];
//        }
//    }else if(self.currentItem == 1){ // 待评价
//        if(self.viewModel.paidOrderDatas.count <= 0){
//            [((UITableView*)self.tableViewArray[1]).header beginRefreshing];
//        }
//    }else if(self.currentItem == 2){ // 完成
//        if(self.viewModel.finshOrderDatas.count <= 0){
//            [((UITableView*)self.tableViewArray[2]).header beginRefreshing];
//        }
//    }
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    self.viewModel.orderParam.pageNumber = [NSString stringWithFormat:@"%ld", (long)start];
    self.viewModel.orderParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.orderParam.token = DATAMODEL.token;
    
    if(self.currentItem == 0){ // 全部
        self.viewModel.orderParam.orderStatus = @"";
    }else if(self.currentItem == 1){    //未支付
        self.viewModel.orderParam.orderStatus = @"UNPAID";
    }else if(self.currentItem == 2){ // 待评价
        self.viewModel.orderParam.orderStatus = @"PAID";
    }else if(self.currentItem == 3){ // 完成
        self.viewModel.orderParam.orderStatus = @"FINISHED";
    }
    
    //请求
    WEAKSelf;
    [self.viewModel getOrderUnderUserDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        UITableView *tableVoew = weakSelf.tableViewArray[weakSelf.navCurrentItem];
        [tableVoew.header endRefreshing];
        [tableVoew.footer endRefreshing];
        
        if(isUpMore){
            if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                [tableVoew.footer noticeNoMoreData];
            }
        }
        
        if([code isEqualToString:@"0000"]){
            //更新 ui
            [tableVoew reloadData];
            
            if(weakSelf.currentItem == 0){ // 全部                
                if(weakSelf.viewModel.allOrderDatas.count > 0){
                    tableVoew.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableVoew.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else if(weakSelf.currentItem == 1){    //未支付
                if(weakSelf.viewModel.unpaidOrderDatas.count > 0){
                    tableVoew.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableVoew.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else if(weakSelf.currentItem == 2){ // 待评价
                if(weakSelf.viewModel.paidOrderDatas.count > 0){
                    tableVoew.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableVoew.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else if(weakSelf.currentItem == 3){ // 完成
                if(weakSelf.viewModel.finshOrderDatas.count > 0){
                    tableVoew.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableVoew.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

#pragma mark -- QL_CustomSegmentDelegate

///当前选中项 标签选择
- (void)customSegmentCurrentItem:(NSInteger)item
{
    
    
    //当前选项
    self.currentItem = item;
    
    
    if(self.tableViewArray.count <= 0){
        return;
    }
    
    //加载数据
    if(self.currentItem == 0){ // 全部
        [self.viewModel.allOrderDatas removeAllObjects];
        [((UITableView*)self.tableViewArray[self.navCurrentItem]) reloadData];
    }else if(self.currentItem == 1){    //未支付
        [self.viewModel.unpaidOrderDatas removeAllObjects];
        [((UITableView*)self.tableViewArray[self.navCurrentItem]) reloadData];
    }else if(self.currentItem == 2){ // 待评价
        [self.viewModel.paidOrderDatas removeAllObjects];
        [((UITableView*)self.tableViewArray[self.navCurrentItem]) reloadData];
    }else if(self.currentItem == 3){ // 完成
        [self.viewModel.finshOrderDatas removeAllObjects];
        [((UITableView*)self.tableViewArray[self.navCurrentItem]) reloadData];
    }
    
    [((UITableView*)self.tableViewArray[self.navCurrentItem]).header beginRefreshing];
}

//导航栏选择
- (void)customNavigationSegmentCurrentItem:(NSInteger)item
{
    //当前选项
    self.navCurrentItem = item;
    
    [self startLoadData];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QL_UserOrderDetailsViewController *uodVC = [[QL_UserOrderDetailsViewController alloc] init];
    uodVC.hidesBottomBarWhenPushed = YES;

    if(tableView == self.tableViewArray[0]){        //买单
        if(self.currentItem == 0){          //全部
            uodVC.orderData = self.viewModel.allOrderDatas[indexPath.section];
        }else if(self.currentItem == 1){    //未支付
            uodVC.orderData = self.viewModel.unpaidOrderDatas[indexPath.section];
            
        }else if(self.currentItem == 2){    //待评价
            uodVC.orderData = self.viewModel.paidOrderDatas[indexPath.section];
        }else if(self.currentItem == 3){    //已完成
            uodVC.orderData = self.viewModel.finshOrderDatas[indexPath.section];
        }
        
    }else if(tableView == self.tableViewArray[1]){  //录单
        if(self.currentItem == 0){          //全部
            uodVC.orderData = self.viewModel.allOrderDatas[indexPath.section];
        }else if(self.currentItem == 1){    //未支付
            uodVC.orderData = self.viewModel.unpaidOrderDatas[indexPath.section];
            
        }else if(self.currentItem == 2){    //待评价
            uodVC.orderData = self.viewModel.paidOrderDatas[indexPath.section];
        }else if(self.currentItem == 3){    //已完成
            uodVC.orderData = self.viewModel.finshOrderDatas[indexPath.section];
        }
    }
    
//    
//    
//    
//    if(tableView == self.tableViewArray[0]){ // 全部
//
//        uodVC.orderData = self.viewModel.allOrderDatas[indexPath.section];
//    }else if(tableView == self.tableViewArray[1]){ // 待评价
//        uodVC.orderData = self.viewModel.paidOrderDatas[indexPath.section];
//    }else if(tableView == self.tableViewArray[2]){ // 完成
//        uodVC.orderData = self.viewModel.finshOrderDatas[indexPath.section];
//    }
//    
    [self.navigationController pushViewController:uodVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableViewArray[0]){        //买单
        if(self.currentItem == 0){      //全部
            return self.viewModel.allOrderDatas.count;
        }else if(self.currentItem == 1){//未支付
            return self.viewModel.unpaidOrderDatas.count;
        }else if(self.currentItem == 2){//待评价
            return self.viewModel.paidOrderDatas.count;
        }else if(self.currentItem == 3){//已完成
            return self.viewModel.finshOrderDatas.count;
        }
    }else if(tableView == self.tableViewArray[1]){  //录单
        if(self.currentItem == 0){      //全部
            return self.viewModel.allOrderDatas.count;
        }else if(self.currentItem == 1){//未支付
            return self.viewModel.unpaidOrderDatas.count;
        }else if(self.currentItem == 2){//待评价
            return self.viewModel.paidOrderDatas.count;
        }else if(self.currentItem == 3){//已完成
            return self.viewModel.finshOrderDatas.count;
        }
    }
//    if(tableView == self.tableViewArray[0]){ // 全部
//        return self.viewModel.allOrderDatas.count;
//    }else if(tableView == self.tableViewArray[1]){ // 待评价
//        return self.viewModel.paidOrderDatas.count;
//    }else if(tableView == self.tableViewArray[2]){ // 完成
//        return self.viewModel.finshOrderDatas.count;
//    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.tableViewArray[0]){        //买单
        if(self.currentItem == 0){      //全部
            if([self.viewModel.allOrderDatas[indexPath.section].status isEqualToString:@"UNPAID"]){
                return [QL_MineOrderTableViewCell getCellHeightForUnPaid];
            }
        }else if(self.currentItem == 1){//未支付
           return [QL_MineOrderTableViewCell getCellHeightForUnPaid];
        }
    }else if(tableView == self.tableViewArray[1]){  //录单
        if(self.currentItem == 0){      //全部
            if([self.viewModel.allOrderDatas[indexPath.section].status isEqualToString:@"UNPAID"]){
                return [QL_MineOrderTableViewCell getCellHeightForUnPaid];
            }
        }else if(self.currentItem == 1){//未支付
           return [QL_MineOrderTableViewCell getCellHeightForUnPaid];
        }
    }
    return [QL_MineOrderTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(10)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_MineOrderTableViewCell *cell = [QL_MineOrderTableViewCell cellWithTableView:tableView];

    if(tableView == self.tableViewArray[0]){        //买单
        if(self.currentItem == 0){          //全部
            [cell updateUiForOrderUnderUserData:self.viewModel.allOrderDatas[indexPath.section]];
        }else if(self.currentItem == 1){    //未支付
            [cell updateUiForOrderUnderUserData:self.viewModel.unpaidOrderDatas[indexPath.section]];
            
        }else if(self.currentItem == 2){    //待评价
            [cell updateUiForOrderUnderUserData:self.viewModel.paidOrderDatas[indexPath.section]];
        }else if(self.currentItem == 3){    //已完成
            [cell updateUiForOrderUnderUserData:self.viewModel.finshOrderDatas[indexPath.section]];
        }
        
    }else if(tableView == self.tableViewArray[1]){
        if(self.currentItem == 0){          //全部
            [cell updateUiForOrderUnderUserData:self.viewModel.allOrderDatas[indexPath.section]];
        }else if(self.currentItem == 1){    //未支付
            [cell updateUiForOrderUnderUserData:self.viewModel.unpaidOrderDatas[indexPath.section]];
            
        }else if(self.currentItem == 2){    //待评价
            [cell updateUiForOrderUnderUserData:self.viewModel.paidOrderDatas[indexPath.section]];
        }else if(self.currentItem == 3){    //已完成
            [cell updateUiForOrderUnderUserData:self.viewModel.finshOrderDatas[indexPath.section]];
        }
    }
    
//    if(tableView == self.tableViewArray[0]){ // 全部热
//        [cell updateUiForOrderUnderUserData:self.viewModel.allOrderDatas[indexPath.section]];
//    }else if(tableView == self.tableViewArray[1]){ // 待评价
//        [cell updateUiForOrderUnderUserData:self.viewModel.paidOrderDatas[indexPath.section]];
//    }else if(tableView == self.tableViewArray[2]){ // 完成
//        [cell updateUiForOrderUnderUserData:self.viewModel.finshOrderDatas[indexPath.section]];
//    }
    
    return cell;
}

#pragma mark -- getter,setter
///选择View
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


///选择view
- (QL_CustomSegmentView *)segmentView
{
    if(!_segmentView){
        QL_CustomSegmentView *view = [[QL_CustomSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(70)];
        view.delegate = self;
        [view setItems:@[@"全部",@"未支付",@"待评价", @"已完成"]];
        [view setSelectItem:self.currentItem];
        [self.view addSubview:_segmentView = view];
    }
    return _segmentView;
}

///滑动区域
- (UIScrollView *)scrollView
{
    if(!_scrollView){
        UIScrollView *scrollView = [UIScrollView createScrollViewWithDelegateTarget:self];
        [self.view addSubview:_scrollView = scrollView];
    }
    return _scrollView;
}

///内容
- (NSMutableArray *)tableViewArray
{
    if(!_tableViewArray){
        _tableViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tableViewArray;
}

///View Model
- (GC_OrderUnderUserViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_OrderUnderUserViewModel alloc] init];
    }
    return _viewModel;
}
@end
