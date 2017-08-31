//
//  GC_MineEditInfoViewController.m
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  修改信息 界面
//

#import "GC_MineEditInfoViewController.h"

#import "GC_EditHeadImageTableViewCell.h"
#import "GC_MineItemTableViewCell.h"

#import "GC_MineMessageViewModel.h"

#import "GC_MineEditPasswordViewController.h"
#import "GC_WeChatBindingViewController.h"
#import "GC_LoginViewController.h"
#import "GC_ReplaceMobileViewController.h"

#import "QL_AreaPickerView.h"
#import "QL_PayPasswordInputView.h"

@interface GC_MineEditInfoViewController ()<Hen_PhotoCollectManagerDelegate, UITableViewDelegate, UITableViewDataSource>
///TableView
@property (nonatomic, weak) UITableView *tableView;
///退出账号
@property (nonatomic, weak) UIButton *exitAccountButton;
///data Source
@property (nonatomic, strong) NSMutableArray *dataSource;

///ViewModel
@property (nonatomic, strong) GC_MineMessageViewModel *viewModel;

///头像数据
@property (nonatomic, strong) GC_UserPhotoDataModel *phtotData;

///照片采集器
@property (nonatomic, strong) Hen_PhotoCollectManager *photoCollect;
///地区选择View
@property (nonatomic, strong) QL_AreaPickerView *areaPickerView;
///显示地区
///@property (nonatomic, strong) NSString *addressInfo;


@end

@implementation GC_MineEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubViewAndConstraint];
    
    [self loadTableView];
    
    [self.tableView.header beginRefreshingForWaitMoment];
    
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
    
    [self setPhtotData:nil];
    
    [self setPhotoCollect:nil];
    
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
    [self.areaPickerView removeFromSuperview];
    [self setAreaPickerView:nil];
}

#pragma mark -- private
///加载子视图
-(void)loadSubViewAndConstraint
{
    self.navigationItem.title = HenLocalizedString(@"修改信息");
    self.view.backgroundColor = kCommonBackgroudColor;
    
    [self.exitAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(99));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.exitAccountButton.mas_top);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
}

///加载列表数据
- (void)loadTableView
{
    WEAKSelf;
    //下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadUserInfoData];
    }];
}

///失败操作
-(void)failureUserInfoData
{
    DATAMODEL.isLogin = NO;
    [DATAMODEL setToken:@""];
    [DATAMODEL setUserInfoData:nil];
    [self.viewModel setUserInfoData:nil];
    
    
    GC_LoginViewController *lVC = [[GC_LoginViewController alloc] init];
    lVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:lVC animated:YES];

}

///加载用户信息
-(void)loadUserInfoData
{
    //参数
    [self.viewModel.userInfoParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.userInfoParam setValue:DATAMODEL.token forKey:@"token"];
    //请求
    WEAKSelf;
    [self.viewModel getUserInfoWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf.tableView.header endRefreshing];
        
        if([code isEqualToString:@"0000"]){    //成功
            
            
            weakSelf.phtotData.statue = 3;
            weakSelf.phtotData.image = weakSelf.viewModel.userInfoData.userPhoto;
            
            
            
            
            [weakSelf.areaPickerView setFirstSelectedByAreaId:weakSelf.viewModel.userInfoData.area.id];
            
            [weakSelf.tableView reloadData];
        }else{  //失败
            [weakSelf showHint:desc];
            [weakSelf failureUserInfoData];
            
        }
    }];
}

///修改用户信息
-(void)updateUserInfoData
{
    self.viewModel.editUserInfoParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.editUserInfoParam.token = DATAMODEL.token;
    WEAKSelf;
    [self.viewModel setEditUserInfoDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            
            
            [weakSelf.areaPickerView setFirstSelectedByAreaId:weakSelf.viewModel.userInfoData.area.id];
            
            [weakSelf.tableView reloadData];
            
            
        }else{
            [weakSelf showHint:desc];
        }
    }];
}


