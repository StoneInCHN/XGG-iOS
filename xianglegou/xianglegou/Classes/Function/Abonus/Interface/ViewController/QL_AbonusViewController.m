//
//  QL_AbonusViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/30.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_AbonusViewController.h"
#import "QL_MineAbonusCollectionViewCell.h"
#import "QL_AllAbonusCollectionViewCell.h"

#import "GC_MineMessageViewModel.h"
#import "QL_AbonusViewModel.h"

@interface QL_AbonusViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

///滑动view
@property(nonatomic, weak) UICollectionView *collectionView;
///圆点
@property(nonatomic, weak) UIPageControl *page;

///ViewModel
@property (nonatomic, strong) GC_MineMessageViewModel *mineViewModel;
/// view model
@property(nonatomic, strong) QL_AbonusViewModel *viewModel;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;

///是否加载数据
@property(nonatomic, assign) BOOL isLoadData;

@end

@implementation QL_AbonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self loadMineMessageData];
    [self loadAbonusData];
    
    [self updateCollectionView];
    [self setupTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self invalidateTimer];
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

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.totalItemsCount = 200;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

///加载我的 数据
-(void)loadMineMessageData
{
    self.isLoadData = YES;
    
    //参数
    [self.mineViewModel.userInfoParam setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.mineViewModel.userInfoParam setValue:DATAMODEL.token forKey:@"token"];
    //请求
    WEAKSelf;
    [self.mineViewModel getUserInfoWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){    //成功
            [weakSelf updateCollectionView];
        }
    }];
}

///加载分红
- (void)loadAbonusData
{
    //参数
    [self.viewModel.abonusParam setValue:DATAMODEL.userInfoData.id forKey:@"userId"];
    [self.viewModel.abonusParam setValue:DATAMODEL.token forKey:@"token"];
    
    WEAKSelf;
    [self.viewModel getUserAbonusDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        weakSelf.isLoadData = NO;
        if(![code isEqualToString:@"0000"]){ // 不成功
            //提示
            [weakSelf showHint:desc];
        }
        [weakSelf updateCollectionView];
    }];

    [self.viewModel getAllAbonusDataWithResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){ // 成功
        }
    }];
}

///更新显示
- (void)updateCollectionView
{
    [self.collectionView reloadData];
    
    if (self.collectionView.contentOffset.x == 0) {
        int targetIndex = self.totalItemsCount * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - actions

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll
{
    int currentIndex = self.collectionView.contentOffset.x / kMainScreenWidth;
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
    self.page.currentPage = targetIndex % 2;
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= self.totalItemsCount) {
        targetIndex = self.totalItemsCount * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

///滑动结束后调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / kMainScreenWidth;
    self.page.currentPage = index % 2;
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalItemsCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(kMainScreenWidth, collectionView.frame.size.height);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0){
        QL_MineAbonusCollectionViewCell *cell = [QL_MineAbonusCollectionViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
        
        [cell updateUIForUserAbonusData:self.viewModel.userAbonusData];
        [cell updateUIForUserInfoData:self.mineViewModel.userInfoData];
        if(self.isLoadData){
            [cell showLoading];
        }else{
            [cell cancelLoading];
        }
        
        return cell;
    }else{
        QL_AllAbonusCollectionViewCell *cell = [QL_AllAbonusCollectionViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
        
        [cell updateUIForAllAbonusData:self.viewModel.allAbonusData];
        if(self.isLoadData){
            [cell showLoading];
        }else{
            [cell cancelLoading];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark -- getter,setter

///滑动view
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionView *collectionView = [UICollectionView createCollectionViewWithDelegateTarget:self forScrollDirection:UICollectionViewScrollDirectionHorizontal];
        collectionView.pagingEnabled = YES;
        [self.view addSubview:_collectionView = collectionView];
        collectionView.backgroundColor = kFontColorBlue;
        //注册
        [QL_MineAbonusCollectionViewCell registerCollectionView:collectionView];
        [QL_AllAbonusCollectionViewCell registerCollectionView:collectionView];
    }
    return _collectionView;
}

///圆点
-(UIPageControl*)page
{
    if(!_page){
        UIPageControl *page = [UIPageControl createPageControl];
        // 设置内部的原点图片
        [page setValue:[UIImage imageNamed:@"rebate_page2"] forKeyPath:@"pageImage"];
        [page setValue:[UIImage imageNamed:@"rebate_page1"] forKeyPath:@"currentPageImage"];
        page.numberOfPages = 2;
        [self.view addSubview:_page = page];
    }
    return _page;
}

///ViewModel
- (GC_MineMessageViewModel *)mineViewModel
{
    if(!_mineViewModel){
        _mineViewModel = [[GC_MineMessageViewModel alloc] init];
    }
    return _mineViewModel;
}

/// view model
- (QL_AbonusViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [[QL_AbonusViewModel alloc] init];
    }
    return _viewModel;
}

@end
