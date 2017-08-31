//
//  GC_MineLeBeansScoreViewController.m
//  Rebate
//
//  Created by mini3 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  乐分 乐豆 界面
//

#import "GC_MineLeBeansScoreViewController.h"
#import "GC_RealNameRZViewController.h"
#import "GC_NavigationSegmentView.h"
#import "GC_MineCountSegmentView.h"

#import "GC_MineIntegralListTableViewCell.h"

#import "GC_MineScoreStatisticsViewModel.h"
#import "GC_MineMessageViewModel.h"


#import "GC_WithdrawViewController.h"
#import "GC_MineEditPasswordViewController.h"
#import "GC_AddBankCardViewController.h"
#import "QL_CustomSegmentView.h"
#import "LZ_TransferViewController.h"


@interface GC_MineLeBeansScoreViewController ()<GC_NavigationSegmentDelegate,QL_CustomSegmentDelegate , UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

///SegmentView
@property (nonatomic, strong) GC_NavigationSegmentView *segmentView;
///乐分 乐豆 信息
@property (nonatomic, weak) GC_MineCountSegmentView *lebSegmentview;

///滑动区域
@property(nonatomic, weak) UIScrollView *scrollView;
///内容
@property(nonatomic, strong) NSMutableArray *tableViewArray;

///ViewModel
@property (nonatomic, strong) GC_MineScoreStatisticsViewModel *viewModel;

///UserViewModel
@property (nonatomic, strong) GC_MineMessageViewModel *bdViewModel;

///提现 按钮
@property (nonatomic, strong) UIButton *withdrawButton;


///乐分
@property (nonatomic, strong) UIButton *scoretransferButton;


///乐豆转账按钮
@property (nonatomic, strong) UIButton *transferButton;

///乐分View
@property (nonatomic, weak) UIView *leScoreView;
///乐分类型选择
@property (nonatomic, strong) QL_CustomSegmentView *leScoreSegmentView;
@end

@implementation GC_MineLeBeansScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubView];
    
    
    [self isMarkHidden];
    
    [self startLoadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNavigationBar];
    
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
    [self setViewModel:nil];
    [self setBdViewModel:nil];
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
    for(UITableView *tableView in self.tableViewArray){
        [tableView removeFromSuperview];
    }
    [self.tableViewArray removeAllObjects];
    [self setTableViewArray:nil];
    
    [self.segmentView removeFromSuperview];
    [self setSegmentView:nil];
}

- (void)onGoBackClick:(id)sender
{
    [super onGoBackClick:sender];
    
    if(self.onBackBlock){
        self.onBackBlock();
    }
}


///微信绑定授权操作
-(void)loadAuthorizationOfWeChat
{
    ThirdLoginType type = ThirdLoginTypeOfWechat;
    
    WEAKSelf;
    [[Hen_UMSocialManager shareManager] thirdLoginForThirdLoginType:type presentingController:self withResultBlock:^(BOOL isSuccess, NSString *uid, NSString *openId, NSString *nickname) {
        if(isSuccess){
            //用户ID
            [weakSelf.bdViewModel.authorizationOfWechatParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
            //用户token
            [weakSelf.bdViewModel.authorizationOfWechatParam setObject:DATAMODEL.token forKey:@"token"];
            //用户微信openid
            [weakSelf.bdViewModel.authorizationOfWechatParam setObject:openId forKey:@"openId"];
            //用户微信昵称
            [weakSelf.bdViewModel.authorizationOfWechatParam setObject:nickname forKey:@"wxNickName"];
            //显示加载
            [weakSelf showPayHud:@""];
            [weakSelf.bdViewModel setAuthorizationOfWechatDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
                //取消加载
                [weakSelf hideHud];
                if([code isEqualToString:@"0000"]){     //成功
                    DATAMODEL.userInfoData.isBindWeChat = @"1";
                    DATAMODEL.userInfoData.wechatNickName = nickname;
                    GC_WithdrawViewController *withdraw = [[GC_WithdrawViewController alloc] init];
                    [weakSelf.navigationController pushViewController:withdraw animated:YES];
                }else{
                    //提示
                    [weakSelf showHint:desc];
                }
            }];
        }
    }];
}