#pragma mark -- event response
///退出账号
- (void)onExitAccountAction:(UIButton*)sender
{
    //参数
    //用户ID
    [self.viewModel.signOutParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //token
    [self.viewModel.signOutParam setObject:DATAMODEL.token forKey:@"token"];
    
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    //请求
    [self.viewModel setSignOutWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            DATAMODEL.isLogin = NO;
            [DATAMODEL setUserInfoData:nil];
            [DATAMODEL setToken:@""];
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
        if(indexPath.row == 0){ //头像
            GC_EditHeadImageTableViewCell *cell = [GC_EditHeadImageTableViewCell cellWithTableView:tableView];
            [cell updateForData:self.phtotData];
            return cell;
        }else{
            GC_MineItemTableViewCell *cell = [GC_MineItemTableViewCell cellWithTableView:tableView];
            cell.titleInfo = self.dataSource[indexPath.row-1][0];
            cell.contentInfo = self.dataSource[indexPath.row-1][1];
            [cell setNextImageViewHidden:NO];
            [cell setTextFieldHidden:YES];
            [cell setClearButtonHidden:NO];
            
            if(indexPath.row == 1){         //账号
                [cell setNextImageViewHidden:YES];
                [cell setTextFieldHidden:NO];
                [cell setTextFieldUserInteractionEnabled:NO];
                
                cell.inputInfo = self.viewModel.userInfoData.cellPhoneNum;
            }else if(indexPath.row == 2){   //昵称
                [cell setNextImageViewHidden:YES];
                [cell setTextFieldHidden:NO];
                [cell setTextFieldUserInteractionEnabled:YES];
                [cell setClearButtonHidden:YES];
                
                cell.inputInfo = self.viewModel.userInfoData.nickName;
                cell.maxCount = 15;
                WEAKSelf;       //输入回调
                cell.onInputTextFieldBlock = ^(NSString *inputStr, NSInteger item){
                    weakSelf.viewModel.editUserInfoParam.nickName = inputStr;
                    weakSelf.viewModel.editUserInfoParam.areaId = @"";
                    [weakSelf updateUserInfoData];
                };
            }else if(indexPath.row == 3){   //所在地区
                
                
                if(self.viewModel.userInfoData.area.id.length > 0){
                    QL_AreaDataModel *modelL3 = [DATAMODEL.configDBHelper getAreaDataForId:self.viewModel.userInfoData.area.id];
                    cell.contentInfo = modelL3.fullName;
                }
//                if(self.addressInfo.length > 0){
//                    cell.contentInfo = self.addressInfo;
//                }
            }else if(indexPath.row == 4){   //登录密码设置
                if([DATAMODEL.userInfoData.isSetLoginPwd isEqualToString:@"1"]){
                    cell.contentInfo = @"已设置";
                }
            }else if(indexPath.row == 5){   //支付密码设置
                if([DATAMODEL.userInfoData.isSetPayPwd isEqualToString:@"1"]){
                    cell.contentInfo = @"已设置";
                }
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){         //头像
            return [GC_EditHeadImageTableViewCell getCellHeight];
        }else{
            return [GC_MineItemTableViewCell getCellHeight];
        }
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return self.dataSource.count + 1;
    }
    return 0;
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
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){             //头像信息
            [self.photoCollect showSelectInViewController:self];
        }else if(indexPath.row == 3){       //所在地区
            [self.areaPickerView showPickerView];
        }else if(indexPath.row == 4){       //登录密码
            GC_MineEditPasswordViewController *editLoginPwd = [[GC_MineEditPasswordViewController alloc] init];
            editLoginPwd.editPwdType = 0;
            editLoginPwd.onEditSuccessBlock = ^(){
                [self loadUserInfoData];
            };
            [self.navigationController pushViewController:editLoginPwd animated:YES];
        }else if(indexPath.row == 5){       //支付密码
            GC_MineEditPasswordViewController *editPayPwd = [[GC_MineEditPasswordViewController alloc] init];
            editPayPwd.editPwdType = 1;
            editPayPwd.onEditSuccessBlock = ^(){
                [self loadUserInfoData];
            };
            [self.navigationController pushViewController:editPayPwd animated:YES];
        }else if(indexPath.row == 6){       //更换手机号
            GC_ReplaceMobileViewController *rmVC = [[GC_ReplaceMobileViewController alloc] init];
            rmVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rmVC animated:YES];
        }
    }
}

