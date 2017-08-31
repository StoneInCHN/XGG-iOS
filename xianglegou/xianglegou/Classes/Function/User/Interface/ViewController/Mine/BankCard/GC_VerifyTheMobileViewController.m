//
//  GC_VerifyTheMobileViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  验证手机号 - 界面
//


#import "GC_VerifyTheMobileViewController.h"
#import "GC_MineViewController.h"
#import "GC_MineBankCardViewController.h"
#import "QL_MineShopViewController.h"
#import "GC_ShopRecordViewController.h"
#import "GC_ShopMoneyViewController.h"
#import "GC_WithdrawViewController.h"
#import "GC_MineLeBeansScoreViewController.h"



#import "GC_BankCardMobileInfoTableViewCell.h"
#import "GC_MobileSenderTableViewCell.h"

#import "QL_MineShopViewViewModel.h"
#import "GC_BankBindingViewModel.h"
#import "GC_GetSmsCodeViewModel.h"

@interface GC_VerifyTheMobileViewController ()<UITableViewDelegate, UITableViewDataSource>

///TableView
@property (nonatomic, weak) UITableView *tableView;

///下一步
@property (nonatomic, weak) UIButton *nextButton;

///ViewModel
@property (nonatomic, strong) GC_BankBindingViewModel *viewModel;


///
@property (nonatomic, strong) GC_GetSmsCodeViewModel *smsViewModel;

@property (nonatomic, strong) QL_MineShopViewViewModel *shopViewModel;
@end

@implementation GC_VerifyTheMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    [self onSmsCodeBankMobile];
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
    
    [self setSmsViewModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
}
#pragma mark -- private
///加载子视图
-(void)loadSubView
{
    self.navigationItem.title = @"验证手机号";
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(96));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.nextButton.mas_top);
    }];
}





#pragma mark -- action
///下一步
-(void)onNextButtonAction:(UIButton *)sender
{
    if(self.viewModel.addBankCardParam.smsCode.length <= 0){
        [self showHint:@"验证码未输入！"];
        return;
    }
    
    //参数
    self.viewModel.addBankCardParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.addBankCardParam.token = DATAMODEL.token;
    self.viewModel.addBankCardParam.ownerName = self.inputData.ownerName;
    
    self.viewModel.addBankCardParam.cardNum = self.inputData.cardNum;
    self.viewModel.addBankCardParam.bankName = self.inputData.bankName;
    self.viewModel.addBankCardParam.cardType = self.inputData.cardType;
    self.viewModel.addBankCardParam.isDefault = self.inputData.isDefault;
    self.viewModel.addBankCardParam.bankLogo = self.inputData.bankLogo;
    self.viewModel.addBankCardParam.reservedMobile = self.inputData.reservedMobile;
    self.viewModel.addBankCardParam.idCard = self.inputData.idCard;
    
    
    
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    //参数
    [self.viewModel setAddBankCardDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf onReturnMineInterface];
        }else if([code isEqualToString:@"1000"]){
            
        }else{
            [weakSelf returnFailureInterface];
        }
        
        [weakSelf showHint:desc];
    }];
}



///加载店铺信息
- (void)loadMineShopInfo
{
    //WEAKSelf;
    //请求
    [self.shopViewModel getShopInfoDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        if([code isEqualToString:@"0000"]){ // 成功
        }
    }];
}


///返回 我的银行界面
- (void)onReturnMineInterface
{
    ///实名认证进入 界面来源   1、我的界面      2、我的银行卡界面     3、我的店铺界面    4、店铺录单界面   5、店铺货款界面   6、乐分提现界面
    if([DATAMODEL.interfaceSource isEqualToString:@"1"]){       //我的界面
        
        //我的银行卡列表 界面
        GC_MineBankCardViewController *bvVC = [[GC_MineBankCardViewController alloc] init];
        bvVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bvVC animated:YES];
    }else if([DATAMODEL.interfaceSource isEqualToString:@"2"]){ //我的银行卡界面
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:GC_MineBankCardViewController.class]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else if([DATAMODEL.interfaceSource isEqualToString:@"3"]){ //我的店铺界面
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:QL_MineShopViewController.class]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else if([DATAMODEL.interfaceSource isEqualToString:@"4"]){ //店铺录单
        [self loadMineShopInfo];
        
        GC_ShopRecordViewController *srVC = [[GC_ShopRecordViewController alloc] init];
        srVC.hidesBottomBarWhenPushed = YES;
        
        srVC.shopInfoData = self.shopViewModel.shopInfoData;
        
        [self.navigationController pushViewController:srVC animated:YES];
        
    }else if([DATAMODEL.interfaceSource isEqualToString:@"5"]){ //店铺货款
        GC_ShopMoneyViewController *smVC = [[GC_ShopMoneyViewController alloc] init];
        
        smVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:smVC animated:YES];
        
    }else if([DATAMODEL.interfaceSource isEqualToString:@"6"]){ //乐分提现界面
        GC_WithdrawViewController *wVC = [[GC_WithdrawViewController alloc] init];
        wVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wVC animated:YES];
    }
    
}


