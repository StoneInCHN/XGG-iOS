//
//  HV_AreaPicker.m
//  MenLi
//
//  Created by mini3 on 16/7/19.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "QL_AreaPickerView.h"

#define PICKER_HEIGHT       HEIGHT_TRANSFORMATION(600)

@implementation QL_AreaRequestDataModel

@end

@interface QL_AreaPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIPickerView *pickerView;

///蒙层
@property (nonatomic, strong) UIView *maskImageView;

@property(nonatomic, strong) UIView *topBgView;

///关闭按钮
@property(nonatomic, strong) UIButton *closeButton;

///完成按钮
@property(nonatomic, strong) UIButton *finishButton;

///请求参数
@property(nonatomic, strong) QL_AreaRequestDataModel *areaParam;
///数据源
@property (nonatomic, strong) NSMutableArray <QL_AreaDataModel *> *dataSource1;
@property (nonatomic, strong) NSMutableArray <QL_AreaDataModel *> *dataSource2;
@property (nonatomic, strong) NSMutableArray <QL_AreaDataModel *> *dataSource3;
///点击完成后传回
@property (nonatomic, strong) NSMutableDictionary *selectedDict;

///标志pickerView是否出现
@property (nonatomic, assign) BOOL isPickerViewShow;
///初始选择数据
@property(nonatomic, strong) NSArray *firstSelectDatas;

@end

@implementation QL_AreaPickerView

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
    
    MASAttachKeys(self.topBgView, self.closeButton, self.finishButton, self.pickerView);
}

///视图出现 && 刷新
-(void)showPickerView
{
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
    
    if(self.dataSource1.count <= 0){
        [self loadAraeDataForComponent:0 entityId:@""];
    }
}

// 设置选中的地方
-(void)setFirstSelectedBy:(NSArray *)select
{
    self.firstSelectDatas = select;
}

// 设置选中的地方
-(void)setFirstSelectedByAreaId:(NSString *)areaId
{
    [self.dataSource1 removeAllObjects];
    [self.dataSource2 removeAllObjects];
    [self.dataSource3 removeAllObjects];
    
    QL_AreaDataModel *modelL3 = [DATAMODEL.configDBHelper getAreaDataForId:areaId];
    if(modelL3){
        self.dataSource3 = [DATAMODEL.configDBHelper getAreaDatasForParentId:modelL3.parentId];
        QL_AreaDataModel *modelL2 = [DATAMODEL.configDBHelper getAreaDataForId:modelL3.parentId];
        if(modelL2){
            self.dataSource2 = [DATAMODEL.configDBHelper getAreaDatasForParentId:modelL2.parentId];
            QL_AreaDataModel *modelL1 = [DATAMODEL.configDBHelper getAreaDataForId:modelL2.parentId];
            if(modelL1){
                self.dataSource1 = [DATAMODEL.configDBHelper getProvinceDatas];
                
                for(NSInteger i = 0; i < self.dataSource1.count; i++){
                    QL_AreaDataModel *model = self.dataSource1[i];
                    if([model.areaId isEqualToString:modelL1.areaId]){
                        [self.pickerView selectRow:i inComponent:0 animated:YES];
                        break;
                    }
                }
                for(NSInteger i = 0; i < self.dataSource2.count; i++){
                    QL_AreaDataModel *model = self.dataSource2[i];
                    if([model.areaId isEqualToString:modelL2.areaId]){
                        [self.pickerView selectRow:i inComponent:1 animated:YES];
                        break;
                    }
                }
                for(NSInteger i = 0; i < self.dataSource3.count; i++){
                    QL_AreaDataModel *model = self.dataSource3[i];
                    if([model.areaId isEqualToString:modelL3.areaId]){
                        [self.pickerView selectRow:i inComponent:2 animated:YES];
                        break;
                    }
                }
            }else{
                [self.dataSource1 addObjectsFromArray:self.dataSource2];
                [self.dataSource2 removeAllObjects];
                [self.dataSource2 addObjectsFromArray:self.dataSource3];
                [self.dataSource3 removeAllObjects];
                
                for(NSInteger i = 0; i < self.dataSource1.count; i++){
                    QL_AreaDataModel *model = self.dataSource1[i];
                    if([model.areaId isEqualToString:modelL2.areaId]){
                        [self.pickerView selectRow:i inComponent:0 animated:YES];
                        break;
                    }
                }
                for(NSInteger i = 0; i < self.dataSource2.count; i++){
                    QL_AreaDataModel *model = self.dataSource2[i];
                    if([model.areaId isEqualToString:modelL3.areaId]){
                        [self.pickerView selectRow:i inComponent:1 animated:YES];
                        break;
                    }
                }
            }
        }
    }
    
    [self.pickerView reloadAllComponents];
}

