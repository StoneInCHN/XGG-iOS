//
//  GC_ShopLoanViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  店铺货款代码 - 界面
//

#import "GC_ShopMoneyViewController.h"

#import "GC_PaymentDetailsViewController.h"
#import "GC_SettingConfigViewController.h"
#import "QL_MineShopViewController.h"

#import "GC_ShopMoneyTableViewCell.h"
#import "GC_MineCountSegmentView.h"

#import "GC_ShopManagetViewModel.h"
#import "GC_PaymentFilterView.h"


@interface GC_ShopMoneyViewController ()<UITableViewDelegate, UITableViewDataSource>
///TableView
@property (nonatomic, weak) UITableView *tableView;

///View Model
@property (nonatomic, strong) GC_ShopManagetViewModel *viewModel;


///消费总额显示
@property(nonatomic, weak) GC_MineCountSegmentView *segmentView;

///结算货款说明
@property (nonatomic, weak) UIView *explainView;


///筛选 View
@property (nonatomic, strong) GC_PaymentFilterView *filterBoxView;

@end

@implementation GC_ShopMoneyViewController

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


- (void)onGoBackClick:(id)sender
{
    if([DATAMODEL.interfaceSource isEqualToString:@"5"]){ //店铺货款
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:QL_MineShopViewController.class]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma mark -- action
///说明
- (void)onExplainAction:(id)sender
{
    GC_SettingConfigViewController *scVC = [[GC_SettingConfigViewController alloc] init];
    scVC.hidesBottomBarWhenPushed = YES;
    scVC.titleInfo = @"店铺货款";
    scVC.configKey = @"SELLER_PAYMENT_DESC";
    
    [self.navigationController pushViewController:scVC animated:YES];
}
///筛选
- (void)onPayFilterAction:(id)sender
{
    [self.filterBoxView showView];
    
    
    WEAKSelf;
    self.filterBoxView.onFinshBlock = ^(NSString *item) {
    
        if(item.length <= 0){
            weakSelf.viewModel.paymentListParam.startTime = @"";
            weakSelf.viewModel.paymentListParam.endTime = @"";
        }else if([item isEqualToString:@"0"]){
            NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",[DATAMODEL.henUtil getSystemDate]];
            
            NSString *endTime = [NSString stringWithFormat:@"%@ 23:59:59",[DATAMODEL.henUtil getSystemDate]];
            
            weakSelf.viewModel.paymentListParam.startTime = [DATAMODEL.henUtil dateTimeSecondStampToString:startTime];
            
            weakSelf.viewModel.paymentListParam.endTime = [DATAMODEL.henUtil dateTimeSecondStampToString:endTime];
            
        }else if([item isEqualToString:@"3"]){
            NSDate *curreateDate = [weakSelf datejishuangTime:0 Month:0 Day:-2 Hour:0 withData:[DATAMODEL.henUtil dateStringToDate:[DATAMODEL.henUtil getSystemDate]]];
            
            
            
            NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",[DATAMODEL.henUtil dateToString:curreateDate]];
            
            NSString *endTime = [NSString stringWithFormat:@"%@ 23:59:59",[DATAMODEL.henUtil getSystemDate]];
            
            weakSelf.viewModel.paymentListParam.startTime = [DATAMODEL.henUtil dateTimeSecondStampToString:startTime];
            
            weakSelf.viewModel.paymentListParam.endTime = [DATAMODEL.henUtil dateTimeSecondStampToString:endTime];
            
            
        }else if([item isEqualToString:@"7"]){
            NSDate *curreateDate = [weakSelf datejishuangTime:0 Month:0 Day:-6 Hour:0 withData:[DATAMODEL.henUtil dateStringToDate:[DATAMODEL.henUtil getSystemDate]]];
            
            
            
            NSString *startTime = [NSString stringWithFormat:@"%@ 00:00:00",[DATAMODEL.henUtil dateToString:curreateDate]];
            
            NSString *endTime = [NSString stringWithFormat:@"%@ 23:59:59",[DATAMODEL.henUtil getSystemDate]];
            
            weakSelf.viewModel.paymentListParam.startTime = [DATAMODEL.henUtil dateTimeSecondStampToString:startTime];
            
            weakSelf.viewModel.paymentListParam.endTime = [DATAMODEL.henUtil dateTimeSecondStampToString:endTime];
        }
    
        [weakSelf.tableView.header beginRefreshing];
    };
}

#pragma mark -- private

-(NSDate *)datejishuangTime:(int)year Month:(int)month Day:(int)day Hour:(int)hour withData:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //NSCalendarIdentifierGregorian:iOS8之前用NSGregorianCalendar
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    //NSCalendarUnitYear:iOS8之前用NSYearCalendarUnit,NSCalendarUnitMonth,NSCalendarUnitDay同理
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:year];
    
    [adcomps setMonth:month];
    
    [adcomps setDay:day];
    
    [adcomps setHour:hour];
    
    return [calendar dateByAddingComponents:adcomps toDate:date options:0];
}