#pragma mark -- event response
///翼支付提现
-(void)onWithdrawAction:(UIButton*)sender
{
    
    ///if([DATAMODEL.userInfoData.isSetPayPwd isEqualToString:@"1"]){
        if([DATAMODEL.userInfoData.isAuth isEqualToString:@"1"]){
            if([DATAMODEL.userInfoData.isOwnBankCard isEqualToString:@"1"]){
                GC_WithdrawViewController *withdraw = [[GC_WithdrawViewController alloc] init];
                withdraw.hidesBottomBarWhenPushed = YES;
                
                WEAKSelf;
                withdraw.onSuccessful = ^{
                    [((UITableView*)weakSelf.tableViewArray[0]).header beginRefreshing];
                };
                
                [self.navigationController pushViewController:withdraw animated:YES];
            }else{
                DATAMODEL.interfaceSource = @"6";
                GC_AddBankCardViewController *abVC = [[GC_AddBankCardViewController alloc] init];
                abVC.hidesBottomBarWhenPushed = YES;
                abVC.isDefault = YES;
                [self.navigationController pushViewController:abVC animated:YES];
            }
        }else{
            DATAMODEL.interfaceSource = @"6";
            GC_RealNameRZViewController *rnzVC = [[GC_RealNameRZViewController alloc] init];
            rnzVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rnzVC animated:YES];
        }
//    }else{
//        //未设置支付密码
//        WEAKSelf;
//        GC_MineEditPasswordViewController *editPayPwd = [[GC_MineEditPasswordViewController alloc] init];
//        
//        editPayPwd.editPwdType = 1;
//        editPayPwd.onEditSuccessBlock = ^(){
//            [weakSelf loadAuthorizationOfWeChat];
//        };
//        [self.navigationController pushViewController:editPayPwd animated:YES];
//        [self showHint:HenLocalizedString(@"支付密码暂未设置！")];
//    }
//    
}

#pragma mark -- private

///加载导航条
-(void)loadNavigationBar
{
//    self.segmentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    self.segmentView.autoresizesSubviews = YES;
//    
//    
//    CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
//    CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
//    
//    CGRect frame;
//    
//    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
//    maxWidth += 15;//leftview 左右都有间隙，左边是5像素，右边是8像素，加2个像素的阀值 5 ＋ 8 ＋ 2
//    
//    frame = self.segmentView.frame;
//    frame.size.width = 250 - maxWidth * 2;
//    
//    frame = self.segmentView.frame;
//    frame.size.width = 250 - maxWidth * 2;
//    
//    self.segmentView.frame = frame;

    self.navigationItem.titleView = self.segmentView;
}

///加载子视图
- (void)loadSubView
{
    
    self.view.backgroundColor = kCommonBackgroudColor;
    
    [self.lebSegmentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(130));
    }];
    
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lebSegmentview.mas_bottom);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    for(NSInteger i = 0; i < 2; i++){
        UITableView *tableView;
        if(i == 0){
            UIView *view = [UIView createViewWithFrame:CGRectMake(i*kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight-self.lebSegmentview.frame.size.height-64) backgroundColor:kCommonBackgroudColor];
            
            [view addSubview:self.leScoreSegmentView];
            [self.leScoreSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view);
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(70));
            }];
            
            [view addSubview:self.withdrawButton];
            [self.withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view);
                make.width.mas_equalTo(kMainScreenWidth/2-0.5);
                make.right.equalTo(view);
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
            }];
            
            [view addSubview:self.scoretransferButton];
            
            [self.scoretransferButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(view);
                make.width.mas_equalTo(kMainScreenWidth/2-0.5);
                make.left.equalTo(view);
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
            }];
            
            tableView = [UITableView createTableViewWithDelegateTarget:self];
