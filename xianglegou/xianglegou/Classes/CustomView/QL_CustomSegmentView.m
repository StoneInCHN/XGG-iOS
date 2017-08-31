//
//  QL_CustomSegmentView.m
//  Ask
//
//  Created by mini2 on 16/11/17.
//  Copyright © 2016年 Ask. All rights reserved.
//

#import "QL_CustomSegmentView.h"

@interface QL_CustomSegmentView()<UIScrollViewDelegate>

///按钮
@property(nonatomic, strong) NSMutableArray *buttonArray;
///下划线
@property(nonatomic, weak) UIImageView *bottomScrollLineImage;
///滑动区域
@property(nonatomic, strong) UIScrollView *scrollView;

///上分界线
@property(nonatomic, weak) UIImageView *topLineImage;
///下分界线
@property(nonatomic, weak) UIImageView *bottomLineImage;

///高度
@property(nonatomic, assign) CGFloat viewHeight;
///默认字体
@property(nonatomic, strong) UIFont *defaultFont;
///默认字体颜色
@property(nonatomic, strong) UIColor *defalutFontColor;
///选中字体
@property(nonatomic, strong) UIFont *selectFont;
///选中字体颜色
@property(nonatomic, strong) UIColor *selectFontColor;

@end

@implementation QL_CustomSegmentView

///初始化
-(id)initWithHeight:(CGFloat)height
{
    self = [super init];
    if(self){
        [self initDefaultWithHeight:height];
    }
    return self;
}

-(void)dealloc
{
    for(UIButton* button in self.buttonArray){
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    [self setButtonArray:nil];
}

///初始
-(void)initDefaultWithHeight:(CGFloat)height
{
    self.viewHeight = height;
    self.frame = CGRectMake(0, 0, kMainScreenWidth, height);
    self.backgroundColor = kCommonWhiteBg;
    
    self.defaultFont = kFontSize_26;
    self.defalutFontColor = kFontColorBlack;
    self.selectFont = kFontSize_26;
    self.selectFontColor = kFontColorRed;
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
-(void)loadSubViewAndConstraints
{
    [self.topLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];

    [self.bottomLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

///设置item
-(void)setItems:(NSArray*)nameArray
{
    if(nameArray.count <= 0){
        return;
    }
    
    //清除
    for(UIButton* button in self.buttonArray){
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    
    //按钮宽
    CGFloat buttonWidth = self.frame.size.width / nameArray.count;
    for(NSInteger i = 0; i < nameArray.count; i++){
        //按钮
        UIButton *button = [UIButton createNoBgButtonWithTitle:[nameArray objectAtIndex:i] target:self action:@selector(onButtonAction:)];
        button.tag = i;
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, self.bounds.size.height);
        [button setTitleClor:self.defalutFontColor];
        [button setTitleColor:self.selectFontColor forState:UIControlStateSelected];
        button.titleLabel.font = self.defaultFont;
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        //分界线
        if(i != nameArray.count - 1){
            UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line2"];
            [button addSubview:lineImage];
            [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(10));
                make.bottom.equalTo(button).offset(HEIGHT_TRANSFORMATION(-10));
                make.right.equalTo(button);
            }];
        }
    }
    
    [self bottomScrollLineImage];
}

///设置item
-(void)setUnLineItems:(NSArray*)nameArray
{
    if(nameArray.count <= 0){
        return;
    }
    
    //清除
    for(UIButton* button in self.buttonArray){
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    
    //按钮宽
    CGFloat buttonWidth = self.frame.size.width / nameArray.count;
    for(NSInteger i = 0; i < nameArray.count; i++){
        //按钮
        UIButton *button = [UIButton createNoBgButtonWithTitle:[nameArray objectAtIndex:i] target:self action:@selector(onButtonAction:)];
        button.tag = i;
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, self.bounds.size.height);
        [button setTitleClor:self.defalutFontColor];
        [button setTitleColor:self.selectFontColor forState:UIControlStateSelected];
        button.titleLabel.font = self.defaultFont;
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        if(i == 0){
            [button setSelected:YES];
            button.titleLabel.font = self.selectFont;
        }
    }
    
    [self bottomScrollLineImage];
}

///设置item名字
- (void)setItem:(NSInteger)item title:(NSString *)title
{
    if(item > self.buttonArray.count){
        return;
    }
    
    UIButton *selectButton = ((UIButton*)[self.buttonArray objectAtIndex:item]);
    [selectButton setTitle:title forState:UIControlStateNormal];
}

///设置选中项
-(void)setSelectItem:(NSInteger)item
{
    if(item < 0 || item >= self.buttonArray.count){
        return;
    }
    
    self.currentItem = item;
    
    //全不选中
    for(UIButton* button in self.buttonArray){
        [button setSelected:NO];
        button.titleLabel.font = self.defaultFont;
    }
    
    UIButton *selectButton = ((UIButton*)[self.buttonArray objectAtIndex:item]);
    [selectButton setSelected:YES];
    selectButton.titleLabel.font = self.selectFont;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomScrollLineImage.center = CGPointMake(selectButton.center.x, self.viewHeight-1);
    }];
    
    if(self.scrollView){
        [self.scrollView setContentOffset:CGPointMake(kMainScreenWidth * self.currentItem, 0) animated:YES];
        
        //延迟0.2s，等滑动结束后返回
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate customSegmentCurrentItem:item];
        });
    }else{
        [self.delegate customSegmentCurrentItem:item];
    }
}

///设置UIScrollView（需要滑动要设置）
-(void)setScrollView:(UIScrollView*)scrollView
{
    _scrollView = scrollView;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kMainScreenWidth * self.buttonArray.count, 0);
}

///设置默认，选中字体
- (void)setDefaultFont:(UIFont *)defaultFont selectFont:(UIFont *)selectFont
{
    self.defaultFont = defaultFont;
    self.selectFont = selectFont;
    
    for(UIButton *button in self.buttonArray){
        button.titleLabel.font = defaultFont;
    }
}

///设置上分界线显隐
-(void)setTopLineImageViewHidden:(BOOL)hidden
{
    self.topLineImage.hidden = hidden;
}

///设置下分界线显隐
-(void)setBottomLineImageViewHidden:(BOOL)hidden
{
    self.bottomLineImage.hidden = hidden;
}

#pragma mark -- event response

-(void)onButtonAction:(UIButton*)sender
{
    if(!sender.selected){
        [self setSelectItem:sender.tag];
    }
}

#pragma mark -- UIScrollViewDelegate

///滑动结束后调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]]){
        // 获得索引
        NSUInteger index = round(scrollView.contentOffset.x / kMainScreenWidth);
        
        [self setSelectItem:index];
    }
}

#pragma mark -- getter, setter

-(NSMutableArray*)buttonArray
{
    if(!_buttonArray){
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _buttonArray;
}

///下划线
- (UIImageView *)bottomScrollLineImage
{
    if(!_bottomScrollLineImage){
        UIImageView *image = [UIImageView createImageViewWithName:@""];
        image.frame = CGRectMake(0, self.viewHeight, WIDTH_TRANSFORMATION(120), 2);
        image.backgroundColor = kFontColorRed;
        [self addSubview:_bottomScrollLineImage = image];
    }
    return _bottomScrollLineImage;
}

///上分界线
- (UIImageView *)topLineImage
{
    if(!_topLineImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
        [self addSubview:_topLineImage = image];
    }
    return _topLineImage;
}

///下分界线
- (UIImageView *)bottomLineImage
{
    if(!_bottomLineImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
        [self addSubview:_bottomLineImage = image];
    }
    return _bottomLineImage;
}

@end
