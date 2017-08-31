//
//  GC_RegisteredViewController.m
//  Rebate
//
//  Created by mini3 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  注册界面
//

#import "GC_RegisteredViewController.h"

#import "GC_MobileSenderTableViewCell.h"
#import "GC_InputInfoTableViewCell.h"
#import "GC_FinishButtonTableViewCell.h"

#import "GC_UserLoginViewModel.h"
#import "GC_GetSmsCodeViewModel.h"

@interface GC_RegisteredViewController ()
///背景图
@property (nonatomic, weak) UIImageView *registerBgImageView;
///图标 Logo
@property (nonatomic, weak) UIImageView *logoImageView;
///Table View
@property (nonatomic, weak) UITableView *tableView;
///dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;

///View Model
@property (nonatomic, strong) GC_UserLoginViewModel *viewModel;
///发送短信
@property (nonatomic, strong) GC_GetSmsCodeViewModel *smsCodeVideModel;


///密码
@property (nonatomic, strong) NSString *password;
///确认密码
@property (nonatomic, strong) NSString *passwordConfirm;
@end

@implementation GC_RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubView];
    //获取RSA key
    [DATAMODEL loadRSAPublickey];
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

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


///加载navigationBar背景
-(void)loadNavigationBarBackground
{
    
    self.navigationItem.title = @"注册账号";
    
    [((Hen_BaseNavigationViewController*)self.navigationController) setDefaultBackground];
    [self.navigationController.navigationBar setTintColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarTitleColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarBgColor:[UIColor clearColor]];
    [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:YES];
    [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:YES];
}

#pragma mark -- override
///清除数据
-(void)cleanUpData
{
    [self.dataSource removeAllObjects];
    [self setDataSource:nil];
    
    [self setViewModel:nil];
    [self setSmsCodeVideModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    
}


///加载子视图
-(void)loadSubView
{
    [self.registerBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(FITSCALE(351/2));
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.registerBgImageView);
        make.bottom.equalTo(self.registerBgImageView.mas_bottom).offset(FITSCALE(-76/2));
        make.width.mas_equalTo(FITSCALE(118/2));
        make.height.mas_equalTo(FITSCALE(124/2));
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerBgImageView.mas_bottom);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark -- action
///发送 短信 Action
- (void)onGetSmsCodeAction:(NSInteger)item
{
    [self.view endEditing:YES];
    
    if(((NSString*)[self.smsCodeVideModel.smsCodeParam objectForKey:@"cellPhoneNum"]).length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }
    
    if(((NSString*)[self.smsCodeVideModel.smsCodeParam objectForKey:@"cellPhoneNum"]).length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    //短信验证码类型 注册：REG, 登录：LOGIN, 找回密码：RESETPWD, 修改登录密码：UPDATELOGINPWD, 修改支付密码：UPDATEPAYPWD
    [self.smsCodeVideModel.smsCodeParam setObject:@"REG" forKey:@"smsCodeType"];
    
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.smsCodeVideModel getSmsCodeWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        
        if([code isEqualToString:@"0000"]){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [((GC_MobileSenderTableViewCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath]) startOnTimers];
            
            [weakSelf showHint:HenLocalizedString(@"已向手机号发送短信，请注意查收！")];
        }else{
            [weakSelf showHint:desc];
        }
    }];
    
}

