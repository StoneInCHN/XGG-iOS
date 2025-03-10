//
//  MJRefreshNormalHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshNormalHeader.h"

@interface MJRefreshNormalHeader()
{
    __weak UIImageView *_arrowView;
}
//@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) QLCustomLoadingView *loadingView;
@end

@implementation MJRefreshNormalHeader
#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
//        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.hidden = YES;
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

//- (UIActivityIndicatorView *)loadingView
//{
//    if (!_loadingView) {
//        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        loadingView.hidesWhenStopped = YES;
//        [self addSubview:_loadingView = loadingView];
//    }
//    return _loadingView;
//}
-(QLCustomLoadingView*)loadingView
{
    if(!_loadingView){
        QLCustomLoadingView *loadingView = [[QLCustomLoadingView alloc] init];
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}
#pragma makr - 重写父类的方法
- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头
    self.arrowView.mj_size = self.arrowView.image.size;
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 70;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    self.arrowView.center = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 圈圈
    self.loadingView.center = CGPointMake(arrowCenterX, arrowCenterY);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    /*if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.loadingView.alpha = 1.0;
                [self.loadingView startAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingView startAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loadingView startAnimating];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView stopAnimating];
        self.arrowView.hidden = YES;
    }*/
    
    if (state == MJRefreshStateIdle) {
        [self.loadingView stopAnimating];
    }else if(state == MJRefreshStateNoMoreData){
        [self.loadingView stopAnimating];
    }else{
        [self.loadingView startAnimating];
    }
}
@end
