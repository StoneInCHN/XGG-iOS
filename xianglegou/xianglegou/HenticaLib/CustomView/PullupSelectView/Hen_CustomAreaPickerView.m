//
//  HV_AreaPicker.m
//  MenLi
//
//  Created by mini3 on 16/7/19.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "Hen_CustomAreaPickerView.h"

#define PICKER_HEIGHT       HEIGHT_TRANSFORMATION(650)
#define ParentId            @"1"

@implementation Hen_AreaPickerModel

@end

@interface Hen_CustomAreaPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIPickerView *pickerView;

///蒙层
@property (nonatomic, strong) UIView *maskImageView;

@property(nonatomic, strong) UIView *topBgView;

///关闭按钮
@property(nonatomic, strong) UIButton *closeButton;

///完成按钮
@property(nonatomic, strong) UIButton *finishButton;

///全部地区数据
@property(nonatomic, strong) NSMutableArray<Hen_AreaPickerModel*> *allAreaDataSource;

///数据源
@property (nonatomic, strong) NSMutableArray<NSMutableArray <Hen_AreaPickerModel *> *> *dataSource;

///点击完成后传回
@property (nonatomic, strong) NSMutableDictionary *selectedDict;

///标志pickerView是否出现
@property (nonatomic, assign) BOOL isPickerViewShow;

///是否正在读数据
@property(nonatomic, assign) BOOL isDataReading;

///初始选择数据
@property(nonatomic, strong) NSArray *firstSelectDatas;


@property (nonatomic, assign) AreaPickerType pickType;

@end

@implementation Hen_CustomAreaPickerView

-(id)init{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

- (void)initDefault{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, PICKER_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.pickerView];
    [self addSubview:self.topBgView];
    [self addSubview:self.closeButton];
    [self addSubview:self.finishButton];
    
    WEAKSelf;
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.equalTo(@(FITHEIGHT(44)));
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.topBgView);
        make.left.equalTo(weakSelf.mas_left).with.offset(FITWITH(30));
    }];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.topBgView);
        make.right.equalTo(weakSelf.mas_right).with.offset(FITWITH(-30));
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topBgView.mas_bottom);
        make.bottom.equalTo(weakSelf);
    }];
    
    MASAttachKeys(self.topBgView, self.closeButton, self.finishButton, self.pickerView);
}

///设置类型
-(void)setAreaPickerType:(AreaPickerType)pickerType
{
    self.pickType = pickerType;
}

///读取地区数据库
-(void)readAreaDB
{
    if(self.allAreaDataSource.count <= 0){
        self.isDataReading = YES;
        //显示加载
        [DATAMODEL.progressManager showPayHud:@""];
        WEAKSelf;
        //异步加载
        [[Hen_Util getInstance] asynchronousLoadingBlock:^{
//            NSMutableArray<QL_AreaDataModel*>* array = [DATAMODEL.configDBHelper getAllAreaDatas];
//            //存入地区数据
//            for(QL_AreaDataModel *model in array){
//                Hen_AreaPickerModel *areaModel = [[Hen_AreaPickerModel alloc] initWithDictionary:@{}];
//                areaModel.areaId = model.areaId;
//                areaModel.parentID = model.parentId;
//                areaModel.name = model.name;
//                
//                [self.allAreaDataSource addObject:areaModel];
//            }
        } finishBlock:^{
            //取消加载
            [DATAMODEL.progressManager hideHud];
            [weakSelf doShow];
            weakSelf.isDataReading = NO;
            [weakSelf setFirstSelectedBy:weakSelf.firstSelectDatas];
        }];
    }else{
        [self doShow];
    }
}

// 视图出现 && 刷新
-(void)showPickerView
{
    [self readAreaDB];
}

-(void)doShow
{
    if(self.allAreaDataSource.count <= 0){
        NSLog(@"=====获取地区数据失败====");
        return;
    }
    
    [self setInitSelected];
    
    if (self.isPickerViewShow) {
        [self.pickerView reloadAllComponents];
        return;
    }
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    self.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, PICKER_HEIGHT);
    
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

