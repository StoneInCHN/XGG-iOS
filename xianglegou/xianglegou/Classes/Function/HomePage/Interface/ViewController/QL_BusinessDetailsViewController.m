//
//  QL_BusinessDetailsViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/21.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BusinessDetailsViewController.h"
#import "QL_BusinessInfoView.h"
#import "QL_SegmentPlaceholderTableViewCell.h"
#import "QL_BDCommentStatisticsView.h"
#import "QL_BDCommentTableViewCell.h"
#import "QL_BDHandleView.h"
#import "QL_BDInformationTableViewCell.h"
#import "QL_BusinessDetailsViewModel.h"

#import "QL_AddressLocationViewController.h"
#import "QL_AllCommentViewController.h"

@interface QL_BusinessDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;
///商家信息
@property(nonatomic, weak) QL_BusinessInfoView *businessInfoView;
///评论统计view
@property(nonatomic, strong) QL_BDCommentStatisticsView *commentStatisticsView;
///操作view
@property(nonatomic, weak) QL_BDHandleView *handleView;

///当前选择项 0：服务评论；1：店铺简介
@property(nonatomic, assign) NSInteger currentItem;
///view model
@property(nonatomic, strong) QL_BusinessDetailsViewModel *viewModel;

@end

@implementation QL_BusinessDetailsViewController

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
    [self.commentStatisticsView removeFromSuperview];
    [self setCommentStatisticsView:nil];
}

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

///加载返回按钮
-(void)loadNavigationBackButton
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [self loadBackButtonForNavBgIsHidden:YES];
    self.navigationItem.hidesBackButton = YES;
}

///加载navigationBar背景
-(void)loadNavigationBarBackground
{
    [((Hen_BaseNavigationViewController*)self.navigationController) setDefaultBackground];
    [self.navigationController.navigationBar setTintColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarTitleColor:kFontColorWhite];
    
    [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:YES];
    [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:YES];
}


#pragma mark -- private

///加载子视图
-(void)loadSubView
{
    [self.handleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(-64);
        make.bottom.equalTo(self.handleView.mas_top);
    }];
    //下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    [self businessInfoView];
}

///加载返回按钮
- (void)loadBackButtonForNavBgIsHidden:(BOOL)hidden
{
    if(hidden){
        UIBarButtonItem *barbtn = [UIBarButtonItem createBarButtonItemWihNormalImage:@"public_back2" pressImage:@"public_back2" target:self action:@selector(onGoBackClick:)];
        self.navigationItem.leftBarButtonItem=barbtn;
    }else{
        UIImage *searchimage=[UIImage imageNamed:@"base_navigation_icon_back"];
        UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(onGoBackClick:)];
        barbtn.image=searchimage;
        self.navigationItem.leftBarButtonItem=barbtn;
    }
}

///加载数据
-(void)loadData
{
    WEAKSelf;
    
    //请求详情
    [self.viewModel getBussinessDetialsDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            [weakSelf.businessInfoView updatePngForImageArray:weakSelf.viewModel.detailsData.envImgs];
            weakSelf.handleView.businessData = weakSelf.viewModel.detailsData;
            [weakSelf.businessInfoView updateUIForData:weakSelf.viewModel.detailsData];
            weakSelf.commentStatisticsView.starScore = weakSelf.viewModel.detailsData.rateScore;
            
            [weakSelf.tableView reloadData];
        }
    }];
    
    if(self.currentItem == 0){ // 服务评论
        //参数
        self.viewModel.commentListParam.pageSize = @"5";
        //请求
        [self.viewModel getCommentListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            //取消加载
            [weakSelf.tableView.header endRefreshing];
            if([code isEqualToString:@"0000"]){
                [weakSelf.tableView reloadData];
                weakSelf.commentStatisticsView.commentTotal = page;
                
                if(weakSelf.viewModel.commentListDatas.count > 0){
                    weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                //提示
                [weakSelf showHint:desc];
            }
        }];
    }else{
        [self.tableView.header endRefreshing];
    }
}

#pragma mark -- event response

