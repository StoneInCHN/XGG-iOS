//
//  GC_MineBankCardViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  我的银行卡 - 界面
//

#import "GC_MineBankCardViewController.h"
#import "GC_AddBankCardViewController.h"

#import "GC_BankCardListTableViewCell.h"
#import "GC_MineItemTableViewCell.h"

#import "GC_BankBindingViewModel.h"
#import "GC_MineViewController.h"


@interface GC_MineBankCardViewController ()<UITableViewDelegate, UITableViewDataSource>

///TableView
@property (nonatomic, weak) UITableView *tableView;
///ViewModel
@property (nonatomic, strong) GC_BankBindingViewModel *viewModel;

@end

@implementation GC_MineBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadNavigationItem];
    
    [self loadSubView];
    
    [self loadTableView];
    [self.tableView.header beginRefreshingForWaitMoment];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([DATAMODEL.interfaceSource isEqualToString:@"2"]){
        [self loadDataForStart:1 isUpMore:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onGoBackClick:(id)sender
{
    //返回
    if([DATAMODEL.interfaceSource isEqualToString:@"1"]){
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:GC_MineViewController.class]){
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
#pragma mark -- private

///加载导航栏信息
-(void)loadNavigationItem{
    self.navigationItem.title = HenLocalizedString(@"我的银行卡");
    self.tableView.backgroundColor = kCommonBackgroudColor;
    
    UIBarButtonItem *rightBar = [UIBarButtonItem createBarButtonItemWithTitle:@"添加" titleColor:kFontColorWhite target:self action:@selector(onAddAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
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
        [weakSelf loadDataForStart:weakSelf.viewModel.myCardListDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    //分页：分页大小.
    [self.viewModel.myCardListParam setObject:[NSString stringWithFormat:@"%ld", start] forKey:@"pageNumber"];
    //登录用户ID
    [self.viewModel.myCardListParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.myCardListParam setObject:DATAMODEL.token forKey:@"token"];

    WEAKSelf;
    //请求
    [self.viewModel getMyCardListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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
            [weakSelf showHint:desc];
        }
    }];
}


///设置默认银行卡
- (void)setUpDefaultCardId:(NSString *)cardId
{
    [self.viewModel.updateCardDefaultParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.updateCardDefaultParam setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.updateCardDefaultParam setObject:cardId forKey:@"entityId"];
    
    
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    [self.viewModel setUpdateCardDefaultDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf.tableView.header beginRefreshing];
        }
        [weakSelf showHint:desc];
    }];
    
}

#pragma mark -- action
///添加
- (void)onAddAction:(id)sender
{
    DATAMODEL.interfaceSource = @"2";
    GC_AddBankCardViewController *abcVC = [[GC_AddBankCardViewController alloc] init];
    abcVC.hidesBottomBarWhenPushed = YES;
    
    if(self.viewModel.myCardListDatas.count == 0){
        abcVC.isDefault = YES;
    }
    [self.navigationController pushViewController:abcVC animated:YES];
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == self.viewModel.myCardListDatas.count){      //添加银行卡
        GC_MineItemTableViewCell *cell = [GC_MineItemTableViewCell cellWithTableView:tableView];
        cell.titleInfo = @"+ 添加银行卡";
        cell.topLongLineImage.hidden = NO;
        cell.bottomLongLineImage.hidden = NO;
        return cell;
    }else{
        GC_BankCardListTableViewCell *cell = [GC_BankCardListTableViewCell cellWithTableView:tableView];
        cell.viewModel = self.viewModel;
        [cell updateUiForMyCardListData:self.viewModel.myCardListDatas[indexPath.section]];
    
        WEAKSelf;
        cell.onDeleteSuccessBlock = ^{      //删除 回调
            [weakSelf.tableView.header beginRefreshing];
        };
    
    
        cell.onSetUpDefault = ^(NSString *entityId, NSInteger item) {
            [weakSelf setUpDefaultCardId:entityId];
        };
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == self.viewModel.myCardListDatas.count){
        return [GC_MineItemTableViewCell getCellHeight];
    }else{
        return [GC_BankCardListTableViewCell getCellHeight];
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.myCardListDatas.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(29);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(indexPath.section == self.viewModel.myCardListDatas.count){
        DATAMODEL.interfaceSource = @"2";
        GC_AddBankCardViewController *abcVC = [[GC_AddBankCardViewController alloc] init];
        abcVC.hidesBottomBarWhenPushed = YES;
        
        if(self.viewModel.myCardListDatas.count == 0){
            abcVC.isDefault = YES;
        }
        
        [self.navigationController pushViewController:abcVC animated:YES];
    }
}


#pragma mark -- getter,setter

- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kCommonBackgroudColor;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}


- (GC_BankBindingViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_BankBindingViewModel alloc] init];
    }
    return _viewModel;
}

@end
