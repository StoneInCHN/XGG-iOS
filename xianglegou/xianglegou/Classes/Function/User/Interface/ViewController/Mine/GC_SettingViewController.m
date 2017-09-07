//
//  GC_SettingViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  设置 -- 界面
//

#import "GC_SettingViewController.h"
#import "GC_SettingTableViewCell.h"
#import "PushSwitchTableViewCell.h"
#import "QL_UserPublishCommentViewController.h"
#import "GC_WithdrawViewController.h"
#import "UserPushViewModel.h"

@interface GC_SettingViewController ()

///DataSource
@property (nonatomic, strong) NSMutableArray *dataSource;

///缓存 大小
@property (nonatomic, strong) NSString *clearCacheName;
@end

@implementation GC_SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNavigationItem];
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
///加载导航栏信息
-(void)loadNavigationItem{
    self.navigationItem.title = HenLocalizedString(@"设置");
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = kCommonBackgroudColor;
}


//清除缓存

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    [self.tableView reloadData];
    
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * title = self.dataSource[indexPath.row][1];
    if([title isEqualToString:@"清除缓存"]){       //
        GC_SettingTableViewCell *cell = [GC_SettingTableViewCell cellWithTableView:tableView];
        cell.icon = self.dataSource[indexPath.row][0];
        cell.title = title;
        cell.bottomLongLineImage.hidden = NO;
        float tmpSize = [SDImageCache sharedImageCache].getDiskCount;
        cell.content = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fM",tmpSize] : [NSString stringWithFormat:@"%.1fK",tmpSize * 1024];
        return cell;
    } else if([title isEqualToString:@"允许推送消息"]) {
        PushSwitchTableViewCell *cell = [PushSwitchTableViewCell cellWithTableView:tableView];
        cell.title = title;
        cell.icon = self.dataSource[indexPath.row][0];
        WEAKSelf;
        cell.switchBlock = ^(BOOL isOn) {
            [weakSelf requestPushSwitch:isOn];
        };
        return cell;
    } else {
        return [[UITableViewCell alloc]init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == 0){
//        return CGFLOAT_MIN;
//    }
    return [GC_SettingTableViewCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
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
    
    if(indexPath.row == 0){             //清除缓存
        WEAKSelf;
        [DATAMODEL.alertManager showTwoButtonWithMessage:@"确定要清除缓存吗？"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 0){
                [weakSelf clearTmpPics];
            }
        }];
    }
}

- (void)requestPushSwitch: (BOOL)isOn {
    if (DATAMODEL.userId && DATAMODEL.token) {
        UserPushViewModel * viewModel = [[UserPushViewModel alloc]init];
        [viewModel setPushSwitch:isOn];
    }
}

#pragma mark -- getter,setter
- (NSMutableArray *)dataSource
{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataSource addObjectsFromArray:@[@[@"mine_delete",@"清除缓存"],
                                           @[@"mine_push",@"允许推送消息"]]];
    }
    return _dataSource;
}

@end
