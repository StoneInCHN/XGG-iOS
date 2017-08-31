//
//  QL_BusinessListViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BusinessListViewController.h"
#import "QL_ListScreenSegmentView.h"
#import "QL_HPBusinessListTableViewCell.h"
#import "QL_ListSelectView.h"
#import "QL_SettledShopViewModel.h"

#import "QL_BusinessDetailsViewController.h"
#import "QL_SearchHistoryViewController.h"

@interface QL_BusinessListViewController ()<QL_ListScreenSegmentDelegate, UITableViewDelegate, UITableViewDataSource>

//选择view
@property(nonatomic, weak) QL_ListScreenSegmentView *segmentView;
///内容
@property(nonatomic, weak) UITableView *tableView;
///地区选择
@property(nonatomic, weak) QL_ListSelectView *areaSelectView;
///分类选择
@property(nonatomic, weak) QL_ListSelectView *classSelectView;
///排序选择
@property(nonatomic, weak) QL_ListSelectView *sortSelectView;
///筛选选择
@property(nonatomic, weak) QL_ListScreenSelectView *screenSelectView;

@end

@implementation QL_BusinessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    [self loadNavigationBar];
    [self loadClassifyData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (void)onGoBackClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- private

///加载导航栏
-(void)loadNavigationBar
{
    UIButton *button = [UIButton createButtonWithTitle:@"" backgroundNormalImage:@"public_icon_search_bg1" backgroundPressImage:@"public_icon_search_bg1" target:self action:@selector(onSearchClickAction)];
    button.frame = CGRectMake(0, 0, WIDTH_TRANSFORMATION(533), 32);
    [button setTitleClor:kFontColorWhite];
    button.titleLabel.font = kFontSize_26;
    
    [button setImage:[UIImage imageNamed:@"public_icon_search1"] forState:UIControlStateNormal];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [button setTitle:self.searchContent.length > 0 ? self.searchContent : @"搜索" forState:UIControlStateNormal];
    //button标题的偏移量，这个偏移量是相对于图片的
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
    self.navigationItem.titleView = button;
}

///加载子视图
- (void)loadSubView
{
    self.viewModel.businessListParam.sortType = @"DISTANCEASC";
    
    [self segmentView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.segmentView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    //下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf loadDataForStart:1 isUpMore:NO];
    }];
    //上拉加载更多
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDataForStart:weakSelf.viewModel.businessListDatas.count / [NumberOfPages integerValue] + 1  isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    self.viewModel.businessListParam.pageNumber = [NSString stringWithFormat:@"%ld", (long)start];
    WEAKSelf;
    //请求
    [self.viewModel getBusinessListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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
            
            if(weakSelf.viewModel.businessListDatas.count > 0){
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

///加载分类数据
- (void)loadClassifyData
{
    WEAKSelf;
    QL_SettledShopViewModel *ssViewModel = [[QL_SettledShopViewModel alloc] init];
    [ssViewModel getSellerCategoryWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            QL_ListSelectViewData *model = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
            model.id = @"";
            model.name = @"不限";
            for(QL_SellerCategoryDataModel *model in msg){
                QL_ListSelectViewData *selectModel = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
                selectModel.id = model.id;
                selectModel.name = model.categoryName;
                [array addObject:selectModel];
            }
            [weakSelf.classSelectView updateDatas:array];
        }
    }];
}

#pragma mark -- event response

///点击搜索
-(void)onSearchClickAction
{
    QL_SearchHistoryViewController *alVC = [[QL_SearchHistoryViewController alloc] init];
    alVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:alVC animated:YES];
}

#pragma mark -- QL_ListScreenSegmentDelegate

