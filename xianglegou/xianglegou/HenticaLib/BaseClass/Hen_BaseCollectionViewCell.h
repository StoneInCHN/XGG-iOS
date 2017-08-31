//
//  Hen_BaseCollectionViewCell.h
//  MenLi
//
//  Created by mini2 on 16/6/21.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hen_BaseCollectionViewCell : UICollectionViewCell

///注册cell
+(void)registerCollectionView:(UICollectionView*)collectionView;

///创建
+(id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

///初始化
-(void)initDefault;

///加载子视图约束
-(void)loadSubviewConstraints;

@end
