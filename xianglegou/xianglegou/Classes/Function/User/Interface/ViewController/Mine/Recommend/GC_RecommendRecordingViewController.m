//
//  GC_RecommendRecordingViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/6.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  推荐记录 -- 界面
//

#import "GC_RecommendRecordingViewController.h"
#import "GC_RecordingTableViewCell.h"

#import "GC_RecommendViewModel.h"

@interface GC_RecommendRecordingViewController ()<UITableViewDelegate, UITableViewDataSource>

///TableView
@property (nonatomic, weak) UITableView *tableView;

///View Model
@property (nonatomic, strong) GC_RecommendViewModel *viewModel;

@end


@implementation GC_RecommendRecordingViewController

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
    self.navigationItem.title = HenLocalizedString(@"推荐记录");
    self.tableView.backgroundColor = kCommonBackgroudColor;
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
        [weakSelf loadDataForStart:weakSelf.viewModel.recommendRecDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}


///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    [self.viewModel.recommendRecParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.recommendRecParam setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.recommendRecParam setObject:[NSString stringWithFormat:@"%ld", start] forKey:@"pageNumber"];
    
    
    //请求
    WEAKSelf;
    [self.viewModel getRecommendRecDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        
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
            
            
            if(weakSelf.viewModel.recommendRecDatas.count > 0){
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

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GC_RecordingTableViewCell *cell = [GC_RecordingTableViewCell cellWithTableView:tableView];
    
    [cell setUpdateUiForRecommendRecData:self.viewModel.recommendRecDatas[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_RecordingTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.recommendRecDatas.count;
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
}


#pragma mark -- getter,setter
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///View Model
- (GC_RecommendViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_RecommendViewModel alloc] init];
    }
    return _viewModel;
}

@end
