//
//  QL_HotCityView.m
//  Rebate
//
//  Created by mini2 on 17/4/10.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_HotCityView.h"
#import "QL_BusinessModel.h"

@interface QL_HotCityViewCollectionViewCell()

///内容
@property(nonatomic, weak) UIButton *contentButton;

@end

@implementation QL_HotCityViewCollectionViewCell

///注册cell
+ (void)registerCollectionView:(UICollectionView*)collectionView{
    [collectionView registerClass:[QL_HotCityViewCollectionViewCell class] forCellWithReuseIdentifier:@"QL_HotCityViewCollectionViewCell"];
}

///创建
+ (id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"QL_HotCityViewCollectionViewCell" forIndexPath:indexPath];
}

///初始化
- (void)initDefault
{
    
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark -- event response

- (void)onButtonAction:(UIButton *)sender
{
    if(!sender.isSelected){
        [sender setSelected:YES];
        if(self.onClickBlock){
            self.onClickBlock();
        }
    }
}

#pragma mark -- getter,setter

///内容
- (UIButton *)contentButton
{
    if(!_contentButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" backgroundNormalImage:@"homepage_city" backgroundPressImage:@"homepage_city_choose" target:self action:@selector(onButtonAction:)];
        [button setTitleColor:kFontColorRed forState:UIControlStateSelected];
        [self.contentView addSubview:_contentButton = button];
    }
    return _contentButton;
}

///内容
- (void)setContent:(NSString *)content
{
    [self.contentButton setTitle:content];
}

///是否选择
- (void)setIsSelect:(BOOL)isSelect
{
    [self.contentButton setSelected:isSelect];
}

@end


@interface QL_HotCityView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///内容
@property(nonatomic, weak) UICollectionView *collectionView;

///数据
@property(nonatomic, strong) NSMutableArray<QL_HotCityDataModel *> *hotDatas;

@end

@implementation QL_HotCityView

- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

#pragma mark -- private

///初始
- (void)initDefault
{
    self.backgroundColor = kCommonWhiteBg;
    self.frame = CGRectMake(0, HEIGHT_TRANSFORMATION(110), kMainScreenWidth-FITWITH(30), HEIGHT_TRANSFORMATION(60));
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(8));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(80));
        make.right.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-80));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-10));
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.top.equalTo(self);
    }];
}

///加载热门城市数据
- (void)loadHotCityData
{
    WEAKSelf;
    NSString *requestId = [[Hen_MessageManager shareMessageManager] requestWithAction:@"/rebate-interface/area/getHotCity.jhtml" dictionaryParam:@{} withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        if([code isEqualToString:@"0000"]){
            for(NSDictionary *dic in msg){
                [weakSelf.hotDatas addObject:[[QL_HotCityDataModel alloc] initWithDictionary:dic]];
            }
            [weakSelf.collectionView reloadData];
            
            if(weakSelf.hotDatas.count > 0){
                NSInteger row = weakSelf.hotDatas.count / 3 + weakSelf.hotDatas.count % 3 > 0 ? 1 : 0;
                weakSelf.frame = CGRectMake(0, HEIGHT_TRANSFORMATION(110), kMainScreenWidth-FITWITH(30), HEIGHT_TRANSFORMATION(60) + row * HEIGHT_TRANSFORMATION(100));
            }
            
            if(weakSelf.onDataLoadFinishBlock){
                weakSelf.onDataLoadFinishBlock();
            }
        }
    }];
    [[Hen_MessageManager shareMessageManager] addUnNoticeNetworkErrorRequestId:requestId];
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
    return self.hotDatas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((kMainScreenWidth - FITWITH(80) - 3 * FITWITH(20)) / 3, HEIGHT_TRANSFORMATION(80));
    return size;
}

///设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return HEIGHT_TRANSFORMATION(10);
}

///设置列间距，配合item宽度来设置
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return FITWITH(10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QL_HotCityViewCollectionViewCell *cell = [QL_HotCityViewCollectionViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    QL_HotCityDataModel *model = self.hotDatas[indexPath.item];
    cell.content = model.cityName;
    if([model.cityId isEqualToString:DATAMODEL.cityId]){
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    //回调
    WEAKSelf;
    cell.onClickBlock = ^(){
        QL_HotCityDataModel *model = weakSelf.hotDatas[indexPath.item];
        
        DATAMODEL.cityId = model.cityId;
        if(self.onSelectBlock){
            self.onSelectBlock(model.cityId);
        }
        
        [weakSelf.collectionView reloadData];
    };
    
    return cell;
}

#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"热门城市" font:kFontSize_28 textColor:kFontColorRed];
        [self addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///内容
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionView *collectionView = [UICollectionView createCollectionViewWithDelegateTarget:self];
        [self addSubview:_collectionView = collectionView];
        //注册
        [QL_HotCityViewCollectionViewCell registerCollectionView:collectionView];
    }
    return _collectionView;
}

///线
- (UIImageView *)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self addSubview:image];
    
    return image;
}

///数据
- (NSMutableArray<QL_HotCityDataModel *> *)hotDatas
{
    if(!_hotDatas){
        _hotDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _hotDatas;
}

@end
