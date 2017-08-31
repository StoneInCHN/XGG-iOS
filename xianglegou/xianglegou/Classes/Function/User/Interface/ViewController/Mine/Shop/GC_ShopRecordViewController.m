//
//  GC_ShopRecordViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/11.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  店铺录单 -界面
//

#import "GC_ShopRecordViewController.h"
#import "GC_ChecklistShoppingCartViewController.h"
#import "GC_PayMoneyViewController.h"
#import "QL_MineShopViewController.h"

#import "QL_OrderManagerViewController.h"

#import "GC_ShopRecordItemTableViewCell.h"

#import "GC_ShopManagetViewModel.h"

@interface GC_ShopRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
///TableView
@property (nonatomic, weak) UITableView *tableView;

///底部View
@property (nonatomic, weak) UIView *bottomView;

///购物车 按钮
@property (nonatomic, weak) UIButton *shoppingCarButton;
///购物数量
@property (nonatomic, weak) UILabel *numberLabel;

///加入购物车 按钮
@property (nonatomic, weak) UIButton *addShoppingCarButton;
///立即录单 按钮
@property (nonatomic, weak) UIButton *checklistButton;



///DataSource
@property (nonatomic, strong) NSMutableArray *dataSource;

///ViewModel
@property (nonatomic, strong) GC_ShopManagetViewModel *viewModel;

//消费金额
@property (nonatomic, strong) NSString *xfPrice;
/// 让利金额
@property (nonatomic, strong) NSString *rebeatPrice;

///商户ID
@property (nonatomic, strong) NSString *sellerId;

///选择view
@property(nonatomic, strong) Hen_CustomPickerView *pickerView;
///折扣数据
@property(nonatomic, strong) NSMutableArray<Hen_CustomPickerModel *> *discountArray;

///折扣
@property (nonatomic, strong) NSString *sellerDiscount;
@end

@implementation GC_ShopRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNavigationItem];
    [self loadSubView];
   
    
    ///[self.tableView.header beginRefreshingForWaitMoment];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [self loadCurrentSellerInfoData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onGoBackClick:(id)sender
{
    if([DATAMODEL.interfaceSource isEqualToString:@"4"]){  //店铺录单
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:QL_MineShopViewController.class]){
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
    self.navigationItem.title = HenLocalizedString(@"店铺录单");
    
    UIBarButtonItem *rightBar = [UIBarButtonItem createBarButtonItemWithTitle:@"订单" titleColor:kFontColorWhite target:self action:@selector(onOrderManageAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

///加载子视图
-(void)loadSubView
{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(98));
    }];
    
    CGFloat carWidth = kMainScreenWidth / 3 - WIDTH_TRANSFORMATION(36);
    CGFloat reWidth = kMainScreenWidth - carWidth;
    
    
    [self.shoppingCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(carWidth);
    }];
    
    [self.addShoppingCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shoppingCarButton.mas_right);
        make.top.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(reWidth / 2);
    }];
    
    [self.checklistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addShoppingCarButton.mas_right);
        make.top.right.bottom.equalTo(self.bottomView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

///加载录单自动填充商户信息
-(void)loadCurrentSellerInfoData
{
    //参数
    //用户ID
    [self.viewModel.getCurrentSellerInfoParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    
    //用户token
    [self.viewModel.getCurrentSellerInfoParam setObject:DATAMODEL.token forKey:@"token"];
    
    WEAKSelf;
    [self.viewModel getCurrentSellerInfoWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            
            //加入购物车 商户ID
            [weakSelf.viewModel.addOrderCartParam setObject:weakSelf.viewModel.getCurrentSellerInfoData.id forKey:@"sellerId"];
            //录单 商户ID
            [weakSelf.viewModel.generateSellerOrderParam setObject:weakSelf.viewModel.getCurrentSellerInfoData.id forKey:@"sellerId"];
            
            weakSelf.sellerId = weakSelf.viewModel.getCurrentSellerInfoData.id;
            //加入购物车 折扣
            [weakSelf.viewModel.addOrderCartParam setObject:weakSelf.viewModel.getCurrentSellerInfoData.discount forKey:@"sellerDiscount"];
            //录单 折扣
            [weakSelf.viewModel.generateSellerOrderParam setObject:weakSelf.viewModel.getCurrentSellerInfoData.discount forKey:@"sellerDiscount"];
            weakSelf.sellerDiscount = weakSelf.viewModel.getCurrentSellerInfoData.discount;
            NSString *cartCount=[NSString stringWithFormat:@"购物车(%@)",weakSelf.viewModel.getCurrentSellerInfoData.cartCount];
            weakSelf.numberLabel.text =cartCount ;
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf showHint:desc];
        }
    }];
}


