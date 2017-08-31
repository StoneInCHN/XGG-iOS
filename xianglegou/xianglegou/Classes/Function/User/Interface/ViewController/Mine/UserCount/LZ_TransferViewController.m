//
//  LZ_TransferViewController.m
//  xianglegou
//
//  Created by mini1 on 2017/8/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "LZ_TransferViewController.h"
#import "GC_InputInfoTableViewCell.h"
#import "GC_MobileSenderTableViewCell.h"
#import "GC_GetSmsCodeViewModel.h"
#import "LZ_TransferViewModel.h"
#import "QL_PayBillViewModel.h"
#import "GC_MineEditPasswordViewController.h"
#import "QL_PayPasswordInputView.h"
#import "GC_MineMessageViewModel.h"



@interface LZ_TransferViewController ()

///Table View
@property (nonatomic, weak) UITableView *tableView;
///发送短信
@property (nonatomic, strong) GC_GetSmsCodeViewModel *smsCodeVideModel;
///dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;

///确认转账按钮
@property (nonatomic, strong) UIButton *transferButton;

@property (nonatomic ,strong) LZ_TransferViewModel *transferViewModel;

///view model
@property(nonatomic, strong) QL_PayBillViewModel *viewModel;

///密码支付输入
@property(nonatomic, strong) QL_PayPasswordInputView *payPasswordView;

///ViewModel
@property (nonatomic, strong) GC_MineMessageViewModel *mineViewModel;



///是否验证支付密码
@property (nonatomic, assign) BOOL isVerPayPwd;






@end

@implementation LZ_TransferViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubView];
    //获取RSA key
    [DATAMODEL loadRSAPublickey];
    [self loadMineMessageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///点击返回按钮
-(void)onGoBackClick:(id)sender
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    if(self.onGoBackSuccess){
        self.onGoBackSuccess();
    }
}




#pragma mark -- override
///清除数据
-(void)cleanUpData
{
    [self.dataSource removeAllObjects];
    [self setDataSource:nil];
//
//    [self setViewModel:nil];
//    [self setSmsCodeVideModel:nil];
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    
}


///加载子视图
-(void)loadSubView
{
    
    if([self.transType isEqualToString:@"LE_MIND"]){//乐心
        self.navigationItem.title = HenLocalizedString(@"乐心转账");
    }else if([self.transType isEqualToString:@"LE_BEAN"]){ //乐豆
        self.navigationItem.title = HenLocalizedString(@"乐豆转账");
        
    }else if([self.transType isEqualToString:@"LE_SCORE"]){ //乐分
        self.navigationItem.title = HenLocalizedString(@"乐分转账");
    }
   
    self.view.backgroundColor = kCommonBackgroudColor;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);;
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
    }];
    
}


#pragma mark -- action


//加载我的 数据
-(void)loadMineMessageData
{
    
    //    [self showPayHud:@"正在刷新状态..."];
    //参数
    [self.mineViewModel.userInfoParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.mineViewModel.userInfoParam setValue:DATAMODEL.token forKey:@"token"];
    //请求
    WEAKSelf;
    [self.mineViewModel getUserInfoWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        
        if([code isEqualToString:@"0000"]){
            DATAMODEL.userInfoData = self.mineViewModel.userInfoData;
          
        }
        
        [weakSelf.tableView reloadData];
        
    }];
}



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
    [self.smsCodeVideModel.smsCodeParam setObject:@"TRANSFER" forKey:@"smsCodeType"];
    
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.smsCodeVideModel getSmsCodeWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        
        if([code isEqualToString:@"0000"]){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [((GC_MobileSenderTableViewCell*)[weakSelf.tableView cellForRowAtIndexPath:indexPath]) startOnTimers];
            
            [weakSelf showHint:HenLocalizedString(@"已向手机号发送短信，请注意查收！")];
        }else{
            [weakSelf showHint:desc];
        }
    }];
    
}


