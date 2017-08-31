//
//  GC_CustomProgressLoadingView.m
//  xianglegou
//
//  Created by mini3 on 2017/7/10.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_CustomProgressLoadingView.h"

@interface GC_CustomProgressLoadingView ()

///帧动画图片
@property(nonatomic, weak) UIImageView *frameImage;
///动画数组
@property(nonatomic, strong) NSMutableArray* animArray;

@end

@implementation GC_CustomProgressLoadingView

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
    self.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
-(void)loadSubViewAndConstraints
{
    [self.frameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -- private
- (void)show
{
    self.hidden = NO;
    
    [self startFrameAnimation:self.animArray andDuration:0.3f];
}

- (void)hide
{
    [self stopFrameAnimation];
    self.frameImage.image = [UIImage imageNamed:@"time1"];
    
    [self removeFromSuperview];
    self.hidden = YES;
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
///帧动画图片
- (UIImageView *)frameImage
{
    if(!_frameImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"time1"];
        [self addSubview:_frameImage = image];
    }
    return _frameImage;
}

-(NSMutableArray*)animArray
{
    if(!_animArray){
        _animArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for(NSInteger i = 1; i < 12; i++){
            [_animArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"time%ld", i]]];
        }
    }
    return _animArray;
}



@end
