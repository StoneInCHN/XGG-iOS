//
//  GC_BusinessCountViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/7/8.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BusinessCountViewController.h"
#import "GC_BusinessCenterViewModel.h"
#import "GC_BusinessNumTableViewCell.h"
#import "GC_BusinessItemTableViewCell.h"

@interface GC_BusinessCountViewController ()<UITableViewDelegate, UITableViewDataSource>
///TableView
@property (nonatomic, weak) UITableView *tableView;

///ViewModel
@property (nonatomic, strong) GC_BusinessCenterViewModel *viewModel;


@property (nonatomic, strong) NSString *businessCount;
@end

@implementation GC_BusinessCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
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

#pragma mark -- private
///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"营业中心";
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
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
        if(weakSelf.businessType == 1){    //商家数
            [weakSelf loadDataForStart:weakSelf.viewModel.sellerCountDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
        }else if(weakSelf.businessType == 2){    //消费者数
            [weakSelf loadDataForStart:weakSelf.viewModel.endUserCountDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
        }
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}



///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    if(self.businessType == 1){         //商家数
        //参数
        self.viewModel.sellerCountParam.pageNumber = [NSString stringWithFormat:@"%ld",(long)start];
        self.viewModel.sellerCountParam.userId = DATAMODEL.userInfoData.id;
        self.viewModel.sellerCountParam.token = DATAMODEL.token;
        WEAKSelf;
        [self.viewModel getSellerCountDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            [weakSelf.tableView.header endRefreshing];
            [weakSelf.tableView.footer endRefreshing];
            
            if(isUpMore){
                if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                    [weakSelf.tableView.footer noticeNoMoreData];
                }
            }
            if([code isEqualToString:@"0000"]){
                weakSelf.businessCount = desc;
                
                [weakSelf.tableView reloadData];
                
                if(weakSelf.viewModel.sellerCountDatas.count > 0){
                    weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                [weakSelf showHint:desc];
            }
        }];
        
        
    }else if(self.businessType == 2){   //消费者数
        //参数
        self.viewModel.endUserCountParam.pageNumber = [NSString stringWithFormat:@"%ld",(long)start];
        self.viewModel.endUserCountParam.userId = DATAMODEL.userInfoData.id;
        self.viewModel.endUserCountParam.token = DATAMODEL.token;
        WEAKSelf;
        [self.viewModel getEndUserCountDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            [weakSelf.tableView.header endRefreshing];
            [weakSelf.tableView.footer endRefreshing];
            
            if(isUpMore){
                if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                    [weakSelf.tableView.footer noticeNoMoreData];
                }
            }
            
            
            if([code isEqualToString:@"0000"]){
                weakSelf.businessCount = desc;
                
                [weakSelf.tableView reloadData];
                
                
                if(weakSelf.viewModel.endUserCountDatas.count > 0){
                    weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                [weakSelf showHint:desc];
            }
        }];

    }
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.businessType == 1){
        if(indexPath.row == 0){
            GC_BusinessNumTableViewCell *cell = [GC_BusinessNumTableViewCell cellWithTableView:tableView];
            [cell updateUiForAreaInfo:self.viewModel.sellerCountParam.areaId];
            [cell updateUiForBusinessCount:self.businessCount andType:self.businessType];
            return cell;
        }else{
            GC_BusinessItemTableViewCell *cell = [GC_BusinessItemTableViewCell cellWithTableView:tableView];
            
            [cell updateUiForSellerCount:self.viewModel.sellerCountDatas[indexPath.row - 1]];
            return cell;
        }
    }else if(self.businessType == 2){
        if(indexPath.row == 0){
            GC_BusinessNumTableViewCell *cell = [GC_BusinessNumTableViewCell cellWithTableView:tableView];
            [cell updateUiForBusinessCount:self.businessCount andType:self.businessType];
            return cell;
        }else{
            GC_BusinessItemTableViewCell *cell = [GC_BusinessItemTableViewCell cellWithTableView:tableView];
            [cell updateUiForSellerCount:self.viewModel.endUserCountDatas[indexPath.row - 1]];
            return cell;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.businessType == 1){ //商家数
        
        return self.viewModel.sellerCountDatas.count + 1;
    }else if(self.businessType == 2){   //消费者数
        return self.viewModel.endUserCountDatas.count + 1;
    }
    return 0;
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
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kCommonBackgroudColor;
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(100)];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///ViewModel
- (GC_BusinessCenterViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_BusinessCenterViewModel alloc] init];
    }
    return _viewModel;
}

- (void)setAreaId:(NSString *)areaId
{
    _areaId = areaId;
    
    self.viewModel.sellerCountParam.areaId = areaId;
    self.viewModel.endUserCountParam.areaId = areaId;
}

@end
