//
//  GC_MineEditPasswordViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  修改 密码 界面
//

#import "GC_MineEditPasswordViewController.h"

#import "GC_MobileSenderTableViewCell.h"
#import "GC_InputInfoTableViewCell.h"
#import "GC_FinishButtonTableViewCell.h"
#import "GC_EditPayPasswordTableViewCell.h"

#import "GC_GetSmsCodeViewModel.h"
#import "GC_MineMessageViewModel.h"

@interface GC_MineEditPasswordViewController ()
///DataSource
@property (nonatomic, strong) NSMutableArray *dataSource;

///SmsCodeView Model
@property (nonatomic, strong) GC_GetSmsCodeViewModel *smsCodeViewModel;

///ViewModel
@property (nonatomic, strong) GC_MineMessageViewModel *viewModel;

///新密码
@property (nonatomic, strong) NSString *passwordNew;
///确认密码
@property (nonatomic, strong) NSString *passwordConfirm;


@end

@implementation GC_MineEditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = kCommonBackgroudColor;
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
    
    [self setSmsCodeViewModel:nil];
    [self setViewModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
}

#pragma mark -- event response

///短信发送回调
-(void)onSmsCodeAction:(NSInteger)item
{
    [self.view endEditing:YES];
    //短信验证码类型
    /** 注册 */
    //REG,
    /** 登录 */
    //LOGIN,
    /** 找回密码 */
    //RESETPWD,
    /** 修改登录密码 */
    //UPDATELOGINPWD,
    /** 修改支付密码 */
    //UPDATEPAYPWD
    if(self.editPwdType == 0){          //登录密码
        [self.smsCodeViewModel.smsCodeParam setObject:@"UPDATELOGINPWD" forKey:@"smsCodeType"];
    }else if(self.editPwdType == 1){    //支付密码
        [self.smsCodeViewModel.smsCodeParam setObject:@"UPDATEPAYPWD" forKey:@"smsCodeType"];
    }
    
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
            //提示
            [weakSelf showHint:desc];
        }
    }];
}


///字符串 连续判断
-(BOOL)continuousString:(NSString*)newStr{
    
    NSString *temp = nil;
    
    NSMutableArray *strArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i =0; i < [newStr length]; i++)
    {
        temp = [newStr substringWithRange:NSMakeRange(i, 1)];
        [strArray addObject:temp];
    }
    
    NSInteger j = 1;
    
    for (int i = 1; i < strArray.count; i ++) {
        if(([strArray[i] intValue] - [strArray[i-1] intValue] == 1) || ([strArray[i] intValue] - [strArray[i-1] intValue] == -1)){
            
            j ++;
        }
    }
    if(j == 6){
        return YES;
    }else{
        return NO;
    }
}



///字符串 重复判断
- (BOOL)rangeString:(NSString *)string repeatCount:(NSInteger)Num{
    if (1 == Num && 0 < string.length) {
        return YES;
    }else if (0 >= string.length){
        return NO;
    }
    NSString *lastStr = @"";
    NSInteger count = 1;
    for (int i = 0; i < string.length; i++) {
        NSString *newStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([lastStr isEqualToString:newStr]) {
            count ++;
            if (Num == count) {
                return YES;
            }
        }else{
            count = 1;
        }
        lastStr = newStr;
    }
    return NO;
}


