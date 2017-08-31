//
//  QL_MineCollectionViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 我的收藏界面
//

#import "QL_MineCollectionViewController.h"
#import "QL_HPBusinessListTableViewCell.h"
#import "QL_BusinessDetailsViewController.h"

#import "GC_CollectionViewModel.h"

@interface QL_MineCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;

///ViewModel
@property (nonatomic, strong) GC_CollectionViewModel *viewModel;
@end

@implementation QL_MineCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    
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
    self.navigationItem.title = HenLocalizedString(@"我的收藏");
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    //下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf loadDataForStart:1 isUpMore:NO];
    }];
    //上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataForStart:weakSelf.viewModel.collectionDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    
    ///参数
    self.viewModel.collectionParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.collectionParam.token = DATAMODEL.token;
    self.viewModel.collectionParam.latitude = DATAMODEL.latitude;
    self.viewModel.collectionParam.longitude = DATAMODEL.longitude;
    self.viewModel.collectionParam.pageNumber = [NSString stringWithFormat:@"%ld",start];
    
    WEAKSelf;
    //请求
    [self.viewModel getFavoriteSellerListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        ///取消请求
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        
        if(isUpMore){
            if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                [weakSelf.tableView.footer noticeNoMoreData];
            }
        }
        
        if([code isEqualToString:@"0000"]){
            [weakSelf.tableView reloadData];
            
            if(weakSelf.viewModel.collectionDatas.count > 0){
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

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QL_BusinessDetailsViewController *bdVC = [[QL_BusinessDetailsViewController alloc] init];
    bdVC.hidesBottomBarWhenPushed = YES;
    
    
    bdVC.sellerId = self.viewModel.collectionDatas[indexPath.row].id;
    
    [self.navigationController pushViewController:bdVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.collectionDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QL_HPBusinessListTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_HPBusinessListTableViewCell *cell = [QL_HPBusinessListTableViewCell cellWithTableView:tableView];
    
    //分界线
    cell.topLongLineImage.hidden = NO;
    if(indexPath.row == 0){
        cell.topLongLineImage.hidden = YES;
    }
    
    [cell setUpdateUiForCollectionListData:self.viewModel.collectionDatas[indexPath.row]];
    
    return cell;
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

///View Model
- (GC_CollectionViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_CollectionViewModel alloc] init];
    }
    return _viewModel;
}
@end