///失败返回到开始界面
- (void)returnFailureInterface
{
    ///实名认证进入 界面来源   1、我的界面      2、我的银行卡界面     3、我的店铺界面    4、店铺录单界面   5、店铺货款界面   6、乐分提现界面
    if([DATAMODEL.interfaceSource isEqualToString:@"1"]){       //我的界面
    
    }else if([DATAMODEL.interfaceSource isEqualToString:@"2"]){ //我的银行卡界面
       
    }else if([DATAMODEL.interfaceSource isEqualToString:@"3"]){ //我的店铺界面
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:QL_MineShopViewController.class]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else if([DATAMODEL.interfaceSource isEqualToString:@"4"]){ //店铺录单
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:QL_MineShopViewController.class]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    }else if([DATAMODEL.interfaceSource isEqualToString:@"5"]){ //店铺货款
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:QL_MineShopViewController.class]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else if([DATAMODEL.interfaceSource isEqualToString:@"6"]){ //乐分提现界面
        
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:GC_MineLeBeansScoreViewController.class]){
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}


///银行预留手机号验证
- (void)onSmsCodeBankMobile
{
    //参数
    [self.smsViewModel.smsCodeParam setObject:@"RESERVEDMOBILE" forKey:@"smsCodeType"];
    [self.smsViewModel.smsCodeParam setObject:self.inputData.reservedMobile forKey:@"cellPhoneNum"];
    WEAKSelf;
    [self.smsViewModel getSmsCodeWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [((GC_MobileSenderTableViewCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath]) startOnTimers];
            [weakSelf showHint:HenLocalizedString(@"已向手机号发送短信，请注意查收！")];
            
        }else{
            [weakSelf showHint:desc];
        }
    }];
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        GC_BankCardMobileInfoTableViewCell *cell = [GC_BankCardMobileInfoTableViewCell cellWithTableView:tableView];
        
        cell.mobileInfo = self.inputData.reservedMobile;
        return cell;
    }else if(indexPath.row == 1){   //验证码
        GC_MobileSenderTableViewCell *cell = [GC_MobileSenderTableViewCell cellWithTableView:tableView];
        cell.titleInfo = @"验证码";
        cell.topLongLineImage.hidden = NO;
        cell.bottomLongLineImage.hidden = NO;
        [cell setTextFieldAlignment:NSTextAlignmentRight];
        cell.placeholder = @"验证码";
        
        WEAKSelf;
        cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item) {
            weakSelf.viewModel.addBankCardParam.smsCode = inputStr;
        };
        cell.onSenderBlock = ^(NSInteger item) {
            
            [weakSelf onSmsCodeBankMobile];
            
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return [GC_BankCardMobileInfoTableViewCell getCellHeightForContent:self.inputData.reservedMobile];
    }else if(indexPath.row == 1){       //手机号
        return [GC_MobileSenderTableViewCell getCellHeight];
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
///TableView
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kCommonBackgroudColor;
        tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}


///下一步
- (UIButton *)nextButton
{
    if(!_nextButton){
        UIButton *button = [UIButton createButtonWithTitle:@"下一步" backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onNextButtonAction:)];
        [button setTitleClor:kFontColorWhite];
        button.titleLabel.font = kFontSize_34;
        [self.view addSubview:_nextButton = button];
    }
    return _nextButton;
}

///ViewModel
- (GC_BankBindingViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_BankBindingViewModel alloc] init];
    }
    return _viewModel;
}

- (GC_GetSmsCodeViewModel *)smsViewModel
{
    if(!_smsViewModel){
        _smsViewModel = [[GC_GetSmsCodeViewModel alloc] init];
    }
    return _smsViewModel;
}

- (QL_MineShopViewViewModel *)shopViewModel
{
    if(!_shopViewModel){
        _shopViewModel = [[QL_MineShopViewViewModel alloc] init];
    }
    return _shopViewModel;
}
@end
