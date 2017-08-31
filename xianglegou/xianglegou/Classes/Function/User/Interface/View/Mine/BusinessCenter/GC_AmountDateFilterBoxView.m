//
//  GC_AmountDateFilterBoxView.m
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_AmountDateFilterBoxView.h"

@interface GC_AmountDateFilterBoxView ()
///开始日期
@property (nonatomic, weak) UILabel *begDateLabel;
@property (nonatomic, weak) UIButton *selectBegDateButton;
@property (nonatomic, weak) UILabel *selectBegDateLabel;

///结束日期
@property (nonatomic, weak) UILabel *endDateLabel;
@property (nonatomic, weak) UIButton *selectEndDateButton;
@property (nonatomic, weak) UILabel *selectEndDateLabel;

///分割线
@property (nonatomic, weak) UIImageView *lineImageView;
///重置按钮
@property (nonatomic, weak) UIButton *resetButton;
///完成 按钮
@property (nonatomic, weak) UIButton *finshButton;

///蒙层
@property (nonatomic, strong) UIView *maskView;
///头部 蒙层
@property (nonatomic, strong) UIView *headMaskView;

///日期选择
@property (nonatomic, strong) Hen_CustomDatePickerView *datePickerView;


///日期选择类型  0、开始日期   1、结束日期
@property (nonatomic, assign) NSInteger dateType;



@property (nonatomic, assign) NSInteger filterState;
@end

@implementation GC_AmountDateFilterBoxView
- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

///初始化
- (void)initDefault
{
    self.frame = CGRectMake(0, 64, kMainScreenWidth, HEIGHT_TRANSFORMATION(350));
    
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

///加载子视图 及约束
- (void)loadSubViewAndConstraints
{
    [self.begDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(45));
        make.left.equalTo(self).offset(OffSetToLeft);
    }];
    
    [self.selectBegDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(200));
        make.centerY.equalTo(self.begDateLabel);
        make.right.equalTo(self).offset(OffSetToRight);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(78));
    }];
    
    [self.endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.begDateLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(92));
        make.left.equalTo(self).offset(OffSetToLeft);
    }];
    
    [self.selectEndDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endDateLabel);
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(200));
        make.right.equalTo(self).offset(OffSetToRight);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(78));
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(HEIGHT_TRANSFORMATION(-90));
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(89));
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(120));
    }];
    
    
    [self.finshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(89));
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(120));
    }];
}

#pragma mark -- private
///显示
- (void)showView
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    self.frame = CGRectMake(0, 64, kMainScreenWidth, HEIGHT_TRANSFORMATION(350));
    
    [view addSubview:self.maskView];
    [view addSubview:self.headMaskView];
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 64, kMainScreenWidth, HEIGHT_TRANSFORMATION(350));
        self.maskView.alpha = 0.5;
        self.headMaskView.frame = CGRectMake(0, 0, kMainScreenWidth, 64);
        self.maskView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64);
        
        
    } completion:^(BOOL finished) {
        self.filterState = 0;
    }];
}

- (void)dismissBoxView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 64, kMainScreenWidth, HEIGHT_TRANSFORMATION(350));
        self.maskView.alpha = 0;
        self.headMaskView.frame = CGRectMake(0, 0, kMainScreenWidth, 64);
        self.maskView.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.headMaskView removeFromSuperview];
        [self.maskView removeFromSuperview];
        
    }];
}

#pragma mark -- action
///日期选择 Action
- (void)onSelectDateAction:(UIButton *)sender
{
    self.filterState = 1;
    self.dateType = sender.tag;
    
    if(self.dateType == 0){         //开始日期
        if(self.begDate.length > 0){
            [self.datePickerView setFirstSelectedByDateString:self.begDate];
        }
    }else if(self.dateType == 1){   //结束日期
        if(self.endDate.length > 0){
            [self.datePickerView setFirstSelectedByDateString:self.endDate];
        }
    }
    [self.datePickerView showDatePickerView];
    
    
}

///重置按钮
- (void)onResetAction:(UIButton *)sender
{
    self.filterState = 0;
    
    self.begDate = @"";
    self.selectBegDateLabel.text = @"选择开始日期";
    
    self.endDate = @"";
    self.selectEndDateLabel.text = @"选择结束日期";
    
}

