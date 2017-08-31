//
//  GC_NoticeListViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/7.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  通知消息 -- 界面
//

#import "GC_NoticeListViewController.h"
#import "GC_NoticeListTableViewCell.h"
#import "GC_DetailsViewController.h"

#import "GC_NoticeMsgViewModel.h"

@interface GC_NoticeListViewController ()

///ViewModel
@property (nonatomic, strong) GC_NoticeMsgViewModel *viewModel;
@end

@implementation GC_NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNavigationBar];
    [self loadTableView];
    
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

///加载导航栏信息
-(void)loadNavigationBar
{
    self.navigationItem.title = HenLocalizedString(@"通知");
    self.tableView.backgroundColor = kCommonBackgroudColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

///加载列表数据
-(void)loadTableView
{
    //下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf loadDataForStart:1 isUpMore:NO];
    }];
    //上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataForStart:weakSelf.viewModel.noticeMsgDatas.count / [NumberOfPages integerValue] + 1  isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    [self.viewModel.noticeMsgParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.noticeMsgParam setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.noticeMsgParam setObject:[NSString stringWithFormat:@"%ld",start] forKey:@"pageNumber"];
    
    WEAKSelf;
    //请求
    [self.viewModel getNoticesMsgDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

///阅读消息
- (void)loadReadMessageData:(NSString*)msgId
{
    //参数
    [self.viewModel.readMessageParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.readMessageParam setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.readMessageParam setObject:msgId forKey:@"msgId"];
    
    WEAKSelf;
    //请求
    [self.viewModel setReadMessageDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        ///取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf showHint:desc];
        }
    }];
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GC_NoticeListTableViewCell *cell = [GC_NoticeListTableViewCell cellWithTableView:tableView];
    cell.bottomLongLineImage.hidden = NO;
    if(indexPath.row == 0){
        cell.topLongLineImage.hidden = NO;
    }
    
    [cell setUpdateUiForNoticesMsgData:self.viewModel.noticeMsgDatas[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_NoticeListTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.noticeMsgDatas.count;
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
    
    
    GC_DetailsViewController *dVC = [[GC_DetailsViewController alloc] init];
    
    dVC.noticeData = self.viewModel.noticeMsgDatas[indexPath.row];
    [self loadReadMessageData:self.viewModel.noticeMsgDatas[indexPath.row].id];
    self.viewModel.noticeMsgDatas[indexPath.row].isRead = @"1";
    
    [self.navigationController pushViewController:dVC animated:YES];
}


#pragma mark -- getter,setter
///ViewModel
- (GC_NoticeMsgViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_NoticeMsgViewModel alloc] init];
    }
    return _viewModel;
}
@end
