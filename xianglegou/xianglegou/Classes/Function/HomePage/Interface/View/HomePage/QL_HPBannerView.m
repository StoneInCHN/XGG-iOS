//
//  QL_HPAcitiveView.m
//  Rebate
//
//  Created by mini2 on 17/3/11.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_HPBannerView.h"

@interface QL_HPBannerView()<UIScrollViewDelegate>

///内容
@property(nonatomic, weak) UIScrollView *scrollView;
///圆点
@property(nonatomic, weak) UIPageControl *page;

///高度
@property(nonatomic, assign) CGFloat viewHeight;

/// 定时器
@property (nonatomic, strong) NSTimer  * timer;
@property(nonatomic, assign) NSInteger countdown;
/// 当前图片
@property(nonatomic, assign) NSInteger currentItem;


@end

@implementation QL_HPBannerView

///初始化
-(id)initWithHeight:(CGFloat)height
{
    self = [super init];
    if(self){
        [self initDefaultWithHeight:height];
    }
    return self;
}

- (void)dealloc
{
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark -- private

///初始
-(void)initDefaultWithHeight:(CGFloat)height
{
    self.viewHeight = height;
    self.frame = CGRectMake(0, 0, kMainScreenWidth, height);
    self.backgroundColor = kCommonWhiteBg;
    
    [self loadSubViewAndConstraints];
    
    self.isTimingCarousel = YES;
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(self);
    }];
    [self.page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.scrollView).offset(HEIGHT_TRANSFORMATION(0));
    }];

}

//更新UI
- (void)updateUI
{
    if(/* DISABLES CODE */ (1)){
        self.currentItem = 0;
        self.countdown = 0;
        NSInteger count = 3;
        
        self.page.numberOfPages = count;
        self.scrollView.contentSize = CGSizeMake(kMainScreenWidth * count, 0);
        //移除所有子视图
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for(NSInteger i = 0; i < count; i++){
            UIImageView *image = [UIImageView createImageViewWithName:@"homepage_banner"];
            image.frame = CGRectMake(kMainScreenWidth*i, 0, kMainScreenWidth, self.viewHeight);
            image.tag = i;
            [self.scrollView addSubview:image];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageAction:)];
            image.userInteractionEnabled = YES;
            [image addGestureRecognizer:tap];
        }
        
        if(self.timer){
            [self.timer invalidate];
            self.timer = nil;
        }
        if(self.isTimingCarousel){
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshRestTime:) userInfo:nil repeats:YES];
        }
    }else{
        UIImageView *image = [UIImageView createImageViewWithName:@"homepage_banner"];
        [self.scrollView addSubview:image];
        image.frame = CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(346));
        
        if(self.timer){
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

///更新UI
- (void)updateUIForImages:(NSMutableArray *)images
{
    if(images.count > 0){
        self.currentItem = 0;
        self.countdown = 0;
        NSInteger count = images.count;
        
        self.page.numberOfPages = count;
        self.scrollView.contentSize = CGSizeMake(kMainScreenWidth * count, 0);
        //移除所有子视图
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for(NSInteger i = 0; i < count; i++){
            UIImageView *image = [UIImageView createImageViewWithName:@""];
            image.frame = CGRectMake(kMainScreenWidth*i, 0, kMainScreenWidth, self.viewHeight);
            image.tag = i;
            [image sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl, images[i]] defaultImageName:@""];
            [self.scrollView addSubview:image];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageAction:)];
            image.userInteractionEnabled = YES;
            [image addGestureRecognizer:tap];
        }
        
        if(self.timer){
            [self.timer invalidate];
            self.timer = nil;
        }
        if(self.isTimingCarousel){
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshRestTime:) userInfo:nil repeats:YES];
        }
    }else{
        UIImageView *image = [UIImageView createImageViewWithName:@"homepage_banner"];
        [self.scrollView addSubview:image];
        image.frame = CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(346));
        
        if(self.timer){
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

///设置圆点显隐
- (void)setPageHidden:(BOOL)hidden
{
    self.page.hidden = hidden;
}

///判断是否支持乐豆抵扣
- (void)setIsBeanPay:(NSString *)isBeanPay
{
   
}

///倒计时回调
- (void)refreshRestTime:(NSTimer *)timer
{
    self.countdown++;
    if(self.countdown > 5){
        self.countdown = 0;
        
        self.currentItem++;
        if(self.currentItem >= 3){
            self.currentItem = 0;
            [self.scrollView setContentOffset:CGPointMake(self.currentItem * kMainScreenWidth, 0) animated:NO];
        }else{
            [self.scrollView setContentOffset:CGPointMake(self.currentItem * kMainScreenWidth, 0) animated:YES];
        }
        self.page.currentPage = self.currentItem;
    }
}

#pragma mark -- event response

-(void)onImageAction:(UITapGestureRecognizer*)tap
{
    UIView *view = tap.view;
    if(self.onPngClickBlock){
        self.onPngClickBlock(view.tag);
    }
}

#pragma mark - UICollectionViewDelegate

///滑动结束后调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / kMainScreenWidth;
    self.page.currentPage = index;
    self.currentItem = index;
}

#pragma mark -- getter,setter

///内容
-(UIScrollView*)scrollView
{
    if(!_scrollView){
        UIScrollView *scrollView = [UIScrollView createScrollViewWithDelegateTarget:self];
        scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView = scrollView];
    }
    return _scrollView;
}

///圆点
-(UIPageControl*)page
{
    if(!_page){
        UIPageControl *page = [UIPageControl createPageControl];
        page.numberOfPages = 0;
        page.currentPageIndicatorTintColor = kCommonWhiteBg;
        page.pageIndicatorTintColor = kFontColorBlack;
        [self addSubview:_page = page];
    }
    return _page;
}


@end
