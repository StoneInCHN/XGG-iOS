//
//  QL_BannerDetailsViewController.m
//  Rebate
//
//  Created by mini2 on 17/4/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BannerDetailsViewController.h"
#import "QL_BannerDetailsTableViewCell.h"

@interface QL_BannerDetailsViewController ()

@end

@implementation QL_BannerDetailsViewController

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

#pragma mark -- override

///清除数据
- (void)cleanUpData
{
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
}

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"详情介绍";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kCommonWhiteBg;
    [self.tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(200)];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_BannerDetailsTableViewCell *cell = [QL_BannerDetailsTableViewCell cellWithTableView:tableView];
    
    [cell updateUIForData:self.bannerData];
    
    return cell;
}

@end
