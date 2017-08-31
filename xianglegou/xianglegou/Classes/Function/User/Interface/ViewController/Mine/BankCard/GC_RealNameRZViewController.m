//
//  GC_RealNameRZViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  实名认证 - 界面
//

#import "GC_RealNameRZViewController.h"
#import "GC_SettingConfigViewController.h"
#import "GC_AddBankCardViewController.h"

#import "GC_AddBankCardTableViewCell.h"
#import "GC_IdentityCardInfoTableViewCell.h"

#import "GC_BankBindingViewModel.h"
#import "GC_BankBindingRequestDataModel.h"

@interface GC_RealNameRZViewController ()<UITableViewDelegate, UITableViewDataSource>

///TableView
@property (nonatomic, weak) UITableView *tableView;

///下一步
@property (nonatomic, weak) UIButton *nextButton;

///ViewModel
@property (nonatomic, strong) GC_BankBindingViewModel *viewModel;

///输入信息
@property (nonatomic, strong) GC_InputBandCardInfoRequestDataModel *inputData;

///身份证正面照
@property (nonatomic, weak) UIImage *cardFrontPic;
///身份证反面照
@property (nonatomic, weak) UIImage *cardBackPic;
@end

@implementation GC_RealNameRZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNavigationItem];
    
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
    self.navigationItem.title = HenLocalizedString(@"实名认证");
    self.tableView.backgroundColor = kCommonBackgroudColor;
    
    UIBarButtonItem *rightBar = [UIBarButtonItem createBarButtonItemWithTitle:@"说明" titleColor:kFontColorWhite target:self action:@selector(onExplainAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

///加载子视图
-(void)loadSubView
{
    
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
///下一步  实名认证操作
- (void)onNextButtonAction:(UIButton *)sender
{

    
    if(((NSString *)[self.viewModel.doIdentityAuthParam objectForKey:@"realName"]).length <= 0){
        [self showHint:@"资料未填写完整！"];
        return;
    }
    if(((NSString *)[self.viewModel.doIdentityAuthParam objectForKey:@"cardNo"]).length <= 0){
        [self showHint:@"资料未填写完整！"];
        return;
    }
    
    if(self.cardFrontPic == nil){
        [self showHint:@"资料未填写完整！"];
        HenLog(@"正面没有上传！");
        return;
    }
    
    if(self.cardBackPic == nil){
        [self showHint:@"资料未填写完整！"];
        HenLog(@"背面没有上传！");
        return;
    }
    
    [self.viewModel.doIdentityAuthParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.doIdentityAuthParam setObject:DATAMODEL.token forKey:@"token"];

    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    [self.viewModel setCardFrontPic:self.cardFrontPic andCardBackPic:self.cardBackPic setDoIdentityAuthDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            GC_AddBankCardViewController *acVC = [[GC_AddBankCardViewController alloc] init];
            
            acVC.hidesBottomBarWhenPushed = YES;
            weakSelf.inputData.isDefault = @"true";
            weakSelf.inputData.ownerName = desc;
            
            acVC.isFirstAdd = YES;
            
            acVC.inputData = weakSelf.inputData;
            [weakSelf.navigationController pushViewController:acVC animated:YES];
        }else {
            [weakSelf showHint:desc];
        }
    }];
    
    
}

///说明 回调
- (void)onExplainAction:(id)sender
{
    GC_SettingConfigViewController *scVC = [[GC_SettingConfigViewController alloc] init];
    scVC.hidesBottomBarWhenPushed = YES;
    scVC.titleInfo = @"实名认证";
    scVC.configKey = @"USER_AUTH_DESC";
    
    [self.navigationController pushViewController:scVC animated:YES];
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){             //真实姓名
            GC_AddBankCardTableViewCell *cell = [GC_AddBankCardTableViewCell cellWithTableView:tableView];
            [cell setIconImageHidden:YES];
            cell.topLongLineImage.hidden = NO;
            cell.bottomLongLineImage.hidden = NO;
            cell.titleInfo = @"真实姓名";
            cell.placeholder = @"真实姓名";
            
            WEAKSelf;
            cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item) {
                [weakSelf.viewModel.doIdentityAuthParam setObject:inputStr forKey:@"realName"];
                
                weakSelf.inputData.ownerName = inputStr;
            };
            
            return cell;
        }else if(indexPath.row == 1){       //身份证号
            GC_AddBankCardTableViewCell *cell = [GC_AddBankCardTableViewCell cellWithTableView:tableView];
            [cell setIconImageHidden:YES];
            cell.bottomLongLineImage.hidden = NO;
            cell.inputType = 3;
            [cell setTextFieldForKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            cell.titleInfo = @"身份证号";
            cell.placeholder = @"身份证号";
            
            WEAKSelf;
            cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item) {
                [weakSelf.viewModel.doIdentityAuthParam setObject:inputStr forKey:@"cardNo"];
                weakSelf.inputData.idCard = inputStr;
            };
            return cell;
        }
    }else if(indexPath.section == 1){       //身份证图片
        GC_IdentityCardInfoTableViewCell *cell = [GC_IdentityCardInfoTableViewCell cellWithTableView:tableView];
        cell.topLongLineImage.hidden = NO;
        cell.bottomLongLineImage.hidden = NO;
        
        WEAKSelf;
        cell.onPositivePicBlock = ^(UIImage *image) {       //身份证正面
            weakSelf.cardFrontPic = image;
        };
        
        cell.onBackPicBlock = ^(UIImage *image) {           //身份证反面
            weakSelf.cardBackPic = image;
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return [GC_AddBankCardTableViewCell getCellHeight];
    }else if(indexPath.section == 1){
        return [GC_IdentityCardInfoTableViewCell getCellHeight];
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
        return 2;
    }else if(section == 1){
        return 1;
    }
    return 0;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return [self tableViewHeaderViewForTitle:@"信息已安全加密，仅用于实名认证审核"];
    }
    return [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(30)) backgroundColor:kCommonBackgroudColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return HEIGHT_TRANSFORMATION(80);
    }else if(section == 1){
        return HEIGHT_TRANSFORMATION(12);
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

- (GC_BankBindingViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_BankBindingViewModel alloc] init];
    }
    return _viewModel;
}

- (GC_InputBandCardInfoRequestDataModel *)inputData
{
    if(!_inputData){
        _inputData = [[GC_InputBandCardInfoRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _inputData;
}
@end
