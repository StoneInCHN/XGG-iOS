//
//  GC_RecommendPoliteViewController.m
//  Rebate
//
//  Created by mini3 on 17/4/5.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  推荐有礼 界面
//

#import "GC_RecommendPoliteViewController.h"
#import "GC_RecommendRecordingViewController.h"

#import "GC_RecommendPoliteTableViewCell.h"

#import "GC_RecommendViewModel.h"



@interface GC_RecommendPoliteViewController ()<UITableViewDelegate, UITableViewDataSource>
///背景图片
@property (nonatomic, weak) UIImageView *bgImageView;
///推荐有礼 标题图片
@property (nonatomic, weak) UIImageView *recommendImageView;

///TableVIew
@property (nonatomic, weak) UITableView *tableView;

///View Model
@property (nonatomic, strong) GC_RecommendViewModel *viewModel;

@end

@implementation GC_RecommendPoliteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubviewConstraints];
    
    [self loadQrCodeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

///加载navigationBar背景
-(void)loadNavigationBarBackground
{
    
    [((Hen_BaseNavigationViewController*)self.navigationController) setDefaultBackground];
    [self.navigationController.navigationBar setTintColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarTitleColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarBgColor:[UIColor clearColor]];
    [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:YES];
    [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:YES];
    
    UIBarButtonItem *barBt = [UIBarButtonItem createBarButtonItemWithTitle:HenLocalizedString(@"推荐记录") titleColor:kFontColorWhite target:self action:@selector(onRecordingAction:)];
    self.navigationItem.rightBarButtonItem = barBt;
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
///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.recommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bgImageView).offset(HEIGHT_TRANSFORMATION(30));
        make.height.mas_equalTo(FITSCALE(154/2));
        make.width.mas_equalTo(FITSCALE(407/2));
    }];
    
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendImageView.mas_bottom).offset(FITSCALE(20/2));
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}


///加载推荐数据信息
-(void)loadQrCodeData
{
    //参数
    [self.viewModel.qrCodeParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.qrCodeParam setObject:DATAMODEL.token forKey:@"token"];
    
    //显示加载
    [self showPayHud:@""];
    WEAKSelf;
    [self.viewModel getQrCodeDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf.tableView reloadData];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

#pragma mark -- action
///推荐记录
- (void)onRecordingAction:(id)sender
{
    GC_RecommendRecordingViewController *recording = [[GC_RecommendRecordingViewController alloc] init];
    [self.navigationController pushViewController:recording animated:YES];
}



///立即分享 回调
-(void)onShareItClickAction:(NSInteger)item
{
    Hen_ShareDataModel *shareData = [[Hen_ShareDataModel alloc] initWithDictionary:@{}];
    
    ///分享标题
    shareData.title = @"享个购";
    ///分享内容
    shareData.content = @"在享个购APP消费越多，获得奖励越高，快来看看吧！";
    ///分享url
    shareData.url = self.viewModel.qrCodeData.recommendUrl;
    ///分享图片
    shareData.image = [UIImage imageNamed:@"iconF180x180"];
    
    [[Hen_UMSocialManager shareManager] shareUserOriginalUIForShareData:shareData andViewController:self];
}
///分享下载链接 回调
-(void)onShareItDownloadlinkBlock:(NSInteger)item
{
    Hen_ShareDataModel *shareItDownloadlinkData = [[Hen_ShareDataModel alloc] initWithDictionary:@{}];
    ///分享标题
    shareItDownloadlinkData.title = @"享个购";
    ///分享内容
    shareItDownloadlinkData.content = @"享个购，大众分享，全民受益！";
    ///分享url
    shareItDownloadlinkData.url = self.viewModel.qrCodeData.downloadUrl;
    ///分享图片
    shareItDownloadlinkData.image = [UIImage imageNamed:@"iconF180x180"];
    
    
    [[Hen_UMSocialManager shareManager] shareUserOriginalUIForShareData:shareItDownloadlinkData andViewController:self];
}

#pragma mark
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GC_RecommendPoliteTableViewCell *cell = [GC_RecommendPoliteTableViewCell cellWithTableView:tableView];
    
    [cell setUpdateUiForQrCodeData:self.viewModel.qrCodeData];
    
    WEAKSelf;
    cell.onShareItClickBlock = ^(NSInteger item){               //分享
        [weakSelf onShareItClickAction:item];
    };
    
    cell.onShareItDownloadlinkBlock = ^(NSInteger item){        //分享下载链接
        [weakSelf onShareItDownloadlinkBlock:item];
    };

    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [GC_RecommendPoliteTableViewCell getCellHeight];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
///背景图
- (UIImageView *)bgImageView
{
    if(!_bgImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_qr_code_bg"];
        bgImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_bgImageView = bgImage];
    }
    return _bgImageView;
}
///推荐有礼 标题 图片
- (UIImageView *)recommendImageView
{
    if(!_recommendImageView){
        UIImageView *recmmendImage = [UIImageView createImageViewWithName:@"mine_recommend_title"];
        ///recmmendImage.backgroundColor = KCommonYellowBgColor;
        [self.view addSubview:_recommendImageView = recmmendImage];
    }
    return _recommendImageView;
}


- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[UIColor clearColor]];
        //自适应高度
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(965)];
        [self.view addSubview:_tableView = tableView];
        
    }
    return _tableView;
}


///View Model
- (GC_RecommendViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_RecommendViewModel alloc] init];
    }
    return _viewModel;
}
@end