//            tableView.frame = CGRectMake(i*kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight-self.lebSegmentview.frame.size.height- 64 - self.leScoreSegmentView.frame.size.height);
            //自适应高度
            [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(195)];
            tableView.backgroundColor = kCommonBackgroudColor;
            [view addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.leScoreSegmentView.mas_bottom);
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.bottom.equalTo(self.withdrawButton.mas_top);
            }];
            [self.scrollView addSubview:view];
        }else if(i == 1){
            
            [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view);
                make.width.equalTo(self.view);
                make.centerX.equalTo(self.view);
                make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
            }];
            
            tableView = [UITableView createTableViewWithDelegateTarget:self];
            tableView.frame = CGRectMake(i*kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight-self.lebSegmentview.frame.size.height-64);
            //自适应高度
            [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(195)];
            
            tableView.backgroundColor = kCommonBackgroudColor;
            [self.scrollView addSubview:tableView];
        }
        __weak typeof(tableView) weakTableView = tableView;
        [self.tableViewArray addObject:weakTableView];
   
        //下拉刷新
        WEAKSelf;
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [tableView.footer resetNoMoreData];
            [weakSelf loadMineDataInfo];
            [weakSelf loadDataForStart:1 isUpMore:NO];
        }];
        
        
        //上拉加载更多
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if(weakSelf.currentItem == 0){       // 乐分
                [weakSelf loadDataForStart:weakSelf.viewModel.leScoreRecDatas.count / [NumberOfPages integerValue] + 1  isUpMore:YES];
            }else if(weakSelf.currentItem == 1){ // 乐豆
                [weakSelf loadDataForStart:weakSelf.viewModel.leBeanRecDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
            }
            
            HenLog(@"当前选项:%ld",self.currentItem);
        }];
        [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
        tableView.footer = footer;
        HenLog(@"当前选项:%ld",self.currentItem);
    }
    
}

///开始 加载 数据
- (void)startLoadData
{
    if(self.tableViewArray.count <= 0){
        return;
    }
    
    if(self.currentItem == 0){              //乐分
        if(self.viewModel.leScoreRecDatas.count <= 0){
            [((UITableView*)self.tableViewArray[0]).header beginRefreshing];
             [self loadDataForStart:1 isUpMore:NO];
        }
    }else if(self.currentItem == 1){        //乐豆
        if(self.viewModel.leBeanRecDatas.count <= 0){
            [((UITableView*)self.tableViewArray[1]).header beginRefreshing];
        }
    }
}


///加载我的信息数据
- (void)loadMineDataInfo
{
    
    //参数
    [self.bdViewModel.userInfoParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.bdViewModel.userInfoParam setObject:DATAMODEL.token forKey:@"token"];
    WEAKSelf;
    //请求
    [self.bdViewModel getUserInfoWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        UITableView *tableView = weakSelf.tableViewArray[weakSelf.currentItem];
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
        if([code isEqualToString:@"0000"]){
            //更新显示
//            weakSelf.totalLeScore = weakSelf.bdViewModel.userInfoData.totalLeScore;
//            weakSelf.curLeScore = weakSelf.bdViewModel.userInfoData.curLeScore;
//            
//            weakSelf.totalLeBean = weakSelf.bdViewModel.userInfoData.totalLeBean;
//            weakSelf.curLeBean = weakSelf.bdViewModel.userInfoData.curLeBean;

            DATAMODEL.userInfoData = self.bdViewModel.userInfoData;
            
            [weakSelf updateLeScoreAndLeBean];
        }
        
    }];
}


///标签显示判断
- (void)isMarkHidden
{
    
    if(DATAMODEL.userInfoData.agent.agencyLevel.length > 0 && [DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){        //既是代理商，又是业务员
        NSString *agencyName = @"";
        if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"PROVINCE"]){       //省代理
            agencyName = @"省代理";
        }else if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"CITY"]){     //市代理
            agencyName = @"市代理";
        }else if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"COUNTY"]){   //县代理
            agencyName = @"区代理";
        }else if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"TOWN"]){     //乡代理
            agencyName = @"乡代理";
        }
        [self.leScoreSegmentView setUnLineItems:@[@"分红",agencyName,@"业务员",@"好友",@"消费",@"提现",@"转账"]];
    }else if(DATAMODEL.userInfoData.agent.agencyLevel.length > 0){      //代理商
        NSString *agencyName = @"";
        if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"PROVINCE"]){       //省代理
            agencyName = @"省代理";
        }else if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"CITY"]){     //市代理
            agencyName = @"市代理";
        }else if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"COUNTY"]){   //县代理
            agencyName = @"区代理";
        }else if([DATAMODEL.userInfoData.agent.agencyLevel isEqualToString:@"TOWN"]){     //乡代理
            agencyName = @"乡代理";
        }
        [self.leScoreSegmentView setUnLineItems:@[@"分红",agencyName,@"好友",@"消费",@"提现",@"转账"]];
    }else if([DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){ //业务员
        [self.leScoreSegmentView setUnLineItems:@[@"分红",@"业务员",@"好友",@"消费",@"提现",@"转账"]];
    }else{
        [self.leScoreSegmentView setUnLineItems:@[@"分红",@"好友",@"消费",@"提现",@"转账"]];
    }
    
    [self.leScoreSegmentView setSelectItem:0];
}


