//
//  QL_ListSelectView.m
//  Rebate
//
//  Created by mini2 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_ListSelectView.h"

@implementation QL_ListSelectViewData

@end

@interface QL_ListSelectViewTableViewCell()

///标题
@property(nonatomic, weak) UILabel *titleLabel;
///选中icon
@property(nonatomic, weak) UIImageView *selectIcon;

@end

@implementation QL_ListSelectViewTableViewCell

///创建
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"QL_ListSelectViewTableViewCell";
    QL_ListSelectViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[QL_ListSelectViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+ (CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(88);
}

///初始化
- (void)initDefault
{
    self.bottomLongLineImage.hidden = NO;
}

///加载子视图约束
- (void)loadSubviewConstraints
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(OffSetToLeft);
    }];
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
}

#pragma mark -- getter,setter

///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///选中icon
- (UIImageView *)selectIcon
{
    if(!_selectIcon){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_remind_select_choose1"];
        image.hidden = YES;
        [self.contentView addSubview:_selectIcon = image];
    }
    return _selectIcon;
}

- (void)setContent:(NSString *)content
{
    self.titleLabel.text = content;
}

- (void)setIsSelect:(BOOL)isSelect
{
    if(isSelect){
        self.titleLabel.textColor = kFontColorRed;
        self.selectIcon.hidden = NO;
    }else{
        self.titleLabel.textColor = kFontColorBlack;
        self.selectIcon.hidden = YES;
    }
}

@end


@interface QL_ListSelectView()<UITableViewDelegate, UITableViewDataSource>

///蒙层
@property (nonatomic, weak) UIView *maskImageView;

///内容
@property(nonatomic, weak) UITableView *tableView;

///数据
@property(nonatomic, strong) NSMutableArray<QL_ListSelectViewData *> *datas;
///选择id
@property(nonatomic, strong) NSString *selectId;

@end

@implementation QL_ListSelectView

///初始化 级数
-(id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

///初始
-(void)initDefault
{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, HEIGHT_TRANSFORMATION(70), kMainScreenWidth, kMainScreenHeight);
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
-(void)loadSubViewAndConstraints
{
    [self maskImageView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(88) * 8);
    }];
}

///更新数据
-(void)updateDatas:(NSMutableArray<QL_ListSelectViewData*> *)datas
{
    self.datas = datas;
    
    if(datas.count < 8){
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(88) * datas.count);
        }];
    }else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(88) * 8);
        }];
    }
}

///显示
- (void)showViewForSelectId:(NSString *)selectId;
{
    NSArray *array = [selectId componentsSeparatedByString:@","];
    if(array.count == 2){
        self.selectId = array.lastObject;
    }else{
        self.selectId = array.firstObject;
    }
    self.hidden = NO;
    
    [self.tableView reloadData];
}

#pragma mark -- event response

-(void)tapGestureHandler:(id)sender
{
    self.hidden = YES;
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QL_ListSelectViewData *model = self.datas[indexPath.row];
    self.selectId = model.id;
    [self.tableView reloadData];
    
    if(self.onSelectBlock){
        self.onSelectBlock(model);
    }
    
    //延迟0.2s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [QL_ListSelectViewTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QL_ListSelectViewTableViewCell *cell = [QL_ListSelectViewTableViewCell cellWithTableView:tableView];
    
    QL_ListSelectViewData *model = self.datas[indexPath.row];
    cell.content = model.name;
    if([model.id isEqualToString:self.selectId]){
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    
    return cell;
}

#pragma mark -- getter,setter

///内容
-(UITableView*)tableView
{
    if(!_tableView){
        UITableView *tableView = [UITableView createTableViewWithDelegateTarget:self];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kCommonWhiteBg;
        [self addSubview:_tableView = tableView];
    }
    return _tableView;
}

- (UIView *)maskImageView
{
    if (!_maskImageView) {
        UIView *maskImageView = [UIView createViewWithFrame:[UIScreen mainScreen].bounds backgroundColor:[UIColor blackColor]];
        maskImageView.userInteractionEnabled = YES;
        maskImageView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [maskImageView addGestureRecognizer:tap];
        [self addSubview:_maskImageView = maskImageView];
    }
    return _maskImageView;
}

@end


@interface QL_ListScreenSelectView()

///背景
@property(nonatomic, weak) UIView *bgView;
///标题
@property(nonatomic, weak) UILabel *titleLabel;
///wifi
@property(nonatomic, weak) UIButton *wifiButton;
///免费停车
@property(nonatomic, weak) UIButton *freeStopButton;
///重置
@property(nonatomic, weak) UIButton *resetButton;
///完成按钮
@property(nonatomic, weak) UIButton *finishButton;
///蒙层
@property (nonatomic, weak) UIView *maskImageView;

@end

@implementation QL_ListScreenSelectView

- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

#pragma mark -- private

///初始
- (void)initDefault
{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, HEIGHT_TRANSFORMATION(70), kMainScreenWidth, kMainScreenHeight);
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    [self maskImageView];
    [self bgView];
}