///加载导航栏信息
-(void)loadNavigationItem{
    self.navigationItem.title = HenLocalizedString(@"店铺货款");
    
    UIBarButtonItem *rightBar = [UIBarButtonItem createBarButtonItemWithTitle:@"筛选" titleColor:kFontColorWhite target:self action:@selector(onPayFilterAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

///加载子视图
-(void)loadSubView
{
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(130));
    }];
    
    
    
    [self.explainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(71));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.explainView.mas_bottom);
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
        [weakSelf loadDataForStart:weakSelf.viewModel.paymentListDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}


///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    
    //参数

    //用户ID
    self.viewModel.paymentListParam.userId = DATAMODEL.userInfoData.id;
    //用户token
    self.viewModel.paymentListParam.token = DATAMODEL.token;
    ///分页：页数
    self.viewModel.paymentListParam.pageNumber = [NSString stringWithFormat:@"%ld", start];
    
    WEAKSelf;
    [self.viewModel getPaymentListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        
        if(isUpMore){
            if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                [weakSelf.tableView.footer noticeNoMoreData];
            }
        }
        
        if([code isEqualToString:@"0000"]){
            
            NSString *priceStr = desc;
            
            NSArray *array = [priceStr componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
            
            if(array.count > 1){
                [weakSelf.segmentView setItemCount:array[0] index:0];
                [weakSelf.segmentView setItemCount:array[1] index:1];
            }
            
            [weakSelf.tableView reloadData];
            
            
            if(weakSelf.viewModel.paymentListDatas.count > 0){
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
    GC_ShopMoneyTableViewCell *cell = [GC_ShopMoneyTableViewCell cellWithTableView:tableView];
    
    [cell updateUIForPatMentListData:self.viewModel.paymentListDatas[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_ShopMoneyTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.paymentListDatas.count;
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
    GC_PaymentDetailsViewController *pdVC = [[GC_PaymentDetailsViewController alloc] init];
    pdVC.hidesBottomBarWhenPushed = YES;
    
    pdVC.entityId = self.viewModel.paymentListDatas[indexPath.row].id;
    [self.navigationController pushViewController:pdVC animated:YES];
}



#pragma mark -- getter,setter
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        tableView.backgroundColor = kCommonBackgroudColor;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}


///View Model
- (GC_ShopManagetViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_ShopManagetViewModel alloc] init];
    }
    return _viewModel;
}

- (UIView *)explainView
{
    if(!_explainView){
        UIView *view = [UIView createViewWithBackgroundColor:kCommonBackgroudColor];
        [self.view addSubview:_explainView = view];
        
        UILabel *label = [UILabel createLabelWithText:@"货款结算说明" font:kFontSize_26 textColor:kFontColorRed];
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(OffSetToLeft);
            make.centerY.equalTo(view);
        }];
        
        
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onExplainAction:)];
        [view addGestureRecognizer:labelTapGestureRecognizer];
        
        
    }
    return _explainView;
}

///选择
- (GC_MineCountSegmentView *)segmentView
{
    if(!_segmentView){
        GC_MineCountSegmentView *view = [[GC_MineCountSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(130)];
        view.lineMargin = 35;
        
        [view setItems:@[@"消费总额(元)",@"结算金额(元)"]];
        [view setItemCount:@"0.0000" index:0];
        [view setItemCount:@"0.0000" index:1];
        [view setTopLineImageViewHidden:YES];
        [view setBottomLineImageViewHidden:NO];
        
        [self.view addSubview:_segmentView = view];
    }
    return _segmentView;
}


- (GC_PaymentFilterView *)filterBoxView
{
    if(!_filterBoxView){
        _filterBoxView = [[GC_PaymentFilterView alloc] init];
    }
    return _filterBoxView;
}
@end