///请求地区数据
- (void)loadAraeDataForComponent:(NSInteger)component entityId:(NSString *)entityId
{
    WEAKSelf;
    if(component == 0){
        self.dataSource1 = [DATAMODEL.configDBHelper getProvinceDatas];
        //默认选择
        QL_AreaDataModel *model = weakSelf.dataSource1.firstObject;
        if(model){
            [weakSelf.selectedDict setObject:model forKey:@"0"];
            [weakSelf loadAraeDataForComponent:component+1 entityId:model.areaId];
            [weakSelf.pickerView selectRow:0 inComponent:0 animated:YES];
        }else{
            [weakSelf.selectedDict removeObjectForKey:@"0"];
            [weakSelf loadAraeDataForComponent:component+1 entityId:@""];
        }
        
        [weakSelf.pickerView reloadAllComponents];
    }else if(component == 1){
        self.dataSource2 = [DATAMODEL.configDBHelper getAreaDatasForParentId:entityId];
        //默认选择
        QL_AreaDataModel *model = weakSelf.dataSource2.firstObject;
        if(model){
            [weakSelf.selectedDict setObject:model forKey:@"1"];
            [weakSelf loadAraeDataForComponent:component+1 entityId:model.areaId];
            [weakSelf.pickerView selectRow:0 inComponent:1 animated:YES];
        }else{
            [weakSelf.selectedDict removeObjectForKey:@"1"];
            [weakSelf loadAraeDataForComponent:component+1 entityId:@""];
        }
        
        [weakSelf.pickerView reloadAllComponents];
    }else{
        self.dataSource3 = [DATAMODEL.configDBHelper getAreaDatasForParentId:entityId];
        //默认选择
        QL_AreaDataModel *model = weakSelf.dataSource3.firstObject;
        if(model){
            [weakSelf.selectedDict setObject:model forKey:@"2"];
            [weakSelf.pickerView selectRow:0 inComponent:2 animated:YES];
        }else{
            [weakSelf.selectedDict removeObjectForKey:@"2"];
        }
        
        [weakSelf.pickerView reloadAllComponents];
    }
//    self.areaParam.userId = DATAMODEL.userInfoData.id;
//    self.areaParam.token = DATAMODEL.token;
//    
//    WEAKSelf;
//    if(component == 0){
//        self.areaParam.entityId = @"";
//        //显示加载
//        [DATAMODEL.progressManager showHudInView:self hint:@""];
//        [[Hen_MessageManager shareMessageManager] requestWithAction:area_selectArea dictionaryParam:[self.areaParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
//            //取消加载
//            [DATAMODEL.progressManager hideHud];
//            if([code isEqualToString:@"0000"]){
//                [weakSelf.dataSource1 removeAllObjects];
//                for(NSDictionary *dic in msg){
//                    [weakSelf.dataSource1 addObject:[[QL_AreaPickerModel alloc] initWithDictionary:dic]];
//                }
//                
//                //默认选择
//                QL_AreaPickerModel *model = weakSelf.dataSource1.firstObject;
//                [weakSelf.selectedDict setObject:model forKey:@"0"];
//                [weakSelf loadAraeDataForComponent:component+1 entityId:model.id];
//                [weakSelf.pickerView reloadAllComponents];
//                [weakSelf.pickerView selectRow:0 inComponent:0 animated:YES];
//            }else{
//                //提示
//                [DATAMODEL.progressManager showHint:desc];
//                [weakSelf dismissPickerView];
//            }
//        }];
//    }else if(component == 1){
//        self.areaParam.entityId = entityId;
//        //显示加载
//        [DATAMODEL.progressManager showHudInView:self hint:@""];
//        [[Hen_MessageManager shareMessageManager] requestWithAction:area_selectArea dictionaryParam:[self.areaParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
//            //取消加载
//            [DATAMODEL.progressManager hideHud];
//            if([code isEqualToString:@"0000"]){
//                [weakSelf.dataSource2 removeAllObjects];
//                for(NSDictionary *dic in msg){
//                    [weakSelf.dataSource2 addObject:[[QL_AreaPickerModel alloc] initWithDictionary:dic]];
//                }
//
//                //默认选择
//                QL_AreaPickerModel *model = weakSelf.dataSource2.firstObject;
//                [weakSelf.selectedDict setObject:model forKey:@"1"];
//                [weakSelf loadAraeDataForComponent:component+1 entityId:model.id];
//                [weakSelf.pickerView reloadAllComponents];
//                [weakSelf.pickerView selectRow:0 inComponent:1 animated:YES];
//            }else{
//                //提示
//                [DATAMODEL.progressManager showHint:desc];
//                [weakSelf dismissPickerView];
//            }
//        }];
//    }else{
//        self.areaParam.entityId = entityId;
//        //显示加载
//        [DATAMODEL.progressManager showHudInView:self hint:@""];
//        [[Hen_MessageManager shareMessageManager] requestWithAction:area_selectArea dictionaryParam:[self.areaParam toDictionary] withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
//            //取消加载
//            [DATAMODEL.progressManager hideHud];
//            if([code isEqualToString:@"0000"]){
//                [weakSelf.dataSource3 removeAllObjects];
//                for(NSDictionary *dic in msg){
//                    [weakSelf.dataSource3 addObject:[[QL_AreaPickerModel alloc] initWithDictionary:dic]];
//                }
//                
//                //默认选择
//                QL_AreaPickerModel *model = weakSelf.dataSource3.firstObject;
//                if(model){
//                    [weakSelf.selectedDict setObject:model forKey:@"2"];
//                }else{
//                    [weakSelf.selectedDict removeObjectForKey:@"2"];
//                }
//                [weakSelf.pickerView reloadAllComponents];
//                [weakSelf.pickerView selectRow:0 inComponent:2 animated:YES];
//            }else{
//                //提示
//                [DATAMODEL.progressManager showHint:desc];
//                [weakSelf dismissPickerView];
//            }
//        }];
//    }
}