///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    
    HenLog(@"当前选项:%ld",self.currentItem);
    if(self.currentItem == 0){          //乐分 数据 请求
        
        //参数
        [self.viewModel.leScoreRecParam setObject:[NSString stringWithFormat:@"%ld", (long)start] forKey:@"pageNumber"];
        
        [self.viewModel.leScoreRecParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
        //用户token
        [self.viewModel.leScoreRecParam setObject:DATAMODEL.token forKey:@"token"];
        //请求
        WEAKSelf;
        [self.viewModel getUserLeScoreRecDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            //取消加载
            UITableView *tableView = weakSelf.tableViewArray[weakSelf.currentItem];
            [tableView.header endRefreshing];
            [tableView.footer endRefreshing];
            
            if(isUpMore){
                if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                    [tableView.footer noticeNoMoreData];
                }
            }
            
            if([code isEqualToString:@"0000"]){
                [tableView reloadData];
                
                if(weakSelf.viewModel.leScoreRecDatas.count > 0){
                    tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                //提示
                [weakSelf showHint:desc];
            }
        }];
        
        
        
    }else if(self.currentItem == 1){    //乐豆 数据 请求
        
        
        //参数
        [self.viewModel.leBeanRecParam setObject:[NSString stringWithFormat:@"%ld",(long)start] forKey:@"pageNumber"];
        //用户ID
        [self.viewModel.leBeanRecParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
        //用户token
        [self.viewModel.leBeanRecParam setObject:DATAMODEL.token forKey:@"token"];
        //请求
        WEAKSelf;
        [self.viewModel getUserLeBeanRecDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            UITableView *tableView = weakSelf.tableViewArray[weakSelf.currentItem];
            //取消加载
            [tableView.header endRefreshing];
            [tableView.footer endRefreshing];
            
            if(isUpMore){
                if(((NSMutableArray*)msg).count < [NumberOfPages integerValue]){
                    [tableView.footer noticeNoMoreData];
                }
            }
            if([code isEqualToString:@"0000"]){
                [tableView reloadData];
                
                
                if(weakSelf.viewModel.leBeanRecDatas.count > 0){
                    tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:YES];
                }else{
                    tableView.tableHeaderView = [[QL_NothingNoticeView alloc] initWithIsHaveSomething:NO];
                }
            }else{
                //提示
                [weakSelf showHint:desc];
            }
        }];
        
    }
    
}



