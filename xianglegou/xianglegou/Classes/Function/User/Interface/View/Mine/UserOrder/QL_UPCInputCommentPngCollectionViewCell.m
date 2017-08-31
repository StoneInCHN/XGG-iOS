//
//  QL_UPCInputCommentPngCollectionViewCell.m
//  Rebate
//
//  Created by mini2 on 17/3/27.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_UPCInputCommentPngCollectionViewCell.h"

@interface QL_UPCInputCommentPngCollectionViewCell()

///图片
@property(nonatomic, weak) UIImageView *pngImage;
///删除按钮
@property(nonatomic, weak) UIButton *deleteButton;

@end

@implementation QL_UPCInputCommentPngCollectionViewCell

///注册cell
+ (void)registerCollectionView:(UICollectionView*)collectionView
{
    [collectionView registerClass:[QL_UPCInputCommentPngCollectionViewCell class] forCellWithReuseIdentifier:@"QL_UPCInputCommentPngCollectionViewCell"];
}

///创建
+ (id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"QL_UPCInputCommentPngCollectionViewCell" forIndexPath:indexPath];
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
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.width.and.height.mas_equalTo(20);
    }];
}

///更新ui
- (void)updateUIForImage:(id)image
{
    if(image){
        if([image isKindOfClass:[NSString class]]){
            [self.pngImage sd_setImageWithUrlString:image defaultImageName:@""];
        }else if([image isKindOfClass:[UIImage class]]){
            self.pngImage.image = image;
        }
    }
}

///更新ui
- (void)updateUIForImage:(id)imageData andItem:(NSInteger)item
{
    if(imageData){
        if([imageData isKindOfClass:[NSString class]]){
            WEAKSelf;
            [self.pngImage sd_setImageWithURL:[NSURL URLWithString:imageData] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(weakSelf.onPngDownloadBlock){
                    weakSelf.onPngDownloadBlock(image, item);
                }
            }];
        }else if([imageData isKindOfClass:[UIImage class]]){
            self.pngImage.image = imageData;
        }
    }
}

///删除按钮显隐
- (void)setDeleteButtonHidden:(BOOL)hidden
{
    self.deleteButton.hidden = hidden;
}

#pragma mark -- event response

///删除
- (void)onDeleteAction:(UIButton *)sender
{
    if(self.onDeleteBlock){
        self.onDeleteBlock();
    }
}

#pragma mark -- getter,setter

///图片
- (UIImageView *)pngImage
{
    if(!_pngImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        [self.contentView addSubview:_pngImage = image];
    }
    return _pngImage;
}

///删除按钮
- (UIButton *)deleteButton
{
    if(!_deleteButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"mine_comment_picture_delete" pressImage:@"mine_comment_picture_delete" target:self action:@selector(onDeleteAction:)];
        [self.contentView addSubview:_deleteButton = button];
    }
    return _deleteButton;
}

@end
