//
//  GC_WeChatBindingViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  微信绑定 界面
//

#import "GC_WeChatBindingViewController.h"

#import "GC_WeChatInfoTableViewCell.h"
#import "GC_AuthorizationButtonTableViewCell.h"

#import "GC_MineMessageViewModel.h"

@interface GC_WeChatBindingViewController ()

///ViewModel
@property (nonatomic, strong) GC_MineMessageViewModel *viewModel;


@end

@implementation GC_WeChatBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNavigationItem];
    
    [self loadDateInfo];
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



- (void)onTVCGoBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if(self.onReturnClickBlock){
        self.onReturnClickBlock();
    }
    
}


#pragma mark -- private

///加载界面信息
-(void)loadDateInfo
{
    [self.tableView reloadData];
}

///解除授权操作
-(void)onDeauthorizeOfWeChat:(NSInteger)item
{
    //参数
    //用户ID
    [self.viewModel.cancelAuthOfWechatParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    //用户token
    [self.viewModel.cancelAuthOfWechatParam setObject:DATAMODEL.token forKey:@"token"];
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    [self.viewModel setDeauthorizeOfWechatDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            DATAMODEL.userInfoData.isBindWeChat = @"0";
            if(weakSelf.onReturnClickBlock){
                weakSelf.onReturnClickBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}
///重新授权操作
-(void)onReauthorizationOfWeChat:(NSInteger)item
{
    ThirdLoginType type = ThirdLoginTypeOfWechat;
    
    WEAKSelf;
    [[Hen_UMSocialManager shareManager] thirdLoginForThirdLoginType:type presentingController:self withResultBlock:^(BOOL isSuccess, NSString *uid, NSString *openId, NSString *nickname) {
        if(isSuccess){
            //用户ID
            [weakSelf.viewModel.authorizationOfWechatParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
            //用户token
            [weakSelf.viewModel.authorizationOfWechatParam setObject:DATAMODEL.token forKey:@"token"];
            //用户微信openid
            [weakSelf.viewModel.authorizationOfWechatParam setObject:openId forKey:@"openId"];
            //用户微信昵称
            [weakSelf.viewModel.authorizationOfWechatParam setObject:nickname forKey:@"wxNickName"];
            
            //显示加载
            [weakSelf showPayHud:@""];
            [weakSelf.viewModel setAuthorizationOfWechatDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
                //取消加载
                [weakSelf hideHud];
                if([code isEqualToString:@"0000"]){     //成功
                    DATAMODEL.userInfoData.isBindWeChat = @"1";
                    DATAMODEL.userInfoData.wechatNickName = nickname;
                    [weakSelf loadDateInfo];
                }else{
                    //提示
                    [weakSelf showHint:desc];
                }
            }];
        }
    }];
}

///加载导航栏信息
-(void)loadNavigationItem{
    self.navigationItem.title = HenLocalizedString(@"微信绑定");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = kCommonWhiteBg;
}


#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        GC_WeChatInfoTableViewCell *cell = [GC_WeChatInfoTableViewCell cellWithTableView:tableView];
        
        [cell setUpdateUiForUserDate:DATAMODEL.userInfoData];
        
        return cell;
    }else if(indexPath.section == 1){
        GC_AuthorizationButtonTableViewCell *cell = [GC_AuthorizationButtonTableViewCell cellWithTableView:tableView];
        WEAKSelf;
        //解除授权 回调
        cell.onDeauthorizeBlock = ^(NSInteger item){
            [weakSelf onDeauthorizeOfWeChat:item];
        };
        
        ///重新授权 回调
        cell.onReauthorizationBlock = ^(NSInteger item){
            [weakSelf onReauthorizationOfWeChat:item];
        };
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return [GC_WeChatInfoTableViewCell getCellHeight];
    }else if(indexPath.section == 1){
        return [GC_AuthorizationButtonTableViewCell getCellHeight];
    }
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -- getter,setter
///ViewModel
- (GC_MineMessageViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_MineMessageViewModel alloc] init];
    }
    return _viewModel;
}

@end
