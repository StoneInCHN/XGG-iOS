//
//  QL_AllCommentViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_AllCommentViewController.h"
#import "QL_BDCommentStatisticsView.h"
#import "QL_BDCommentTableViewCell.h"
#import "QL_BusinessDetailsViewModel.h"

@interface QL_AllCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;
///评论统计view
@property(nonatomic, weak) QL_BDCommentStatisticsView *commentStatisticsView;

///view model
@property(nonatomic, strong) QL_BusinessDetailsViewModel *viewModel;

@end

@implementation QL_AllCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
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
- (void)cleanUpData
{
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"全部评价";
    [self commentStatisticsView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.commentStatisticsView.mas_bottom);
    }];
    //下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf loadDataForStart:1 isUpMore:NO];
    }];
    //上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataForStart:weakSelf.viewModel.commentListDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    self.viewModel.commentListParam.pageNumber = [NSString stringWithFormat:@"%ld", (long)start];
    WEAKSelf;
    //请求
    [self.viewModel getCommentListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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
            
            weakSelf.commentStatisticsView.commentTotal = page;
            
            if(weakSelf.viewModel.commentListDatas.count > 0){
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.commentListDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    QL_BDCommentTableViewCell *cell = [QL_BDCommentTableViewCell cellWithTableView:tableView];
    
    [cell updateUIForData:self.viewModel.commentListDatas[indexPath.section]];
    
    //分界线
    cell.topLongLineImage.hidden = NO;
    if(indexPath.section == 0){
        cell.topLongLineImage.hidden = YES;
    }
    
    return cell;
}

#pragma mark -- getter,setter

///内容
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(100)];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///评论统计view
- (QL_BDCommentStatisticsView *)commentStatisticsView
{
    if(!_commentStatisticsView){
        QL_BDCommentStatisticsView *view = [[QL_BDCommentStatisticsView alloc] init];
        [view hiddenNextImage];
        [self.view addSubview:_commentStatisticsView = view];
    }
    return _commentStatisticsView;
}

///view model
- (QL_BusinessDetailsViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_BusinessDetailsViewModel alloc] init];
    }
    return _viewModel;
}

///设置商家id
- (void)setSellerId:(NSString *)sellerId
{
    self.viewModel.commentListParam.sellerId = sellerId;
}

///设置评分
- (void)setCommentScore:(NSString *)commentScore
{
    self.commentStatisticsView.starScore = commentScore;
}

@end