#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.tableViewArray[0]){
        GC_MineIntegralListTableViewCell *cell = [GC_MineIntegralListTableViewCell cellWithTableView:tableView];
        [cell updateUiForLeScoreRecData:self.viewModel.leScoreRecDatas[indexPath.section]];
        return cell;
    }else if(tableView == self.tableViewArray[1]){
        GC_MineIntegralListTableViewCell *cell = [GC_MineIntegralListTableViewCell cellWithTableView:tableView];
        [cell updateUiForLeBeanRecData:self.viewModel.leBeanRecDatas[indexPath.section]];
        return cell;
    }
    
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ////return [GC_MineIntegralListTableViewCell getCellHeightForContent:@""];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tableViewArray[0]){
        HenLog(@"列表个数:%ld",self.viewModel.leScoreRecDatas.count);
        return self.viewModel.leScoreRecDatas.count;
    }else if(tableView == self.tableViewArray[1]){
        return self.viewModel.leBeanRecDatas.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -- GC_BeanAndScoreSegmentDelegate

///当前选中项   乐分乐豆切换
- (void)customNavigationSegmentCurrentItem:(NSInteger)item
{
    //当前选项
    self.currentItem = item;
    
    
    //切换 乐分 乐豆 数值显示
    if(item == 0){                  ///乐分
        [self.lebSegmentview setItems:@[@"累计乐分",@"当前乐分"]];
        [self.lebSegmentview setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.totalLeScore showDotNumber:4] index:0];
        [self.lebSegmentview setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeScore showDotNumber:4] index:1];
        
        self.withdrawButton.hidden = NO;
        self.scoretransferButton.hidden=NO;
         self.transferButton.hidden = YES;
        [self.withdrawButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
        }];
        [self.transferButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else if(item == 1){            ///乐豆
        [self.lebSegmentview setItems:@[@"累计乐豆",@"当前乐豆"]];
        [self.lebSegmentview setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.totalLeBean showDotNumber:4] index:0];
        [self.lebSegmentview setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeBean showDotNumber:4] index:1];
        self.withdrawButton.hidden = YES;
        self.scoretransferButton.hidden=YES;
        self.transferButton.hidden = NO;
        [self.withdrawButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.transferButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
        }];
    }
    
    //加载数据
    [self startLoadData];
}


///当前选中项 乐分类型 切换
- (void)customSegmentCurrentItem:(NSInteger)item
{
    
    [self.viewModel.leScoreRecDatas removeAllObjects];
    [self.viewModel setLeScoreRecDatas:nil];
    [((UITableView*)self.tableViewArray[0]) reloadData];
    
    [self.viewModel.leScoreRecParam setObject:@"1" forKey:@"pageNumber"];
    if(DATAMODEL.userInfoData.agent.agencyLevel.length > 0 && [DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){        //既是代理商，又是业务员
        if(item == 0){  //分红
            [self.viewModel.leScoreRecParam setObject:@"BONUS" forKey:@"leScoreType"];
        }else if(item == 1){    //代理商
            [self.viewModel.leScoreRecParam setObject:@"AGENT" forKey:@"leScoreType"];
        }else if(item == 2){    //业务员
            [self.viewModel.leScoreRecParam setObject:@"RECOMMEND_SELLER" forKey:@"leScoreType"];
        }else if(item == 3){    //好友
            [self.viewModel.leScoreRecParam setObject:@"RECOMMEND_USER" forKey:@"leScoreType"];
        }else if(item == 4){    //消费
            [self.viewModel.leScoreRecParam setObject:@"CONSUME" forKey:@"leScoreType"];
        }else if(item == 5){    //提现
            [self.viewModel.leScoreRecParam setObject:@"WITHDRAW" forKey:@"leScoreType"];
        }else if(item == 6){    //转账
            [self.viewModel.leScoreRecParam setObject:@"TRANSFER" forKey:@"leScoreType"];
        }
    }else if(DATAMODEL.userInfoData.agent.agencyLevel.length > 0){      //代理商
        if(item == 0){          //分红
            [self.viewModel.leScoreRecParam setObject:@"BONUS" forKey:@"leScoreType"];
        }else if(item == 1){    //代理商
            [self.viewModel.leScoreRecParam setObject:@"AGENT" forKey:@"leScoreType"];
        }else if(item == 2){    //好友
            [self.viewModel.leScoreRecParam setObject:@"RECOMMEND_USER" forKey:@"leScoreType"];
        }else if(item == 3){    //消费
            [self.viewModel.leScoreRecParam setObject:@"CONSUME" forKey:@"leScoreType"];
        }else if(item == 4){    //提现
            [self.viewModel.leScoreRecParam setObject:@"WITHDRAW" forKey:@"leScoreType"];
        }else if(item == 5){    //转账
            [self.viewModel.leScoreRecParam setObject:@"TRANSFER" forKey:@"leScoreType"];
        }
    }else if([DATAMODEL.userInfoData.isSalesman isEqualToString:@"1"]){ //业务员
        if(item == 0){          //分红
            [self.viewModel.leScoreRecParam setObject:@"BONUS" forKey:@"leScoreType"];
        }else if(item == 1){    //业务员
            [self.viewModel.leScoreRecParam setObject:@"RECOMMEND_SELLER" forKey:@"leScoreType"];
        }else if(item == 2){    //好友
            [self.viewModel.leScoreRecParam setObject:@"RECOMMEND_USER" forKey:@"leScoreType"];
        }else if(item == 3){    //消费
            [self.viewModel.leScoreRecParam setObject:@"CONSUME" forKey:@"leScoreType"];
        }else if(item == 4){    //提现
            [self.viewModel.leScoreRecParam setObject:@"WITHDRAW" forKey:@"leScoreType"];
        }else if(item == 5){    //转账
            [self.viewModel.leScoreRecParam setObject:@"TRANSFER" forKey:@"leScoreType"];
        }
        
    }else{
        if(item == 0){          //分红
            [self.viewModel.leScoreRecParam setObject:@"BONUS" forKey:@"leScoreType"];
        }else if(item == 1){    //好友
            [self.viewModel.leScoreRecParam setObject:@"RECOMMEND_USER" forKey:@"leScoreType"];
        }else if(item == 2){    //消费
            [self.viewModel.leScoreRecParam setObject:@"CONSUME" forKey:@"leScoreType"];
        }else if(item == 3){    //提现
            [self.viewModel.leScoreRecParam setObject:@"WITHDRAW" forKey:@"leScoreType"];
        }else if(item == 4){    //转账
            [self.viewModel.leScoreRecParam setObject:@"TRANSFER" forKey:@"leScoreType"];
        }
    }
    
    [((UITableView*)self.tableViewArray[0]).header beginRefreshing];

}



///更新 乐分乐豆 显示

- (void)updateLeScoreAndLeBean
{
    //切换 乐分 乐豆 数值显示
    if(self.currentItem == 0){                  ///乐分
        [self.lebSegmentview setItems:@[@"累计乐分",@"当前乐分"]];
        [self.lebSegmentview setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.totalLeScore showDotNumber:4] index:0];
        [self.lebSegmentview setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeScore showDotNumber:4] index:1];
        
        self.withdrawButton.hidden = NO;
        self.transferButton.hidden = YES;
        self.scoretransferButton.hidden=NO;
        [self.withdrawButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
        }];
        [self.transferButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else if(self.currentItem == 1){            ///乐豆
        [self.lebSegmentview setItems:@[@"累计乐豆",@"当前乐豆"]];
        [self.lebSegmentview setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.totalLeBean showDotNumber:4] index:0];
        [self.lebSegmentview setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeBean showDotNumber:4] index:1];
        self.withdrawButton.hidden = YES;
        self.transferButton.hidden = NO;
         self.scoretransferButton.hidden=YES;
        [self.withdrawButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.transferButton mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
        }];
    }
}

