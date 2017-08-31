//
//  GC_BusinessCenterViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/7/1.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  营业中心 - 界面
//

#import "GC_BusinessCenterViewController.h"
#import "GC_BusinessCountViewController.h"

#import "QL_ListScreenSegmentView.h"
#import "QL_CustomSegmentView.h"
#import "GC_TransactionAmountTableViewCell.h"
#import "GC_TransactionDateTableViewCell.h"
#import "GC_AmountBottomTableViewCell.h"
#import "GC_JiaoAmountTableViewCell.h"

#import "GC_AmountDateFilterBoxView.h"

#import "GC_BusinessNumTableViewCell.h"
#import "GC_BusinessItemTableViewCell.h"
#import "QL_ListSelectView.h"
#import "GC_BusinessCenterViewModel.h"
#import "GC_ClerkInfoTableViewCell.h"

@interface GC_BusinessCenterViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, QL_ListScreenSegmentDelegate, QL_CustomSegmentDelegate>
//地址选择view
@property (nonatomic, weak) QL_ListScreenSegmentView *areaSegmentView;

///类型选择View
@property (nonatomic, weak) QL_CustomSegmentView *segmentView;


///当前选择 0：交易额；1：商家数；2：消费者数；3：业务员数
@property(nonatomic, assign) NSInteger currentItem;

///筛选
@property (nonatomic, strong) GC_AmountDateFilterBoxView *filterBoxView;

///滑动区域
@property(nonatomic, weak) UIScrollView *scrollView;
///内容
@property(nonatomic, strong) NSMutableArray *tableViewArray;


///省选择
@property (nonatomic, weak) QL_ListSelectView *provinceSelectView;
///市选择
@property (nonatomic, weak) QL_ListSelectView *citySelectView;
///区选择
@property (nonatomic, weak) QL_ListSelectView *countySelectView;


///ViewModel
@property (nonatomic, strong) GC_BusinessCenterViewModel *viewModel;

///营业总数
@property (nonatomic, strong) NSString *businessCount;

///是否可以选择 市
@property (nonatomic, assign) BOOL isSelectCity;
@property (nonatomic, strong) NSString *cityId;
///是否可以选择 区
@property (nonatomic, assign) BOOL isSelectCounty;
@property (nonatomic, strong) NSString *countyId;


///开始日期
@property (nonatomic, strong) NSString *begDate;
///结束日期
@property (nonatomic, strong) NSString *endDate;

@property (nonatomic, assign) UIBarButtonItem *rightBarButon;


///是否点击跳转
@property (nonatomic, assign) BOOL isJump;


///业务员 显示状态   3、区
@property (nonatomic, assign) NSInteger clerkDisplayType;
@end

@implementation GC_BusinessCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNavigationItem];
    
    self.currentItem = 0;

    [self loadSubView];
    
    [self initDefaultParam];
    
    [self startLoadData];
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

///加载导航栏信息
-(void)loadNavigationItem{
    self.navigationItem.title = HenLocalizedString(@"营业中心");
    UIBarButtonItem *rightBar = [UIBarButtonItem createBarButtonItemWithTitle:@"筛选" titleColor:kFontColorWhite target:self action:@selector(onFilterAction:)];
    
    self.navigationItem.rightBarButtonItem = _rightBarButon = rightBar;
}