///更多评价
- (void)onMoreCommentAction:(id)sender
{
    QL_AllCommentViewController *acVC = [[QL_AllCommentViewController alloc] init];
    acVC.hidesBottomBarWhenPushed = YES;
    acVC.sellerId = self.sellerId;
    acVC.commentScore = self.viewModel.detailsData.rateScore;
    
    [self.navigationController pushViewController:acVC animated:YES];
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]]){
        return;
    }
    CGPoint offset = scrollView.contentOffset;
    if (offset.y <= 0) {
        CGRect newFrame = CGRectMake(0, -offset.y-64, kMainScreenWidth, BI_ViewHeight);
        self.businessInfoView.frame = newFrame;
    } else {
        if(offset.y <= BI_ViewHeight - BI_SegmentHeight - 64){
            CGRect newFrame = CGRectMake(0, -offset.y-64, kMainScreenWidth, BI_ViewHeight);
            self.businessInfoView.frame = newFrame;
        }else{
            CGRect newFrame = CGRectMake(0, BI_SegmentHeight - BI_ViewHeight, kMainScreenWidth, BI_ViewHeight);
            self.businessInfoView.frame = newFrame;
        }
        if(offset.y <= HEIGHT_TRANSFORMATION(430)){
            self.navigationItem.title = @"";
            
            [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:YES];
            [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:YES];
            [self loadBackButtonForNavBgIsHidden:YES];
            [self.navigationController.navigationBar setTintColor:kFontColorWhite];
        }else{
            self.navigationItem.title = self.viewModel.detailsData.name;
            
            [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:NO];
            [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:NO];
            [self loadBackButtonForNavBgIsHidden:NO];
            [self.navigationController.navigationBar setTintColor:kFontColorWhite];
        }
    }
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //segment占位栏+内容栏
    if(self.currentItem == 0){ // 服务评论
        return 1+1;
    }else if(self.currentItem == 1){ // 店铺简介
        return 1+1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){// segment占位栏
        return 1;
    }
    if(self.currentItem == 0){ // 服务评论
        return self.viewModel.commentListDatas.count;
    }else if(self.currentItem == 1){ // 店铺简介
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){ // segment占位栏
        return CGFLOAT_MIN;
    }
    if(self.currentItem == 0){ // 服务评论
        return self.commentStatisticsView.frame.size.height;
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){ // segment占位栏
        return nil;
    }
    if(self.currentItem == 0){ // 服务评论
        return self.commentStatisticsView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){ // segment占位栏
        QL_SegmentPlaceholderTableViewCell *cell = [QL_SegmentPlaceholderTableViewCell cellWithTableView:tableView];
        
        [cell updateViewHeight:BI_ViewHeight];
        
        return cell;
    }
    
    if(self.currentItem == 0){ // 服务评论
        QL_BDCommentTableViewCell *cell = [QL_BDCommentTableViewCell cellWithTableView:tableView];
        
        [cell updateUIForData:self.viewModel.commentListDatas[indexPath.row]];
        
        return cell;
    }else if(self.currentItem == 1){ // 店铺简介
        QL_BDInformationTableViewCell *cell = [QL_BDInformationTableViewCell cellWithTableView:tableView];
        
        [cell updateUIForData:self.viewModel.detailsData];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

#pragma mark -- getter,setter

///内容
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.backgroundColor = kCommonBackgroudColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //自适应高度
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(200)];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///商家信息
- (QL_BusinessInfoView *)businessInfoView
{
    if(!_businessInfoView){
        QL_BusinessInfoView *view = [[QL_BusinessInfoView alloc] init];
        view.frame = CGRectMake(0, -64, kMainScreenWidth, BI_ViewHeight);
        //回调
        WEAKSelf;
        view.onSelectItemBlock = ^(NSInteger item){
            weakSelf.currentItem = item;
            
            [weakSelf.tableView reloadData];
            
            if(weakSelf.currentItem == 0){
                if(weakSelf.viewModel.commentListDatas.count > 0){
                    weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    weakSelf.tableView.tableFooterView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                weakSelf.tableView.tableFooterView = nil;
            }
        };
        view.onAddressBlock = ^(){
            QL_AddressLocationViewController *alVC = [[QL_AddressLocationViewController alloc] init];
            alVC.hidesBottomBarWhenPushed = YES;
            
            alVC.addressString = weakSelf.viewModel.detailsData.address;
            alVC.distanceString = weakSelf.viewModel.detailsData.distance;
            [alVC setLatitude:weakSelf.viewModel.detailsData.latitude andLongitude:weakSelf.viewModel.detailsData.longitude];
            
            [weakSelf.navigationController pushViewController:alVC animated:YES];
        };
        [self.view addSubview:_businessInfoView = view];
    }
    return _businessInfoView;
}

///评论统计view
- (QL_BDCommentStatisticsView *)commentStatisticsView
{
    if(!_commentStatisticsView){
        _commentStatisticsView = [[QL_BDCommentStatisticsView alloc] init];

        //点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMoreCommentAction:)];
        [_commentStatisticsView addGestureRecognizer:tap];
    }
    return _commentStatisticsView;
}

///操作view
- (QL_BDHandleView *)handleView
{
    if(!_handleView){
        QL_BDHandleView *view = [[QL_BDHandleView alloc] init];
        [self.view addSubview:_handleView = view];
    }
    return _handleView;
}

///view model
- (QL_BusinessDetailsViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_BusinessDetailsViewModel alloc] init];
    }
    return _viewModel;
}

///设置商户id
- (void)setSellerId:(NSString *)sellerId
{
    _sellerId = sellerId;
    
    self.viewModel.detialsParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.detialsParam.entityId = sellerId;
    self.viewModel.detialsParam.latitude = DATAMODEL.latitude;
    self.viewModel.detialsParam.longitude = DATAMODEL.longitude;
    
    self.viewModel.commentListParam.sellerId = sellerId;
}

@end