/// 选中的某列
- (void)pickerViewDidSelectRow:(NSInteger)row andComponent:(NSInteger)component
{
    if(component == 0){
        QL_AreaDataModel *model = self.dataSource1[row];
        [self.selectedDict setObject:model forKey:@"0"];
        [self loadAraeDataForComponent:component+1 entityId:model.areaId];
    }else if(component == 1){
        QL_AreaDataModel *model = self.dataSource2[row];
        [self.selectedDict setObject:model forKey:@"1"];
        [self loadAraeDataForComponent:component+1 entityId:model.areaId];
    }else{
        QL_AreaDataModel *model = self.dataSource3[row];
        [self.selectedDict setObject:model forKey:@"2"];
    }
}

#pragma mark -- UIPickerViewDataSource, UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self pickerViewDidSelectRow:row andComponent:component];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return self.dataSource1.count;
    }else if(component == 1){
        return self.dataSource2.count;
    }else{
        return self.dataSource3.count;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //数据
    QL_AreaDataModel *data;
    if(component == 0){
        data = self.dataSource1[row];
    }else if(component == 1){
        data = self.dataSource2[row];
    }else{
        data = self.dataSource3[row];
    }
    NSString *showStr = data.name;
    
    return showStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    QL_AreaDataModel *model;
    if(component == 0){
        model = self.dataSource1[row];
    }else if(component == 1){
        model = self.dataSource2[row];
    }else{
        model = self.dataSource3[row];
    }
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kMainScreenWidth / 3, 30)];
    
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

- (NSMutableArray <QL_AreaDataModel *> *)dataSource1
{
    if(!_dataSource1){
        _dataSource1 = [[NSMutableArray alloc] init];
    }
    return _dataSource1;
}

- (NSMutableArray <QL_AreaDataModel *> *)dataSource2
{
    if(!_dataSource2){
        _dataSource2 = [[NSMutableArray alloc] init];
    }
    return _dataSource2;
}

- (NSMutableArray <QL_AreaDataModel *> *)dataSource3
{
    if(!_dataSource3){
        _dataSource3 = [[NSMutableArray alloc] init];
    }
    return _dataSource3;
}

///请求参数
- (QL_AreaRequestDataModel *)areaParam
{
    if(!_areaParam){
        _areaParam = [[QL_AreaRequestDataModel alloc] initWithDictionary:@{}];
    }
    return _areaParam;
}

@end
