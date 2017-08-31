//
//  QL_HPClassifyCollectionViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/20.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_HPClassifyCollectionViewCell.h"
#import "QL_BusinessListViewController.h"

@interface QL_HPClassifyItemCollectionViewCell()

///图标
@property(nonatomic, weak) UIImageView *iconImage;
///名字
@property(nonatomic, weak) UILabel *nameLabel;

@end

@implementation QL_HPClassifyItemCollectionViewCell

///注册cell
+ (void)registerCollectionView:(UICollectionView*)collectionView{
    [collectionView registerClass:[QL_HPClassifyItemCollectionViewCell class] forCellWithReuseIdentifier:@"QL_HPClassifyItemCollectionViewCell"];
}

///创建
+ (id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"QL_HPClassifyItemCollectionViewCell" forIndexPath:indexPath];
}

///初始化
- (void)initDefault
{
    
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(8));
        make.width.mas_equalTo(FITWITH(70/2));
        make.height.mas_equalTo(FITWITH(70/2));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

///更新ui
- (void)updateUIForData:(QL_SellerCategoryDataModel *)data
{
    if(data){
        self.nameLabel.text = data.categoryName;
        [self.iconImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl,data.categoryPicUrl] defaultImageName:@""];
    }
}

#pragma mark -- getter,setter

///图标
- (UIImageView *)iconImage
{
    if(!_iconImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        image.backgroundColor = kCommonBackgroudColor;
        [image makeRadiusForWidth:FITWITH(70/2)];
        [self.contentView addSubview:_iconImage = image];
    }
    return _iconImage;
}

///名字
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"xx" font:kFontSize_28];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

@end



@interface QL_HPClassifyCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

///内容
@property(nonatomic, weak) UICollectionView *collectionView;

///数据
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation QL_HPClassifyCollectionViewCell

///注册cell
+ (void)registerCollectionView:(UICollectionView*)collectionView{
    [collectionView registerClass:[QL_HPClassifyCollectionViewCell class] forCellWithReuseIdentifier:@"QL_HPClassifyCollectionViewCell"];
}

///创建
+ (id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"QL_HPClassifyCollectionViewCell" forIndexPath:indexPath];
}

///初始化
- (void)initDefault
{
    
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

///更新ui
- (void)updateUIForData:(NSMutableArray *)array
{
    self.dataArray = array;
    
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    QL_SellerCategoryDataModel *model = self.dataArray[indexPath.item];
    
    QL_BusinessListViewController *blVC = [[QL_BusinessListViewController alloc] init];
    blVC.hidesBottomBarWhenPushed = YES;
    blVC.categoryId = model.id;
    
    [[DATAMODEL.henUtil getCurrentViewController].navigationController pushViewController:blVC animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((kMainScreenWidth - WIDTH_TRANSFORMATION(20) * 5) / 5, HEIGHT_TRANSFORMATION(110));
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
    return WIDTH_TRANSFORMATION(10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QL_HPClassifyItemCollectionViewCell *cell = [QL_HPClassifyItemCollectionViewCell collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    [cell updateUIForData:self.dataArray[indexPath.item]];
    
    return cell;
}

#pragma mark -- getter,setter

///内容
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        UICollectionView *collectionView = [UICollectionView createCollectionViewWithDelegateTarget:self];
        collectionView.scrollEnabled = NO;
        [self.contentView addSubview:_collectionView = collectionView];
        //注册
        [QL_HPClassifyItemCollectionViewCell registerCollectionView:collectionView];
    }
    return _collectionView;
}

@end
