//
//  GC_RecommendedBusinessViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  推荐商家 - 界面
//

#import "GC_RecommendedBusinessViewController.h"
#import "QL_SettledShopViewController.h"

#import "GC_RecommendedBusinessTableViewCell.h"
#import "GC_RecommendViewModel.h"



@interface GC_RecommendedBusinessViewController ()<UITableViewDelegate, UITableViewDataSource>

///TableView
@property (nonatomic, weak) UITableView *tableView;

///ViewModel
@property (nonatomic, strong) GC_RecommendViewModel *viewModel;
@end

@implementation GC_RecommendedBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNavigationItem];
    [self loadSubView];
    
    [self loadTableView];
    [self.tableView.header beginRefreshingForWaitMoment];
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
    
    self.navigationItem.title = HenLocalizedString(@"推荐商家");
    self.tableView.backgroundColor = kCommonBackgroudColor;
   
    if([DATAMODEL.userInfoData.isSalesmanApply isEqualToString:@"1"]){  //具有上传功能
        UIBarButtonItem *rightBar = [UIBarButtonItem createBarButtonItemWithTitle:@"新增" titleColor:kFontColorWhite target:self action:@selector(onAddAction:)];
        
        self.navigationItem.rightBarButtonItem = rightBar;
    }
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
        [weakSelf loadDataForStart:1 isUpMore:NO];
    }];
    
    //上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataForStart:weakSelf.viewModel.recommendSellerDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    [self.viewModel.recommendSellerParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.recommendSellerParam setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.recommendSellerParam setObject:[NSString stringWithFormat:@"%ld", start] forKey:@"pageNumber"];

    
    //请求
    WEAKSelf;
    [self.viewModel getRecommendSellerRecDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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
            
            if(weakSelf.viewModel.recommendSellerDatas.count > 0){
                weakSelf.tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
            }else{
                weakSelf.tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
            }
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
    
}




#pragma mark -- action
///新增
- (void)onAddAction:(id)sender
{
    ///新增店铺界面
    QL_SettledShopViewController *ssVC = [[QL_SettledShopViewController alloc] init];
    ssVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ssVC animated:YES];
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GC_RecommendedBusinessTableViewCell *cell = [GC_RecommendedBusinessTableViewCell cellWithTableView:tableView];
    if(indexPath.row == 0){
        cell.topLongLineImage.hidden = NO;
    }
    cell.bottomLongLineImage.hidden = NO;
    [cell setUpdateUiForRecommendSellerRecData:self.viewModel.recommendSellerDatas[indexPath.row]];
    
    if([self.viewModel.recommendSellerDatas[indexPath.row].sellerApplication.applyStatus isEqualToString:@"AUDIT_PASSED"]){     //审核通过
        [cell unShowClickEffect];
    }else{
        [cell showClickEffect];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_RecommendedBusinessTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.recommendSellerDatas.count;
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
    
    GC_MResRecommendSellerDataModel *model = self.viewModel.recommendSellerDatas[indexPath.row];
    
    if([model.sellerApplication.applyStatus isEqualToString:@"AUDIT_WAITING"]){         //待审核
        QL_SettledShopViewController *ssVC = [[QL_SettledShopViewController alloc] init];
        ssVC.hidesBottomBarWhenPushed = YES;
        ssVC.isAuditing = YES;
        [self.navigationController pushViewController:ssVC animated:YES];
        
    }else if([model.sellerApplication.applyStatus isEqualToString:@"AUDIT_FAILED"]){    //审核退回
        QL_SettledShopViewController *ssVC = [[QL_SettledShopViewController alloc] init];
        ssVC.hidesBottomBarWhenPushed = YES;
        ssVC.isAuditeFail = YES;
        ssVC.failureReason = model.sellerApplication.notes;
        ssVC.shopMobile = model.sellerApplication.contactCellPhone;
        ssVC.shopId = model.sellerApplication.id;
        [self.navigationController pushViewController:ssVC animated:YES];
    }
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
- (GC_RecommendViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_RecommendViewModel alloc] init];
    }
    return _viewModel;
}

@end
