//
//  QL_CustomDatePickerView.m
//  MenLi
//
//  Created by mini2 on 16/7/2.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "Hen_CustomDatePickerView.h"

#define PICKER_HEIGHT       FITHEIGHT(360)

@interface Hen_CustomDatePickerView()

@property(nonatomic, strong) UIDatePicker *dataPikerView;

@property (nonatomic, assign) UIDatePickerMode datePcikerModel;

///蒙层
@property (nonatomic, strong) UIView *maskImageView;

@property(nonatomic, strong) UIView *topBgView;

///关闭按钮
@property(nonatomic, strong) UIButton *closeButton;

///完成按钮
@property(nonatomic, strong) UIButton *finishButton;

///标志pickerView是否出现
@property (nonatomic, assign) BOOL isPickerViewShow;

@end

@implementation Hen_CustomDatePickerView

-(id)init{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

-(void)initDefault{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, PICKER_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.dataPikerView];
    [self addSubview:self.topBgView];
    [self addSubview:self.closeButton];
    [self addSubview:self.finishButton];
    
    WEAKSelf;
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.topBgView);
        make.left.equalTo(self);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(150));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
    }];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.topBgView);
        make.right.equalTo(self);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(150));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(100));
    }];
    [self.dataPikerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topBgView.mas_bottom);
        make.bottom.equalTo(weakSelf);
    }];
    
    MASAttachKeys(self.topBgView, self.closeButton, self.finishButton, self.dataPikerView);
}

///显示
-(void)showDatePickerView
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    self.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, FITHEIGHT(PICKER_HEIGHT));
    
    [view addSubview:self];
    [view addSubview:self.maskImageView];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kMainScreenHeight - self.frame.size.height, kMainScreenWidth, self.frame.size.height);
        self.maskImageView.alpha = 0.5;
        self.maskImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - self.frame.size.height);
        
    } completion:^(BOOL finished) {
        self.isPickerViewShow = YES;
    }];
}

///设置类型
-(void)setDatePickerModel:(UIDatePickerMode)datePickerModel
{
    [self.dataPikerView setDatePickerMode:datePickerModel];
    self.datePcikerModel = datePickerModel;
}

// 设置初始选中的地方
- (void)setFirstSelectedByDateString:(NSString*)date
{
    if(date.length > 0){
        if(self.datePcikerModel == UIDatePickerModeDate){
            self.dataPikerView.date = [DATAMODEL.henUtil dateStringToDate:date];
        }else if(self.datePcikerModel == UIDatePickerModeDateAndTime){
            self.dataPikerView.date = [DATAMODEL.henUtil dateTimeToDateTime:date];
        }
    }else{
        if(self.datePcikerModel == UIDatePickerModeDate){
            self.dataPikerView.date = [DATAMODEL.henUtil dateStringToDate:[DATAMODEL.henUtil getSystemDate]];
        }
    }
}

///最小日期
-(void)setMinDatePickerBy:(NSDate *)minDate
{
    if (minDate) {
       self.dataPikerView.minimumDate  = minDate;
    } else {
        self.dataPikerView.minimumDate  = nil;
    }
}

///最大日期
-(void)setMaxDatePickerBy:(NSDate *)maxDate
{
    if (maxDate) {
        self.dataPikerView.maximumDate  = maxDate;
    } else {
        self.dataPikerView.maximumDate  = nil;
    }
}

#pragma mark --------------- action

-(void)onCloseButtonClick:(UIButton*)sender{
    [self dismissPickerView];
}

-(void)onFinishButtonClick:(UIButton*)sender
{
    if (self.datePcikerModel == UIDatePickerModeDate) {

        if(self.onDatePickerReturnBlock){
            self.onDatePickerReturnBlock([[Hen_Util getInstance] dateToString:self.dataPikerView.date]);
        }
    } else if (self.datePcikerModel == UIDatePickerModeTime) {

        if(self.onDatePickerReturnBlock){
            self.onDatePickerReturnBlock([[Hen_Util getInstance] timeToString:self.dataPikerView.date]);
        }
    } else if(self.datePcikerModel == UIDatePickerModeDateAndTime){
        if(self.onDatePickerReturnBlock){
            self.onDatePickerReturnBlock([[Hen_Util getInstance] dateTimeToString:self.dataPikerView.date]);
        }
    }
    
    [self dismissPickerView];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tap {
    [self dismissPickerView];
}

#pragma mark --------------- private

- (void)dismissPickerView {
    if (!self.isPickerViewShow) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, self.frame.size.height);
        self.maskImageView.alpha = 0;
        self.maskImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isPickerViewShow = NO;
        [self.maskImageView removeFromSuperview];
    }];
}

#pragma mark ----------- getter, setter

-(UIDatePicker*)dataPikerView
{
    if(!_dataPikerView){
        _dataPikerView = [[UIDatePicker alloc] init];
    }
    return _dataPikerView;
}

- (UIView *)maskImageView
{
    if (!_maskImageView) {
        _maskImageView = [UIView createViewWithFrame:[UIScreen mainScreen].bounds backgroundColor:[UIColor blackColor]];
        _maskImageView.userInteractionEnabled = YES;
        _maskImageView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [_maskImageView addGestureRecognizer:tap];
    }
    return _maskImageView;
}

- (UIView*)topBgView{
    if(!_topBgView){
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = kCommonBackgroudColor;
    }
    return _topBgView;
}

-(UIButton*)closeButton{
    if(!_closeButton){
        _closeButton = [UIButton createNoBgButtonWithTitle:@"关闭" target:self action:@selector(onCloseButtonClick:)];
        _closeButton.titleLabel.font = kFontSize_28;
    }
    return _closeButton;
}

-(UIButton*)finishButton{
    if(!_finishButton){
        _finishButton = [UIButton createNoBgButtonWithTitle:@"完成" target:self action:@selector(onFinishButtonClick:)];
        _finishButton.titleLabel.font = kFontSize_28;
        [_finishButton setTitleClor:kFontColorRed];
    }
    return _finishButton;
}



@end