/// 初始化选中
- (void)setInitSelected
{
    self.dataSource = [@[] mutableCopy];
    self.selectedDict = [@{} mutableCopy];
    /// 省份数组
    NSMutableArray <Hen_AreaPickerModel *> *provinceArray = [self getAreaDatasForParentId:ParentId];
    /// 市数组
    NSMutableArray <Hen_AreaPickerModel *> *cityArray = [self getAreaDatasForParentId:provinceArray.firstObject.areaId];
    /// 地区数组
    NSMutableArray <Hen_AreaPickerModel *> *districtArray = [self getAreaDatasForParentId:cityArray.firstObject.areaId];

    if (self.pickType == AreaPickerTypeProvinceAndCityAndDistrict) {  /// 省 市 区
        [self.dataSource addObject:provinceArray];
        [self.dataSource addObject:cityArray];
        [self.dataSource addObject:districtArray];
        [self.selectedDict setObject:provinceArray.firstObject forKey:@"0"];
        [self.selectedDict setObject:cityArray.firstObject forKey:@"1"];
        [self.selectedDict setObject:districtArray.firstObject forKey:@"2"];
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
    } else if (self.pickType == AreaPickerTypeProvinceAndCity) { /// 省 市
        [self.dataSource addObject:provinceArray];
        [self.dataSource addObject:cityArray];
        [self.selectedDict setObject:provinceArray.firstObject forKey:@"0"];
        [self.selectedDict setObject:cityArray.firstObject forKey:@"1"];
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    }
}

// 设置选中的地方
-(void)setFirstSelectedBy:(NSArray *)select
{
    self.firstSelectDatas = select;
    
    if (!select || self.isDataReading) {
        return;
    }
    
    self.dataSource = [@[] mutableCopy];
    for (NSString *selectId in select) {
        Hen_AreaPickerModel *model = [self getAreaDataForId:selectId];
        [self.dataSource addObject:[self getAreaDatasForParentId:model.parentID]];
    }
    [self.pickerView reloadAllComponents];
    
    for (int i = 0; i < select.count; i ++) {
        NSString* selectID = select[i];
        NSArray <Hen_AreaPickerModel *> *areaArray = self.dataSource[i];
        for (Hen_AreaPickerModel *model in areaArray) {
            if ([model.areaId isEqualToString:selectID]) {
                [self.pickerView selectRow:[areaArray indexOfObject:model] inComponent:i animated:YES];
                [self.selectedDict setObject:model forKey:[NSString stringWithFormat:@"%ld", (long)i]];
                break;
            }
        }
    }
}

///通过父Id获取地区
-(NSMutableArray<Hen_AreaPickerModel*>*)getAreaDatasForParentId:(NSString*)parentId
{
    NSMutableArray<Hen_AreaPickerModel*>* array = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(Hen_AreaPickerModel *model in self.allAreaDataSource){
        if([model.parentID isEqualToString:parentId]){
            [array addObject:model];
        }
    }
    
    return array;
}

///通过id获取地区
-(Hen_AreaPickerModel*)getAreaDataForId:(NSString*)areaId
{
    for(Hen_AreaPickerModel *model in self.allAreaDataSource){
        if([model.areaId isEqualToString:areaId]){
            return model;
        }
    }
    
    return [[Hen_AreaPickerModel alloc] initWithDictionary:@{}];
}

