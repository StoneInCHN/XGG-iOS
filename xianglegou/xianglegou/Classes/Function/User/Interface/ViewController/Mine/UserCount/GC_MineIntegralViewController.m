//
//  GC_MineIntegralViewController.m
//  Rebate
//
//  Created by mini3 on 17/3/29.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  我的积分 -- 界面
//

#import "GC_MineIntegralViewController.h"
#import "GC_MineCountSegmentView.h"

#import "GC_MineIntegralListTableViewCell.h"

#import "GC_MineScoreStatisticsViewModel.h"

@interface GC_MineIntegralViewController ()<UITableViewDelegate, UITableViewDataSource>

///SegMentView
@property (nonatomic, weak) GC_MineCountSegmentView *segmentView;

///TableView
@property (nonatomic, weak) UITableView *tableView;


///View Model
@property (nonatomic, strong) GC_MineScoreStatisticsViewModel *viewModel;

///乐分 积分d大小
@property (nonatomic, strong) NSString *scoreNum;
@end

@implementation GC_MineIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubviewConstraints];
    
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
///加载子视图及其约束
- (void)loadSubviewConstraints
{
    
    self.navigationItem.title = HenLocalizedString(@"积分");
    self.view.backgroundColor = kCommonBackgroudColor;
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(130));
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
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
        [weakSelf loadDataForStart:weakSelf.viewModel.scoreRecDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    [self.viewModel.scoreRecParam setObject:[NSString stringWithFormat:@"%ld", start] forKey:@"pageNumber"];
    
    [self.viewModel.scoreRecParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.scoreRecParam setObject:DATAMODEL.token forKey:@"token"];
    //请求
    WEAKSelf;
    [self.viewModel getUsetScoreRecWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        
        if(isUpMore){
            if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                [weakSelf.tableView.footer noticeNoMoreData];
            }
        }
        
        if([code isEqualToString:@"0000"]){
            weakSelf.scoreNum = desc;
            
            [weakSelf.tableView reloadData];
            
            if(weakSelf.viewModel.scoreRecDatas.count > 0){
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
    GC_MineIntegralListTableViewCell *cell = [GC_MineIntegralListTableViewCell cellWithTableView:tableView];
    [cell updateUiForScoreRecData:self.viewModel.scoreRecDatas[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_MineIntegralListTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.scoreRecDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if(self.scoreNum.length <= 0){
            self.scoreNum = @"300";
        }
        return [self tableViewHeaderViewForTitle:[NSString stringWithFormat:@"注：满%@自动转化为1乐心。",self.scoreNum]];
    }
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return HEIGHT_TRANSFORMATION(50);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(10);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark -- getter,setter
- (GC_MineCountSegmentView *)segmentView
{
    if(!_segmentView){
        GC_MineCountSegmentView *segment = [[GC_MineCountSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(130)];
        [segment setItems:@[@"累计积分",@"当前积分"]];
        [segment setTopLineImageViewHidden:YES];
        if(self.totalScore.length <= 0 || [self.totalScore isEqualToString:@"0"]){
            self.totalScore = @"0";
        }
        if(self.curScore.length <= 0 || [self.curScore isEqualToString:@""]){
            self.curScore = @"0";
        }
        [segment setItemCount:[DATAMODEL.henUtil string:self.totalScore showDotNumber:4] index:0];
        [segment setItemCount:[DATAMODEL.henUtil string:self.curScore showDotNumber:4] index:1];
        [self.view addSubview:_segmentView = segment];
    }
    return _segmentView;
}

///TableView
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        ///tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

-(UIView*)tableViewHeaderViewForTitle:(NSString*)title
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(50)) backgroundColor:kCommonBackgroudColor];
    
    
    UILabel *titleLabel = [UILabel createLabelWithText:HenLocalizedString(title) font:kFontSize_24 textColor:kFontColorGray];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(OffSetToLeft);
        make.centerY.equalTo(view);
        
    }];
    
    return view;
}

///View Model
- (GC_MineScoreStatisticsViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_MineScoreStatisticsViewModel alloc] init];
    }
    return _viewModel;
}
@end
