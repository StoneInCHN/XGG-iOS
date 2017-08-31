//
//  GC_PaymentFilterView.m
//  xianglegou
//
//  Created by mini3 on 2017/7/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  货款筛选 -- view
//

#import "GC_PaymentFilterView.h"
#import "GC_PaymentFilterCollectionViewCell.h"


#define PayBoxHeight                HEIGHT_TRANSFORMATION(400)

@interface GC_PaymentFilterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
///标题
@property (nonatomic, weak) UILabel *titleLabel;
///内容
@property (nonatomic, weak) UICollectionView *collectionView;
///分割线
@property (nonatomic, weak) UIImageView *lineImageView;
///重置按钮
@property (nonatomic, weak) UIButton *resetButton;
///完成 按钮
@property (nonatomic, weak) UIButton *finshButton;


///蒙层
@property (nonatomic, strong) UIView *maskView;
///头部 蒙层
@property (nonatomic, strong) UIView *headMaskView;

///数据
@property(nonatomic, strong) NSMutableArray *dataArray;


///数据源
@property (nonatomic, strong) NSMutableArray<GC_PaymentFilterDataModel *> *filterDatasArray;
///选中时间
@property (nonatomic, strong) NSString *selectDate;
@end

@implementation GC_PaymentFilterDataModel

@end

@implementation GC_PaymentFilterView
- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

///初始化
- (void)initDefault
{
    self.frame = CGRectMake(0, 64, kMainScreenWidth, PayBoxHeight);
    
    self.backgroundColor = kCommonWhiteBg;
    [self loadSubViewAndConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

///加载子视图 及约束
- (void)loadSubViewAndConstraints
{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(27));
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(30));
    }];
    
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(90));
        make.left.equalTo(self).offset(FITSCALE(80/2));
        make.right.equalTo(self).offset(FITSCALE(-80/2));
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-90));
    }];
    
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-90));
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(89));
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(120));
    }];
    
    
    [self.finshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(89));
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(120));
    }];
}


#pragma mark -- private
///显示
- (void)showView
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    self.frame = CGRectMake(0, 64, kMainScreenWidth, PayBoxHeight);
    
    [view addSubview:self.maskView];
    [view addSubview:self.headMaskView];
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 64, kMainScreenWidth, PayBoxHeight);
        self.maskView.alpha = 0.5;
        self.headMaskView.frame = CGRectMake(0, 0, kMainScreenWidth, 64);
        self.maskView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64);
        
        
    } completion:^(BOOL finished) {
        
        [self loadFilterDatas];
    }];

}



///加载数据
- (void)loadFilterDatas
{
    [self.filterDatasArray removeAllObjects];
    
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        GC_PaymentFilterDataModel *model = [[GC_PaymentFilterDataModel alloc] initWithDictionary:0];
        model.itemId = self.dataArray[i][0];
        model.name = self.dataArray[i][1];
        model.isSelected = NO;
        [self.filterDatasArray addObject:model];
    }
    
    self.selectDate = @"";
    self.filterDatasArray[0].isSelected = YES;
    
    [self.collectionView reloadData];
}


- (void)dismissBoxView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 64, kMainScreenWidth, PayBoxHeight);
        self.maskView.alpha = 0;
        self.headMaskView.frame = CGRectMake(0, 0, kMainScreenWidth, 64);
        self.maskView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.headMaskView removeFromSuperview];
        [self.maskView removeFromSuperview];
        
    }];
}


#pragma mark -- action
///重置按钮
- (void)onResetAction:(UIButton *)sender
{
    //设置全不选中
    for (GC_PaymentFilterDataModel *model in self.filterDatasArray) {
        model.isSelected = NO;
    }
    self.filterDatasArray[0].isSelected = YES;

    self.selectDate = @"";
    
    [self.collectionView reloadData];
}


///完成 按钮
- (void)onFinshAction:(UIButton *)sender
{
    if(self.onFinshBlock){
        self.onFinshBlock(self.selectDate);
    }
    
    [self dismissBoxView];
}


- (void)tapGestureHandler:(id)sender
{
    [self dismissBoxView];
}



#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //设置全不选中
    for (GC_PaymentFilterDataModel *model in self.filterDatasArray) {
        model.isSelected = NO;
    }
    GC_PaymentFilterDataModel *data = self.filterDatasArray[indexPath.row];
    data.isSelected = YES;
    
    self.selectDate = data.itemId;
    
    [collectionView reloadData];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.filterDatasArray.count;
}

//大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width = (kMainScreenWidth - WIDTH_TRANSFORMATION(90) - FITSCALE(80)) / 3;
    CGSize size = CGSizeMake(width, HEIGHT_TRANSFORMATION(78));
    return size;
}

///设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(20);
}


///设置列间距，配合item宽度来设置
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return WIDTH_TRANSFORMATION(45);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GC_PaymentFilterCollectionViewCell *cell = [GC_PaymentFilterCollectionViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    GC_PaymentFilterDataModel *model = self.filterDatasArray[indexPath.row];
    
    [cell updateUiForDate:model];
    
    if(model.isSelected){
        [cell setFilterIsSelected:YES];
    }else{
        [cell setFilterIsSelected:NO];
    }
    return cell;
}






#pragma mark -- getter,setter

///内容
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionView *collectionView = [UICollectionView createCollectionViewWithDelegateTarget:self];
        collectionView.pagingEnabled = YES;
        [self addSubview:_collectionView = collectionView];
        //注册
        [GC_PaymentFilterCollectionViewCell registerCollectionView:collectionView];
    }
    return _collectionView;
}


///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"查看时间" font:kFontSize_28];
        [self addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///蒙层
- (UIView *)maskView
{
    if(!_maskView){
        _maskView = [UIView createViewWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight) backgroundColor:[UIColor blackColor]];
        
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)headMaskView
{
    if(!_headMaskView){
        _headMaskView = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64) backgroundColor:[UIColor clearColor]];
        
        _headMaskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [_headMaskView addGestureRecognizer:tap];
    }
    return _headMaskView;
}


///分割线
- (UIImageView *)lineImageView
{
    if(!_lineImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
        [self addSubview:_lineImageView = image];
    }
    return _lineImageView;
}

///重置按钮
- (UIButton *)resetButton
{
    if(!_resetButton){
        UIButton *butotn = [UIButton createNoBgButtonWithTitle:@"重置" target:self action:@selector(onResetAction:)];
        [self addSubview:_resetButton = butotn];
    }
    return _resetButton;
}

///完成 按钮
- (UIButton *)finshButton
{
    if(!_finshButton){
        UIButton *button = [UIButton createNoBgButtonWithTitle:@"完成" target:self action:@selector(onFinshAction:)];
        [button setTitleClor:kFontColorRed];
        [self addSubview:_finshButton = button];
    }
    return _finshButton;
}




///数据
- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
        [_dataArray addObjectsFromArray:@[@[@"",@"全部"],@[@"0",@"当天"],@[@"3",@"近3天"],@[@"7",@"近7天"]]];
        
    }
    return _dataArray;
}


///时间 数据

- (NSMutableArray<GC_PaymentFilterDataModel *> *)filterDatasArray
{
    if(!_filterDatasArray){
        _filterDatasArray = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return _filterDatasArray;
}

@end