///加载子视图
- (void)loadSubView
{
    [self.areaSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(70));
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaSegmentView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(70));
    }];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.segmentView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    NSInteger tableNum = 0;
    if([DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){   //业务员
        tableNum = 3;
    }else{
        tableNum = 4;
    }
    for (NSInteger i = 0; i < tableNum; i ++) {
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        
        tableView.frame = CGRectMake(i * kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight - self.areaSegmentView.frame.size.height - self.segmentView.frame.size.height - 64);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kCommonBackgroudColor;
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(100)];
        [self.scrollView addSubview:tableView];
        
        __weak typeof(tableView) weakTableView = tableView;
        [self.tableViewArray addObject:weakTableView];
        
        if(i < 2){
            //下拉刷新
            WEAKSelf;
            tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [tableView.footer resetNoMoreData];
                [weakSelf loadDataForStart:1 isUpMore:NO];
            }];
            
            //上拉加载更多
            MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                
                if(weakSelf.currentItem == 0){          //交易额
                    [weakSelf loadDataForStart:weakSelf.viewModel.consumeAmountDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
                }else if(weakSelf.currentItem == 1){    //商家数
                    [weakSelf loadDataForStart:weakSelf.viewModel.sellerCountDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
                }else if(weakSelf.currentItem == 2){    //消费者数
                    [weakSelf loadDataForStart:weakSelf.viewModel.endUserCountDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
                }else if(weakSelf.currentItem == 3){    //业务员数
                    [weakSelf loadDataForStart:weakSelf.viewModel.salesmanCountDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
                    
                }
            }];
            [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
            tableView.footer = footer;
        }
        
    }
}



///初始化数据
- (void)initDefaultParam
{
    //交易额
    self.viewModel.consumeAmountParam.areaId = DATAMODEL.userInfoData.agent.areaId;
    //商家数
    self.viewModel.sellerCountParam.areaId = DATAMODEL.userInfoData.agent.areaId;
    //消费者数
    self.viewModel.endUserCountParam.areaId = DATAMODEL.userInfoData.agent.areaId;
    //业务员数
    self.viewModel.salesmanCountParam.areaId = DATAMODEL.userInfoData.agent.areaId;
    
    if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"PROVINCE"]){         //省代理
        [self.areaSegmentView setItem:0 title:DATAMODEL.userInfoData.agent.areaName];
        self.isSelectCity = YES;
        self.cityId = DATAMODEL.userInfoData.agent.areaId;
        self.isJump = YES;
        self.clerkDisplayType = 2;
        
    }
    if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"CITY"]){             //市代理
        [self.areaSegmentView setItem:1 title:DATAMODEL.userInfoData.agent.areaName];
        self.isSelectCounty = YES;
        self.countyId = DATAMODEL.userInfoData.agent.areaId;
        self.isJump = NO;
        self.clerkDisplayType = 2;
    }
    
    if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"COUNTY"]){
        [self.areaSegmentView setItem:2 title:DATAMODEL.userInfoData.agent.areaName];
        self.clerkDisplayType = 3;
    }
}

