//
//  QL_CustomPickerView.m
//  CRM
//
//  Created by mini2 on 16/6/7.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import "Hen_CustomPickerView.h"

@implementation Hen_CustomPickerModel

@end

#define PICKER_HEIGHT       HEIGHT_TRANSFORMATION(600)

@interface Hen_CustomPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIPickerView *pickerView;

///蒙层
@property (nonatomic, strong) UIView *maskImageView;

@property(nonatomic, strong) UIView *topBgView;

///关闭按钮
@property(nonatomic, strong) UIButton *closeButton;

///完成按钮
@property(nonatomic, strong) UIButton *finishButton;

///数据源
@property (nonatomic, strong) NSMutableArray<NSMutableArray<Hen_CustomPickerModel*> *> *dataSource;

///单位
@property (nonatomic, strong) NSMutableArray<NSMutableArray<Hen_CustomPickerModel*> *> *unitArray;

///点击完成后传回
@property (nonatomic, strong) NSMutableDictionary *selectedDict;

///标志pickerView是否出现
@property (nonatomic, assign) BOOL isPickerViewShow;

@end


@implementation Hen_CustomPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

-(void)initDefault
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, PICKER_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.pickerView];
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
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topBgView.mas_bottom);
        make.bottom.equalTo(weakSelf);
    }];
    
//    MASAttachKeys(self.topBgView, self.closeButton, self.finishButton, self.pickerView);
}

// 视图出现 && 刷新
- (void)showPickerViewWithDataSource:(NSArray<NSMutableArray<Hen_CustomPickerModel*>*>*)dataSource unitArray:(NSArray *)uniArray
{
    self.firstRowUnShowUnit = NO;
    
    self.dataSource = [NSMutableArray arrayWithArray:dataSource];
    self.unitArray = [NSMutableArray arrayWithArray:uniArray];
    
    if (self.isPickerViewShow) {
        [self.pickerView reloadAllComponents];
        return;
    }
    for (int i = 0; i < dataSource.count; i++) {
        if(((NSMutableArray*)dataSource[i]).count > i){
            [self.selectedDict setObject:((NSMutableArray*)dataSource[i]).firstObject forKey:[NSString stringWithFormat:@"%d", i]];
        }
    }
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
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

    [self.pickerView reloadAllComponents];
}

// 设置初始选中的地方
- (void)setFirstSelectedBy:(NSArray<NSString*>*)select
{
    for(NSInteger i = 0; i < select.count; i++){
        
        NSString *item = [select objectAtIndex:i];
        NSMutableArray *array = [self.dataSource objectAtIndex:i];
        NSInteger count = 0;
        [self.pickerView selectRow:0 inComponent:i animated:YES];
        
        for(Hen_CustomPickerModel* data in array){
            
            if([data.itemId isEqualToString:item]){
                [self.pickerView selectRow:count inComponent:i animated:YES];
                [self.selectedDict setObject:data forKey:[NSString stringWithFormat:@"%ld", (long)i]];
                break;
            }else if([data.name isEqualToString:item]){
                [self.pickerView selectRow:count inComponent:i animated:YES];
                [self.selectedDict setObject:data forKey:[NSString stringWithFormat:@"%ld", (long)i]];
                break;
            }
            
            count++;
        }
    }
}

#pragma mark -- UIPickerViewDataSource, UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(((NSMutableArray*)self.dataSource[component]).count > row){
        [self.selectedDict setObject:self.dataSource[component][row] forKey:[NSString stringWithFormat:@"%ld", (long)component]];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSource[component] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *showStr = @"";
    
    if(component < self.dataSource.count && row < self.dataSource[component].count){
        Hen_CustomPickerModel *data = self.dataSource[component][row];
    
        showStr = data.name;
    
        if(self.unitArray.count > 0){
            if(component == 0 && self.firstRowUnShowUnit){
                return showStr;
            }
            return [NSString stringWithFormat:@"%@%@", showStr, self.unitArray[component]];
        }
    }
    return showStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kMainScreenWidth, FITHEIGHT(30))];
    
    myView.textAlignment = NSTextAlignmentCenter;
    myView.textColor = kFontColorBlack;
    
    NSString *showStr = @"";
    
    if(component < self.dataSource.count && row < self.dataSource[component].count){
        Hen_CustomPickerModel *data = self.dataSource[component][row];
    
        showStr = data.name;
    
        if(self.unitArray.count > 0){
            if(component == 0 && self.firstRowUnShowUnit){
                myView.text = showStr;
            }else{
                myView.text = [NSString stringWithFormat:@"%@%@", showStr, self.unitArray[component]];
            }
        }else{
            myView.text = showStr;
        }
    }
    //用label来设置字体大小
    myView.font = [UIFont systemFontOfSize:kFont_28];
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

#pragma mark --------------- action

-(void)onCloseButtonClick:(UIButton*)sender{
    [self dismissPickerView];
}

-(void)onFinishButtonClick:(UIButton*)sender{
    if(self.onCustomPickerSelectBlock){
        self.onCustomPickerSelectBlock(self.selectedDict);
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

#pragma mark --------------- getter, setter

-(UIPickerView*)pickerView{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return _pickerView;
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

- (NSMutableDictionary *)selectedDict {
    if (!_selectedDict) {
        _selectedDict = [@{} mutableCopy];
    }
    return _selectedDict;
}

@end
