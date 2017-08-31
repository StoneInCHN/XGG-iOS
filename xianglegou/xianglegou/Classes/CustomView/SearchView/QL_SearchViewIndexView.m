//
//  CustomIndex.m
//  L09-UITableview01
//
//  Created by Harvey on 16/1/24.
//  Copyright © 2016年 Harvey. All rights reserved.
//

#import "QL_SearchViewIndexView.h"

#define HV_TAG 1000
#define ANIMATIONTIME  0.3

@interface QL_SearchViewIndexView () <UIGestureRecognizerDelegate>{
    NSInteger _lastTag;
    SelectedIndexBlock _block;
}

@property (nonatomic, strong) NSArray *indexTitleArray;     /**< 索引标题 */

@property(nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation QL_SearchViewIndexView

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        self.indexTitleArray = titleArray;
        [self configUI];
    }
    return self;
}

-(instancetype)initWithTitleArray:(NSArray*)titleArray
{
    self = [super init];
    if(self){
        self.indexTitleArray = titleArray;
        [self initDefault];
    }
    return self;
}

-(void)dealloc
{
    [self.inditorView removeFromSuperview];
    [self setInditorView:nil];
}

#pragma mark
#pragma mark -- private methods
- (void)configUI {
    _lastTag = -1;
    CGFloat height = self.bounds.size.height / self.indexTitleArray.count;
    for (int i = 0; i < self.indexTitleArray.count ; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0 + height * i, self.bounds.size.width, height);
        button.tag = HV_TAG + i;
        [button addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(displayView:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:self.indexTitleArray[i] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPanGesture:)];
    [self addGestureRecognizer:pan];
    
}

- (void)initDefault
{
    _lastTag = -1;
    self.buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(NSInteger i = 0; i < self.indexTitleArray.count; i++){
        UIButton *button = [[UIButton alloc] init];
        button.tag = HV_TAG + i;
        [button addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(displayView:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:self.indexTitleArray[i] forState:UIControlStateNormal];
        
        [self addSubview:button];
        
        [self.buttonArray addObject:button];
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPanGesture:)];
    [self addGestureRecognizer:pan];
    
    [self updateButtonConstraints];
}

-(void)updateButtonConstraints
{
    WEAKSelf;
    for(NSInteger i = 0; i < self.buttonArray.count; i++){
        UIButton *button = [self.buttonArray objectAtIndex:i];
        if(i == 0){
            UIButton *tempButton = [self.buttonArray objectAtIndex:i+1];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(weakSelf);
                make.centerX.equalTo(weakSelf);
                make.top.equalTo(weakSelf.mas_top);
                make.height.equalTo(tempButton.mas_height);
            }];
        }else if(i == self.buttonArray.count - 1){
            UIButton *tempButton = [self.buttonArray objectAtIndex:i-1];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(weakSelf);
                make.centerX.equalTo(weakSelf);
                make.bottom.equalTo(weakSelf.mas_bottom);
                make.top.equalTo(tempButton.mas_bottom);
                make.height.equalTo(tempButton.mas_height);
            }];
        }else{
            UIButton *tempButton1 = [self.buttonArray objectAtIndex:i-1];
            UIButton *tempButton2 = [self.buttonArray objectAtIndex:i+1];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(weakSelf);
                make.centerX.equalTo(weakSelf);
                make.top.equalTo(tempButton1.mas_bottom);
                make.height.equalTo(tempButton1.mas_height);
                make.height.equalTo(tempButton2.mas_height);
            }];
        }
    }
}

#pragma mark
#pragma mark -- responds events
- (void)respondsToButton:(UIButton *)sender {
    if (sender.tag != _lastTag) {
        _lastTag = sender.tag;
        if(_block){
            _block(sender.titleLabel.text, sender.tag - HV_TAG);
        }
    }
    [self hiddeView:sender];
        return;
}

- (void)displayView:(UIButton *)sender {
    if (_inditorView) {
        [UIView animateWithDuration:ANIMATIONTIME animations:^{
            _inditorView.alpha = 1;
        }];
    }
}

- (void)hiddeView:(UIButton *)sender {
    if (_inditorView) {
        [UIView animateWithDuration:ANIMATIONTIME animations:^{
            _inditorView.alpha = 0;
        }];
    }
}

- (void)respondsToPanGesture:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan locationInView:self];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (CGRectContainsPoint(button.frame, currentPoint) && _lastTag != button.tag) {
                _lastTag = button.tag;
                if(_block){
                    _block(button.titleLabel.text, button.tag - HV_TAG);
                }
            }
        }
    }
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self displayView:nil];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self hiddeView:nil];
        }
            
        default:
            break;
    }
}

- (void)setSelectedBlock:(SelectedIndexBlock)selectedIndexBlock {
    _block = selectedIndexBlock;
}
#pragma mark
#pragma mark -- getter && setter
- (void)setIndexBackGroundColor:(UIColor *)indexBackGroundColor {
    _indexBackGroundColor = indexBackGroundColor;
    self.backgroundColor = indexBackGroundColor;
}

- (void)setIndexColor:(UIColor *)indexColor {
    for (UIButton *button in self.subviews) {
        [button setTitleColor:indexColor forState:UIControlStateNormal];
        [button setTintColor:indexColor];
    }

    _indexColor = indexColor;
}

- (void)setIndexFontSize:(CGFloat)indexFontSize {
    _indexFontSize = indexFontSize;
    for (UIButton *button in self.subviews) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:indexFontSize];
    }
    _indexColor = [UIColor whiteColor];

}



- (void)setInditorView:(UIView *)inditorView {
    _inditorView = inditorView;
    _inditorView.alpha = 0;
}


@end