- (void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    UITableView *tableView = self.tableViewArray[self.currentItem];
    
    
    WEAKSelf;
    if(self.currentItem == 0){              //交易额
        //参数
        self.viewModel.consumeAmountParam.pageNumber = [NSString stringWithFormat:@"%ld",(long)start];
        self.viewModel.consumeAmountParam.userId = DATAMODEL.userInfoData.id;
        self.viewModel.consumeAmountParam.token = DATAMODEL.token;
        
        
        [self.viewModel getConsumeAmountDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            [tableView.header endRefreshing];
            [tableView.footer endRefreshing];
            
            if(isUpMore){
                if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                    [tableView.footer noticeNoMoreData];
                }
            }
            if([code isEqualToString:@"0000"]){
                [tableView reloadData];
                
                if(weakSelf.viewModel.consumeAmountDatas.count > 0){
                    tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                [weakSelf showHint:desc];
            }
        }];
    }else if(self.currentItem == 1){        //商家数
        //参数
        self.viewModel.sellerCountParam.pageNumber = [NSString stringWithFormat:@"%ld",(long)start];
        self.viewModel.sellerCountParam.userId = DATAMODEL.userInfoData.id;
        self.viewModel.sellerCountParam.token = DATAMODEL.token;
        
        [self.viewModel getSellerCountDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            [tableView.header endRefreshing];
            [tableView.footer endRefreshing];
            
            if(isUpMore){
                if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                    [tableView.footer noticeNoMoreData];
                }
            }
            if([code isEqualToString:@"0000"]){
                weakSelf.businessCount = desc;
                
                [tableView reloadData];
                
                if(weakSelf.viewModel.sellerCountDatas.count > 0){
                    tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                [weakSelf showHint:desc];
            }
        }];
    }else if(self.currentItem == 2){        //消费者数
        //参数
        self.viewModel.endUserCountParam.pageNumber = [NSString stringWithFormat:@"%ld",(long)start];
        self.viewModel.endUserCountParam.userId = DATAMODEL.userInfoData.id;
        self.viewModel.endUserCountParam.token = DATAMODEL.token;
        
        [self.viewModel getEndUserCountDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            [tableView.header endRefreshing];
            [tableView.footer endRefreshing];
            
            if(isUpMore){
                if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                    [tableView.footer noticeNoMoreData];
                }
            }
            
            
            if([code isEqualToString:@"0000"]){
                weakSelf.businessCount = desc;
                
                [tableView reloadData];
                
                
                if(weakSelf.viewModel.endUserCountDatas.count > 0){
                    tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                [weakSelf showHint:desc];
            }
        }];
        
    }else if(self.currentItem == 3){        //业务员数
        //参数
        self.viewModel.salesmanCountParam.pageNumber = [NSString stringWithFormat:@"%ld",(long)start];
        self.viewModel.salesmanCountParam.userId = DATAMODEL.userInfoData.id;
        self.viewModel.salesmanCountParam.token = DATAMODEL.token;
        
        [self.viewModel getSalesmanCountDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            [tableView.header endRefreshing];
            [tableView.footer endRefreshing];
            
            if(isUpMore){
                if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                    [tableView.footer noticeNoMoreData];
                }
            }
            
            if([code isEqualToString:@"0000"]){
                weakSelf.businessCount = desc;
                
                [tableView reloadData];
                
                if(weakSelf.viewModel.salesmanCountDatas.count > 0){
                    tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                [weakSelf showHint:desc];
            }
        }];
    }
}

///开始加载数据
-(void)startLoadData
{
    if(self.tableViewArray.count <= 0){
        return;
    }
    
    if(self.currentItem == 0){
        if(self.viewModel.consumeAmountDatas.count <= 0){        //交易额
            [((UITableView*)self.tableViewArray[0]).header beginRefreshing];
        }
    }else if(self.currentItem == 1){
        if(self.viewModel.sellerCountDatas.count <= 0){         //商家数
            [((UITableView*)self.tableViewArray[1]).header beginRefreshing];
        }
    }else if(self.currentItem == 2){
        if(self.viewModel.endUserCountDatas.count <= 0){        //消费者数
            [((UITableView*)self.tableViewArray[2]) reloadData];
//            [((UITableView*)self.tableViewArray[2]).header beginRefreshing];
        }
    }else if(self.currentItem == 3){
        if(self.viewModel.salesmanCountDatas.count <= 0){       //业务员数
            [((UITableView*)self.tableViewArray[3]) reloadData];
//            [((UITableView*)self.tableViewArray[3]).header beginRefreshing];
        }
    }
}



#pragma mark -- action
///筛选 回调
- (void)onFilterAction:(id)sender
{
    if(self.currentItem == 0){
        self.filterBoxView.begDate = self.begDate;
        self.filterBoxView.endDate = self.endDate;
        
        [self.filterBoxView showView];
    }
}




///业务员界面显示 判断



