//
//  GC_FillInBankCardInfoViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  填写银行卡信息 -- 界面
//

#import "GC_FillInBankCardInfoViewController.h"
#import "GC_VerifyTheMobileViewController.h"
#import "GC_SettingConfigViewController.h"

#import "GC_AddBankCardTableViewCell.h"
#import "GC_BankBindingViewModel.h"


@interface GC_FillInBankCardInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

///TableView
@property (nonatomic, weak) UITableView *tableView;

///下一步
@property (nonatomic, weak) UIButton *nextButton;

///ViewModel
@property (nonatomic, strong) GC_BankBindingViewModel *viewModel;

///返回结果
@property (nonatomic, strong) NSString *error_code;

@end

@implementation GC_FillInBankCardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    [self getBankCardInfo];
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
    
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    
}

#pragma mark -- private

///加载子视图
-(void)loadSubView
{
    self.navigationItem.title = @"填写银行卡信息";
    
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


///银行卡信息
- (void)getBankCardInfo
{
    
    
    //参数
    [self.viewModel.bankCardInfoParam setObject:self.inputData.cardNum forKey:@"cardid"];
    
    //KEY
    [self.viewModel.bankCardInfoParam setObject:@"6436f789374de2722ea5047079908e4a" forKey:@"key"];
    
    WEAKSelf;
    NSString *url = @"http://detectionBankCard.api.juhe.cn/bankCard";
    
    //显示 加载
    [self showPayHud:@""];
    [self.viewModel setUrl:url getBankInfoDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        weakSelf.inputData.bankName = weakSelf.viewModel.bankCardInfoData.result.bank;
        weakSelf.inputData.cardType = weakSelf.viewModel.bankCardInfoData.result.nature;
        weakSelf.inputData.bankLogo = weakSelf.viewModel.bankCardInfoData.result.logo;
        weakSelf.error_code = weakSelf.viewModel.bankCardInfoData.error_code;
        [weakSelf.tableView reloadData];
        
    }];
}


///服务协议
-(void)onAgreeProtocolLabelTouchUpInside:(UITapGestureRecognizer *)recognizer
{
    GC_SettingConfigViewController *scVC = [[GC_SettingConfigViewController alloc] init];
    scVC.hidesBottomBarWhenPushed = YES;
    scVC.titleInfo = @"银行卡服务协议";
    scVC.configKey = @"BANKCARD_SERVICE_AGREEMENT";
    [self.navigationController pushViewController:scVC animated:YES];
}

///下一步
- (void)onNextButtonAction:(UIButton *)sender
{
    
    if(self.viewModel.verifyBankCardParam.reservedMobile.length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }
    
    
    
    if(![self.error_code isEqualToString:@"0"]){
        [self showHint:@"卡类型有误！"];
        return;
    }
    
    //参数
    self.viewModel.verifyBankCardParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.verifyBankCardParam.token = DATAMODEL.token;
    self.viewModel.verifyBankCardParam.ownerName = self.inputData.ownerName;
    self.viewModel.verifyBankCardParam.cardNum = self.inputData.cardNum;
    self.viewModel.verifyBankCardParam.idCard = self.inputData.idCard;
    
    //显示加载
    [self showPayHud:@""];
    //银行卡四元素校验 方法
    WEAKSelf;
    [self.viewModel setVerifyBankCardDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            GC_VerifyTheMobileViewController *vtmVC = [[GC_VerifyTheMobileViewController alloc] init];
            
            vtmVC.hidesBottomBarWhenPushed = YES;
            vtmVC.inputData = weakSelf.inputData;
            
            [weakSelf.navigationController pushViewController:vtmVC animated:YES];
        }else{
            [weakSelf showHint:desc];
        }
    }];
    
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){             // 卡类型
        GC_AddBankCardTableViewCell *cell = [GC_AddBankCardTableViewCell cellWithTableView:tableView];
       
        cell.topLongLineImage.hidden = NO;
        cell.titleInfo = @"卡类型";
        [cell setIconImageHidden:YES];
        [cell setTextFieldUserInteractionEnabled:NO];
        
        
        
        cell.inputInfo = [NSString stringWithFormat:@"%@ %@",self.inputData.bankName, self.inputData.cardType];
        
        
        if(self.inputData.bankName.length <= 0){
            cell.inputInfo = @"未获取到银行卡信息！";
        }
        
        return cell;
    }else if(indexPath.row == 1){       //手机号
        GC_AddBankCardTableViewCell *cell = [GC_AddBankCardTableViewCell cellWithTableView:tableView];
        cell.topLongLineImage.hidden = NO;
        cell.bottomLongLineImage.hidden = NO;
        cell.titleInfo = @"手机号";
        [cell setClearButtonHidden:YES];
        cell.inputType = 2;
        [cell setIconImageHidden:NO];
        [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
        
        WEAKSelf;
        cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item) {
            weakSelf.viewModel.verifyBankCardParam.reservedMobile = inputStr;
            weakSelf.inputData.reservedMobile = inputStr;
        };
        
        
        
        cell.onDescriptionBlock = ^(NSInteger item) {
            GC_SettingConfigViewController *scVC = [[GC_SettingConfigViewController alloc] init];
            scVC.hidesBottomBarWhenPushed = YES;
            scVC.titleInfo = @"银行卡手机号";
            scVC.configKey = @"BANKCARD_MOBILE_DESC";
            [weakSelf.navigationController pushViewController:scVC animated:YES];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GC_AddBankCardTableViewCell getCellHeight];
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
    return [self tableViewHeaderViewForTitle:@"信息已安全加密，仅用于银行验证"];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self tableViewFooterView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(80);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(60);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -- getter,setter

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



///头部View
-(UIView*)tableViewHeaderViewForTitle:(NSString*)title
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(80)) backgroundColor:kCommonBackgroudColor];
    
    
    UILabel *titleLabel = [UILabel createLabelWithText:HenLocalizedString(title) font:kFontSize_24 textColor:kFontColorGray];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    return view;
}

///底部View
- (UIView*)tableViewFooterView
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(60)) backgroundColor:kCommonBackgroudColor];
    
    
    UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorBlack];
    
    NSString *text = @"同意《服务协议》";
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:kFontColorRed range:NSMakeRange(2,6)];
    
    label.attributedText = str;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAgreeProtocolLabelTouchUpInside:)];
    [label addGestureRecognizer:labelTapGestureRecognizer];
    
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(OffSetToLeft);
    }];
    
    return view;
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



- (GC_InputBandCardInfoRequestDataModel *)inputData
{
    if(!_inputData){
        _inputData = [[GC_InputBandCardInfoRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _inputData;
}


///ViewModel
- (GC_BankBindingViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_BankBindingViewModel alloc] init];
    }
    return _viewModel;
}
@end