/// 选中的某列
- (void)pickerViewDidSelectRow:(NSInteger)row andComponent:(NSInteger)component
{
    if(self.dataSource[component].count <= row){
        return;
    }
    
    [self.selectedDict setObject:self.dataSource[component][row] forKey:[NSString stringWithFormat:@"%ld", (long)component]];
    Hen_AreaPickerModel *model;
    if (self.pickType == AreaPickerTypeProvinceAndCityAndDistrict) {  /// 省 市 区
        if (component == 0) { // 选择省
            [self.dataSource removeLastObject];
            [self.dataSource removeLastObject];
            model = self.dataSource.firstObject[row];
            [self.dataSource addObject:[self getAreaDatasForParentId:model.areaId]];
            Hen_AreaPickerModel *model1 = self.dataSource[1][0];
            [self.dataSource addObject:[self getAreaDatasForParentId:model1.areaId]];
            Hen_AreaPickerModel *model2 = self.dataSource[2][0];
            [self.selectedDict setObject:model1 forKey:@"1"];
            [self.selectedDict setObject:model2 forKey:@"2"];
             [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        } else if (component == 1){  //选择市
            [self.dataSource removeLastObject];
            Hen_AreaPickerModel *model1 = self.dataSource[1][row];
            [self.dataSource addObject:[self getAreaDatasForParentId:model1.areaId]];
            Hen_AreaPickerModel *model2 = self.dataSource[2][0];
            [self.selectedDict setObject:model2 forKey:@"2"];
             [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
    } else if (self.pickType == AreaPickerTypeProvinceAndCity) { /// 省 市
        if (component == 0) { // 选择省
            [self.dataSource removeLastObject];
            model = self.dataSource.firstObject[row];
            [self.dataSource addObject:[self getAreaDatasForParentId:model.areaId]];
            Hen_AreaPickerModel *model1 = self.dataSource[1][0];
            [self.selectedDict setObject:model1 forKey:@"1"];
             [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
        }
    }
}

#pragma mark -- UIPickerViewDataSource, UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self pickerViewDidSelectRow:row andComponent:component];
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
    //数据
    Hen_AreaPickerModel *data = self.dataSource[component][row];
    NSString *showStr = data.name;
    
    return showStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    Hen_AreaPickerModel *model = self.dataSource[component][row];
    UILabel *myView = nil;
    if (self.pickType == AreaPickerTypeProvinceAndCityAndDistrict) {  /// 省 市 区
         myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kMainScreenWidth / 3, 30)];
    } else if (self.pickType == AreaPickerTypeProvinceAndCity) { /// 省 市
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kMainScreenWidth / 2, 30)];
    }
    
    myView.textAlignment = NSTextAlignmentCenter;
    myView.textColor = kFontColorBlack;
    //用label来设置字体大小
    myView.font = [UIFont systemFontOfSize:kFont_28];
    myView.backgroundColor = [UIColor clearColor];
    myView.text = model.name;
    
    return myView;
}

#pragma mark --------------- action

-(void)onCloseButtonClick:(UIButton*)sender
{
    [self dismissPickerView];
}

-(void)onFinishButtonClick:(UIButton*)sender
{
    if(self.onAreaPickerSelectBlock){
        self.onAreaPickerSelectBlock(self.selectedDict);
    }
    
    [self dismissPickerView];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tap
{
    [self dismissPickerView];
}

#pragma mark --------------- private

- (void)dismissPickerView
{
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

-(UIPickerView*)pickerView
{
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

- (UIView*)topBgView
{
    if(!_topBgView){
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = kCommonBackgroudColor;
    }
    return _topBgView;
}

-(UIButton*)closeButton
{
    if(!_closeButton){
        _closeButton = [UIButton createNoBgButtonWithTitle:@"关闭" target:self action:@selector(onCloseButtonClick:)];
        _closeButton.titleLabel.font = kFontSize_28;
    }
    return _closeButton;
}

-(UIButton*)finishButton
{
    if(!_finishButton){
        _finishButton = [UIButton createNoBgButtonWithTitle:@"完成" target:self action:@selector(onFinishButtonClick:)];
        _finishButton.titleLabel.font = kFontSize_28;
        [_finishButton setTitleClor:kFontColorBlue];
    }
    return _finishButton;
}

- (NSMutableDictionary *)selectedDict {
    if (!_selectedDict) {
        _selectedDict = [@{} mutableCopy];
    }
    return _selectedDict;
}

- (NSMutableArray<NSMutableArray <Hen_AreaPickerModel *> *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}

-(NSMutableArray<Hen_AreaPickerModel*>*)allAreaDataSource
{
    if(!_allAreaDataSource){
        _allAreaDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _allAreaDataSource;
}

@end