///验证支付密码
-(void)verPayPwd
{
    if([DATAMODEL.userInfoData.isSetPayPwd isEqualToString:@"0"]){
        //提示
        [self showHint:@"支付密码暂未设置！"];
        [self showPayPasswordChange];
        return;
    }
    if(!self.isVerPayPwd){           //未验证过支付密码
       [self.payPasswordView showView];
    }


}


///显示支付密码修改
- (void)showPayPasswordChange
{
    //跳转
    GC_MineEditPasswordViewController *mepVC = [[GC_MineEditPasswordViewController alloc] init];
    mepVC.hidesBottomBarWhenPushed = YES;
    mepVC.editPwdType = 1;
    //回调
    WEAKSelf;
    mepVC.onEditPaySuccessBlock = ^(NSString *payPwd){
             weakSelf.isVerPayPwd = YES;
            [weakSelf onUserTransfer];
    
    };
    
    [self.navigationController pushViewController:mepVC animated:YES];
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
            
                weakSelf.isVerPayPwd = YES;
                [weakSelf onUserTransfer]; ///验证成功调用转账方法
        }else if([code isEqualToString:@"1000"]){// 支付密码错误
            //提示
            [DATAMODEL.alertManager showCustomButtonTitls:@[@"重新输入", @"忘记密码"] message:@"支付密码错误，请重试。"];
            [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
                if(buttonIndex == 0){
                    //显示支付密码输入
                    [weakSelf.payPasswordView showView];
                }else{
                    [weakSelf showPayPasswordChange];
                }
            }];
            
        }else{
             weakSelf.isVerPayPwd=false;
            [weakSelf showHint:desc];
        }
    }];
    
}


///确认转账
-(void)onTransferAction
{
    [self.view endEditing:YES];
     Hen_Util *henUtil=[[Hen_Util alloc] init];
    self.transferViewModel.transferModel.token=DATAMODEL.token;
    self.transferViewModel.transferModel.userId=DATAMODEL.userInfoData.id;
    if(self.transferViewModel.transferModel.cellPhoneNum.length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }
    
    if(self.transferViewModel.transferModel.cellPhoneNum.length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    
    if(self.transferViewModel.transferModel.smsCode.length <= 0){
        [self showHint:HenLocalizedString(@"验证码未输入")];
        return;
    }
    
    if(self.transferViewModel.transferModel.amount.intValue==0){
        [self showHint:HenLocalizedString(@"转账数量不可为空")];
        return ;
    }
    
    if([self.transType isEqualToString:@"LE_MIND"]){//乐心
        
       self.transferViewModel.transferModel.transType = @"LE_MIND";
        if(![henUtil isPureInt:self.transferViewModel.transferModel.amount]){
        
        [self showHint:HenLocalizedString(@"转账数量为整数")];
           return;
        }
        
        if(self.transferViewModel.transferModel.amount.intValue>DATAMODEL.userInfoData.curLeMind.intValue){
        [self showHint:HenLocalizedString(@"转账数量不能大于当前数量")];
            return ;
        }
    }else if([self.transType isEqualToString:@"LE_BEAN"]){ //乐豆
       
          self.transferViewModel.transferModel.transType = @"LE_BEAN";
        
        if(![henUtil isFourMath:self.transferViewModel.transferModel.amount len:@"4"]){
            
            [self showHint:HenLocalizedString(@"转账数量最多可输入四位小数")];
            return ;
        }
            
        if(self.transferViewModel.transferModel.amount.intValue>DATAMODEL.userInfoData.curLeBean.intValue){
            [self showHint:HenLocalizedString(@"转账数量不能大于当前数量")];
        }
        
    }else if([self.transType isEqualToString:@"LE_SCORE"]){ //乐分
        
            self.transferViewModel.transferModel.transType = @"LE_SCORE";
        
            if(![henUtil isFourMath:self.transferViewModel.transferModel.amount len:@"4"]){
                
                [self showHint:HenLocalizedString(@"转账数量最多可输入四位小数")];
                return ;
            }
            
            
            if(self.transferViewModel.transferModel.amount.intValue>DATAMODEL.userInfoData.curLeScore.intValue){
                [self showHint:HenLocalizedString(@"转账数量不能大于当前数量")];
            }
    }
    
    ///验证支付密码
    if(self.isVerPayPwd){
        [self onUserTransfer];
    }else{
      [self verPayPwd];
    }
    

    
}

///验证手机号
-(void)verifyReceiver
{
    
    if(((NSString*)[self.transferViewModel.verifyReceiverParam objectForKey:@"receiverMobile"]).length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }
    
    if(((NSString*)[self.transferViewModel.verifyReceiverParam objectForKey:@"receiverMobile"]).length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    [self.transferViewModel.verifyReceiverParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.transferViewModel.verifyReceiverParam setObject:DATAMODEL.token forKey:@"token"];
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.transferViewModel getVerifyReceiverWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf.transferViewModel.verifyReceiverParam setObject:@"" forKey:@"receiverMobile"];
            [weakSelf showHint:HenLocalizedString(@"该用户可以转账")];
            
        }else{

            [weakSelf showHint:desc];
        }
        
    }];

}

