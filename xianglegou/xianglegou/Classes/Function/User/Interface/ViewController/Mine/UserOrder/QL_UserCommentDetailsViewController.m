//
//  QL_UserCommentDetailsViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_UserCommentDetailsViewController.h"
#import "QL_UPCInfoTableViewCell.h"
#import "QL_UPCInputCommentTableViewCell.h"
#import "QL_UCDBusinessCommentTableViewCell.h"

#import "GC_OrderUnderUserViewModel.h"

@interface QL_UserCommentDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;

///View Model
@property (nonatomic, strong) GC_OrderUnderUserViewModel *viewModel;
@end

@implementation QL_UserCommentDetailsViewController

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



#pragma mark -- override

///清除数据
- (void)cleanUpData
{
    [self setViewModel:nil];
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
}

- (void)onGoBackClick:(id)sender
{
    if(self.publicState == 1){
        [self.navigationController popViewControllerAnimated:NO];
        if(self.onBackClickBlock){
            self.onBackClickBlock();
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = HenLocalizedString(@"评价详情");
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}

///加载列表数据
- (void)loadTableView
{
    WEAKSelf;
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadEvaluateByOrderData];
    }];
}

///加载评价详情 数据
-(void)loadEvaluateByOrderData
{
    //参数
    //用户id
    self.viewModel.evaluateByOrderParam.userId = DATAMODEL.userInfoData.id;
    //Token
    self.viewModel.evaluateByOrderParam.token = DATAMODEL.token;
    //订单ID
    self.viewModel.evaluateByOrderParam.entityId = self.orderData.id;
    ////self.viewModel.evaluateByOrderParam.entityId = @"7";
    WEAKSelf;
    //请求
    [self.viewModel getEvaluateByOrderDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        
        if([code isEqualToString:@"0000"]){
            [weakSelf.tableView reloadData];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}



#pragma mark -- event response

/////发表评价
//- (void)onPublishCommentAction:(UIButton *)sender
//{
//    
//}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    if(indexPath.section == 0){ // 信息
        QL_UPCInfoTableViewCell *cell = [QL_UPCInfoTableViewCell cellWithTableView:tableView];
        
        
        cell.isEdit = NO;
        
        [cell setUpdateUiForOrderUnderUserData:self.orderData];
        
        cell.score = self.viewModel.evaluateByOrderData.score;
        
        
        return cell;
    }else if(indexPath.section == 1){ // 评价输入
        QL_UPCInputCommentTableViewCell *cell = [QL_UPCInputCommentTableViewCell cellWithTableView:tableView];
        
        cell.isEdit = NO;
        
        [cell updateUIForCommentContent:self.viewModel.evaluateByOrderData.content images:self.viewModel.evaluateByOrderData.evaluateImages];
        
        return cell;
    }else if(indexPath.section == 2){ // 商家回复
        QL_UCDBusinessCommentTableViewCell *cell = [QL_UCDBusinessCommentTableViewCell cellWithTableView:tableView];
        
        cell.sellerReplyInfo = self.viewModel.evaluateByOrderData.sellerReply;
        return cell;
    }
    
    return nil;
}

#pragma mark -- getter,setter

///内容
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(460)];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///View Model
- (GC_OrderUnderUserViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_OrderUnderUserViewModel alloc] init];
    }
    return _viewModel;
}
@end