#pragma mark -- Hen_PhotoCollectManagerDelegate
///成功采集照片
- (void)successCollectPhoto:(NSMutableArray<UIImage *> *)photos
{
    self.phtotData.image = photos.firstObject;
    self.phtotData.statue = 1;
    self.phtotData.tatole = 100;
    self.phtotData.current = 0;
    //请求
    WEAKSelf;
    
    ///参数
    [self.viewModel.editUserPhotoParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.editUserPhotoParam setObject:DATAMODEL.token forKey:@"token"];
    
    [self.viewModel setUploadPhoto:photos.firstObject editUserPhotoDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            weakSelf.phtotData.statue = 2;
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf showHint:desc];
        }
    } withUploadProgressBlock:^(CGFloat total, CGFloat current) {
        weakSelf.phtotData.statue = 1;
        weakSelf.phtotData.tatole = total;
        weakSelf.phtotData.current = current;
        if(weakSelf.tableView){
            [weakSelf.tableView reloadData];
        }
    }];
}


#pragma mark -- getter,setter
///TableView
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        ///tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///退出账号 按钮
- (UIButton *)exitAccountButton
{
    if(!_exitAccountButton){
        UIButton *exit = [UIButton createButtonWithTitle:HenLocalizedString(@"退出账号") backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onExitAccountAction:)];
        exit.titleLabel.font = kFontSize_36;
        [exit setTitleClor:kFontColorWhite];
        [self.view addSubview:_exitAccountButton = exit];
    }
    return _exitAccountButton;
}

///DataSource
- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataSource addObjectsFromArray:@[@[@"账号",@""],@[@"昵称",@""],@[@"所在地区",@"所在地区"],@[@"登录密码",@"暂未设置"],@[@"支付密码",@"暂未设置"],@[@"更换手机号",@""]]];
    }
    return _dataSource;
}

- (GC_MineMessageViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_MineMessageViewModel alloc] init];
    }
    return _viewModel;
}


- (GC_UserPhotoDataModel *)phtotData
{
    if(!_phtotData){
        _phtotData = [[GC_UserPhotoDataModel alloc] initWithDictionary:@{}];
    }
    return _phtotData;
}

- (Hen_PhotoCollectManager *)photoCollect
{
    if(!_photoCollect){
        _photoCollect = [[Hen_PhotoCollectManager alloc] init];
        _photoCollect.delegate = self;
        _photoCollect.photoSize = 100;
        _photoCollect.maxPhotoCount = 1;
    }
    return _photoCollect;
}

- (QL_AreaPickerView *)areaPickerView
{
    if(!_areaPickerView){
        _areaPickerView = [[QL_AreaPickerView alloc] init];
        //回调
        WEAKSelf;
        _areaPickerView.onAreaPickerSelectBlock = ^(NSMutableDictionary *selectedDict){
            QL_AreaDataModel *model1 = selectedDict[@"0"];
            QL_AreaDataModel *model2 = selectedDict[@"1"];
            QL_AreaDataModel *model3 = selectedDict[@"2"];
            
            if(model3){
                weakSelf.viewModel.editUserInfoParam.areaId = model3.areaId;
            }else if(model2){
                weakSelf.viewModel.editUserInfoParam.areaId = model2.areaId;
            }
//            if([model1.name isEqualToString:model2.name]){
//                weakSelf.addressInfo = [NSString stringWithFormat:@"%@%@", model1.name, model3.name];
//            }else{
//                weakSelf.addressInfo = [NSString stringWithFormat:@"%@%@%@", model1.name, model2.name, model3.name];
//            }
            
            weakSelf.viewModel.editUserInfoParam.nickName = @"";
            
            [weakSelf updateUserInfoData];
        };
    }
    return _areaPickerView;
}
@end