///录单根据手机号获取消费者信息
- (void)loadUserInfoByMobileData
{
    //参数
    [self.viewModel.userInfoByMobileParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.userInfoByMobileParam setObject:DATAMODEL.token forKey:@"token"];
    
    WEAKSelf;
    [self.viewModel getUserInfoByMobileDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            //加入购物车 消费者 ID
            [weakSelf.viewModel.addOrderCartParam setObject:weakSelf.viewModel.userInfoByMobileData.id forKey:@"entityId"];
            //录单 消费者ID
            [weakSelf.viewModel.generateSellerOrderParam setObject:weakSelf.viewModel.userInfoByMobileData.id forKey:@"entityId"];
            
            
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.viewModel setUserInfoByMobileData:nil];
            
            //加入购物车 消费者 ID
            [weakSelf.viewModel.addOrderCartParam setObject:weakSelf.viewModel.userInfoByMobileData.id forKey:@"entityId"];
            //录单 消费者ID
            [weakSelf.viewModel.generateSellerOrderParam setObject:weakSelf.viewModel.userInfoByMobileData.id forKey:@"entityId"];
            
            [weakSelf.tableView reloadData];
            
            [weakSelf showHint:desc];
        }
    }];
    
    
}


#pragma mark -- action

///订单
- (void)onOrderManageAction:(id)sender
{
    QL_OrderManagerViewController *omVC = [[QL_OrderManagerViewController alloc] init];
    omVC.hidesBottomBarWhenPushed = YES;
    omVC.navCurrentItem=1;
    omVC.shopInfoData = self.shopInfoData;
    [self.navigationController pushViewController:omVC animated:YES];
}

