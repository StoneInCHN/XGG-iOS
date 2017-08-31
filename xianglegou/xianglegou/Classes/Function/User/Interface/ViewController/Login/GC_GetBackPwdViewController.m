//
//  GC_GetBackPwdViewController.m
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  找回密码 -- 界面
//

#import "GC_GetBackPwdViewController.h"

#import "GC_MobileSenderTableViewCell.h"
#import "GC_InputInfoTableViewCell.h"
#import "GC_FinishButtonTableViewCell.h"

#import "GC_UserLoginViewModel.h"
#import "GC_GetSmsCodeViewModel.h"

@interface GC_GetBackPwdViewController ()

///DataSource
@property (nonatomic, strong) NSMutableArray *dataSource;

///SmsCodeView Model
@property (nonatomic, strong) GC_GetSmsCodeViewModel *smsCodeViewModel;

///ViewModel
@property (nonatomic, strong) GC_UserLoginViewModel *viewModel;

///密码
@property (nonatomic, strong) NSString *password;
///确认密码
@property (nonatomic, strong) NSString *passwordConfirm;
@end

@implementation GC_GetBackPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNavigationItem];
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

#pragma mark -- override
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

///加载导航栏信息
-(void)loadNavigationItem{
    self.navigationItem.title = HenLocalizedString(@"找回密码");

    self.view.backgroundColor = kCommonBackgroudColor;
}


///发送 回调
-(void)onSenderCodeAction:(NSInteger)item
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
    [self.smsCodeViewModel.smsCodeParam setObject:@"RESETPWD" forKey:@"smsCodeType"];
    
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.smsCodeViewModel getSmsCodeWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
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


///完成 回调
-(void)onSetPwdFinshAction:(NSInteger)item
{
    [self.view endEditing:YES];
    
    if(((NSString*)[self.viewModel.resetPwdParam objectForKey:@"cellPhoneNum"]).length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }
    
    if(((NSString*)[self.viewModel.resetPwdParam objectForKey:@"cellPhoneNum"]).length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    
    if(((NSString*)[self.viewModel.resetPwdParam objectForKey:@"smsCode"]).length <= 0){
        [self showHint:HenLocalizedString(@"验证码未输入！")];
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
    
    
    [self.viewModel.resetPwdParam setObject:[DATAMODEL RSAEncryptorString:self.password] forKey:@"password"];
    
    [self.viewModel.resetPwdParam setObject:[DATAMODEL RSAEncryptorString:self.passwordConfirm] forKey:@"password_confirm"];
    //////[self.viewModel.resetPwdParam setObject:((NSString*)[self.viewModel.resetPwdParam objectForKey:@"password"]) forKey:@"password_confirm"];
    
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    //请求
    [self.viewModel getResetPwdWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
            
            cell.titleInfo = @"手 机 号";
            cell.placeholder = @"手机号";
            cell.topLongLineImage.hidden = NO;
            cell.bottomLongLineImage.hidden = NO;
            [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
            [cell setClearButtonHidden:YES];
            
            WEAKSelf;
            cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item){     //输入回调
                [weakSelf.viewModel.resetPwdParam setObject:inputStr forKey:@"cellPhoneNum"];
                [weakSelf.smsCodeViewModel.smsCodeParam setObject:inputStr forKey:@"cellPhoneNum"];
            };
            
            cell.onSenderBlock = ^(NSInteger item){             //发送按钮回调
                [weakSelf onSenderCodeAction:item];
            };
            return cell;
        }else{
            GC_InputInfoTableViewCell *cell = [GC_InputInfoTableViewCell cellWithTableView:tableView];
            cell.titleInfo = self.dataSource[indexPath.row-1][0];
            cell.placeholder = self.dataSource[indexPath.row-1][1];
            cell.bottomLongLineImage.hidden = NO;
            
            
            if(indexPath.row == 1){             //验证码
                [cell setStartUpPwdLock:NO];
            }else if(indexPath.row == 2){       //密码
                [cell setStartUpPwdLock:YES];
            }else if(indexPath.row == 3){       //确认密码
                [cell setStartUpPwdLock:YES];
            }
            
            
            WEAKSelf;       //输入回调
            
            cell.onInputTextFieldBlock = ^(NSString *inputStr,NSInteger item){
                if(indexPath.row == 1){             //验证码
                    [weakSelf.viewModel.resetPwdParam setObject:inputStr forKey:@"smsCode"];
                }else if(indexPath.row == 2){       //密码
                    weakSelf.password = inputStr;
                }else if(indexPath.row == 3){       //确认密码
                    weakSelf.passwordConfirm = inputStr;
                }
            };
            return cell;
            
        }
    }else if(indexPath.section == 1){           //完成 按钮
        GC_FinishButtonTableViewCell *cell = [GC_FinishButtonTableViewCell cellWithTableView:tableView];
        
        [cell setProtocolHidden:YES];
        
        WEAKSelf;       //完成按钮 回调
        cell.onFinshBlock = ^(NSInteger item){
            [weakSelf onSetPwdFinshAction:item];
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
    if(section == 0){
        return self.dataSource.count + 1;
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
        
        [_dataSource addObjectsFromArray:@[@[@"验 证 码",@"验证码"],@[@"密  码",@"密码"],@[@"确认密码",@"确认密码"]]];
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

- (GC_GetSmsCodeViewModel *)smsCodeViewModel
{
    if(!_smsCodeViewModel){
        _smsCodeViewModel = [[GC_GetSmsCodeViewModel alloc] init];
    }
    return _smsCodeViewModel;
}

@end
