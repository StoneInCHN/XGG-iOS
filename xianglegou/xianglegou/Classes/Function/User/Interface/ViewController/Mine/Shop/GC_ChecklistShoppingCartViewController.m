//
//  GC_ChecklistShoppingCartViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/12.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  录单购物车 -- cell
//


#import "GC_ChecklistShoppingCartViewController.h"
#import "GC_PayMoneyViewController.h"


#import "GC_ChecklistShoppingCartTableViewCell.h"
#import "GC_ShopManagetViewModel.h"


@interface GC_ChecklistShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource>
///TableView
@property (nonatomic, weak) UITableView *tableView;
///底部View
@property (nonatomic, weak) UIView *bottomView;

///复选框
@property (nonatomic, weak) UIButton *checkBoxButton;
///合计
@property (nonatomic, weak) UILabel *totalLabel;
///合计 金额
@property (nonatomic, weak) UILabel *totalMoneyLabel;
///支付按钮
@property (nonatomic, weak) UIButton *payButton;



///ViewModel
@property (nonatomic, strong) GC_ShopManagetViewModel *viewModel;


///购物车 ID集合
@property (nonatomic, strong) NSMutableArray *entityIdsArray;

///购物车 id
@property (nonatomic, strong) NSString *entityId;
@end

@implementation GC_ChecklistShoppingCartViewController

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
    
    [self.entityIdsArray removeAllObjects];
    [self setEntityIdsArray:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    
}
#pragma mark -- private
///加载导航栏信息
-(void)loadNavigationItem{
    self.navigationItem.title = HenLocalizedString(@"录单购物车");
}

///加载子视图
-(void)loadSubView
{
    CGFloat payWidth = kMainScreenWidth / 3 + WIDTH_TRANSFORMATION(18);
    CGFloat viewWidth = kMainScreenWidth - payWidth;
    
    CGFloat totalWidth =  viewWidth / 3 * 2 + WIDTH_TRANSFORMATION(10);
    CGFloat checkWidth = viewWidth - totalWidth;
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(98));
        make.width.mas_equalTo(viewWidth);
    }];
    

    
    [self.checkBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(checkWidth);
    }];

    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkBoxButton.mas_right).offset(FITSCALE(50/2));
        make.centerY.equalTo(self.bottomView);
    }];

    [self.totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalLabel.mas_right);
        make.centerY.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView.mas_right).offset(WIDTH_TRANSFORMATION(-30));
    }];
    
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_right);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(98));
    }];

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
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
        [weakSelf loadDataForStart:weakSelf.viewModel.sellerOrderCartListDatas.count / [NumberOfPages integerValue] + 1 isUpMore:YES];
    }];
    [footer setTitle:HenLocalizedString(@"没有更多的信息！") forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
}

