//
//  GC_WithdrawViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_WithdrawViewController.h"
#import "GC_MineEditPasswordViewController.h"
#import "GC_MineLeBeansScoreViewController.h"
#import "GC_BankInfoWithdrawTableViewCell.h"

#import "GC_MineItemTableViewCell.h"
#import "GC_WDHeadInfoTableViewCell.h"
#import "GC_WithdrawRulesTableViewCell.h"
#import "QL_PayPasswordInputView.h"

#import "GC_MineScoreStatisticsViewModel.h"


@interface GC_WithdrawViewController ()<UITableViewDelegate, UITableViewDataSource>
///Table View
@property (nonatomic, weak) UITableView *tableView;
///信息
@property (nonatomic, strong) NSMutableArray *dataSource;

///确认提现 按钮
@property (nonatomic, weak) UIButton *confirmWithdrawButton;


@property (nonatomic, strong) QL_PayPasswordInputView *payPasswordView;

///ViewModel
@property (nonatomic, strong) GC_MineScoreStatisticsViewModel *viewModel;



///实际到账、
@property (nonatomic, assign) double actualPrice;
@end

@implementation GC_WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubviewConstraints];
    
    [self loadTableView];
    [self.tableView.header beginRefreshingForWaitMoment];
    //获取RSA key
    [DATAMODEL loadRSAPublickey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onGoBackClick:(id)sender
{
    if([DATAMODEL.interfaceSource isEqualToString:@"6"]){   //乐分提现界面
        
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:GC_MineLeBeansScoreViewController.class]){
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
    [self.dataSource removeAllObjects];
    [self setDataSource:nil];
    
    [self setViewModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    [self.payPasswordView removeFromSuperview];
    [self setPayPasswordView:nil];
}

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

///加载navigationBar背景
-(void)loadNavigationBarBackground
{
    
    self.navigationItem.title = @"提现";
    
    [((Hen_BaseNavigationViewController*)self.navigationController) setDefaultBackground];
    [self.navigationController.navigationBar setTintColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarTitleColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarBgColor:[UIColor clearColor]];
    [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:YES];
    [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:YES];
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.confirmWithdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(-64);
        make.bottom.equalTo(self.confirmWithdrawButton.mas_top);
    }];
}


///加载列表数据
-(void)loadTableView
{
    WEAKSelf;
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDefaultBankInfo];
        [weakSelf loadWithdrawInfoData];
    }];
}


///加载默认银行卡信息
- (void)loadDefaultBankInfo
{
    //cans
    [self.viewModel.defaultCardParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //TOken
    [self.viewModel.defaultCardParam setObject:DATAMODEL.token forKey:@"token"];
    
    WEAKSelf;
    [self.viewModel getDefaultCardDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        
        if([code isEqualToString:@"0000"]){
            
            weakSelf.viewModel.withdrawConfirmParam.entityId = weakSelf.viewModel.defaultCardData.id;
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView reloadData];
    }];
}


///加载提现数据信息
-(void)loadWithdrawInfoData
{
    //参数
    //用户ID
    [self.viewModel.withdrawInfoParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.withdrawInfoParam setObject:DATAMODEL.token forKey:@"token"];
    
    WEAKSelf;
    [self.viewModel getWithdrawInfoDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        if([code isEqualToString:@"0000"]){
            [weakSelf.tableView reloadData];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}


///提现操作
-(void)onWithdrawConfirmData
{
    
    //参数
    //用户ID
    self.viewModel.withdrawConfirmParam.userId = DATAMODEL.userInfoData.id;
    //用户token
    self.viewModel.withdrawConfirmParam.token = DATAMODEL.token;
    
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    [self.viewModel setWithdrawConfirDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            
            if(weakSelf.onSuccessful){
                weakSelf.onSuccessful();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [weakSelf showHint:desc];
        }
    }];
}

///验证支付密码
- (void)setVerifyPayPassWord
{
    //参数
    //用户ID
    [self.viewModel.verifyPayPwdParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.verifyPayPwdParam setObject:DATAMODEL.token forKey:@"token"];
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    [self.viewModel setVerifyPayPwdDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf onWithdrawConfirmData];
        }else if([code isEqualToString:@"1000"]){// 支付密码错误
            //提示
            [DATAMODEL.alertManager showCustomButtonTitls:@[@"重新输入", @"忘记密码"] message:@"支付密码错误，请重试。"];
            [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
                if(buttonIndex == 0){
                    //显示支付密码输入
                    [weakSelf.payPasswordView showView];
                }else{
                    [weakSelf loadForgetPayPassword];
                }
            }];
            
        }else{
            [weakSelf showHint:desc];
        }
    }];
    
}



