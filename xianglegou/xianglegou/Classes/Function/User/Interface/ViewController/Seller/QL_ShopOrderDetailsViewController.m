//
//  QL_UserOrderDetailsViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_ShopOrderDetailsViewController.h"
#import "QL_UserOrderDetailsTableViewCell.h"

#import "QL_UserPublishCommentViewController.h"
#import "QL_UserCommentDetailsViewController.h"
#import "GC_ShopOrderCommentViewController.h"
#import "GC_PayMoneyViewController.h"
#import "QL_OrderManagerViewModel.h"

@interface QL_ShopOrderDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;
///查看评价按钮
@property(nonatomic, weak) UIButton *commentButton;
///联系电话按钮
@property(nonatomic, weak) UIButton *phoneButton;

///删除订单
@property (nonatomic, weak) UIButton *delOrderButton;
///立即支付
@property (nonatomic, weak) UIButton *payButton;

///评价状态 1:待回复，2：已回复
@property(nonatomic, assign) NSInteger commentStatus;

///ViewModel
@property (nonatomic, strong) QL_OrderManagerViewModel *viewModel;
@end

@implementation QL_ShopOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    //[self.tableView.header beginRefreshingForWaitMoment];
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

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = HenLocalizedString(@"订单详情");
    self.view.backgroundColor = kCommonBackgroudColor;
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(OffSetToLeft);
        make.right.equalTo(self.view.mas_centerX).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
        make.bottom.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(-12));
    }];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(OffSetToRight);
        make.left.equalTo(self.view.mas_centerX).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
        make.bottom.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(-12));
    }];
    
    
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(OffSetToRight);
        make.left.equalTo(self.view.mas_centerX).offset(POSITION_WIDTH_FIT_TRANSFORMATION(20));
        make.bottom.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(-12));
    }];
    
    
    [self.delOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(OffSetToLeft);
        make.right.equalTo(self.view.mas_centerX).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
        make.bottom.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(-12));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.phoneButton.mas_top);
    }];
    
    [self loadData];
}

///加载数据
- (void)loadData
{
    if(self.orderData){
        self.commentStatus = 1;
        
        
        self.phoneButton.hidden = NO;
        self.commentButton.hidden = NO;
        
        if([self.orderData.status isEqualToString:@"UNPAID"]){          //未支付
            if([self.orderData.isSallerOrder isEqualToString:@"1"]){    //录单订单
                self.phoneButton.hidden = YES;
                self.commentButton.hidden = YES;
                self.delOrderButton.hidden = NO;
                self.payButton.hidden = NO;
            }else{
                self.phoneButton.hidden = YES;
                self.commentButton.hidden = YES;
            }
        }
        
        
        
        
        if([self.orderData.status isEqualToString:@"FINISHED"]){
            self.commentButton.hidden = NO;
            
            if([self.orderData.evaluate.sellerReply isEqualToString:@""]){
                self.commentStatus = 1;
                [self.commentButton setTitle:@"立即回复"];
            }else{
                self.commentStatus = 2;
                [self.commentButton setTitle:@"查看回复"];
            }
        }else{
            self.commentButton.hidden = YES;
        }
    }
}

#pragma mark -- event response

///查看评价
- (void)onButtonAction:(UIButton *)sender
{
    if(sender.tag == 0){
        if(self.commentStatus == 1){//立即回复
            GC_ShopOrderCommentViewController *scVC = [[GC_ShopOrderCommentViewController alloc] init];
            scVC.hidesBottomBarWhenPushed = YES;
            scVC.orderData = self.orderData;
            scVC.replyState = @"1";
            
            WEAKSelf;
            scVC.onReturnClickBlock = ^(){
                weakSelf.commentStatus = 2;
                [self.commentButton setTitle:@"查看回复"];
            };
            
            [self.navigationController pushViewController:scVC animated:YES];
        }else if(self.commentStatus == 2){ // 查看回复
            //评价详情
            GC_ShopOrderCommentViewController *scVC = [[GC_ShopOrderCommentViewController alloc] init];
            scVC.hidesBottomBarWhenPushed = YES;
            scVC.orderData = self.orderData;
            scVC.replyState = @"2";
            
            [self.navigationController pushViewController:scVC animated:YES];
        }
    }else if(sender.tag == 1){ // 打电话
        [DATAMODEL.henUtil customerPhone:self.orderData.endUser.cellPhoneNum];
    }
    //发表评价
    /*QL_UserPublishCommentViewController *upcVC = [[QL_UserPublishCommentViewController alloc] init];
    upcVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:upcVC animated:YES];*/
    
    
}


