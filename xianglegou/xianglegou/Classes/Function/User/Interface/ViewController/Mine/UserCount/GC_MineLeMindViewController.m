//
//  GC_MineLeMindViewController.m
//  Rebate
//
//  Created by mini3 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  乐心 界面
//

#import "GC_MineLeMindViewController.h"
#import "GC_MineCountSegmentView.h"
#import "GC_MineLeMindListTableViewCell.h"

#import "GC_MineScoreStatisticsViewModel.h"
#import "LZ_TransferViewController.h"

@interface GC_MineLeMindViewController ()<UITableViewDelegate, UITableViewDataSource>

///Segment
@property (nonatomic, weak) GC_MineCountSegmentView *segmentView;

///TableView
@property (nonatomic, weak) UITableView *tableView;

///ViewModel
@property (nonatomic, strong) GC_MineScoreStatisticsViewModel *viewModel;

///转账按钮
@property (nonatomic, strong) UIButton *transferButton;


@end

@implementation GC_MineLeMindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubviewAndConstraints];
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
-(void)loadSubviewAndConstraints
{
    self.navigationItem.title = HenLocalizedString(@"乐心");
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
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
//        make.top.equalTo(self.tableView.mas_bottom);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
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
        [weakSelf loadDataForStart:weakSelf.viewModel.leMindRecDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    [self.viewModel.leMindRecParam setObject:[NSString stringWithFormat:@"%ld", start] forKey:@"pageNumber"];

    
    [self.viewModel.leMindRecParam setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.leMindRecParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //请求
    WEAKSelf;
    [self.viewModel getUserLeMindRecWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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
            
            
            if(weakSelf.viewModel.leMindRecDatas.count > 0){
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
    GC_MineLeMindListTableViewCell *cell = [GC_MineLeMindListTableViewCell cellWithTableView:tableView];
    
    [cell updateUiForLeMindRecData:self.viewModel.leMindRecDatas[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_MineLeMindListTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.leMindRecDatas.count;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return HEIGHT_TRANSFORMATION(10);
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
}



///乐心转账
-(void)onTransferAction:(UIButton*)sender
{

    LZ_TransferViewController *LZVC = [[LZ_TransferViewController alloc] init];
    LZVC.hidesBottomBarWhenPushed = YES;
    LZVC.transType=@"LE_MIND";
    
    WEAKSelf;
    LZVC.onGoBackSuccess = ^{
        [weakSelf.segmentView setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.totalLeMind showDotNumber:0] index:0];
        [weakSelf.segmentView setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeMind showDotNumber:0] index:1];
        [weakSelf.tableView.header beginRefreshing];
    };
    
    [self.navigationController pushViewController:LZVC animated:YES];
    


}



#pragma mark -- getter,setter
- (GC_MineCountSegmentView *)segmentView
{
    if(!_segmentView){
        GC_MineCountSegmentView *view = [[GC_MineCountSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(130)];
        [view setItems:@[@"累计分红乐心",@"当前乐心"]];
        [view setTopLineImageViewHidden:YES];
//        if(self.totalLeMind.length <= 0 || [self.totalLeMind isEqualToString:@""]){
//            self.totalLeMind = @"0";
//        }
//        if(self.curLeMind.length <= 0 || [self.curLeMind isEqualToString:@""]){
//            self.curLeMind = @"0";
//        }
        [view setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.totalLeMind showDotNumber:0] index:0];
        [view setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeMind showDotNumber:0] index:1];
        [self.view addSubview:_segmentView = view];
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


///转账按钮
- (UIButton *)transferButton
{
    if(!_transferButton){
        _transferButton = [UIButton createButtonWithTitle:HenLocalizedString(@"转账") backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onTransferAction:)];
        _transferButton.titleLabel.font = kFontSize_36;
        [_transferButton setTitleClor:kFontColorWhite];
         [self.view addSubview:_transferButton];
    }
    return _transferButton;
}



///ViewModel
- (GC_MineScoreStatisticsViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_MineScoreStatisticsViewModel alloc] init];
    }
    return _viewModel;
}





@end
