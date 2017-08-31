//
//  QL_UserPublishCommentViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_UserPublishCommentViewController.h"
#import "QL_UserCommentDetailsViewController.h"

#import "QL_UPCInfoTableViewCell.h"
#import "QL_UPCInputCommentTableViewCell.h"

#import "GC_OrderUnderUserViewModel.h"

@interface QL_UserPublishCommentViewController ()<UITableViewDelegate, UITableViewDataSource>

///内容
@property(nonatomic, weak) UITableView *tableView;
///发表评价按钮
@property(nonatomic, weak) UIButton *publishCommentButton;
///ViewModel
@property (nonatomic, strong) GC_OrderUnderUserViewModel *viewModel;

///初始星级
@property (nonatomic, strong) NSString *starNum;

///用户选择 图片
@property (nonatomic, strong) NSArray *imageArray;
@end

@implementation QL_UserPublishCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.starNum = @"5";
    [self loadSubView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    [self setViewModel:nil];
    [self setImageArray:nil];
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
    
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = HenLocalizedString(@"发表评价");
    
    [self.publishCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.publishCommentButton.mas_top);
    }];
}

#pragma mark -- event response

///发表评价
- (void)onPublishCommentAction:(UIButton *)sender
{
    
    if(self.viewModel.userEvaluateOrderParam.content.length <= 0 || [self.viewModel.userEvaluateOrderParam.content isEqualToString:@""]){
        [self showHint:@"评价内容未输入！"];
        return;
    }
    
    self.viewModel.userEvaluateOrderParam.userId = DATAMODEL.userInfoData.id;
    self.viewModel.userEvaluateOrderParam.token = DATAMODEL.token;
    self.viewModel.userEvaluateOrderParam.entityId = self.orderData.id;
    
    
    WEAKSelf;
    //请求
    //显示加载
    [self showPayHud:@""];
    [self.viewModel setImageArray:self.imageArray andUserEvaluateOrderDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){
            [weakSelf setImageArray:nil];

            QL_UserCommentDetailsViewController *ucVC = [[QL_UserCommentDetailsViewController alloc] init];
    
            ucVC.publicState = 1;
            ucVC.onBackClickBlock = ^(){
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if(weakSelf.onPublishedSuccessBlock){
                    weakSelf.onPublishedSuccessBlock();
                }
            };
            
            ucVC.orderData = weakSelf.orderData;
            [weakSelf.navigationController pushViewController:ucVC animated:YES];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    if(indexPath.section == 0){ // 信息
        QL_UPCInfoTableViewCell *cell = [QL_UPCInfoTableViewCell cellWithTableView:tableView];
        
        [cell setUpdateUiForOrderUnderUserData:self.orderData];
        
        cell.isEdit = YES;
        cell.score = self.starNum;
        self.viewModel.userEvaluateOrderParam.score = self.starNum;
        WEAKSelf;
        //星级回调
        cell.onCommentScoreBlock = ^(NSInteger star){
            weakSelf.starNum = [NSString stringWithFormat:@"%ld",star];
            weakSelf.viewModel.userEvaluateOrderParam.score = [NSString stringWithFormat:@"%ld",star];
        };
        
        return cell;
    }else if(indexPath.section == 1){ // 评价输入
        QL_UPCInputCommentTableViewCell *cell = [QL_UPCInputCommentTableViewCell cellWithTableView:tableView];
        
        cell.isEdit = YES;
        WEAKSelf;
        //评价输入回调
        cell.onCommentContentBlock = ^(NSString *content){
            weakSelf.viewModel.userEvaluateOrderParam.content = content;
        };
        //图片采集回调
        cell.onPhotoCollectBlock = ^(NSMutableArray *images){
            weakSelf.imageArray = [images copy];
            [weakSelf.tableView reloadData];
        };
        
        return cell;
    }
    return nil;
}

#pragma mark -- getter,setter

///内容
- (UITableView *)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setCellAutoAdaptationForEstimatedRowHeight:HEIGHT_TRANSFORMATION(460)];
        [self.view addSubview:_tableView = tableView];
    }
    return _tableView;
}

///查看评价按钮
- (UIButton *)publishCommentButton
{
    if(!_publishCommentButton){
        UIButton *button = [UIButton createButtonWithTitle:@"发表评价" backgroundNormalImage:@"public_big_button" backgroundPressImage:@"public_big_button_press" target:self action:@selector(onPublishCommentAction:)];
        [button setTitleClor:kFontColorWhite];
        button.titleLabel.font = kFontSize_36;
        [self.view addSubview:_publishCommentButton = button];
    }
    return _publishCommentButton;
}


///View Model
- (GC_OrderUnderUserViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[GC_OrderUnderUserViewModel alloc] init];
    }
    return _viewModel;
}

- (NSArray *)imageArray
{
    if(!_imageArray){
        _imageArray = [[NSArray alloc] init];
    }
    return _imageArray;
}
@end
