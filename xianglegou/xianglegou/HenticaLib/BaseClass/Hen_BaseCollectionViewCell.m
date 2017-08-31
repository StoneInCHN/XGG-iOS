//
//  QL_BaseCollectionViewCell.m
//  MenLi
//
//  Created by mini2 on 16/6/21.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "Hen_BaseCollectionViewCell.h"

@implementation Hen_BaseCollectionViewCell

///注册cell
+(void)registerCollectionView:(UICollectionView*)collectionView{
    [collectionView registerClass:[Hen_BaseCollectionViewCell class] forCellWithReuseIdentifier:@"Hen_BaseCollectionViewCell"];
}

///创建
+(id)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Hen_BaseCollectionViewCell" forIndexPath:indexPath];
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
