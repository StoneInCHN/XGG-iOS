//
//  GC_TransferSegmentView.m
//  xianglegou
//
//  Created by mini1 on 2017/8/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "LZ_TransferSegmentView.h"

@interface LZ_TransferSegmentView ()
///按钮
@property (nonatomic, strong) NSMutableArray *buttonArray;
///标题
@property (nonatomic, strong) NSMutableArray *titleArray;
///数目
@property (nonatomic, strong) NSMutableArray *countArray;

///高度
@property (nonatomic, assign) CGFloat viewHeight;

///上分界线
@property(nonatomic, weak) UIImageView *topLineImage;
///下分界线
@property(nonatomic, weak) UIImageView *bottomLineImage;
@end


@implementation LZ_TransferSegmentView

///初始化
- (id)initWithHeight:(CGFloat)height
{
    self = [super init];
    if(self){
        [self initDefaultWithHeight:height];
    }
    return self;
}

- (void)dealloc
{
    for (UIButton* button in self.buttonArray) {
        [button removeFromSuperview];
    }
    
    [self.buttonArray removeAllObjects];
    [self setButtonArray:nil];
    
    
    for (UILabel* titleLabel in self.titleArray) {
        [titleLabel removeFromSuperview];
    }
    [self.titleArray removeAllObjects];
    [self setTitleArray:nil];
    
    for (UILabel* countLabel in self.countArray) {
        [countLabel removeFromSuperview];
    }
    [self.countArray removeAllObjects];
    [self setCountArray:nil];
}

///初始
-(void)initDefaultWithHeight:(CGFloat)height
{
    self.viewHeight = height;
    self.frame = CGRectMake(0, 0, kMainScreenWidth, height);
    self.backgroundColor = kCommonWhiteBg;
    
    [self loadSubViewAndConstraints];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
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
    for (UIButton* button in self.buttonArray) {
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    
    for (UILabel* titleLabel in self.titleArray) {
        [titleLabel removeFromSuperview];
    }
    [self.titleArray removeAllObjects];
    
    
    for (UILabel* countLabel in self.countArray) {
        [countLabel removeFromSuperview];
    }
    [self.countArray removeAllObjects];
    
    //按钮宽
    CGFloat buttonWidth = self.frame.size.width / nameArray.count;
    
    for (NSInteger i = 0; i < nameArray.count; i++) {
        //按钮
        UIButton *button = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onButtonAction:)];
        button.tag = i;
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, self.bounds.size.height);
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        //标题
        UILabel *titleLabel = [UILabel createLabelWithText:[nameArray objectAtIndex:i] font:kFontSize_28];
        titleLabel.frame = CGRectMake(buttonWidth*i, 10, buttonWidth, 30);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        [self.titleArray addObject:titleLabel];
        
        //数目
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorRed];
        label.frame = CGRectMake(buttonWidth*i, 30, buttonWidth, 30);
        
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.countArray addObject:label];
        
        //分界线
        if(i != nameArray.count - 1){
            UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line2"];
            [button addSubview:lineImage];
            if(self.lineMargin > 0){
                [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(self.lineMargin));
                    make.bottom.equalTo(button).offset(HEIGHT_TRANSFORMATION(-self.lineMargin));
                    make.right.equalTo(button);
                }];
            }else{
                [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(16));
                    make.bottom.equalTo(button).offset(HEIGHT_TRANSFORMATION(-16));
                    make.right.equalTo(button);
                }];
            }
            
        }
    }
}

///设置item
-(void)setItems:(NSArray*)nameArray andLineImageName:(NSString *)lineName
{
    if(nameArray.count <= 0){
        return;
    }
    
    //清除
    for (UIButton* button in self.buttonArray) {
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    
    for (UILabel* titleLabel in self.titleArray) {
        [titleLabel removeFromSuperview];
    }
    [self.titleArray removeAllObjects];
    
    
    for (UILabel* countLabel in self.countArray) {
        [countLabel removeFromSuperview];
    }
    [self.countArray removeAllObjects];
    
    //按钮宽
    CGFloat buttonWidth = self.frame.size.width / nameArray.count;
    
    for (NSInteger i = 0; i < nameArray.count; i++) {
        //按钮
        UIButton *button = [UIButton createNoBgButtonWithTitle:@"" target:self action:@selector(onButtonAction:)];
        button.tag = i;
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, self.bounds.size.height);
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        //标题
        UILabel *titleLabel = [UILabel createLabelWithText:[nameArray objectAtIndex:i] font:kFontSize_28];
        titleLabel.frame = CGRectMake(buttonWidth*i, 10, buttonWidth, 30);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        [self.titleArray addObject:titleLabel];
        
        //数目
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorRed];
        label.frame = CGRectMake(buttonWidth*i, 30, buttonWidth, 30);
        
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.countArray addObject:label];
        
        //分界线
        if(i != nameArray.count - 1){
            UIImageView *lineImage = [UIImageView createImageViewWithName:lineName];
            [button addSubview:lineImage];
            if(self.lineMargin > 0){
                [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(self.lineMargin));
                    make.bottom.equalTo(button).offset(HEIGHT_TRANSFORMATION(-self.lineMargin));
                    make.right.equalTo(button);
                }];
            }else{
                [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(16));
                    make.bottom.equalTo(button).offset(HEIGHT_TRANSFORMATION(-16));
                    make.right.equalTo(button);
                }];
            }
            
        }
    }
}

///设置数目
-(void)setItemCount:(NSString*)count index:(NSInteger)index
{
    if(index < 0 || index >= self.countArray.count){
        return;
    }
    
    ((UILabel*)[self.countArray objectAtIndex:index]).text = count;
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

///设置背景
- (void)setBgColor:(UIColor *)color
{
    self.backgroundColor = color;
}

#pragma mark -- event response

///按钮 点击事件
-(void)onButtonAction:(UIButton*)sender
{
    if(self.onSelectedBlock){
        self.onSelectedBlock(sender.tag);
    }
}


#pragma mark -- getter,setter

- (NSMutableArray *)buttonArray
{
    if(!_buttonArray){
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _buttonArray;
}


- (NSMutableArray *)titleArray
{
    if(!_titleArray){
        _titleArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _titleArray;
}

- (NSMutableArray *)countArray
{
    if(!_countArray){
        _countArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _countArray;
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
