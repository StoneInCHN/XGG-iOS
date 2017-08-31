//
//  QL_SearchHistoryViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/31.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_SearchHistoryViewController.h"
#import "QL_BusinessModel.h"
#import "GC_CustomNavigationBarSearchView.h"
#import "QL_SearchHistoryTableViewCell.h"

#import "QL_BusinessListViewController.h"

@interface QL_SearchHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) UITableView *tableView;

///搜索条
@property (nonatomic, strong) GC_CustomNavigationBarSearchView *searchView;

///清除按钮
@property(nonatomic, weak) UIButton *cleanHistoryButton;

///搜索历史
@property(nonatomic, strong) NSMutableArray<QL_SearchHistoryDataModel *> *searchHistoryDatas;

@end

@implementation QL_SearchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNavigationBar];
    
    //获取历史
    [self.searchHistoryDatas removeAllObjects];
    [self.searchHistoryDatas addObjectsFromArray:[DATAMODEL.userDBHelper getSearchHistory]];
    [self.tableView reloadData];
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
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    [self.searchView removeFromSuperview];
    [self setSearchView:nil];
}

#pragma mark -- private

///加载导航条
-(void)loadNavigationBar
{
    [self.searchView setEjectKeyboard];
    self.navigationItem.titleView = self.searchView;
}

- (void)loadSubView
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.cleanHistoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(-100));
    }];
}

///搜索 调用
-(void)onStartSearchContent:(NSString *)searchString
{
    QL_BusinessListViewController *blVC = [[QL_BusinessListViewController alloc] init];
    blVC.hidesBottomBarWhenPushed = YES;
    blVC.searchContent = searchString;
        
    [self.navigationController pushViewController:blVC animated:YES];
    
    //保存
    [DATAMODEL.userDBHelper insertSearchHistoryContent:searchString time:[DATAMODEL.henUtil getSystemDate]];
}

///搜索 占位符 和 颜色
-(void)setSearchPlaceholder:(NSString*)placeholder fontColor:(UIColor*)color
{
    [self.searchView setPlaceholder:placeholder color:color];
}

#pragma mark -- event response

- (void)onCleanHistoryAction:(id)sender
{
    //清除历史记录
    [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要清除搜索记录吗？"];
    //回调
    WEAKSelf;
    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            [weakSelf.searchHistoryDatas removeAllObjects];
            [weakSelf.tableView reloadData];
            
            [DATAMODEL.userDBHelper deleteSearchHistory];
        }
    }];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QL_SearchHistoryDataModel *model = self.searchHistoryDatas[indexPath.row];
    [self onStartSearchContent:model.content];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchHistoryDatas.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchHistoryDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_TRANSFORMATION(110);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(64);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self historyTableTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_SearchHistoryTableViewCell *cell = [QL_SearchHistoryTableViewCell cellWithTableView:tableView];
    
    QL_SearchHistoryDataModel *model = self.searchHistoryDatas[indexPath.row];
    cell.content = model.content;
    cell.time = model.time;
    
    return cell;
}

#pragma mark -- getter,setter

- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.backgroundColor = kCommonBackgroudColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///清除按钮
- (UIButton *)cleanHistoryButton
{
    if(!_cleanHistoryButton){
        UIButton *button = [UIButton createButtonWithTitle:@"清除历史记录" backgroundNormalImage:@"public_botton_remind_botton_ok" backgroundPressImage:@"public_botton_remind_botton_ok_press" target:self action:@selector(onCleanHistoryAction:)];
        [button setTitleClor:kFontColorRed];
        [self.view addSubview:_cleanHistoryButton = button];
    }
    return _cleanHistoryButton;
}

- (GC_CustomNavigationBarSearchView *)searchView
{
    if(!_searchView){
        _searchView = [[GC_CustomNavigationBarSearchView alloc] init];
        [_searchView setSearchContentTextColor:kFontColorWhite];
        [_searchView setPlaceholder:@"搜索" color:kFontColorWhite];
        //回调
        WEAKSelf;
        _searchView.onStartSearchBlock = ^(NSString *searchString){
            [weakSelf onStartSearchContent:searchString];
        };
    }
    return _searchView;
}

///搜索历史
- (NSMutableArray<QL_SearchHistoryDataModel *> *)searchHistoryDatas
{
    if(!_searchHistoryDatas){
        _searchHistoryDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _searchHistoryDatas;
}

///表单标题
- (UIView *)historyTableTitle
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(64)) backgroundColor:kCommonBackgroudColor];
    
    UILabel *label = [UILabel createLabelWithText:@"搜索记录" font:kFontSize_24 textColor:kFontColorGray];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(OffSetToLeft);
    }];
    
    return view;
}

@end