#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   

    if(tableView == self.tableViewArray[0]){            //交易额
        if(indexPath.row == 0){
            GC_TransactionDateTableViewCell *cell = [GC_TransactionDateTableViewCell cellWithTableView:tableView];
            
            [cell updateUiForConsumeAmountData:self.viewModel.consumeAmountDatas[indexPath.section]];
            return cell;
        }else if(indexPath.row == self.viewModel.consumeAmountDatas[indexPath.section].discountAmounts.count + 1){
            GC_AmountBottomTableViewCell *cell = [GC_AmountBottomTableViewCell cellWithTableView:tableView];
            return cell;
        }else{
            GC_JiaoAmountTableViewCell *cell = [GC_JiaoAmountTableViewCell cellWithTableView:tableView];
            [cell updateUiForDiscountAmountsData:self.viewModel.consumeAmountDatas[indexPath.section].discountAmounts[indexPath.row - 1]];
            return cell;
        }
    }else if(tableView == self.tableViewArray[1]){      //商家数
        if(indexPath.row == 0){
            GC_BusinessNumTableViewCell *cell = [GC_BusinessNumTableViewCell cellWithTableView:tableView];
            [cell updateUiForAreaInfo:self.viewModel.sellerCountParam.areaId];
            [cell updateUiForBusinessCount:self.businessCount andType:self.currentItem];
            return cell;
        }else{
            GC_BusinessItemTableViewCell *cell = [GC_BusinessItemTableViewCell cellWithTableView:tableView];
            
            [cell updateUiForSellerCount:self.viewModel.sellerCountDatas[indexPath.row - 1]];
            return cell;
        }
    }else if(tableView == self.tableViewArray[2]){      //消费者数
        if(indexPath.row == 0){
            GC_BusinessNumTableViewCell *cell = [GC_BusinessNumTableViewCell cellWithTableView:tableView];
            [cell updateUiForBusinessCount:@"正在统计中" andType:self.currentItem];
            return cell;
        }else{
            GC_BusinessItemTableViewCell *cell = [GC_BusinessItemTableViewCell cellWithTableView:tableView];
            [cell updateUiForSellerCount:self.viewModel.endUserCountDatas[indexPath.row - 1]];
            return cell;
        }
    }else if(tableView == self.tableViewArray[3]){      //业务员数
        if(indexPath.section == 0){
            GC_BusinessNumTableViewCell *cell = [GC_BusinessNumTableViewCell cellWithTableView:tableView];
            [cell updateUiForBusinessCount:@"正在统计中" andType:self.currentItem];
            return cell;
        }else{
            if(self.clerkDisplayType == 2){         //省、市
                GC_BusinessItemTableViewCell *cell = [GC_BusinessItemTableViewCell cellWithTableView:tableView];
                [cell updateUiForSellerCount:self.viewModel.salesmanCountDatas[indexPath.section - 1]];
                return cell;
            }else if(self.clerkDisplayType == 3){   //区
                GC_ClerkInfoTableViewCell *cell = [GC_ClerkInfoTableViewCell cellWithTableView:tableView];
                [cell updateUiForSalesmanInfoData:self.viewModel.salesmanCountDatas[indexPath.section - 1].list[indexPath.row]];
                return cell;
            }
            
            
        }
    }
    
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if(tableView == self.tableViewArray[0]){        //交易额
        return self.viewModel.consumeAmountDatas.count;
    }else if(tableView == self.tableViewArray[1]){  //商家数
        return 1;
    }else if(tableView == self.tableViewArray[2]){  //消费者数
        return 1;
    }else if(tableView == self.tableViewArray[3]){  //业务员数
        return self.viewModel.salesmanCountDatas.count + 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableViewArray[0]){            //交易额
        return self.viewModel.consumeAmountDatas[section].discountAmounts.count + 2;
    }else if(tableView == self.tableViewArray[1]){      //商家数
        return self.viewModel.sellerCountDatas.count + 1;
    }else if(tableView == self.tableViewArray[2]){      //消费者数
        return self.viewModel.endUserCountDatas.count + 1;
    }else if(tableView == self.tableViewArray[3]){      //业务员数
        if(section == 0){
            return 1;
        }else{
            if(self.clerkDisplayType == 2){
                return 1;
            }else if(self.clerkDisplayType == 3){
                return self.viewModel.salesmanCountDatas[section - 1].list.count;
            }
        }
    }
    return 0;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(34)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableViewArray[0]){
        return HEIGHT_TRANSFORMATION(34);
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
    
    if(tableView == self.tableViewArray[0]){
        
    }else if(tableView == self.tableViewArray[1]){            //商家数
        
        if(indexPath.row != 0){
            if(self.isJump){
                GC_MResBusinessCountDataModel *model = self.viewModel.sellerCountDatas[indexPath.row - 1];
                GC_BusinessCountViewController *bcVC = [[GC_BusinessCountViewController alloc] init];
                bcVC.hidesBottomBarWhenPushed = YES;
                bcVC.businessType = self.currentItem;
                bcVC.areaId = model.id;
                [self.navigationController pushViewController:bcVC animated:YES];
            }
            
        }
        
    }else if(tableView == self.tableViewArray[2]){      //消费者数
        if(indexPath.row != 0){
            if(self.isJump){
                GC_MResBusinessCountDataModel *model = self.viewModel.endUserCountDatas[indexPath.row - 1];
                
                GC_BusinessCountViewController *bcVC = [[GC_BusinessCountViewController alloc] init];
                bcVC.hidesBottomBarWhenPushed = YES;
                bcVC.businessType = self.currentItem;
                bcVC.areaId = model.id;
                [self.navigationController pushViewController:bcVC animated:YES];
            }
        }
        
    }else if(tableView == self.tableViewArray[3]){        //业务员数
        if(indexPath.section != 0){
            GC_SalesmanInfoDataModel *model = self.viewModel.salesmanCountDatas[indexPath.section - 1].list[indexPath.row];
            [DATAMODEL.henUtil customerPhone:model.cellPhoneNum];
            
        }
    }
}