///完成 按钮
- (void)onFinshAction:(UIButton *)sender
{
    
    if(self.filterState == 1){
        if(self.begDate.length <= 0){
            [DATAMODEL.progressManager showHint:@"日期未选择完整！"];
            return;
        }
        
        
        if(self.endDate.length <= 0){
            [DATAMODEL.progressManager showHint:@"日期未选择完整！"];
            return;
        }
    }
    
    
    
    if(self.onFinshBlock){
        self.onFinshBlock(self.begDate, self.endDate);
    }
    
    [self dismissBoxView];
}


- (void)tapGestureHandler:(id)sender
{
    [self dismissBoxView];
}

#pragma mark -- getter,setter

///蒙层
- (UIView *)maskView
{
    if(!_maskView){
        _maskView = [UIView createViewWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight) backgroundColor:[UIColor blackColor]];
        
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)headMaskView
{
    if(!_headMaskView){
        _headMaskView = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, 64) backgroundColor:[UIColor clearColor]];
        
        _headMaskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [_headMaskView addGestureRecognizer:tap];
    }
    return _headMaskView;
}


///开始日期
- (UILabel *)begDateLabel
{
    if(!_begDateLabel){
        UILabel *label = [UILabel createLabelWithText:@"开始日期" font:kFontSize_28];
        [self addSubview:_begDateLabel = label];
    }
    return _begDateLabel;
}

- (UIButton *)selectBegDateButton
{
    if(!_selectBegDateButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" backgroundNormalImage:@"mine_date" backgroundPressImage:@"mine_date" target:self action:@selector(onSelectDateAction:)];
        button.tag = 0;
        [button setTitleClor:kFontColorGray];
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_selectBegDateButton = button];
        
        UILabel *label = [UILabel createLabelWithText:@"选择开始日期" font:kFontSize_28 textColor:kFontColorGray];
        [button addSubview:_selectBegDateLabel = label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button).offset(WIDTH_TRANSFORMATION(16));
            make.centerY.equalTo(button);
            make.right.equalTo(button).offset(WIDTH_TRANSFORMATION(-16));
        }];
    }
    return _selectBegDateButton;
}

///结束日期
- (UILabel *)endDateLabel
{
    if(!_endDateLabel){
        UILabel *label = [UILabel createLabelWithText:@"结束日期" font:kFontSize_28];
        
        [self addSubview:_endDateLabel = label];
    }
    return _endDateLabel;
}
- (UIButton *)selectEndDateButton
{
    if(!_selectEndDateButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" backgroundNormalImage:@"mine_date" backgroundPressImage:@"mine_date" target:self action:@selector(onSelectDateAction:)];
        button.tag = 1;
        
        [button setTitleClor:kFontColorGray];
        [self addSubview:_selectEndDateButton = button];
        
        UILabel *label = [UILabel createLabelWithText:@"选择结束日期" font:kFontSize_28 textColor:kFontColorGray];
        [button addSubview:_selectEndDateLabel = label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button).offset(WIDTH_TRANSFORMATION(16));
            make.centerY.equalTo(button);
            make.right.equalTo(button).offset(WIDTH_TRANSFORMATION(-16));
        }];
    }
    return _selectEndDateButton;
}


///分割线
- (UIImageView *)lineImageView
{
    if(!_lineImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
        [self addSubview:_lineImageView = image];
    }
    return _lineImageView;
}

///重置按钮
- (UIButton *)resetButton
{
    if(!_resetButton){
        UIButton *butotn = [UIButton createNoBgButtonWithTitle:@"重置" target:self action:@selector(onResetAction:)];
        [self addSubview:_resetButton = butotn];
    }
    return _resetButton;
}

///完成 按钮
- (UIButton *)finshButton
{
    if(!_finshButton){
        UIButton *button = [UIButton createNoBgButtonWithTitle:@"完成" target:self action:@selector(onFinshAction:)];
        [button setTitleClor:kFontColorRed];
        [self addSubview:_finshButton = button];
    }
    return _finshButton;
}

- (Hen_CustomDatePickerView *)datePickerView
{
    if(!_datePickerView){
        _datePickerView = [[Hen_CustomDatePickerView alloc] init];
        [_datePickerView setDatePickerModel:UIDatePickerModeDate];
        
        WEAKSelf;
        //回调
        _datePickerView.onDatePickerReturnBlock = ^(NSString *dateString) {
            if(weakSelf.dateType == 0){         //开始日期
                weakSelf.begDate = dateString;
                weakSelf.selectBegDateLabel.text = dateString;
            }else if(weakSelf.dateType == 1){   //结束日期
                weakSelf.endDate = dateString;
                weakSelf.selectEndDateLabel.text = dateString;
            }
        };
    }
    return _datePickerView;
}
@end