///购物车
- (void)onShoppingCarAction:(UIButton *)sender
{
    GC_ChecklistShoppingCartViewController *cscVC = [[GC_ChecklistShoppingCartViewController alloc] init];
    cscVC.hidesBottomBarWhenPushed = YES;
    cscVC.shopInfoData = self.shopInfoData;
    cscVC.sellerId = self.sellerId;
    [self.navigationController pushViewController:cscVC animated:YES];
}
///加入购物车
- (void)onAddShoppingCarAction:(UIButton *)sender
{
    
    
    
    if(((NSString *)[self.viewModel.addOrderCartParam objectForKey:@"amount"]).length <= 0){
        [self showHint:@"资料未填写完整！"];
        return;
    }
    
    if(((NSString*)[self.viewModel.userInfoByMobileParam objectForKey:@"cellPhoneNum"]).length <= 0){
        [self showHint:@"资料未填写完整！"];
        return;
    }
    
    
    if(((NSString *)[self.viewModel.addOrderCartParam objectForKey:@"entityId"]).length <= 0){
        [self showHint:@"资料未填写完整！"];
        return;
    }
    
    
    if([self.xfPrice floatValue] <= 0 || self.xfPrice.length <= 0){
        [self showHint:@"消费金额不能小于0.01元！"];
        return;
    }
    
    
    //参数
    //用户ID
    [self.viewModel.addOrderCartParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //TOken
    [self.viewModel.addOrderCartParam setObject:DATAMODEL.token forKey:@"token"];
    
    WEAKSelf;
    [self.viewModel setAddOrderCartDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        
        if([code isEqualToString:@"0000"]){
            weakSelf.numberLabel.text = weakSelf.viewModel.addOrderCartData.count;
        }else{
            [weakSelf showHint:desc];
        }
        
    }];
}
///录入
- (void)onChecklistAction:(UIButton *)sender
{
    if(((NSString*)[self.viewModel.userInfoByMobileParam objectForKey:@"cellPhoneNum"]).length <= 0){
        [self showHint:@"资料未填写完整！"];
        return;
    }
    
    if(((NSString *)[self.viewModel.generateSellerOrderParam objectForKey:@"amount"]).length <= 0){
        [self showHint:@"资料未填写完整！"];
        return;
    }
    
    
    if(((NSString *)[self.viewModel.generateSellerOrderParam objectForKey:@"entityId"]).length <= 0){
        [self showHint:@"资料未填写完整！"];
        return;

    }
    
    
    if([self.xfPrice floatValue] <= 0 || self.xfPrice.length <= 0){
        [self showHint:@"消费金额不能小于0.01元！"];
        return;
    }
    
    
    //参数
    [self.viewModel.generateSellerOrderParam setObject:DATAMODEL.userInfoData.id    forKey:@"userId"];
    [self.viewModel.generateSellerOrderParam setObject:DATAMODEL.token forKey:@"token"];

    WEAKSelf;
    [self.viewModel setGenerateSellerOrderDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            GC_PayMoneyViewController *payVC = [[GC_PayMoneyViewController alloc] init];
            payVC.hidesBottomBarWhenPushed = YES;
            payVC.shopInfoData = weakSelf.shopInfoData;
            payVC.sellerId = weakSelf.sellerId;
            payVC.sn = weakSelf.viewModel.generateSellerOrderData.orderSn;
            payVC.amount = weakSelf.rebeatPrice;
            payVC.goodsName = weakSelf.viewModel.getCurrentSellerInfoData.name;
            [weakSelf.navigationController pushViewController:payVC animated:YES];
            
        }else{
            [weakSelf showHint:desc];
        }
    }];
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    
    
    GC_ShopRecordItemTableViewCell *cell = [GC_ShopRecordItemTableViewCell cellWithTableView:tableView];
    cell.titleInfo = title;
    [cell setNextImageHidden:YES];
    [cell setClearButtonHidden:YES];
    if([title isEqualToString:@"店铺名称"]){
        cell.contentInfo = self.viewModel.getCurrentSellerInfoData.name;
    }else if([title isEqualToString:@"店铺地址"]){
        cell.contentInfo = self.viewModel.getCurrentSellerInfoData.address;
    }else if([title isEqualToString:@"店铺法人"]){
        cell.contentInfo = self.viewModel.getCurrentSellerInfoData.realName;
    }else if([title isEqualToString:@"消费者手机号"]){
        [cell setTextFieldHidden:NO];
        [cell setTextFieldUserInteractionEnabled:YES];
        cell.placeholder = @"手机号";
        cell.inputInfo = self.viewModel.userInfoByMobileData.cellPhoneNum;
        
        [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
        
        WEAKSelf;
        cell.onInputTextFieldBlock = ^(NSString *inputStr) {
            [weakSelf.viewModel.userInfoByMobileParam setObject:inputStr forKey:@"cellPhoneNum"];
            [weakSelf loadUserInfoByMobileData];
        };
    }else if([title isEqualToString:@"消费者昵称"]){
        [cell setTextFieldHidden:NO];
        [cell setTextFieldUserInteractionEnabled:NO];
        cell.placeholder = @"输入手机号后自动获取不可修改";
        cell.inputInfo = self.viewModel.userInfoByMobileData.nickName;
        
    }else if([title isEqualToString:@"消费者姓名"]){
        [cell setTextFieldHidden:NO];
        [cell setTextFieldUserInteractionEnabled:NO];
        cell.placeholder = @"消费者姓名";
        cell.inputInfo = self.viewModel.userInfoByMobileData.realName;
        
        if(self.viewModel.userInfoByMobileData.realName.length <= 0){
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
    }else if([title isEqualToString:@"消费金额"]){
        [cell setTextFieldHidden:NO];
        cell.placeholder = @"消费金额";
        [cell setTextFieldForKeyboardType:UIKeyboardTypeDecimalPad];
        
        WEAKSelf;
        cell.onInputTextFieldBlock = ^(NSString *inputStr) {
            //加入购物车 金额
            [weakSelf.viewModel.addOrderCartParam setObject:inputStr forKey:@"amount"];
            //录单 金额
            [weakSelf.viewModel.generateSellerOrderParam setObject:inputStr forKey:@"amount"];
            
            weakSelf.xfPrice = inputStr;
            
            [weakSelf.tableView reloadData];
        };
        
    }else if([title isEqualToString:@"商家折扣"]){
        [cell setNextImageHidden:NO];
        cell.contentInfo = [NSString stringWithFormat:@"%@折",self.sellerDiscount];
        
    }else if([title isEqualToString:@"让利金额"]){
        
        [cell setTextFieldHidden:NO];
        [cell setTextFieldUserInteractionEnabled:NO];
        cell.placeholder = @"自动计算不可修改";
        if(self.xfPrice.length > 0){
            double rlMoney = (1 - [self.sellerDiscount doubleValue] * 0.1) * [self.xfPrice doubleValue];

            NSString *money = [NSString stringWithFormat:@"%f",rlMoney];
            self.rebeatPrice = [NSString stringWithFormat:@"%0.2f",rlMoney];
            cell.inputInfo = [DATAMODEL.henUtil string:money showDotNumber:2];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    if([title isEqualToString:@"消费者姓名"]){
        if(self.viewModel.userInfoByMobileData.realName.length <= 0){
            return CGFLOAT_MIN;
        }
        return [GC_ShopRecordItemTableViewCell getCellHeight];
    }
    return [GC_ShopRecordItemTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSMutableArray*)self.dataSource[section]).count;
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
    return HEIGHT_TRANSFORMATION(10);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    if([title isEqualToString:@"商家折扣"]){
        [self selectDiscount];
    }
}


///选择折扣
- (void)selectDiscount
{
    WEAKSelf;
    [self.pickerView showPickerViewWithDataSource:@[self.discountArray] unitArray:nil];
    [self.pickerView setFirstSelectedBy:@[self.sellerDiscount]];
    //回调
    self.pickerView.onCustomPickerSelectBlock = ^(NSMutableDictionary *selectedDict){
        Hen_CustomPickerModel *model = selectedDict[@"0"];
        //加入购物车 折扣
        [weakSelf.viewModel.addOrderCartParam setObject:model.itemId forKey:@"sellerDiscount"];
        //录单 折扣
        [weakSelf.viewModel.generateSellerOrderParam setObject:model.itemId forKey:@"sellerDiscount"];
        weakSelf.sellerDiscount = model.itemId;
        
        [weakSelf.tableView reloadData];
    };
}



#pragma mark -- getter,setter
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        tableView.backgroundColor = kCommonBackgroudColor;
        tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///底部View
- (UIView *)bottomView
{
    if(!_bottomView){
        UIView *view = [[UIView alloc] init];
        UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
        [view addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view);
            make.left.right.equalTo(view);
        }];
        [self.view addSubview:_bottomView = view];
    }
    return _bottomView;
}

