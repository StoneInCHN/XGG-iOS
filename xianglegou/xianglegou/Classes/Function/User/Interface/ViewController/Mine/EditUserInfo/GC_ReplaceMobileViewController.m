//
//  GC_ReplaceMobileViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/7/7.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_ReplaceMobileViewController.h"
#import "GC_MobileSenderTableViewCell.h"
#import "GC_InputInfoTableViewCell.h"
#import "GC_FinishButtonTableViewCell.h"

#import "GC_GetSmsCodeViewModel.h"
#import "GC_EditUserInfoViewModel.h"

@interface GC_ReplaceMobileViewController ()<UITableViewDelegate, UITableViewDataSource>
///TableView
@property (nonatomic, weak) UITableView *tableView;

///DataSource
@property (nonatomic, strong) NSMutableArray *dataSource;

///发送短信
@property (nonatomic, strong) GC_GetSmsCodeViewModel *smsCodeVideModel;

///ViewModel
@property (nonatomic, strong) GC_EditUserInfoViewModel *viewModel;
@end

@implementation GC_ReplaceMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
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

#pragma mark -- private
///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"更换手机号";
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}


///发送 操作
- (void)sendSmsCode
{
    
    [self.view endEditing:YES];
    
    if(((NSString *)[self.smsCodeVideModel.smsCodeParam objectForKey:@"cellPhoneNum"]).length <= 0){
        [self showHint:@"手机号未输入！"];
        return;
    }
    
    if(((NSString *)[self.smsCodeVideModel.smsCodeParam objectForKey:@"cellPhoneNum"]).length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    
    //参数
    [self.smsCodeVideModel.smsCodeParam setObject:@"REG" forKey:@"smsCodeType"];
    
    WEAKSelf;
    //显示加载
    [self showPayHud:@""];
    
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


///完成 操作
- (void)replaceMobile
{
    [self.view endEditing:YES];
    
    if(((NSString *)[self.viewModel.changeMobileParam objectForKey:@"cellPhoneNum"]).length <= 0){
        [self showHint:HenLocalizedString(@"手机号未输入！")];
        return;
    }
    
    if(((NSString *)[self.viewModel.changeMobileParam objectForKey:@"cellPhoneNum"]).length != 11){
        [self showHint:HenLocalizedString(@"手机号输入有误！")];
        return;
    }
    
    
    if(((NSString *)[self.viewModel.changeMobileParam objectForKey:@"smsCode"]).length <= 0){
        [self showHint:@"验证码未输入！"];
        return;
    }
    
    //参数
    [self.viewModel.changeMobileParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.changeMobileParam setObject:DATAMODEL.token forKey:@"token"];
    
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    [self.viewModel setChangeMobileDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [DATAMODEL.userDBHelper updateUserMoblie:[weakSelf.viewModel.changeMobileParam objectForKey:@"cellPhoneNum"]];
            
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
    if(indexPath.row == 0){         //手机号
        GC_MobileSenderTableViewCell *cell = [GC_MobileSenderTableViewCell cellWithTableView:tableView];
        cell.topLongLineImage.hidden = NO;
        cell.bottomLongLineImage.hidden = NO;
        
        cell.titleInfo = @"手 机 号";
        cell.placeholder = @"新的手机号";
        
        [cell setClearButtonHidden:YES];
        [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
        
        WEAKSelf;
        cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item) {
            [weakSelf.viewModel.changeMobileParam setObject:inputStr forKey:@"cellPhoneNum"];
            [weakSelf.smsCodeVideModel.smsCodeParam setObject:inputStr forKey:@"cellPhoneNum"];
        };
        
        
        cell.onSenderBlock = ^(NSInteger item) {
            [weakSelf sendSmsCode];
        };
        
        
        return cell;
    }else if(indexPath.row == 1){
        GC_InputInfoTableViewCell *cell = [GC_InputInfoTableViewCell cellWithTableView:tableView];
        cell.bottomLongLineImage.hidden = NO;
        
        cell.titleInfo = @"验 证 码";
        cell.placeholder = @"验证码";
        
        
        WEAKSelf;
        cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item) {
            [weakSelf.viewModel.changeMobileParam setObject:inputStr forKey:@"smsCode"];
        };
        
        return cell;
    }else if(indexPath.row == 2){
        GC_FinishButtonTableViewCell *cell = [GC_FinishButtonTableViewCell cellWithTableView:tableView];
        [cell setProtocolHidden:YES];
        
        WEAKSelf;
        cell.onFinshBlock = ^(NSInteger item) {
            [weakSelf replaceMobile];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){     //手机号
        return [GC_MobileSenderTableViewCell getCellHeight];
    }else if(indexPath.row == 1){
        return [GC_InputInfoTableViewCell getCellHeight];
    }else if(indexPath.row == 2){
        return [GC_FinishButtonTableViewCell getCellHeight];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return [self tableViewHeaderViewForTitle:[NSString stringWithFormat:@"当前手机号：%@",DATAMODEL.userInfoData.cellPhoneNum]];
    }
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return HEIGHT_TRANSFORMATION(80);
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

- (GC_GetSmsCodeViewModel *)smsCodeVideModel
{
    if(!_smsCodeVideModel){
        _smsCodeVideModel = [[GC_GetSmsCodeViewModel alloc] init];
    }
    return _smsCodeVideModel;
}

///ViewModel
- (GC_EditUserInfoViewModel *)viewModel
{
    if(!_viewModel){
        
        _viewModel = [[GC_EditUserInfoViewModel alloc] init];
    }
    return _viewModel;
}
@end