///转账的方法

-(void)onUserTransfer
{
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [self.transferViewModel setUserTransferWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            ///返回上一个界面
             [weakSelf showHint:HenLocalizedString(@"操作成功")];
             [weakSelf.transferViewModel setTransferModel:nil];
             [weakSelf loadMineMessageData];
            
        }else{
             weakSelf.isVerPayPwd=false;
            [weakSelf showHint:desc];
        }
        
    }];

}



#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if(indexPath.section == 1){
        
            GC_MobileSenderTableViewCell *cell = [GC_MobileSenderTableViewCell cellWithTableView:tableView];

            [cell setClearButtonHidden:YES];
            cell.titleInfo = self.dataSource[indexPath.section][0];
            cell.placeholder = self.dataSource[indexPath.section][1];
            [cell setInputInfo:DATAMODEL.userInfoData.cellPhoneNum];
            [cell setTextFieldUserInteractionEnabled:NO];
            cell.topLongLineImage.hidden = NO;
            cell.bottomLongLineImage.hidden = NO;
            [cell setSenderButtonHidden:NO];
            [cell  setSecondLabelHidden:YES];
            [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
            
            [self.smsCodeVideModel.smsCodeParam setObject:DATAMODEL.userInfoData.cellPhoneNum forKey:@"cellPhoneNum"];

            WEAKSelf;
            
            cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item){     //输入回调
                [weakSelf.smsCodeVideModel.smsCodeParam setObject:inputStr forKey:@"cellPhoneNum"];

            };
            
            
            cell.onSenderBlock = ^(NSInteger item){     //发送短信 回调
                [weakSelf onGetSmsCodeAction:item];
            };
            return cell;
            
            
        }else{
         GC_InputInfoTableViewCell *cell = [GC_InputInfoTableViewCell cellWithTableView:tableView];
            cell.titleInfo = self.dataSource[indexPath.section][0];
            cell.placeholder = self.dataSource[indexPath.section][1];
            cell.bottomLongLineImage.hidden = NO;
            [cell setClearButtonHidden:NO];
            [cell setStartUpPwdLock:NO];
            [cell setInputInfo:@""];
            WEAKSelf;       //输入回调
            cell.onInputTextFieldBlock = ^(NSString *inputStr,NSInteger item){
                if(indexPath.section == 0){  //转账手机号
                    weakSelf.transferViewModel.transferModel.cellPhoneNum =inputStr;
                    [weakSelf.transferViewModel.verifyReceiverParam setObject:inputStr forKey:@"receiverMobile"];
                    ///验证手机号
                    [self verifyReceiver];
                    
                }else if(indexPath.section == 2){   //验证码
                   weakSelf.transferViewModel.transferModel.smsCode =inputStr;
                }else if(indexPath.section == 3){   //转账数量
                 weakSelf.transferViewModel.transferModel.amount =inputStr;
                }
            };
            
            return cell;
    
    }
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==1){
    
       
          return [GC_MobileSenderTableViewCell getCellHeight];
        }else{
        
          return [GC_InputInfoTableViewCell getCellHeight];
        }
        
     return CGFLOAT_MIN;


}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
        if(section==3){
         NSString *centent=@"";
            
        if([self.transType isEqualToString:@"LE_MIND"]){//乐心
            centent=DATAMODEL.userInfoData.curLeMind;
        }else if([self.transType isEqualToString:@"LE_BEAN"]){ //乐豆
            centent=DATAMODEL.userInfoData.curLeBean;
        
        }else if([self.transType isEqualToString:@"LE_SCORE"]){ //乐分
            centent=DATAMODEL.userInfoData.curLeScore;
        }
        return [self tableViewFooterViewForTitle:centent];
    }
     return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if(section == 3){
    
        return HEIGHT_TRANSFORMATION(90);
        
    }
    return CGFLOAT_MIN;
}