///忘记密码
-(void)loadForgetPayPassword
{
    WEAKSelf;
    GC_MineEditPasswordViewController *editPayPwd = [[GC_MineEditPasswordViewController alloc] init];
    
    editPayPwd.editPwdType = 1;
    editPayPwd.onEditPaySuccessBlock = ^(NSString *payPwdStr){
        [weakSelf onWithdrawConfirmData];
        
    };
    
    [self.navigationController pushViewController:editPayPwd animated:YES];
}

///确认提现 Action
-(void)onConfirmWithdrawAction:(UIButton*)sender
{
    if(self.viewModel.withdrawConfirmParam.withdrawAmount.length <= 0){
        [self showHint:@"提现金额未输入！"];
        return;
    }
    
    if([self.viewModel.withdrawConfirmParam.withdrawAmount isEqualToString:@"0"] || [self.viewModel.withdrawConfirmParam.withdrawAmount doubleValue] <= 0){
        [self showHint:@"提现金额不能为0元！"];
        return;
    }
    
    
    
    NSString *withdrawAmount=self.viewModel.withdrawConfirmParam.withdrawAmount;
    
    
    
    
    double actualPrice = [self.viewModel.withdrawConfirmParam.withdrawAmount doubleValue] - [self.viewModel.withdrawInfoData.transactionFee doubleValue];
    if(actualPrice <= 0){
        NSString *info = [NSString stringWithFormat:@"手续费为%@元，提现金额不能低于手续费！",self.viewModel.withdrawInfoData.transactionFee];
        [self showHint:info];
        return;
    }
    
    if([self.viewModel.withdrawConfirmParam.withdrawAmount doubleValue] < [self.viewModel.withdrawInfoData.minLimitAmount doubleValue]){
        
        [self showHint:[NSString stringWithFormat:@"提现金额小于%@元，不能提现。",self.viewModel.withdrawInfoData.minLimitAmount]];
        return;
    }
    
    
    
//    if([self.viewModel.withdrawConfirmParam.withdrawAmount integerValue] % [self.viewModel.withdrawInfoData.minLimitAmount integerValue] != 0){
//        
//        [self showHint:[NSString stringWithFormat:@"提现金额必须是%@的整数倍！",self.viewModel.withdrawInfoData.minLimitAmount]];
//        return;
//    }
    if(![DATAMODEL.henUtil judgeStr:self.viewModel.withdrawInfoData.minLimitAmount with:self.viewModel.withdrawConfirmParam.withdrawAmount]){
        [self showHint:[NSString stringWithFormat:@"提现金额必须是%@的整数倍！",self.viewModel.withdrawInfoData.minLimitAmount]];
        return;
        
    }
    
    
    
    
    GC_MResWithdrawInfoDataModel *model = self.viewModel.withdrawInfoData;
    double currLeScore = [model.agentLeScore doubleValue] + [model.incomeLeScore doubleValue] + [model.motivateLeScore doubleValue];
    if(currLeScore < [model.minLimitAmount doubleValue]){
        [self showHint:[NSString stringWithFormat:@"当前乐分小于%@元，不能提现。",model.minLimitAmount]];
        return;
    }
    
    if([self.viewModel.withdrawConfirmParam.withdrawAmount doubleValue] > currLeScore){
        [self showHint:@"当前乐分不足，不能提现。"];
        return;
    }
    
    
    
    if([DATAMODEL.userInfoData.isSetPayPwd isEqualToString:@"1"]){
        [self.payPasswordView showView];
    }else{
        
        [self loadForgetPayPassword];
        [self showHint:HenLocalizedString(@"支付密码暂未设置！")];
    }
    
    
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        GC_BankInfoWithdrawTableViewCell *cell = [GC_BankInfoWithdrawTableViewCell cellWithTableView:tableView];
        
        [cell updateBankInfoUI:self.viewModel.defaultCardData];
        
        return cell;
    }else if(indexPath.section == 1){
        GC_MineItemTableViewCell *cell = [GC_MineItemTableViewCell cellWithTableView:tableView];
        cell.titleInfo = self.dataSource[indexPath.row][0];
        cell.placeholder = self.dataSource[indexPath.row][1];
        [cell setTextFieldHidden:NO];
        [cell setNextImageViewHidden:YES];
        cell.bottomLongLineImage.hidden = NO;
        
        if(indexPath.row == 0){                 //提现金额
            cell.topLongLineImage.hidden = NO;
            cell.maxCount = 0;
            [cell setClearButtonHidden:NO];
            [cell setTextFieldUserInteractionEnabled:YES];
            [cell setTextFieldForKeyboardType:UIKeyboardTypeDefault andInputPrice:YES];
            WEAKSelf;
            cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item) {
                weakSelf.viewModel.withdrawConfirmParam.withdrawAmount = inputStr;
                [weakSelf.tableView reloadData];
            };
        }else if(indexPath.row == 1){           //备注
            [cell setTextFieldUserInteractionEnabled:YES];
            [cell setTextFieldForKeyboardType:UIKeyboardTypeDefault andInputPrice:NO];
            [cell setClearButtonHidden:YES];
            cell.maxCount = 15;
            
            WEAKSelf;
            cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item){
                weakSelf.viewModel.withdrawConfirmParam.remark = inputStr;
            };
        }
        return cell;
    }else if(indexPath.section == 2){
        GC_WithdrawRulesTableViewCell *cell = [GC_WithdrawRulesTableViewCell cellWithTableView:tableView];
        [cell setUpdateUiForWithdrawInfoData:self.viewModel.withdrawInfoData andPrice:self.viewModel.withdrawConfirmParam.withdrawAmount];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return [GC_WDHeadInfoTableViewCell getCellHeight];
    }else if(indexPath.section == 1){
        return [GC_MineItemTableViewCell getCellHeight];
    }else if(indexPath.section == 2){
        //自适应高度
        return [GC_WithdrawRulesTableViewCell getCellHeight];
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1){
        return self.dataSource.count;
    }
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

- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataSource addObjectsFromArray:@[@[@"提现金额",@"提现金额"],@[@"备注(选填)",@"0-15字"]]];
    }
    return _dataSource;
}

- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}


///确认提现 按钮
- (UIButton *)confirmWithdrawButton
{
    if(!_confirmWithdrawButton){
        UIButton *confirmButton = [UIButton createButtonWithTitle:HenLocalizedString(@"确认提现") backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onConfirmWithdrawAction:)];
        [confirmButton setTitleClor:kFontColorWhite];
        confirmButton.titleLabel.font = kFontSize_36;
        [self.view addSubview:_confirmWithdrawButton = confirmButton];
    }
    return _confirmWithdrawButton;
}

- (QL_PayPasswordInputView *)payPasswordView
{
    if(!_payPasswordView){
        _payPasswordView = [[QL_PayPasswordInputView alloc] init];
        
        WEAKSelf;
        _payPasswordView.onInputFinishBlock = ^(NSString *payPwdStr){
            
            //参数
            [weakSelf.viewModel.verifyPayPwdParam setObject:[DATAMODEL RSAEncryptorString:payPwdStr] forKey:@"password"];
            
            //验证操作
            [weakSelf setVerifyPayPassWord];
            
        };
    }
    return _payPasswordView;
}

- (GC_MineScoreStatisticsViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_MineScoreStatisticsViewModel alloc] init];
    }
    return _viewModel;
}



@end
