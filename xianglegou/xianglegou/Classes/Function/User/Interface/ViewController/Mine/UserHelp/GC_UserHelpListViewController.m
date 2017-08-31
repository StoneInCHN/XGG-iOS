//
//  GC_UserHelpListViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_UserHelpListViewController.h"

#import "GC_MineItemTableViewCell.h"

#import "GC_UserHelpDetailViewController.h"

#import "GC_UserHelpViewModel.h"

@interface GC_UserHelpListViewController ()

///ViewModel
@property (nonatomic, strong) GC_UserHelpViewModel *viewModel;

///TableVIew
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GC_UserHelpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    [self loadTableview];
    
    [self.tableView.header beginRefreshingForWaitMoment];
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

///加载子视图
-(void)loadSubView
{
    
    self.navigationItem.title = @"用户帮助";
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

///加载列表数据
-(void)loadTableview
{
    WEAKSelf;
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadUserHelpListData];
    }];
}

///加载帮助列表数据
- (void)loadUserHelpListData
{
    WEAKSelf;
    [self.viewModel getUserHelpListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        if([code isEqualToString:@"0000"]){
            [weakSelf.tableView reloadData];
            
            
            if(weakSelf.viewModel.userHelpListDatas.count > 0){
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
    GC_MineItemTableViewCell *cell = [GC_MineItemTableViewCell cellWithTableView:tableView];
    
    cell.titleInfo = self.viewModel.userHelpListDatas[indexPath.row].title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_MineItemTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.userHelpListDatas.count;
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
    
    
    GC_UserHelpDetailViewController *ucDVC = [[GC_UserHelpDetailViewController alloc] init];
    ucDVC.hidesBottomBarWhenPushed = YES;
    
    ucDVC.titleInfo = self.viewModel.userHelpListDatas[indexPath.row].title;
    ucDVC.entityId = self.viewModel.userHelpListDatas[indexPath.row].id;
    
    [self.navigationController pushViewController:ucDVC animated:YES];
}



#pragma mark -- getter,setter
- (GC_UserHelpViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_UserHelpViewModel alloc] init];
    }
    return _viewModel;
}

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
@end