///删除订单
- (void)onDelOrderAction:(UIButton *)sender
{
    [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要删除此订单吗？"];
    WEAKSelf;
    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            [weakSelf delSellerUnpaidOrder];
        }
    }];
}


///删除订单
- (void)delSellerUnpaidOrder
{
    [self.viewModel.delSellerUnpaidOrderParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.delSellerUnpaidOrderParam setObject:DATAMODEL.token forKey:@"token"];
    [self.viewModel.delSellerUnpaidOrderParam setObject:self.orderData.id forKey:@"entityId"];
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    [self.viewModel setDelSellerUnpaidOrderDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelf showHint:desc];
        }
    }];
    
}

///立即支付
- (void)onPayOrderAction:(UIButton *)sender
{
    GC_PayMoneyViewController *pmVC = [[GC_PayMoneyViewController alloc] init];
    pmVC.hidesBottomBarWhenPushed = YES;
    
    pmVC.sn = self.orderData.sn;
    [self.navigationController pushViewController:pmVC animated:YES];
    
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    QL_UserOrderDetailsTableViewCell *cell = [QL_UserOrderDetailsTableViewCell cellWithTableView:tableView];
    cell.isClearing = self.isClearing;
    
    [cell updateUIForShopOrderListData:self.orderData];
    [cell setNextImageHidden:YES];
    
    return cell;
}

#pragma mark -- getter,setter

///内容
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

///查看评价按钮
- (UIButton *)commentButton
{
    if(!_commentButton){
        UIButton *button = [UIButton createButtonWithTitle:@"立即回复" backgroundNormalImage:@"public_botton_big_white" backgroundPressImage:@"public_botton_big_white_press" target:self action:@selector(onButtonAction:)];
        button.tag = 0;
        [button setTitleClor:kFontColorRed];
        button.titleLabel.font = kFontSize_36;
        [self.view addSubview:_commentButton = button];
    }
    return _commentButton;
}

///联系电话
- (UIButton *)phoneButton
{
    if(!_phoneButton){
        UIButton *button = [UIButton createButtonWithTitle:@"联系电话" backgroundNormalImage:@"public_botton_big_red" backgroundPressImage:@"public_botton_big_red_press" target:self action:@selector(onButtonAction:)];
        button.tag = 1;
        [button setTitleClor:kFontColorWhite];
        button.titleLabel.font = kFontSize_36;
        [self.view addSubview:_phoneButton = button];
    }
    return _phoneButton;
}


///删除订单
- (UIButton *)delOrderButton
{
    if(!_delOrderButton){
        UIButton *button = [UIButton createButtonWithTitle:@"删除订单" backgroundNormalImage:@"public_botton_big_white" backgroundPressImage:@"public_botton_big_white_press" target:self action:@selector(onDelOrderAction:)];
        [button setTitleClor:kFontColorRed];
        button.titleLabel.font = kFontSize_36;
        
        button.hidden = YES;
        [self.view addSubview:_delOrderButton = button];
    }
    return _delOrderButton;
}

///立即支付
- (UIButton *)payButton
{
    if(!_payButton){
        UIButton *button = [UIButton createButtonWithTitle:@"立即支付" backgroundNormalImage:@"public_botton_big_red" backgroundPressImage:@"public_botton_big_red_press" target:self action:@selector(onPayOrderAction:)];
        [button setTitleClor:kFontColorWhite];
        button.titleLabel.font = kFontSize_36;
        button.hidden = YES;
        [self.view addSubview:_payButton = button];
    }
    return _payButton;
}
- (QL_OrderManagerViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_OrderManagerViewModel alloc] init];
    }
    return _viewModel;
}
@end