-(UIView*)tableViewFooterViewForTitle:(NSString*)centent
{
    UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(90)) backgroundColor:kCommonBackgroudColor];
    
    NSString *title=@"";
    
    if([self.transType isEqualToString:@"LE_MIND"]){//乐心
        title=@"当前乐心";
    }else if([self.transType isEqualToString:@"LE_BEAN"]){ //乐豆
        title=@"当前乐豆";
        
    }else if([self.transType isEqualToString:@"LE_SCORE"]){ //乐分
        title=@"当前乐分";
    }
    

    
    UILabel *titleLabel = [UILabel createLabelWithText:HenLocalizedString(title) font:kFontSize_28 textColor:kFontColorBlack];
    UILabel *cententLable=[UILabel createLabelWithText:HenLocalizedString(centent)  font:kFontSize_24 textColor:kFontColorGray];
    [view addSubview:titleLabel];
    [view addSubview:cententLable];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(OffSetToLeft);
        
    }];
    
    [cententLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(view);
         make.left.equalTo(view).offset(WIDTH_TRANSFORMATION(225));
    }];
    
    return view;
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

- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataSource addObjectsFromArray:@[@[@"手 机 号",@"转账手机号"],@[@"手 机 号",@"获取自己手机号"],@[@"验 证 码",@"验证码"],@[@"转账数量",@"数量"]]];
    }
    return _dataSource;
}


- (GC_GetSmsCodeViewModel *)smsCodeVideModel
{
    if(!_smsCodeVideModel){
        _smsCodeVideModel = [[GC_GetSmsCodeViewModel alloc] init];
    }
    return _smsCodeVideModel;
}

-(LZ_TransferViewModel *)transferViewModel
{
    if(!_transferViewModel){
        _transferViewModel =[[LZ_TransferViewModel alloc] init];
        
    }

    return _transferViewModel;
}
- (QL_PayBillViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_PayBillViewModel alloc] init];
    }
    return _viewModel;
}

///密码支付输入
- (QL_PayPasswordInputView *)payPasswordView
{
    if(!_payPasswordView){
        _payPasswordView = [[QL_PayPasswordInputView alloc] init];
        //回调
        WEAKSelf;
        _payPasswordView.onInputFinishBlock = ^(NSString *password){
            //            weakSelf.viewModel.orderPayParam.payPwd = [DATAMODEL RSAEncryptorString:password];
            //支付密码(rsa加密)
            [weakSelf.viewModel.verifyPayPwdParam setObject:[DATAMODEL RSAEncryptorString:password] forKey:@"password"];
            
            [weakSelf setVerifyPayPassWord];
        };
    }
    return _payPasswordView;
}

///转账按钮
- (UIButton *)transferButton
{
    if(!_transferButton){
        _transferButton = [UIButton createButtonWithTitle:HenLocalizedString(@"确认转账") backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onTransferAction)];
        _transferButton.titleLabel.font = kFontSize_36;
        [_transferButton setTitleClor:kFontColorWhite];
        [self.view addSubview:_transferButton];
    }
    return _transferButton;
}


- (GC_MineMessageViewModel *)mineViewModel
{
    if(!_mineViewModel){
        _mineViewModel = [[GC_MineMessageViewModel alloc] init];
    }
    return _mineViewModel;
}


@end
