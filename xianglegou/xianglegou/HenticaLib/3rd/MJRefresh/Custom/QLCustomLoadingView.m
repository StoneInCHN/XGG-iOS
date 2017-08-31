//
//  QLCustomLoadingView.m
//  Ask
//
//  Created by mini2 on 16/11/25.
//  Copyright © 2016年 Ask. All rights reserved.
//

#import "QLCustomLoadingView.h"

@interface QLCustomLoadingView()

///帧动画图片
@property(nonatomic, strong) UIImageView *frameImage;
///动画数组
@property(nonatomic, strong) NSMutableArray* animArray;

@end

@implementation QLCustomLoadingView

-(id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

///初始
-(void)initDefault
{
    self.frame = CGRectMake(0, 0, 19, 32);
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
-(void)loadSubViewAndConstraints
{
    self.frameImage = [[UIImageView alloc] initWithFrame:self.bounds];
    self.frameImage.image = [UIImage imageNamed:@"QLRefresh1"];
    [self addSubview:self.frameImage];
}

- (void)startAnimating
{
    [self startFrameAnimation:self.animArray andDuration:0.05f];
}

- (void)stopAnimating
{
    [self stopFrameAnimation];
    self.frameImage.image = [UIImage imageNamed:@"QLRefresh1"];
}

///开始帧动画
-(void)startFrameAnimation:(NSMutableArray*)animArray andDuration:(CGFloat)duration
{
    // 1. 设置图片的数组
    [self.frameImage setAnimationImages:animArray];
    // 2. 设置动画时长，默认每秒播放30张图片
    [self.frameImage setAnimationDuration:animArray.count * duration];
    // 3. 设置动画重复次数，默认为0，无限循环
    [self.frameImage setAnimationRepeatCount:0];
    // 4. 开始动画
    [self.frameImage startAnimating];
}

///停止帧动画
-(void)stopFrameAnimation
{
    [self.frameImage stopAnimating];
    //清空动画数组
    [self.frameImage performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.frameImage.animationDuration];
}

#pragma mark -- getter,setter

-(NSMutableArray*)animArray
{
    if(!_animArray){
        _animArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for(NSInteger i = 1; i < 9; i++){
            [_animArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"QLRefresh%ld", i]]];
        }
    }
    return _animArray;
}

@end