///当前选中项
- (void)customScreenSegmentCurrentItem:(NSInteger)item andIsSelect:(BOOL)isSelect
{
    if(!isSelect){ // 选中
        self.areaSelectView.hidden = YES;
        self.classSelectView.hidden = YES;
        self.sortSelectView.hidden = YES;
        self.screenSelectView.hidden = YES;
        
        if(item == 0){ // 地区
            [self.areaSelectView showViewForSelectId:self.viewModel.businessListParam.areaIds];
        }else if(item == 1){ // 类别
            [self.classSelectView showViewForSelectId:self.viewModel.businessListParam.categoryId];
        }else if(item == 2){ // 排序
            [self.sortSelectView showViewForSelectId:self.viewModel.businessListParam.sortType];
        }else if(item == 3){ // 筛选
            [self.screenSelectView showViewForSelectId:self.viewModel.businessListParam.featuredService];
        }
    }else{ // 关闭
        if(item == 0){ // 地区
            if(self.areaSelectView.hidden){
                [self.areaSelectView showViewForSelectId:self.viewModel.businessListParam.areaIds];
            }else{
                self.areaSelectView.hidden = YES;
            }
        }else if(item == 1){ // 类别
            if(self.classSelectView.hidden){
               [self.classSelectView showViewForSelectId:self.viewModel.businessListParam.categoryId];
            }else{
                self.classSelectView.hidden = YES;
            }
        }else if(item == 2){ // 排序
            if(self.sortSelectView.hidden){
                [self.sortSelectView showViewForSelectId:self.viewModel.businessListParam.sortType];
            }else{
                self.sortSelectView.hidden = YES;
            }
        }else if(item == 3){ // 筛选
            if(self.screenSelectView.hidden){
                [self.screenSelectView showViewForSelectId:self.viewModel.businessListParam.featuredService];
            }else{
                self.screenSelectView.hidden = YES;
            }
        }
    }
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QL_BusinessDetailsViewController *bdVC = [[QL_BusinessDetailsViewController alloc] init];
    bdVC.hidesBottomBarWhenPushed = YES;
    bdVC.sellerId = self.viewModel.businessListDatas[indexPath.row].sellerId;
    
    [self.navigationController pushViewController:bdVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.businessListDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QL_HPBusinessListTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_HPBusinessListTableViewCell *cell = [QL_HPBusinessListTableViewCell cellWithTableView:tableView];
    
    [cell updateUIForData:self.viewModel.businessListDatas[indexPath.row]];
    //分界线
    cell.topLongLineImage.hidden = NO;
    if(indexPath.row == 0){
        cell.topLongLineImage.hidden = YES;
    }
    
    return cell;
}

#pragma mark -- getter,setter

//选择view
- (QL_ListScreenSegmentView *)segmentView
{
    if(!_segmentView){
        QL_ListScreenSegmentView *view = [[QL_ListScreenSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(70)];
        view.delegate = self;
        [view setItems:@[@"地区", @"分类", @"距离优先", @"筛选"]];
        [view setTopLineImageViewHidden:YES];
        [view setBottomLineImageViewHidden:NO];
        [self.view addSubview:_segmentView = view];
    }
    return _segmentView;
}

///内容
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///地区选择
- (QL_ListSelectView *)areaSelectView
{
    if(!_areaSelectView){
        QL_ListSelectView *view = [[QL_ListSelectView alloc] init];
        view.hidden = YES;
        //回调
        WEAKSelf;
        view.onSelectBlock = ^(QL_ListSelectViewData *model){
            if([model.id isEqualToString:DATAMODEL.cityId]){
                weakSelf.viewModel.businessListParam.areaIds = [DATAMODEL.configDBHelper getQuaryCityBusinessListAreaId: model.id];
            }else{
                weakSelf.viewModel.businessListParam.areaIds = [NSString stringWithFormat:@"%@,%@", DATAMODEL.cityId, model.id];
            }
            
            [weakSelf.segmentView setItem:0 title:model.name];
            
            [weakSelf.tableView.header beginRefreshing];
        };
        
        //获取地区数据
        NSMutableArray<QL_AreaDataModel*>* areaArray = [DATAMODEL.configDBHelper getAreaDatasForParentId:DATAMODEL.cityId];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        QL_ListSelectViewData *model = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
        model.id = DATAMODEL.cityId;
        model.name = @"不限";
        [array addObject:model];
        for(QL_AreaDataModel *model in areaArray){
            QL_ListSelectViewData *selectModel = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
            selectModel.id = model.areaId;
            selectModel.name = model.name;
            [array addObject:selectModel];
        }
        [view updateDatas:array];
        
        [self.view addSubview:_areaSelectView = view];
    }
    return _areaSelectView;
}

///分类选择
- (QL_ListSelectView *)classSelectView
{
    if(!_classSelectView){
        QL_ListSelectView *view = [[QL_ListSelectView alloc] init];
        view.hidden = YES;
        //回调
        WEAKSelf;
        view.onSelectBlock = ^(QL_ListSelectViewData *model){
            weakSelf.viewModel.businessListParam.categoryId = model.id;
            [weakSelf.segmentView setItem:1 title:model.name];
            
            [weakSelf.tableView.header beginRefreshing];
        };
        [self.view addSubview:_classSelectView = view];
    }
    return _classSelectView;
}

///排序选择
- (QL_ListSelectView *)sortSelectView
{
    if(!_sortSelectView){
        QL_ListSelectView *view = [[QL_ListSelectView alloc] init];
        view.hidden = YES;
        //回调
        WEAKSelf;
        view.onSelectBlock = ^(QL_ListSelectViewData *model){
            weakSelf.viewModel.businessListParam.sortType = model.id;
            [weakSelf.segmentView setItem:2 title:model.name];
            
            [weakSelf.tableView.header beginRefreshing];
        };
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        QL_ListSelectViewData *model3 = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
        model3.id = @"DEFAULT";
        model3.name = @"默认排序";
        [array addObject:model3];
        QL_ListSelectViewData *model = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
        model.id = @"DISTANCEASC";
        model.name = @"距离优先";
        [array addObject:model];
        QL_ListSelectViewData *model1 = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
        model1.id = @"SCOREDESC";
        model1.name = @"好评优先";
        [array addObject:model1];
        QL_ListSelectViewData *model2 = [[QL_ListSelectViewData alloc] initWithDictionary:@{}];
        model2.id = @"COLLECTDESC";
        model2.name = @"收藏最多";
        [array addObject:model2];
        [view updateDatas:array];
        
        [self.view addSubview:_sortSelectView = view];
    }
    return _sortSelectView;
}

///筛选选择
- (QL_ListScreenSelectView *)screenSelectView
{
    if(!_screenSelectView){
        QL_ListScreenSelectView *view = [[QL_ListScreenSelectView alloc] init];
        view.hidden = YES;
        //回调
        WEAKSelf;
        view.onSelectBlock = ^(NSString *selectId){
            weakSelf.viewModel.businessListParam.featuredService = selectId;
            
            [weakSelf.tableView.header beginRefreshing];
        };
        
        [self.view addSubview:_screenSelectView = view];
    }
    return _screenSelectView;
}

///view model
- (QL_HomePageViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_HomePageViewModel alloc] init];
        
        _viewModel.businessListParam.areaIds = [DATAMODEL.configDBHelper getQuaryCityBusinessListAreaId:DATAMODEL.cityId];
        _viewModel.businessListParam.latitude = DATAMODEL.latitude;
        _viewModel.businessListParam.longitude = DATAMODEL.longitude;
        _viewModel.businessListParam.sortType = @"DISTANCEASC";
    }
    return _viewModel;
}

///设置搜索内容
- (void)setSearchContent:(NSString *)searchContent
{
    _searchContent = searchContent;
    
    self.viewModel.businessListParam.keyWord = searchContent;
}

///设置分类id
- (void)setCategoryId:(NSString *)categoryId
{
    _categoryId = categoryId;
    
    self.viewModel.businessListParam.categoryId = categoryId;
}

@end
