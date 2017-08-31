//
//  QL_ListScreenSegmentView.m
//  Rebate
//
//  Created by mini2 on 17/3/23.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_ListScreenSegmentView.h"

@interface QL_ListScreenSegmentView()

///按钮
@property(nonatomic, strong) NSMutableArray *buttonArray;
///箭头
@property(nonatomic, strong) NSMutableArray *arrowArray;

///上分界线
@property(nonatomic, weak) UIImageView *topLineImage;
///下分界线
@property(nonatomic, weak) UIImageView *bottomLineImage;

///高度
@property(nonatomic, assign) CGFloat viewHeight;
///默认字体
@property(nonatomic, strong) UIFont *defaultFont;

@end

@implementation QL_ListScreenSegmentView

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
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
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
    //清除
    for(UIImageView* arrow in self.arrowArray){
        [arrow removeFromSuperview];
    }
    [self.arrowArray removeAllObjects];
    
    //按钮宽
    CGFloat buttonWidth = kMainScreenWidth / nameArray.count;
    for(NSInteger i = 0; i < nameArray.count; i++){
        //按钮
        UIButton *button = [UIButton createNoBgButtonWithTitle:[nameArray objectAtIndex:i] target:self action:@selector(onButtonAction:)];
        button.tag = i;
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, self.bounds.size.height);
        [button setTitleColor:kFontColorRed forState:UIControlStateHighlighted];
        [button setTitleColor:kFontColorRed forState:UIControlStateSelected];
        button.titleLabel.font = self.defaultFont;
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        UIImageView *image = [UIImageView createImageViewWithName:@"homepage_screening_down"];
        [button addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(button);
            make.left.equalTo(button.titleLabel.mas_right).offset(2);
        }];
        [self.arrowArray addObject:image];
        
        if(i != 0){
            UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line2"];
            [self addSubview:lineImage];
            [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(button).offset(HEIGHT_TRANSFORMATION(10));
                make.bottom.equalTo(button).offset(HEIGHT_TRANSFORMATION(-10));
                make.right.equalTo(button.mas_left);
            }];
        }
    }
}

///设置item名字
- (void)setItem:(NSInteger)item title:(NSString *)title
{
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
    
    UIButton *selectButton = ((UIButton*)[self.buttonArray objectAtIndex:item]);
    UIImageView *arrowImage = ((UIImageView*)[self.arrowArray objectAtIndex:item]);
    
    if(!selectButton.isSelected){ // 选中
        //全不选中
        for(UIButton* button in self.buttonArray){
            [button setSelected:NO];
        }
        for(UIImageView *image in self.arrowArray){
             [image setImageForName:@"homepage_screening_down"];
        }
        
        [selectButton setSelected:YES];
        [arrowImage setImageForName:@"homepage_screening_down_red"];
        
        [self.delegate customScreenSegmentCurrentItem:item andIsSelect:NO];
    }else{
        [self.delegate customScreenSegmentCurrentItem:item andIsSelect:YES];
    }
}

//设置上分界线显隐
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
    [self setSelectItem:sender.tag];
}

#pragma mark -- getter, setter

///按钮
-(NSMutableArray*)buttonArray
{
    if(!_buttonArray){
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _buttonArray;
}

///箭头
- (NSMutableArray *)arrowArray
{
    if(!_arrowArray){
        _arrowArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrowArray;
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