///加载数据
-(void)loadDataForStart:(NSInteger)start isUpMore:(BOOL)isUpMore
{
    //参数
    
    //登录用户ID
    [self.viewModel.sellerOrderCartListParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.sellerOrderCartListParam setObject:DATAMODEL.token forKey:@"token"];
    //分页：每页大小
    [self.viewModel.sellerOrderCartListParam setObject:[NSString stringWithFormat:@"%ld", start] forKey:@"pageNumber"];
    
    WEAKSelf;
    [self.viewModel getSellerOrderCartListDatasWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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
            
            [weakSelf loadSelectedStateDisplay];
            if(weakSelf.viewModel.sellerOrderCartListDatas.count > 0){
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



///全选
-(void)onCheckBoxAction:(UIButton *)sender
{
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    
    for (GC_MResSellerOrderCartListDataModel *model in self.viewModel.sellerOrderCartListDatas) {
        model.isSelected = sender.isSelected;
    }
    
    [self loadSelectedStateDisplay];
    
    [self.tableView reloadData];
    
    
}

///先录单 后支付
- (void)onPayMonyAction:(UIButton *)sender
{
    //参数
    //用户ID
    [self.viewModel.confirmOrderParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    
    //Token
    [self.viewModel.confirmOrderParam setObject:DATAMODEL.token forKey:@"token"];
    //购车项ID集合
    [self.entityIdsArray removeAllObjects];
    for (GC_MResSellerOrderCartListDataModel *model in self.viewModel.sellerOrderCartListDatas) {
        if(model.isSelected){
            [self.entityIdsArray addObject:model.id];
        }
    }
    [self.viewModel.confirmOrderParam setObject:self.entityIdsArray forKey:@"entityIds"];
    
    WEAKSelf;
    //购物车批量录单
    [self.viewModel setConfirmOrderDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            [weakSelf.entityIdsArray removeAllObjects];
            GC_PayMoneyViewController *pmVC = [[GC_PayMoneyViewController alloc] init];
            pmVC.hidesBottomBarWhenPushed = YES;
            pmVC.shopInfoData = weakSelf.shopInfoData;
            pmVC.sellerId = weakSelf.sellerId;
            pmVC.sn = weakSelf.viewModel.confirmOrderData.orderSn;
            pmVC.goodsName = weakSelf.shopInfoData.name;
            pmVC.amount = weakSelf.viewModel.totalRebateAmount;
            [weakSelf.navigationController pushViewController:pmVC animated:YES];
            
        }else{
            [weakSelf showHint:desc];
        }
    }];
    
    
   
}


///加载选中状态显示
- (void)loadSelectedStateDisplay
{
    ///选中个数
    NSInteger selectedNum = 0;
    CGFloat orderPrice = 0;
    CGFloat totalRebateAmount = 0;
    for (GC_MResSellerOrderCartListDataModel *model in self.viewModel.sellerOrderCartListDatas) {
        if(model.isSelected){
            selectedNum ++ ;
            orderPrice = [model.amount floatValue] + orderPrice;
            totalRebateAmount = [model.rebateAmount floatValue] + totalRebateAmount;
        }
    }
    if(selectedNum > 0){
        [self.payButton setTitle:[NSString stringWithFormat:@"支付（%ld）",selectedNum]];
    }else{
        [self.payButton setTitle:@"支付"];
    }
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f",orderPrice];
    self.viewModel.totalRebateAmount = [NSString stringWithFormat:@"%0.2f",totalRebateAmount];
    if(selectedNum == self.viewModel.sellerOrderCartListDatas.count){
        [self.checkBoxButton setSelected:YES];
    }else{
        [self.checkBoxButton setSelected:NO];
    }
    
}


///删除 操作
- (void)onDeleteSellerOrderCart
{
    //参数
    //登录用户ID
    [self.viewModel.deleteSellerOrderCartParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.deleteSellerOrderCartParam setObject:DATAMODEL.token forKey:@"token"];
    
    WEAKSelf;
    [self.viewModel setDeleteSellerOrderCartDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            [weakSelf.entityIdsArray removeAllObjects];
            [weakSelf.tableView.header beginRefreshingForWaitMoment];
            [weakSelf showHint:@"删除 录单购物车 信息成功！！！"];
        }else{
            [weakSelf showHint:desc];
        }
    }];
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GC_ChecklistShoppingCartTableViewCell *cell = [GC_ChecklistShoppingCartTableViewCell cellWithTableView:tableView];
    cell.topLongLineImage.hidden = NO;
    cell.bottomLongLineImage.hidden = NO;
    
    
    GC_MResSellerOrderCartListDataModel *model = self.viewModel.sellerOrderCartListDatas[indexPath.section];
    
    [cell updateUiForSellerOrderCartListData:model];
    
    WEAKSelf;           //选中按钮 回调
    cell.onIsSelectedBlock = ^(BOOL isSelected, NSInteger item) {
        model.isSelected = isSelected;
        [weakSelf loadSelectedStateDisplay];
        [weakSelf.tableView reloadData];
    };
    
    //删除 按钮回调
    cell.onDeletedUIButtonBlock = ^(NSInteger item, NSString *orderId) {
        weakSelf.entityId = orderId;
        [weakSelf.entityIdsArray removeAllObjects];
        [weakSelf.entityIdsArray addObject:orderId];
        [weakSelf.viewModel.deleteSellerOrderCartParam setObject:weakSelf.entityIdsArray forKey:@"entityIds"];
        
        
        [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要删除吗？删除后不可恢复！"];
        
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
                [weakSelf onDeleteSellerOrderCart];
            }
        }];
        
    };
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_ChecklistShoppingCartTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.sellerOrderCartListDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return [self tableViewHeaderViewForTitle:@"录单只需要支付让利款。"];
    }
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return HEIGHT_TRANSFORMATION(66);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(8);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -- getter,setter
///TableView
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