///购物车 按钮
- (UIButton *)shoppingCarButton
{
    if(!_shoppingCarButton){
        UIButton *button = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onShoppingCarAction:)];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#F3F3F3"]];
        [self.view addSubview:_shoppingCarButton = button];
        
        UIImageView *carImage = [UIImageView createImageViewWithName:@"public_shopping_cart"];
        [button addSubview:carImage];
        [carImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(12));
        }];
        
        UILabel *label = [UILabel createLabelWithText:@"购物车(3564)" font:kFontSize_22 textColor:kFontColorBlack];
        [button addSubview:_numberLabel = label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(carImage.mas_bottom).offset(HEIGHT_TRANSFORMATION(5));
            make.centerX.equalTo(button);
        }];
    }
    return _shoppingCarButton;
}


///加入购物车
- (UIButton *)addShoppingCarButton
{
    if(!_addShoppingCarButton){
        UIButton *button = [UIButton createButtonWithTitle:@"加入购物车" backgroundNormalImage:@"public_botton_small_cart1" backgroundPressImage:@"public_botton_small_cart1_press" target:self action:@selector(onAddShoppingCarAction:)];
        
        button.titleLabel.font = kFontSize_36;
        [button setTitleClor:kFontColorWhite];
        [self.view addSubview:_addShoppingCarButton = button];
    }
    return _addShoppingCarButton;
}

///立即录单
- (UIButton *)checklistButton
{
    if(!_checklistButton){
        UIButton *button = [UIButton createButtonWithTitle:@"立即录单" backgroundNormalImage:@"public_botton_small_cart" backgroundPressImage:@"public_botton_small_cart_press" target:self action:@selector(onChecklistAction:)];
        button.titleLabel.font = kFontSize_36;
        [button setTitleClor:kFontColorWhite];
        [self.view addSubview:_checklistButton = button];
    }
    return _checklistButton;
}

- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataSource addObjectsFromArray:@[@[@"店铺名称",@"店铺地址",@"店铺法人"],@[@"消费者手机号",@"消费者昵称",@"消费者姓名"],@[@"消费金额",@"商家折扣",@"让利金额"]]];
    }
    return _dataSource;
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

///选择view
- (Hen_CustomPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[Hen_CustomPickerView alloc] init];
    }
    return _pickerView;
}

///折扣数据
- (NSMutableArray<Hen_CustomPickerModel *> *)discountArray
{
    if(!_discountArray){
        _discountArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for(NSInteger i = 1; i < 21; i++){
            CGFloat temp = 10.0 - i * 0.1;
            Hen_CustomPickerModel *model = [[Hen_CustomPickerModel alloc] initWithDictionary:@{}];
            model.itemId = [NSString stringWithFormat:@"%0.1f", temp];
            model.name = [NSString stringWithFormat:@"%0.1f折", temp];
            [_discountArray addObject:model];
        }
    }
    return _discountArray;
}
@end