///完成回调
-(void)onUpdateFinshAction:(NSInteger)item
{
    [self.view endEditing:YES];
    
    if(((NSString*)[self.viewModel.updatePwdParam objectForKey:@"smsCode"]).length <= 0){
        [self showHint:HenLocalizedString(@"验证码未输入！")];
        return;
    }
    
    if(self.passwordNew.length <= 0){
        [self showHint:HenLocalizedString(@"密码未输入！")];
        return;
    }
    
    if(self.passwordNew.length < 6){
        [self showHint:HenLocalizedString(@"密码不足6位！")];
        return;
    }
    
    
    if(self.editPwdType == 1){
        if([self rangeString:self.passwordNew repeatCount:6] || [self continuousString:self.passwordNew]){
            [self showHint:HenLocalizedString(@"密码不能是重复、连续的数字，请重新设置！")];
            return;
        }
    }
    
    
    
    if(self.passwordConfirm.length <= 0){
        [self showHint:HenLocalizedString(@"确认密码未输入！")];
        return;
    }
    
    if(self.passwordConfirm.length < 6){
        [self showHint:HenLocalizedString(@"确认密码不足6位！")];
        return;
    }
    
    if(![self.passwordNew isEqualToString:self.passwordConfirm]){
        [self showHint:HenLocalizedString(@"密码和确认密码不一致，请重新输入！")];
        return;
    }
    
    [self.viewModel.updatePwdParam setObject:[DATAMODEL RSAEncryptorString:self.passwordNew] forKey:@"password"];
    
    [self.viewModel.updatePwdParam setObject:[DATAMODEL RSAEncryptorString:self.passwordConfirm] forKey:@"password_confirm"];
    
    /////验证码类型
    /** 修改登录密码 */
    //UPDATELOGINPWD,
    /** 修改支付密码 */
    //UPDATEPAYPWD
    if(self.editPwdType == 0){              //登录密码
        [self.viewModel.updatePwdParam setObject:@"UPDATELOGINPWD" forKey:@"smsCodeType"];
    }else if(self.editPwdType == 1){        //支付密码
        [self.viewModel.updatePwdParam setObject:@"UPDATEPAYPWD" forKey:@"smsCodeType"];
    }
    
    [self.viewModel.updatePwdParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.updatePwdParam setObject:DATAMODEL.token forKey:@"token"];
    
    
    
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.viewModel setUserUpdatePwdDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            
            if(weakSelf.editPwdType == 0){          //登录密码
                DATAMODEL.userInfoData.isSetLoginPwd = @"1";
            }else if(weakSelf.editPwdType == 1){    //支付密码
                DATAMODEL.userInfoData.isSetPayPwd = @"1";
                if(weakSelf.onEditPaySuccessBlock){
                    weakSelf.onEditPaySuccessBlock(weakSelf.passwordNew);
                }
            }
            
            if(weakSelf.onEditSuccessBlock){
                weakSelf.onEditSuccessBlock();
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            //提示
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
            [cell setTextFieldUserInteractionEnabled:NO];
            [self.smsCodeViewModel.smsCodeParam setObject:DATAMODEL.userInfoData.cellPhoneNum forKey:@"cellPhoneNum"];
            [self.viewModel.updatePwdParam setObject:DATAMODEL.userInfoData.cellPhoneNum forKey:@"cellPhoneNum"];
            cell.inputInfo = DATAMODEL.userInfoData.cellPhoneNum;
            WEAKSelf;
            cell.onSenderBlock = ^(NSInteger item){             //发送按钮回调
                [weakSelf onSmsCodeAction:item];
            };
            return cell;
        }else{
            
            if(self.editPwdType == 0){              //修改登录密码
                GC_InputInfoTableViewCell *cell = [GC_InputInfoTableViewCell cellWithTableView:tableView];
                cell.titleInfo = self.dataSource[indexPath.row-1][0];
                cell.placeholder = self.dataSource[indexPath.row-1][1];
                cell.bottomLongLineImage.hidden = NO;
                
                if(indexPath.row == 1){             //验证码
                    [cell setStartUpPwdLock:NO];
                }else if(indexPath.row == 2){       //新密码
                    [cell setStartUpPwdLock:YES];
                }else if(indexPath.row == 3){       //确认密码
                    [cell setStartUpPwdLock:YES];
                }
                
                
                WEAKSelf;       //输入回调
                
                cell.onInputTextFieldBlock = ^(NSString *inputStr,NSInteger item){
                    if(indexPath.row == 1){             //验证码
                        [weakSelf.viewModel.updatePwdParam setObject:inputStr forKey:@"smsCode"];
                    }else if(indexPath.row == 2){       //密码
                        weakSelf.passwordNew = inputStr;
                    }else if(indexPath.row == 3){       //确认密码
                        weakSelf.passwordConfirm = inputStr;
                    }
                };
                return cell;
            }else if(self.editPwdType == 1){        //修改支付密码
                if(indexPath.row == 1){
                    GC_InputInfoTableViewCell *cell = [GC_InputInfoTableViewCell cellWithTableView:tableView];
                    cell.bottomLongLineImage.hidden = NO;
                    
                    cell.titleInfo = @"验 证 码";
                    cell.placeholder = @"验证码";
                    
                    WEAKSelf;
                    cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item){
                        [weakSelf.viewModel.updatePwdParam setObject:inputStr forKey:@"smsCode"];
                    };
                    return cell;
                }else if(indexPath.row == 2){
                    GC_EditPayPasswordTableViewCell *cell = [GC_EditPayPasswordTableViewCell cellWithTableView:tableView];
                    cell.bottomLongLineImage.hidden = NO;
                    
                    cell.titleInfo = @"新 密 码";
                    
                    WEAKSelf;
                    cell.onInputFinishBlock = ^(NSString *inputStr){
                        weakSelf.passwordNew = inputStr;
                    };
                    return cell;
                }else if(indexPath.row == 3){
                    GC_EditPayPasswordTableViewCell *cell = [GC_EditPayPasswordTableViewCell cellWithTableView:tableView];
                    cell.bottomLongLineImage.hidden = NO;
                    cell.titleInfo = @"确认密码";
                    
                    WEAKSelf;
                    cell.onInputFinishBlock = ^(NSString *inputStr){
                        weakSelf.passwordConfirm = inputStr;
                    };
                    return cell;
                }
            }
            
            
        }
    }else if(indexPath.section == 1){           //完成 按钮
        GC_FinishButtonTableViewCell *cell = [GC_FinishButtonTableViewCell cellWithTableView:tableView];
        
        [cell setProtocolHidden:YES];
        
        WEAKSelf;       //完成按钮 回调
        cell.onFinshBlock = ^(NSInteger item){
            [weakSelf onUpdateFinshAction:item];
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
            if(self.editPwdType == 0){
                return [GC_InputInfoTableViewCell getCellHeight];
            }else if(self.editPwdType == 1){
                if(indexPath.row == 1){
                    return [GC_InputInfoTableViewCell getCellHeight];
                }else{
                    return [GC_EditPayPasswordTableViewCell getCellHeight];
                }
            }
            
            
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
        
        [_dataSource addObjectsFromArray:@[@[@"验 证 码",@"验证码"],@[@"新 密 码",@"新密码"],@[@"确认密码",@"确认密码"]]];
    }
    return _dataSource;
}

- (GC_GetSmsCodeViewModel *)smsCodeViewModel
{
    if(!_smsCodeViewModel){
        _smsCodeViewModel = [[GC_GetSmsCodeViewModel alloc] init];
    }
    return _smsCodeViewModel;
}


- (GC_MineMessageViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_MineMessageViewModel alloc] init];
    }
    return _viewModel;
}

- (void)setEditPwdType:(NSInteger)editPwdType
{
    _editPwdType = editPwdType;
    if(editPwdType == 0){           //登录密码
        self.navigationItem.title = @"登录密码";
    }else if(editPwdType == 1){     //支付密码
        self.navigationItem.title = @"支付密码";
    }
}
@end
