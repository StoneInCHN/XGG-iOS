//
//  QL_UserOrderDetailsViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_UserOrderDetailsViewController.h"
#import "QL_UserOrderDetailsTableViewCell.h"

#import "QL_UserPublishCommentViewController.h"
#import "QL_UserCommentDetailsViewController.h"
#import "QL_MineOrderViewController.h"

@interface QL_UserOrderDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;
///查看评价按钮
@property(nonatomic, weak) UIButton *lookCommentButton;

@end

@implementation QL_UserOrderDetailsViewController

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
}

- (void)onGoBackClick:(id)sender
{
    if(self.enterType == 1){
        [self goBackMineOrder];
    }else{
        [super onGoBackClick:sender];
    }
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = HenLocalizedString(@"订单详情");
    
    self.view.backgroundColor = kCommonBackgroudColor;
    [self.lookCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.lookCommentButton.mas_top);
    }];
    //下拉刷新
    WEAKSelf;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf loadData];
    }];
}

///加载数据
- (void)loadData
{
    if(self.orderData){
        [self.tableView.header endRefreshing];
        if(self.orderData.evaluate.content.length <= 0 || [self.orderData.evaluate.content isEqualToString:@""]){
            [self.lookCommentButton setTitle:@"立即评价"];
        }else{
            [self.lookCommentButton setTitle:@"查看评价"];
        }
        self.lookCommentButton.hidden = NO;
        
        if([self.orderData.status isEqualToString:@"UNPAID"]){        //未支付
            self.lookCommentButton.hidden = YES;
        }
        
        [self.tableView reloadData];
    }else{
        //参数
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
        [param setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
        [param setObject:DATAMODEL.token forKey:@"token"];
        [param setObject:self.orderId forKey:@"entityId"];
        //请求
        WEAKSelf;
        [[Hen_MessageManager shareMessageManager] requestWithAction:@"/rebate-interface/order/detail.jhtml" dictionaryParam:param withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            //取消加载
            [weakSelf.tableView.header endRefreshing];
            if([code isEqualToString:@"0000"]){ // 成功
                weakSelf.orderData = [[GC_MResOrderUnderUserDataModel alloc] initWithDictionary:msg];
                
                if(weakSelf.orderData.evaluate.content.length <= 0 || [weakSelf.orderData.evaluate.content isEqualToString:@""]){
                    [weakSelf.lookCommentButton setTitle:@"立即评价"];
                }else{
                    [weakSelf.lookCommentButton setTitle:@"查看评价"];
                }
                weakSelf.lookCommentButton.hidden = NO;
                if([weakSelf.orderData.status isEqualToString:@"UNPAID"]){        //未支付
                    weakSelf.lookCommentButton.hidden = YES;
                }
                [weakSelf.tableView reloadData];
            }else{
                //提示
                [weakSelf showHint:desc];
            }
        }];
    }
}

///返回我的订单
-(void)goBackMineOrder
{
    QL_MineOrderViewController *moVC = [[QL_MineOrderViewController alloc] init];
    moVC.hidesBottomBarWhenPushed = YES;
    moVC.enterType = self.enterType;
    
    [self.navigationController pushViewController:moVC animated:YES];
}

#pragma mark -- event response

///查看评价
- (void)onLookCommentAction:(UIButton *)sender
{
    
    if(self.orderData.evaluate.content.length <= 0 || [self.orderData.evaluate.content isEqualToString:@""]){
        //发表评价
        QL_UserPublishCommentViewController *upcVC = [[QL_UserPublishCommentViewController alloc] init];
        upcVC.hidesBottomBarWhenPushed = YES;
        upcVC.orderData = self.orderData;
        WEAKSelf;
        upcVC.onPublishedSuccessBlock = ^(){
            weakSelf.orderData.evaluate.content = @"0000";
            [weakSelf.lookCommentButton setTitle:@"查看评价"];
            
        };
        [self.navigationController pushViewController:upcVC animated:YES];
    }else{
        //评价详情
        QL_UserCommentDetailsViewController *ucdVC = [[QL_UserCommentDetailsViewController alloc] init];
        ucdVC.hidesBottomBarWhenPushed = YES;
        ucdVC.orderData = self.orderData;
        [self.navigationController pushViewController:ucdVC animated:YES];
    }
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.orderData){
        return 1;
    }
    return 0;
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
    
    [cell setUpdateUiForOrderUnderUserData:self.orderData];
    
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
- (UIButton *)lookCommentButton
{
    if(!_lookCommentButton){
        UIButton *button = [UIButton createButtonWithTitle:@"查看评价" backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onLookCommentAction:)];
        [button setTitleClor:kFontColorWhite];
        button.hidden = YES;
        button.titleLabel.font = kFontSize_36;
        [self.view addSubview:_lookCommentButton = button];
    }
    return _lookCommentButton;
}

@end
