//
//  QL_BDConmmentPngCollectionViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/22.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BDConmmentPngCollectionViewCell.h"

@interface QL_BDConmmentPngCollectionViewCell()

///图片
@property(nonatomic, weak) UIImageView *pngImage;

@end

@implementation QL_BDConmmentPngCollectionViewCell

///注册cell
+ (void)registerCollectionView:(UICollectionView*)collectionView{
    [collectionView registerClass:[QL_BDConmmentPngCollectionViewCell class] forCellWithReuseIdentifier:@"QL_BDConmmentPngCollectionViewCell"];
}

///创建
+ (id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"QL_BDConmmentPngCollectionViewCell" forIndexPath:indexPath];
}

///初始化
- (void)initDefault
{
    
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.pngImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark -- getter,setter

///图片
- (UIImageView *)pngImage
{
    if(!_pngImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        image.backgroundColor = kCommonBackgroudColor;
        [self.contentView addSubview:_pngImage = image];
    }
    return _pngImage;
}

///设置图片地址
- (void)setPngUrl:(NSString *)pngUrl
{
    [self.pngImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl, pngUrl] defaultImageName:@""];
}

@end