///完成
- (void)onFinshAction:(NSInteger)item
{
    [self.view endEditing:YES];
    
    if(self.viewModel.userRegParam.cellPhoneNum.length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }
    if(self.viewModel.userRegParam.cellPhoneNum.length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    
    if(self.viewModel.userRegParam.smsCode.length <= 0){
        [self showHint:HenLocalizedString(@"验证码未输入")];
        return;
    }
    
    if(self.password.length <= 0){
        [self showHint:HenLocalizedString(@"密码未输入！")];
        return;
    }
    
    if(self.password.length < 6){
        [self showHint:HenLocalizedString(@"密码不足6位！")];
        return;
    }
    
    if(self.passwordConfirm.length <= 0){
        [self showHint:HenLocalizedString(@"确认密码未输入！")];
        return;
    }
    
    if(self.passwordConfirm.length < 6){
        [self showHint:HenLocalizedString(@"确认密码不足6位！")];
        return;
    }
    
    
    if(![self.password isEqualToString:self.passwordConfirm]){
        [self showHint:HenLocalizedString(@"密码和确认密码不一致，请重新输入！")];
        return;
    }

    
    self.viewModel.userRegParam.password = [DATAMODEL RSAEncryptorString:self.password];
    
    
    
    self.viewModel.userRegParam.password_confirm = [DATAMODEL RSAEncryptorString:self.passwordConfirm];
    //////[self.viewModel.userRegParam setObject:((NSString*)[self.viewModel.userRegParam objectForKey:@"password"]) forKey:@"password_confirm"];
    
    
    
    if(self.viewModel.userRegParam.recommenderMobile.length > 0){
        if(self.viewModel.userRegParam.recommenderMobile.length != 11){
            [self showHint:HenLocalizedString(@"手机号输入有误！")];
            return;
        }
        
        
        if([self.viewModel.userRegParam.recommenderMobile isEqualToString:self.viewModel.userRegParam.cellPhoneNum]){
            [self showHint:HenLocalizedString(@"推荐人不能为自己！")];
            return;
            
        }
    }
    
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    //请求
    [self.viewModel setUserRegWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
    
    
            [weakSelf.navigationController popViewControllerAnimated:NO];
            if(weakSelf.onRegisteredSuccessBlock){
                weakSelf.onRegisteredSuccessBlock();
            }
    
        }else{
            [weakSelf showHint:desc];
        }

    }];
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            GC_MobileSenderTableViewCell *cell = [GC_MobileSenderTableViewCell cellWithTableView:tableView];
            [cell setClearButtonHidden:YES];
            cell.titleInfo = @"手 机 号";
            cell.placeholder = @"手机号";
            cell.topLongLineImage.hidden = NO;
            cell.bottomLongLineImage.hidden = NO;
            [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
            
            WEAKSelf;
            
            cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item){     //输入回调
                [weakSelf.smsCodeVideModel.smsCodeParam setObject:inputStr forKey:@"cellPhoneNum"];
                weakSelf.viewModel.userRegParam.cellPhoneNum = inputStr;
            };
            
            
            cell.onSenderBlock = ^(NSInteger item){     //发送短信 回调
                [weakSelf onGetSmsCodeAction:item];
            };
            return cell;
        }else{
            GC_InputInfoTableViewCell *cell = [GC_InputInfoTableViewCell cellWithTableView:tableView];
            cell.titleInfo = self.dataSource[indexPath.row-1][0];
            cell.placeholder = self.dataSource[indexPath.row-1][1];
            cell.bottomLongLineImage.hidden = NO;
            [cell setClearButtonHidden:NO];
            if(indexPath.row == 1){             //验证码
                [cell setStartUpPwdLock:NO];
            }else if(indexPath.row == 2){       //密码
                [cell setStartUpPwdLock:YES];
            }else if(indexPath.row == 3){       //确认密码
                [cell setStartUpPwdLock:YES];
            }else if(indexPath.row == 4){       //推荐人手机号
                [cell setStartUpPwdLock:NO];
                [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
                [cell setClearButtonHidden:YES];
            }
            
            WEAKSelf;       //输入回调
            cell.onInputTextFieldBlock = ^(NSString *inputStr,NSInteger item){
                if(indexPath.row == 1){         //验证码
                    weakSelf.viewModel.userRegParam.smsCode = inputStr;
                }else if(indexPath.row == 2){   //密码
                    weakSelf.password = inputStr;
                }else if(indexPath.row == 3){   //确认密码
                    weakSelf.passwordConfirm = inputStr;
                }else if(indexPath.row == 4){   //推荐人手机号
                    weakSelf.viewModel.userRegParam.recommenderMobile = inputStr;
                }
            };
            
            return cell;
        }
    }else if(indexPath.section == 1){       //完成按钮
        GC_FinishButtonTableViewCell *cell = [GC_FinishButtonTableViewCell cellWithTableView:tableView];
            WEAKSelf;
            cell.onFinshBlock = ^(NSInteger item){
                [weakSelf onFinshAction:item];
            };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return [GC_MobileSenderTableViewCell getCellHeight];
        }else{
            return [GC_InputInfoTableViewCell getCellHeight];
        }
    }else if(indexPath.section == 1){
        return [GC_FinishButtonTableViewCell getCellHeight];
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1){
        return 1;
    }
    return self.dataSource.count + 1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return [self tableViewHeaderViewForTitle:@"手机号即登录账号，我们将发送验证码到此号码"];
    }
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return HEIGHT_TRANSFORMATION(60);
    }
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
///注册背景
- (UIImageView *)registerBgImageView
{
    if(!_registerBgImageView){
        UIImageView *registerBgImage = [UIImageView createImageViewWithName:@"mine_bg1"];
        [self.view addSubview:_registerBgImageView = registerBgImage];
    }
    return _registerBgImageView;
}
///Logo 图标
- (UIImageView *)logoImageView
{
    if(!_logoImageView){
        UIImageView *logoImage = [UIImageView createImageViewWithName:@"public_login_logo"];
        [self.view addSubview:_logoImageView = logoImage];
    }
    return _logoImageView;
}

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

-(UIView*)tableViewHeaderViewForTitle:(NSString*)title
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(60)) backgroundColor:kCommonBackgroudColor];

    
    UILabel *titleLabel = [UILabel createLabelWithText:HenLocalizedString(title) font:kFontSize_24 textColor:kFontColorGray];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        
    }];
    
    return view;
}


- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataSource addObjectsFromArray:@[@[@"验 证 码",@"验证码"],@[@"密   码",@"密码"],@[@"确认密码",@"确认密码"],@[@"推荐人手机号",@"选填"]]];
    }
    return _dataSource;
}


- (GC_UserLoginViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_UserLoginViewModel alloc] init];
    }
    return _viewModel;
}

- (GC_GetSmsCodeViewModel *)smsCodeVideModel
{
    if(!_smsCodeVideModel){
        _smsCodeVideModel = [[GC_GetSmsCodeViewModel alloc] init];
    }
    return _smsCodeVideModel;
}
@end