///底部 View
- (UIView *)bottomView
{
    if(!_bottomView){
        UIView *view = [UIView createViewWithBackgroundColor:[UIColor colorWithHexString:@"#F3F3F3"]];
        UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
        [view addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(view);
        }];
        [self.view addSubview:_bottomView = view];
    }
    return _bottomView;
}

///复选框
- (UIButton *)checkBoxButton
{
    if(!_checkBoxButton){
        
        CGFloat payWidth = kMainScreenWidth / 3 + WIDTH_TRANSFORMATION(18);
        CGFloat viewWidth = kMainScreenWidth - payWidth;
        
        CGFloat totalWidth =  viewWidth / 3 * 2 + WIDTH_TRANSFORMATION(10);
        CGFloat checkWidth = viewWidth - totalWidth;
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置button正常状态下的图片
        [button setImage:[UIImage imageNamed:@"public_remind_select"] forState:UIControlStateNormal];
        //设置button高亮状态下的图片
        [button setImage:[UIImage imageNamed:@"public_remind_select_choose"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"public_remind_select_choose"] forState:UIControlStateSelected];
        
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        button.imageEdgeInsets = UIEdgeInsetsMake((HEIGHT_TRANSFORMATION(98) - HEIGHT_TRANSFORMATION(37)) / 2, FITSCALE(30/2), (HEIGHT_TRANSFORMATION(98) - HEIGHT_TRANSFORMATION(37)) / 2, checkWidth - WIDTH_TRANSFORMATION(37) - FITSCALE(30/2));
        [button setTitle:@"全选" forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        button.titleEdgeInsets = UIEdgeInsetsMake(0, WIDTH_TRANSFORMATION(20), 0, 0);
        //设置button正常状态下的标题颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置button高亮状态下的标题颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        button.titleLabel.font = kFontSize_26;
        
        [button addTarget:self action:@selector(onCheckBoxAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_checkBoxButton = button];
    }
    return _checkBoxButton;
}

///合计
- (UILabel *)totalLabel
{
    if(!_totalLabel){
        UILabel *label = [UILabel createLabelWithText:@"合计：" font:kFontSize_26];
        [self.view addSubview:_totalLabel = label];
    }
    return _totalLabel;
}

///合计 金额
- (UILabel *)totalMoneyLabel
{
    if(!_totalMoneyLabel){
        UILabel *label = [UILabel createLabelWithText:@"￥0.00" font:kFontSize_28 textColor:kFontColorRed];
        [self.view addSubview:_totalMoneyLabel = label];
    }
    return _totalMoneyLabel;
}


///支付
- (UIButton *)payButton
{
    if(!_payButton){
        UIButton *button = [UIButton createButtonWithTitle:@"支付" backgroundNormalImage:@"public_botton_small_cart" backgroundPressImage:@"public_botton_small_cart_press" target:self action:@selector(onPayMonyAction:)];
        button.titleLabel.font = kFontSize_36;
        [button setTitleClor:kFontColorWhite];
        [self.view addSubview:_payButton = button];
    }
    return _payButton;
}

-(UIView*)tableViewHeaderViewForTitle:(NSString*)title
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(66)) backgroundColor:kCommonBackgroudColor];
    
    
    UILabel *titleLabel = [UILabel createLabelWithText:HenLocalizedString(title) font:kFontSize_24 textColor:kFontColorGray];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
    return view;
}

- (GC_ShopManagetViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_ShopManagetViewModel alloc] init];
    }
    return _viewModel;
}

///购物车 ID集合
- (NSMutableArray *)entityIdsArray
{
    if(!_entityIdsArray){
        _entityIdsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _entityIdsArray;
}

- (void)setSellerId:(NSString *)sellerId
{
    _sellerId = sellerId;
    
    //商户ID
    [self.viewModel.confirmOrderParam setObject:sellerId forKey:@"entityId"];
}
@end