#pragma mark - QL_CustomSegmentDelegate

///类型选择
- (void)customSegmentCurrentItem:(NSInteger)item
{
    
    self.currentItem = item;
    
    if(self.currentItem == 0){
        self.rightBarButon.title = @"筛选";
    }else{
        self.rightBarButon.title = @"";
    }
    
    [self startLoadData];
}



#pragma mark - QL_ListScreenSegmentDelegate
////地区选择
- (void)customScreenSegmentCurrentItem:(NSInteger)item andIsSelect:(BOOL)isSelect
{
    if(!isSelect){      //开启
        self.provinceSelectView.hidden = YES;
        self.citySelectView.hidden = YES;
        self.countySelectView.hidden = YES;
        
        
        if(item == 0){              //省选择
            
        }else if(item == 1){        //市选择
            if(self.isSelectCity){
                [self.citySelectView showViewForSelectId:self.cityId];
            }
        }else if(item == 2){        //区选择
            if(self.isSelectCounty){
                [self.countySelectView showViewForSelectId:self.countyId];
            }
            
            
        }
    }else{              //关闭
        if(item == 0){              //省选择
            
        }else if(item == 1){        //市选择
            if(self.isSelectCity){
                if(self.citySelectView.hidden){
                    [self.citySelectView showViewForSelectId:self.cityId];
                }else{
                    self.citySelectView.hidden = YES;
                }
            }
        }else if(item == 2){        //区选择
            if(self.isSelectCounty){
                if(self.countySelectView.hidden){
                    [self.countySelectView showViewForSelectId:self.countyId];
                }else{
                    self.countySelectView.hidden = YES;
                }
            }
        }
        
    }
}



///加载区数据
- (void)loadCountyDataForAreaId:(NSString *)areaId
{
    
    //获取地区数据
    NSMutableArray<QL_AreaDataModel*>* areaArray = [DATAMODEL.configDBHelper getAreaDatasForParentId:areaId];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    QL_ListSelectViewData *model = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
    model.id = areaId;
    model.name = @"全区";
    [array addObject:model];
    for (QL_AreaDataModel *areaModel in areaArray) {
        QL_ListSelectViewData *selectModel = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
        selectModel.id = areaModel.areaId;
        selectModel.name = areaModel.name;
        [array addObject:selectModel];
    }
    
    [self.countySelectView updateDatas:array];
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
        [self.view addSubview:_scrollView = scrollView];
    }
    return _scrollView;
}


