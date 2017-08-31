//
//  Hen_BaseCollectionReusableView.m
//  HelloWorld
//
//  Created by mini2 on 16/8/31.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "Hen_BaseCollectionReusableView.h"

@implementation Hen_BaseCollectionReusableView

///注册cell
+(void)registerCollectionView:(UICollectionView*)collectionView
{
    [collectionView registerClass:[Hen_BaseCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Hen_BaseCollectionReusableView"];
}

///创建
+(id)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Hen_BaseCollectionReusableView" forIndexPath:indexPath];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        [self initDefault];
        [self loadSubviewConstraints];
    }
    
    return self;
}

-(void)initDefault
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    
}

@end