///显示
- (void)showViewForSelectId:(NSString *)selectId
{
    [self.wifiButton setSelected:NO];
    [self.freeStopButton setSelected:NO];
    if([selectId isEqualToString:@"ALL"]){
        [self.wifiButton setSelected:YES];
        [self.freeStopButton setSelected:YES];
    }else if([selectId isEqualToString:@"WIFI"]){
        [self.wifiButton setSelected:YES];
    }else if([selectId isEqualToString:@"FREE_PARKING"]){
        [self.freeStopButton setSelected:YES];
    }
    
    self.hidden = NO;
}

#pragma mark -- event response

-(void)tapGestureHandler:(id)sender
{
    self.hidden = YES;
}

- (void)onButtonAction:(UIButton *)sender
{
    if(sender.tag == 1){ // wifi
        if(sender.isSelected){
            [sender setSelected:NO];
        }else{
            [sender setSelected:YES];
        }
    }else if(sender.tag == 2){ // 免费停车
        if(sender.isSelected){
            [sender setSelected:NO];
        }else{
            [sender setSelected:YES];
        }
    }else if(sender.tag == 3){ // 重置
        [self.wifiButton setSelected:NO];
        [self.freeStopButton setSelected:NO];
    }else if(sender.tag == 4){ // 完成
        if(self.onSelectBlock){
            if(self.wifiButton.isSelected && self.freeStopButton.isSelected){
                self.onSelectBlock(@"ALL");
            }else if(!self.wifiButton.isSelected && !self.freeStopButton.isSelected){
                self.onSelectBlock(@"");
            }else if(self.wifiButton.isSelected){
                self.onSelectBlock(@"WIFI");
            }else if(self.freeStopButton.isSelected){
                self.onSelectBlock(@"FREE_PARKING");
            }
        }
        self.hidden = YES;
    }
}

#pragma mark -- getter,setter

///背景
- (UIView *)bgView
{
    if(!_bgView){
        UIView *view = [UIView createViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(268)) backgroundColor:kCommonWhiteBg];
        [self addSubview:_bgView = view];
        
        UILabel *titleLabel = [UILabel createLabelWithText:@"特色服务" font:kFontSize_28 textColor:kFontColorRed];
        [view addSubview:_titleLabel = titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(HEIGHT_TRANSFORMATION(14));
            make.left.equalTo(view).offset(OffSetToLeft);
        }];
        UIButton *wifiButton = [UIButton createButtonWithTitle:@"wifi" backgroundNormalImage:@"homepage_city" backgroundPressImage:@"homepage_city_choose" target:self action:@selector(onButtonAction:)];
        wifiButton.tag = 1;
        [wifiButton setTitleColor:kFontColorRed forState:UIControlStateSelected];
        [view addSubview:_wifiButton = wifiButton];
        [wifiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(WIDTH_TRANSFORMATION(80));
            make.top.equalTo(view).offset(HEIGHT_TRANSFORMATION(66));
        }];
        UIButton *freeStopButton = [UIButton createButtonWithTitle:@"免费停车" backgroundNormalImage:@"homepage_city" backgroundPressImage:@"homepage_city_choose" target:self action:@selector(onButtonAction:)];
        freeStopButton.tag = 2;
        [freeStopButton setTitleColor:kFontColorRed forState:UIControlStateSelected];
        [view addSubview:_freeStopButton = freeStopButton];
        [freeStopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wifiButton.mas_right).offset(WIDTH_TRANSFORMATION(48));
            make.centerY.equalTo(wifiButton);
        }];
        UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
        [view addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(view);
            make.centerX.equalTo(view);
            make.bottom.equalTo(view).offset(HEIGHT_TRANSFORMATION(-90));
        }];
        UIButton *resetButton = [UIButton createNoBgButtonWithTitle:@"重置" target:self action:@selector(onButtonAction:)];
        resetButton.tag = 3;
        [view addSubview:_resetButton = resetButton];
        [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.bottom.equalTo(view);
            make.width.mas_equalTo(WIDTH_TRANSFORMATION(140));
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(90));
        }];
        UIButton *finishButton = [UIButton createNoBgButtonWithTitle:@"完成" target:self action:@selector(onButtonAction:)];
        finishButton.tag = 4;
        [finishButton setTitleClor:kFontColorRed];
        [view addSubview:_finishButton = finishButton];
        [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view);
            make.bottom.equalTo(view);
            make.width.mas_equalTo(WIDTH_TRANSFORMATION(140));
            make.height.mas_equalTo(HEIGHT_TRANSFORMATION(90));
        }];
    }
    return _bgView;
}

- (UIView *)maskImageView
{
    if (!_maskImageView) {
        UIView *maskImageView = [UIView createViewWithFrame:[UIScreen mainScreen].bounds backgroundColor:[UIColor blackColor]];
        maskImageView.userInteractionEnabled = YES;
        maskImageView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [maskImageView addGestureRecognizer:tap];
        [self addSubview:_maskImageView = maskImageView];
    }
    return _maskImageView;
}


@end