#pragma mark -- getter,setter


///乐分 乐豆
- (GC_MineCountSegmentView *)lebSegmentview
{
    if(!_lebSegmentview){
        GC_MineCountSegmentView *view = [[GC_MineCountSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(130)];
        [view setTopLineImageViewHidden:YES];
        if(self.currentItem == 0){
            [view setItems:@[@"累计乐分",@"当前乐分"]];
//            if(self.totalLeScore.length <= 0 || [self.totalLeScore isEqualToString:@""]){
//                self.totalLeScore = @"0";
//            }
//            
//            if(self.curLeScore.length <= 0 || [self.curLeScore isEqualToString:@""]){
//                self.curLeScore = @"0";
//            }
            [view setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.totalLeScore showDotNumber:4] index:0];
            [view setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeScore showDotNumber:4] index:1];
        }else if(self.currentItem == 1){
            [view setItems:@[@"累计乐豆",@"当前乐豆"]];
//            if(self.totalLeBean.length <= 0 || [self.totalLeBean isEqualToString:@""]){
//                self.totalLeBean = @"0";
//            }
//            if(self.curLeBean.length <= 0 || [self.curLeBean isEqualToString:@""]){
//                self.curLeBean = @"0";
//            }
            [view setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.totalLeBean showDotNumber:4] index:0];
            [view setItemCount:[DATAMODEL.henUtil string:DATAMODEL.userInfoData.curLeBean showDotNumber:4] index:1];
        }
        [self.view addSubview:_lebSegmentview = view];
    }
    return _lebSegmentview;
}

