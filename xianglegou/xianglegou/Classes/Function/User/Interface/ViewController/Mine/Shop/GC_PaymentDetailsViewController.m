//
//  GC_PaymentDetailsViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  货款明细 - 界面
//

#import "GC_PaymentDetailsViewController.h"

#import "GC_PaymentIncomeInfoTableViewCell.h"
#import "GC_PaymentConsumptionInfoTableViewCell.h"
#import "GC_ShopManagetViewModel.h"

@interface GC_PaymentDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>
///TableView
@property (nonatomic, weak) UITableView *tableView;

///View Model
@property (nonatomic, strong) GC_ShopManagetViewModel *viewModel;
@end

@implementation GC_PaymentDetailsViewController

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
    self.navigationItem.title = HenLocalizedString(@"货款明细");
    
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
        [weakSelf loadDataForStart:weakSelf.viewModel.paymentDetailData.orders.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    
    //参数
    //用户ID
    [self.viewModel.paymentDetailParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    
    //用户token
    [self.viewModel.paymentDetailParam setObject:DATAMODEL.token forKey:@"token"];
    
    //分页：页数.
    [self.viewModel.paymentDetailParam setObject:[NSString stringWithFormat:@"%ld", start] forKey:@"pageNumber"];
    
    WEAKSelf;
    [self.viewModel getPaymentDetailDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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
            
//            if(weakSelf.viewModel.paymentDetailData.orders.count > 0){
//                weakSelf.tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
//            }else{
//                weakSelf.tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
//            }
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
    
    if(indexPath.section == 0){
        GC_PaymentIncomeInfoTableViewCell *cell = [GC_PaymentIncomeInfoTableViewCell cellWithTableView:tableView];
        [cell updateUIForPayMentDetailsData:self.viewModel.paymentDetailData];
        return cell;
    }else if(indexPath.section == 1){
        GC_PaymentConsumptionInfoTableViewCell *cell = [GC_PaymentConsumptionInfoTableViewCell cellWithTableView:tableView];
        
        [cell updateUiForPayMentOrdersData:self.viewModel.paymentDetailData.orders[indexPath.row]];
        return cell;
    }
    return nil;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 1){
        return self.viewModel.paymentDetailData.orders.count;
    }
    return 1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return HEIGHT_TRANSFORMATION(12);
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

#pragma mark -- getter,setter
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        tableView.backgroundColor = kCommonBackgroudColor;
        //自适应高度
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(220)];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}


- (GC_ShopManagetViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_ShopManagetViewModel alloc] init];
    }
    return _viewModel;
}

- (void)setEntityId:(NSString *)entityId
{
    _entityId = entityId;
    [self.viewModel.paymentDetailParam setObject:entityId forKey:@"entityId"];
}
@end
