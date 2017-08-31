//
//  GC_AddBankCardViewController.m
//  xianglegou
//
//  Created by mini3 on 2017/5/23.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_AddBankCardViewController.h"
#import "GC_FillInBankCardInfoViewController.h"
#import "GC_SettingConfigViewController.h"

#import "GC_AddBankCardTableViewCell.h"

#import "GC_BankBindingViewModel.h"

@interface GC_AddBankCardViewController ()<UITableViewDelegate, UITableViewDataSource>

///TableView
@property (nonatomic, weak) UITableView *tableView;

///下一步
@property (nonatomic, weak) UIButton *nextButton;


///ViewModel
@property (nonatomic, strong) GC_BankBindingViewModel *viewModel;

@end

@implementation GC_AddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
    
    [self loadgetUserIdCardInfo];
    
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


- (void)onGoBackClick:(id)sender
{
    [DATAMODEL.alertManager showTwoButtonWithMessage:@"现在您还没有添加银行卡，会影响结算哦！确定要返回吗？"];
    
    [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
        if(buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

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

///加载子视图
-(void)loadSubView
{
    self.navigationItem.title = @"添加银行卡";
    
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


///加载用户实名信息-
- (void)loadgetUserIdCardInfo
{
    if(!self.isFirstAdd){
        
        //显示加载
        [self showPayHud:@""];
        WEAKSelf;
        [self.viewModel getIdCardInfoDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
            //取消加载
            [weakSelf hideHud];
            if([code isEqualToString:@"0000"]){
                weakSelf.inputData.ownerName = weakSelf.viewModel.idCardInfoData.realName;
                weakSelf.inputData.idCard = weakSelf.viewModel.idCardInfoData.idCardNo;
                
                [weakSelf.tableView reloadData];
            }else{
                [weakSelf showHint:desc];
            }
        }];
    }
}


#pragma mark -- action
///设置 默认回调
-(void)onSetUpDefaultAction:(UIButton *)sender
{
    if(self.isFirstAdd){
        if(sender.isSelected){
            [sender setSelected:YES];
            self.inputData.isDefault = @"true";
        }else{
            [sender setSelected:YES];
            self.inputData.isDefault = @"true";
        }
    }else{
        
        if(self.isDefault){
            if(sender.isSelected){
                [sender setSelected:YES];
                self.inputData.isDefault = @"true";
            }else{
                [sender setSelected:YES];
                self.inputData.isDefault = @"true";
            }
        }else{
            if(sender.isSelected){
                [sender setSelected:NO];
                self.inputData.isDefault = @"false";
            }else{
                [sender setSelected:YES];
                self.inputData.isDefault = @"true";
            }
        }
    }
}

///下一步
-(void)onNextButtonAction:(UIButton *)sender
{
    
    if(self.inputData.cardNum.length <= 0){
        [self showHint:@"卡号未填写！"];
        return;
    }
    
    
    GC_FillInBankCardInfoViewController *fbcVC = [[GC_FillInBankCardInfoViewController alloc] init];
    fbcVC.hidesBottomBarWhenPushed = YES;
    
    fbcVC.inputData = self.inputData;
    
    [self.navigationController pushViewController:fbcVC animated:YES];
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){         //持卡人
        GC_AddBankCardTableViewCell *cell = [GC_AddBankCardTableViewCell cellWithTableView:tableView];
        cell.titleInfo = @"持卡人";
        cell.inputInfo = self.inputData.ownerName;
        [cell setTextFieldUserInteractionEnabled:NO];
        cell.topLongLineImage.hidden = NO;
        WEAKSelf;
        //持卡人说明回调
        cell.onDescriptionBlock = ^(NSInteger item) {
            GC_SettingConfigViewController *scVC = [[GC_SettingConfigViewController alloc] init];
            scVC.hidesBottomBarWhenPushed = YES;
            scVC.titleInfo = @"银行卡持卡人";
            scVC.configKey = @"BANKCARD_OWNER_DESC";
            [weakSelf.navigationController pushViewController:scVC animated:YES];
        };
        return cell;
    }else if(indexPath.row == 1){   //卡号
        GC_AddBankCardTableViewCell *cell = [GC_AddBankCardTableViewCell cellWithTableView:tableView];
        cell.topLongLineImage.hidden = NO;
        cell.bottomLongLineImage.hidden = NO;
        cell.titleInfo = @"卡号";
        cell.placeholder = @"卡号";
        [cell setClearButtonHidden:YES];
        cell.inputType = 1;
        
        [cell setTextFieldUserInteractionEnabled:YES];
        [cell setIconImageHidden:YES];
        [cell setTextFieldForKeyboardType:UIKeyboardTypeNumberPad];
        WEAKSelf;
        cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item) {
            weakSelf.inputData.cardNum = inputStr;
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
    
    return [self tableViewHeaderViewForTitle:@"请绑定持卡人本人的银行卡"];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
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
    
    UIButton *button = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onSetUpDefaultAction:)];
    [button setTitle:@" 设为默认提现卡" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"mine_choose_no"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"mine_choose"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"mine_choose"] forState:UIControlStateSelected];
    if(self.isFirstAdd){
        if([self.inputData.isDefault isEqualToString:@"true"]){
            [button setSelected:YES];
        }
    }else{
        if(self.isDefault){
            self.inputData.isDefault = @"true";
            [button setSelected:YES];
        }else{
            [button setSelected:NO];
            self.inputData.isDefault = @"false";
        }
        
    }
    
   
    
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
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
