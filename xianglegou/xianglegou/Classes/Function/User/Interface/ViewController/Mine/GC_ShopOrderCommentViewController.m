//
//  GC_ShopOrderCommentViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  商户订单 评论界面
//

#import "GC_ShopOrderCommentViewController.h"
#import "QL_UPCInfoTableViewCell.h"
#import "QL_UPCInputCommentTableViewCell.h"
#import "GC_ShopReplyCommentTableViewCell.h"
#import "GC_ShopOrderCommentViewModel.h"

@interface GC_ShopOrderCommentViewController ()

///TableView
@property (nonatomic, weak) UITableView *tableView;
///回复评论按钮
@property (nonatomic, weak) UIButton *replyCommentButton;

///View Model
@property (nonatomic, strong) GC_ShopOrderCommentViewModel *viewModel;



@end

@implementation GC_ShopOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.s
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


///点击返回按钮
-(void)onGoBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if(self.onReturnClickBlock){
        self.onReturnClickBlock();
    }
}




///加载导航栏信息
-(void)loadNavigationItem
{
    self.navigationItem.title = @"回复评价";
    self.view.backgroundColor = kCommonBackgroudColor;
}

///加载子视图
-(void)loadSubView
{
    [self.replyCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.replyCommentButton.mas_top);
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



///回复评论按钮显示
-(void)loadReplyCommentButtonHidden
{
    if([self.replyState isEqualToString:@"1"]){
        self.navigationItem.title = @"回复评价";
        self.replyCommentButton.hidden = NO;
        [self.replyCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
        }];
    }else if([self.replyState isEqualToString:@"2"]){
        self.navigationItem.title = @"评价详情";
        self.replyCommentButton.hidden = YES;
        [self.replyCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(0));
        }];
    }
}


///加载评价详情 数据
-(void)loadEvaluateByOrderData
{
    
    [self loadReplyCommentButtonHidden];
    //参数
    //用户id
    self.viewModel.evaluateByOrderParam.userId = DATAMODEL.userInfoData.id;
    //Token
    self.viewModel.evaluateByOrderParam.token = DATAMODEL.token;
    //订单ID
    self.viewModel.evaluateByOrderParam.entityId = self.orderData.id;
    
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
///回复评论
-(void)onReplyClickAction:(UIButton*)sender
{
    //参数
    ///////[self.viewModel.sellerReplyParam setObject:@"" forKey:@""];
    //用户ID
    [self.viewModel.sellerReplyParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.sellerReplyParam setObject:DATAMODEL.token forKey:@"token"];
    //订单ID
    [self.viewModel.sellerReplyParam setObject:self.viewModel.evaluateByOrderData.id forKey:@"entityId"];
    //商家回复
    if(((NSString*)[self.viewModel.sellerReplyParam objectForKey:@"sellerReply"]).length <= 0){
        [self showHint:@"回复内容未输入！"];
        return;
    }
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    //请求
    [self.viewModel setSellerReplyDataWithResuleBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            weakSelf.replyState = @"2";
            [weakSelf loadEvaluateByOrderData];
        }
    }];
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){         //用户信息
        QL_UPCInfoTableViewCell *cell = [QL_UPCInfoTableViewCell cellWithTableView:tableView];
        
        cell.isEdit = NO;
        cell.score = self.viewModel.evaluateByOrderData.score;
        [cell setUpdateUiForEvaluateByOrderData:self.viewModel.evaluateByOrderData];
        return cell;
    }else if(indexPath.section == 1){   //用户评价信息
        QL_UPCInputCommentTableViewCell *cell = [QL_UPCInputCommentTableViewCell cellWithTableView:tableView];
        
        cell.isEdit = NO;
        
        [cell updateUIForCommentContent:self.viewModel.evaluateByOrderData.content images:self.viewModel.evaluateByOrderData.evaluateImages];
        
        
        return cell;
    }else if(indexPath.section == 2){   //商家回复
        GC_ShopReplyCommentTableViewCell *cell = [GC_ShopReplyCommentTableViewCell cellWithTableView:tableView];
        
        if([self.replyState isEqualToString:@"1"]){ //未回复
            [cell setSellerReplyInputHidden:NO];
            
            cell.content = [self.viewModel.sellerReplyParam objectForKey:@"sellerReply"];
            
            cell.placeholder = @"请写下对买家的感受吧！";
            
            
            WEAKSelf;
            cell.onInputFinishBlock = ^(NSString *str){
                [weakSelf.viewModel.sellerReplyParam setObject:str forKey:@"sellerReply"];
            };
        }else if([self.replyState isEqualToString:@"2"]){
            [cell setSellerReplyInputHidden:YES];
            
            cell.sellerReplyInfo = self.viewModel.evaluateByOrderData.sellerReply;
        }
        
        return cell;
        
    }
    return nil;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
///TableVIew
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(460)];
        tableView.backgroundColor = kCommonBackgroudColor;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}
///回复评论
- (UIButton *)replyCommentButton
{
    if(!_replyCommentButton){
        UIButton *replyButton = [UIButton createButtonWithTitle:@"回复评价" backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onReplyClickAction:)];
        replyButton.titleLabel.font = kFontSize_36;
        [replyButton setTitleClor:kFontColorWhite];
        replyButton.hidden = YES;
        [self.view addSubview:_replyCommentButton = replyButton];
    }
    return _replyCommentButton;
}


- (GC_ShopOrderCommentViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_ShopOrderCommentViewModel alloc] init];
    }
    return _viewModel;
}
@end
