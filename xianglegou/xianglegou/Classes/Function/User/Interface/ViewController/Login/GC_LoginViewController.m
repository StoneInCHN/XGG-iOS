//
//  GC_LoginViewController.m
//  Rebate
//
//  Created by mini3 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_LoginViewController.h"
#import "GC_RegisteredViewController.h"
#import "GC_GetBackPwdViewController.h"
#import "GC_LoginIconTableViewCell.h"
#import "GC_LoginRowTableViewCell.h"
#import "GC_LoginButtonTableViewCell.h"
#import "GC_UserLoginViewModel.h"
#import "GC_GetSmsCodeViewModel.h"
#import "SetupPushRequestParam.h"
#import "UserPushViewModel.h"

@interface GC_LoginViewController ()<UITableViewDelegate, UITableViewDataSource>

///背景图片
@property (nonatomic, weak) UIImageView *backgroundImageView;

///TableView
@property (nonatomic, weak) UITableView *tableView;

///dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;

///登录 切换  YES:密码登录  NO:验证码登录
@property (nonatomic, assign) BOOL loginState;


///ViewModel
@property (nonatomic, strong) GC_UserLoginViewModel *viewModel;

/// UserPushViewModel
@property (nonatomic, strong) UserPushViewModel *pushViewModel;

///发送短信 ViewModel
@property (nonatomic, strong) GC_GetSmsCodeViewModel *smsCodeViewModel;

///密码
@property (nonatomic, strong) NSString *password;

///验证码
@property (nonatomic, strong) NSString *smsCode;
@end

@implementation GC_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubView];
    self.loginState = YES;
    
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
    
    self.navigationItem.title = @"登录";
    
    [((Hen_BaseNavigationViewController*)self.navigationController) setDefaultBackground];
    [self.navigationController.navigationBar setTintColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarTitleColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarBgColor:[UIColor clearColor]];
    [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:YES];
    [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:YES];
}



///加载子视图
- (void)loadSubView
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark -- 子类必须重写并实现
///清除数据
-(void)cleanUpData
{
    [self.dataSource removeAllObjects];
    [self setDataSource:nil];
    
    [self setViewModel:nil];
    [self setSmsCodeViewModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    
}


#pragma mark -- event response
///发送短信 回调
-(void)onSenderSmsAction:(NSInteger)item
{
    [self.view endEditing:YES];
    
    if(((NSString*)[self.smsCodeViewModel.smsCodeParam objectForKey:@"cellPhoneNum"]).length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }

    if(((NSString*)[self.smsCodeViewModel.smsCodeParam objectForKey:@"cellPhoneNum"]).length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    
    //短信验证码类型 注册：REG, 登录：LOGIN, 找回密码：RESETPWD, 修改登录密码：UPDATELOGINPWD, 修改支付密码：UPDATEPAYPWD
    [self.smsCodeViewModel.smsCodeParam setObject:@"LOGIN" forKey:@"smsCodeType"];
    
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    //请求
    [self.smsCodeViewModel getSmsCodeWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [((GC_LoginRowTableViewCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath]) startOnTimers];
            [weakSelf showHint:HenLocalizedString(@"已向手机号发送短信，请注意查收！")];
        }else{
            [weakSelf showHint:desc];
        }
    }];
}

///登录回调
- (void)onLoginAction:(NSInteger)item
{
    [self.view endEditing:YES];
    
    if(self.viewModel.loginParam.cellPhoneNum.length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }
    if(self.viewModel.loginParam.cellPhoneNum.length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    
    
    if(self.loginState){    //密码登录
        if(self.password.length <= 0){
            [self showHint:HenLocalizedString(@"密码未输入！")];
            return;
        }
        
        if(self.password.length < 6){
            [self showHint:HenLocalizedString(@"密码不足6位！")];
            return;
        }
        
        self.viewModel.loginParam.password = [DATAMODEL RSAEncryptorString:self.password];
        
        self.viewModel.loginParam.smsCode = @"";
    }else{                  //验证码登录
        
        if(self.smsCode.length <= 0){
            [self showHint:HenLocalizedString(@"验证码未输入！")];
            return;
        }
        
        self.viewModel.loginParam.smsCode = self.smsCode;
        
        self.viewModel.loginParam.password = @"";
        
    }
    
    
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    //请求
    [self.viewModel getLoginWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf.pushViewModel uploadPushRegisterId];
            if(weakSelf.onLoginSuccessBlock){
                weakSelf.onLoginSuccessBlock();
            }
        }else{
            [weakSelf showHint:desc];
        }
    }];
}