///ViewModel
- (GC_BusinessCenterViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_BusinessCenterViewModel alloc] init];
    }
    return _viewModel;
}




///地区选择View
- (QL_ListScreenSegmentView *)areaSegmentView
{
    if(!_areaSegmentView){
        QL_ListScreenSegmentView *view = [[QL_ListScreenSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(70)];
        view.delegate = self;
        [view setItems:@[@"省", @"市", @"区"]];
        [view setTopLineImageViewHidden:YES];
        [view setBottomLineImageViewHidden:NO];
        [self.view addSubview:_areaSegmentView = view];
    }
    return _areaSegmentView;
}

//选择View
- (QL_CustomSegmentView *)segmentView
{
    if(!_segmentView){
        QL_CustomSegmentView *view = [[QL_CustomSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(70)];
        view.delegate = self;
        if([DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){
            [view setUnLineItems:@[@"交易额",@"商家数",@"消费者数"]];
        }else{
            [view setUnLineItems:@[@"交易额",@"商家数",@"消费者数",@"业务员数"]];
        }
        
        [view setSelectItem:self.currentItem];
        
        [view setScrollView:self.scrollView];
        [self.view addSubview:_segmentView = view];
    }
    return _segmentView;
}

///筛选
- (GC_AmountDateFilterBoxView *)filterBoxView
{
    if(!_filterBoxView){
        _filterBoxView = [[GC_AmountDateFilterBoxView alloc] init];
        
        WEAKSelf;
        _filterBoxView.onFinshBlock = ^(NSString *begDate, NSString *endDate) {
            if(begDate.length > 0 && endDate.length > 0){
                weakSelf.viewModel.consumeAmountParam.startDate = [DATAMODEL.henUtil dateTimeSecondStampToString:[NSString stringWithFormat:@"%@ 00:00:00",begDate]];
                weakSelf.viewModel.consumeAmountParam.endDate = [DATAMODEL.henUtil dateTimeSecondStampToString:[NSString stringWithFormat:@"%@ 00:00:00",endDate]];
            }else{
                weakSelf.viewModel.consumeAmountParam.startDate = @"";
                weakSelf.viewModel.consumeAmountParam.endDate = @"";
            }
            
            
            weakSelf.begDate = begDate;
            weakSelf.endDate = endDate;
            [((UITableView*)weakSelf.tableViewArray[weakSelf.currentItem]).header beginRefreshing];
        };
    }
    return _filterBoxView;
}


///省选择
- (QL_ListSelectView *)provinceSelectView
{
    if(!_provinceSelectView){
        QL_ListSelectView *view = [[QL_ListSelectView alloc] init];
        view.hidden = YES;

        
        [self.view addSubview:_provinceSelectView = view];
    }
    return _provinceSelectView;
}

///市选择
- (QL_ListSelectView *)citySelectView
{
    if(!_citySelectView){
        QL_ListSelectView *view = [[QL_ListSelectView alloc] init];
        view.hidden = YES;
        //回调
        WEAKSelf;
        view.onSelectBlock = ^(QL_ListSelectViewData *model) {
            if(weakSelf.currentItem == 0){          //交易额
                weakSelf.viewModel.consumeAmountParam.areaId = model.id;
            }else if(weakSelf.currentItem == 1){    //商家数
                weakSelf.viewModel.sellerCountParam.areaId = model.id;
            }else if(weakSelf.currentItem == 2){    //消费者数
                weakSelf.viewModel.endUserCountParam.areaId = model.id;
            }else if(weakSelf.currentItem == 3){    //业务员数
                weakSelf.viewModel.salesmanCountParam.areaId = model.id;
            }
            
            [weakSelf.areaSegmentView setItem:2 title:@"区"];
            weakSelf.cityId = model.id;
            if([DATAMODEL.userInfoData.agent.areaId isEqualToString:model.id]){
                weakSelf.isSelectCounty = NO;
                weakSelf.isJump = YES;
            }else{
                weakSelf.isSelectCounty = YES;
                weakSelf.isJump = NO;
            }
            weakSelf.clerkDisplayType = 2;
            [weakSelf.areaSegmentView setItem:1 title:model.name];  //市
            [weakSelf loadCountyDataForAreaId:model.id];
            if(weakSelf.currentItem < 2){
                [((UITableView*)weakSelf.tableViewArray[weakSelf.currentItem]).header beginRefreshing];
            }
            
        };
        
        if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"PROVINCE"]){     //省代理
            
            //获取地区数据
            NSMutableArray<QL_AreaDataModel*>* areaArray = [DATAMODEL.configDBHelper getAreaDatasForParentId:DATAMODEL.userInfoData.agent.areaId];
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            
            QL_ListSelectViewData *model = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
            model.id = DATAMODEL.userInfoData.agent.areaId;
            model.name = @"全市";
            [array addObject:model];
            for (QL_AreaDataModel *areaModel in areaArray) {
                QL_ListSelectViewData *selectModel = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
                selectModel.id = areaModel.areaId;
                selectModel.name = areaModel.name;
                [array addObject:selectModel];
            }
            
            [view updateDatas:array];
        }
        [self.view addSubview:_citySelectView = view];
    }
    return _citySelectView;
}

///区选择
- (QL_ListSelectView *)countySelectView
{
    if(!_countySelectView){
        QL_ListSelectView *view = [[QL_ListSelectView alloc] init];
        view.hidden = YES;
        //回调
        WEAKSelf;
        view.onSelectBlock = ^(QL_ListSelectViewData *model) {
            if(weakSelf.currentItem == 0){          //交易额
                weakSelf.viewModel.consumeAmountParam.areaId = model.id;
            }else if(weakSelf.currentItem == 1){    //商家数
                weakSelf.viewModel.sellerCountParam.areaId = model.id;
            }else if(weakSelf.currentItem == 2){    //消费者数
                weakSelf.viewModel.endUserCountParam.areaId = model.id;
            }else if(weakSelf.currentItem == 3){    //业务员数
                weakSelf.viewModel.salesmanCountParam.areaId = model.id;
            }
            weakSelf.isJump = NO;
            weakSelf.countyId = model.id;
            [weakSelf.areaSegmentView setItem:2 title:model.name];  //区
            if([weakSelf.cityId isEqualToString:weakSelf.countyId]){    //全区
                weakSelf.clerkDisplayType = 2;
            }else{
                weakSelf.clerkDisplayType = 3;
            }
            if(weakSelf.currentItem < 2){
                [((UITableView*)weakSelf.tableViewArray[weakSelf.currentItem]).header beginRefreshing];
            }
        };
        
        if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"CITY"]){     //市代理
            //获取地区数据
            NSMutableArray<QL_AreaDataModel*>* areaArray = [DATAMODEL.configDBHelper getAreaDatasForParentId:DATAMODEL.userInfoData.agent.areaId];
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            QL_ListSelectViewData *model = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
            model.id = DATAMODEL.userInfoData.agent.areaId;
            model.name = @"全区";
            [array addObject:model];
            for (QL_AreaDataModel *areaModel in areaArray) {
                QL_ListSelectViewData *selectModel = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
                selectModel.id = areaModel.areaId;
                selectModel.name = areaModel.name;
                [array addObject:selectModel];
            }
            
            [view updateDatas:array];
        }
        
        [self.view addSubview:_countySelectView = view];
    }
    return _countySelectView;
}
@end