///选择view
- (GC_NavigationSegmentView *)segmentView
{
    if(!_segmentView){
        
        _segmentView = [[GC_NavigationSegmentView alloc] initWithHeight:42.5];
        [_segmentView setDefaultFontColor:kFontColorWhite andSelectFontColor:kFontColorWhite];
        [_segmentView setTopLineImageViewHidden:YES];
        [_segmentView setBottomLineImageViewHidden:YES];
        _segmentView.delegate = self;
        [_segmentView setUnLineItems:@[@"乐分",@"乐豆"]];
        [_segmentView setDefaultFont:kFontSize_28 selectFont:kFontSize_38];
        [_segmentView setSelectItem:self.currentItem];
        [_segmentView setScrollView:self.scrollView];
    }
    return _segmentView;
}

///乐豆转账
-(void)onTransferAction:(UIButton*)sender
{
    
    LZ_TransferViewController *LZVC = [[LZ_TransferViewController alloc] init];
    LZVC.hidesBottomBarWhenPushed = YES;
    LZVC.transType=@"LE_BEAN";
    
    WEAKSelf;
    LZVC.onGoBackSuccess = ^{
        [weakSelf updateLeScoreAndLeBean];
        [((UITableView*)self.tableViewArray[1]).header beginRefreshing];
    };
    [self.navigationController pushViewController:LZVC animated:YES];
}

///乐分转账
-(void)onScoreTransferAction:(UIButton*)sender
{
    
    LZ_TransferViewController *LZVC = [[LZ_TransferViewController alloc] init];
    LZVC.hidesBottomBarWhenPushed = YES;
    LZVC.transType=@"LE_SCORE";
    WEAKSelf;
    LZVC.onGoBackSuccess = ^{
        [weakSelf updateLeScoreAndLeBean];
        [((UITableView*)self.tableViewArray[0]).header beginRefreshing];
    };
    [self.navigationController pushViewController:LZVC animated:YES];
}



///滑动区域
- (UIScrollView *)scrollView
{
    if(!_scrollView){
        UIScrollView *scrollView = [UIScrollView createScrollViewWithDelegateTarget:self];
        [scrollView setContentOffset:CGPointMake(kMainScreenWidth * self.currentItem, 0) animated:YES];
        [self.view addSubview:_scrollView = scrollView];
    }
    return _scrollView;
}

///内容
- (NSMutableArray *)tableViewArray
{
    if(!_tableViewArray){
        _tableViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tableViewArray;
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




- (GC_MineScoreStatisticsViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_MineScoreStatisticsViewModel alloc] init];
    }
    return _viewModel;
}



- (GC_MineMessageViewModel *)bdViewModel
{
    if(!_bdViewModel){
        _bdViewModel = [[GC_MineMessageViewModel alloc] init];
    }
    return _bdViewModel;
}



///提现 按钮
- (UIButton *)withdrawButton
{
    if(!_withdrawButton){
        _withdrawButton = [UIButton createButtonWithTitle:HenLocalizedString(@"提现") backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onWithdrawAction:)];
        _withdrawButton.titleLabel.font = kFontSize_36;
        [_withdrawButton setTitleClor:kFontColorWhite];
    }
    return _withdrawButton;
}

///乐分转账
- (UIButton *)scoretransferButton
{
    if(!_scoretransferButton){
        _scoretransferButton = [UIButton createButtonWithTitle:HenLocalizedString(@"转账") backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onScoreTransferAction:)];
        _scoretransferButton.titleLabel.font = kFontSize_36;
        [_scoretransferButton setTitleClor:kFontColorWhite];
    }
    return _scoretransferButton;
}


 ///乐转账
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



///乐分类型选择
- (QL_CustomSegmentView *)leScoreSegmentView
{
    if(!_leScoreSegmentView){
        _leScoreSegmentView = [[QL_CustomSegmentView alloc] initWithHeight:HEIGHT_TRANSFORMATION(70)];
        _leScoreSegmentView.delegate = self;
        
    }
    return _leScoreSegmentView;
}
@end