///注册 回调
- (void)onRegisteredAction:(NSInteger)item
{
    GC_RegisteredViewController *registered = [[GC_RegisteredViewController alloc] init];
    
    WEAKSelf;
    registered.onRegisteredSuccessBlock = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [weakSelf.pushViewModel uploadPushRegisterId];
        if(weakSelf.onLoginSuccessBlock){
            weakSelf.onLoginSuccessBlock();
        }
    };    
    [self.navigationController pushViewController:registered animated:YES];
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){                 //Login_logo
        GC_LoginIconTableViewCell *cell = [GC_LoginIconTableViewCell cellWithTableView:tableView];
        [cell setImageForName:@"public_login_logo" andHidden:NO];
        return cell;
    }else if(indexPath.section == 3){           //登录按钮
        GC_LoginButtonTableViewCell *cell = [GC_LoginButtonTableViewCell cellWithTableView:tableView];
        
        if(self.loginState){
            cell.titleInfo = @"验证码登录";
        }else{
            cell.titleInfo = @"密码登录";
        }
        WEAKSelf;
        cell.onLoginStateBlock = ^(NSInteger item){
            if(weakSelf.loginState){            //切换验证码登录
                weakSelf.loginState = NO;
            }else{                              //切换密码登录
                weakSelf.loginState = YES;
            }
            [weakSelf.tableView reloadData];
        };
        
        //忘记密码回调
        cell.onForgetPwdBlock = ^(NSInteger item){
            GC_GetBackPwdViewController *backPwd = [[GC_GetBackPwdViewController alloc] init];
            [weakSelf.navigationController pushViewController:backPwd animated:YES];
        };
        
        //登录回调
        cell.onLoginBlock = ^(NSInteger item){
            [weakSelf onLoginAction:item];
        };
        
        //注册账号回调
        cell.onRegisteredBlock = ^(NSInteger item){
            [weakSelf onRegisteredAction:item];
        };
        
        return cell;
    }else{                                      //账号信息录入
        GC_LoginRowTableViewCell *cell = [GC_LoginRowTableViewCell cellWithTableView:tableView];
        cell.iconImage = self.dataSource[indexPath.section - 1][0];
        cell.placeholder = self.dataSource[indexPath.section - 1][1];
       
        if(self.loginState){                    //密码登录
            WEAKSelf;
            [cell setSenderHidden:YES];
            if(indexPath.section == 1){         //手机号
                [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
                
                [cell setClearButtonHidden:YES];
                if(self.viewModel.loginParam.cellPhoneNum.length <= 0){
                    self.viewModel.loginParam.cellPhoneNum = [DATAMODEL.userDBHelper getUserMoblie];
                    [self.smsCodeViewModel.smsCodeParam setObject:[DATAMODEL.userDBHelper getUserMoblie] forKey:@"cellPhoneNum"];
                }
                
                cell.inputInfo = self.viewModel.loginParam.cellPhoneNum;
                cell.onEnterTextFieldBlock = ^(NSString *inputStr,NSInteger item){      //输入回调
                    [weakSelf.smsCodeViewModel.smsCodeParam setObject:inputStr forKey:@"cellPhoneNum"];
                    weakSelf.viewModel.loginParam.cellPhoneNum = inputStr;
                };
            }else if(indexPath.section == 2){   //密码
                [cell setClearButtonHidden:NO];
                [cell setStartUpPwdLock:YES];
                cell.inputInfo = self.password;
                cell.onEnterTextFieldBlock = ^(NSString *inputStr,NSInteger item){      //输入回调
                    weakSelf.password = inputStr;
                };
            }
        }else{                                  //验证码登录
            WEAKSelf;
            if(indexPath.section == 1){         //手机号
                [cell setSenderHidden:NO];      //显示发送按钮
                [cell setClearButtonHidden:YES];
                [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
                if(self.viewModel.loginParam.cellPhoneNum.length <= 0){
                    self.viewModel.loginParam.cellPhoneNum = [DATAMODEL.userDBHelper getUserMoblie];
                    [self.smsCodeViewModel.smsCodeParam setObject:[DATAMODEL.userDBHelper getUserMoblie] forKey:@"cellPhoneNum"];
                }
                
                cell.inputInfo = self.viewModel.loginParam.cellPhoneNum;
                cell.onEnterTextFieldBlock = ^(NSString *inputStr,NSInteger item){      //输入回调
                    [weakSelf.smsCodeViewModel.smsCodeParam setObject:inputStr forKey:@"cellPhoneNum"];
                    weakSelf.viewModel.loginParam.cellPhoneNum = inputStr;
                };
                
                cell.onSenderBlock = ^(NSInteger item){         //发送回调
                    [weakSelf onSenderSmsAction:item];
                };
            }else if(indexPath.section == 2){   //验证码
                [cell setClearButtonHidden:NO];
                [cell setStartUpPwdLock:NO];
                [cell setSenderHidden:YES];
                cell.iconImage = @"login_icon_verification";
                cell.placeholder = @"验证码";
                cell.inputInfo = self.smsCode;
                cell.onEnterTextFieldBlock = ^(NSString *inputStr,NSInteger item){      //输入回调
                    weakSelf.smsCode = inputStr;
                };
            }
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){             //Login_logo
        return [GC_LoginIconTableViewCell getCellHeight];
    }else if(indexPath.section == 3){
        return [GC_LoginButtonTableViewCell getCellHeight];
    }else{       //账号信息录入
        return [GC_LoginRowTableViewCell getCellHeight];
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataSource.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:[UIColor clearColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return FITHEIGHT(30/2);
    }else if(section == 2){
        return FITHEIGHT(50/2);
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
- (UIImageView *)backgroundImageView
{
    if(!_backgroundImageView){
        UIImageView *backgroundImage = [UIImageView createImageViewWithName:@"login_bg"];
        backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_backgroundImageView = backgroundImage];
    }
    return _backgroundImageView;
}

///TableView
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataSource addObjectsFromArray:@[@[@"login_icon_number",@"手机号"],@[@"login_icon_password",@"密码"]]];
    }
    return _dataSource;
}

///ViewModel
- (GC_UserLoginViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_UserLoginViewModel alloc] init];
    }
    return _viewModel;
}

// UserPushViewModel
- (UserPushViewModel *)pushViewModel {
    if(!_pushViewModel){
        _pushViewModel = [[UserPushViewModel alloc] init];
    }
    return _pushViewModel;
}

///SmsCodeViewModek
- (GC_GetSmsCodeViewModel *)smsCodeViewModel
{
    if(!_smsCodeViewModel){
        _smsCodeViewModel = [[GC_GetSmsCodeViewModel alloc] init];
    }
    return _smsCodeViewModel;
}
@end
