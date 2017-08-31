//
//  QL_CustomBottomSelectView.m
//  CRM
//
//  Created by mini2 on 16/6/12.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import "Hen_CustomBottomSelectView.h"

#define Item_Height HEIGHT_TRANSFORMATION(100)

@interface Hen_CustomBottomSelectTableViewCell()

///标题
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation Hen_CustomBottomSelectTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView{
    static NSString *ID = @"Hen_CustomBottomSelectTableViewCell";
    Hen_CustomBottomSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[Hen_CustomBottomSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight{
    return Item_Height;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self initDefault];
    }
    
    return self;
}

-(void)initDefault{
    
    [self addSubview:self.titleLabel];
    WEAKSelf;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
}

#pragma mark ------------------ getter, setter

-(UILabel*)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel createLabelWithText:@"" font:kFontSize_28];
    }
    return _titleLabel;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end


@interface Hen_CustomBottomSelectView()<UITableViewDelegate, UITableViewDataSource>

///蒙层
@property(nonatomic, strong) UIView *maskView;

///显示标题蒙层
@property(nonatomic, strong) UIView *showTitleMaskView;

///选择试图
@property(nonatomic, strong) UITableView *selectTableView;

///选择名字
@property(nonatomic, strong) NSArray<NSString*> *selectNameArray;

///当前选中
@property(nonatomic, assign) NSInteger currentSelect;

///是否显示
@property(nonatomic, assign) BOOL isShow;

///类型
@property(nonatomic, assign) CustomBottomSelectViewType viewType;

@end

@implementation Hen_CustomBottomSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithNameArray:(NSArray<NSString*> *)selectNameArray{
    self = [super init];
    if(self){
        self.selectNameArray = selectNameArray;
        [self initDefault];
    }
    return self;
}

-(void)initDefault{
    
    self.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, Item_Height);
    
    [self addSubview:self.selectTableView];
    WEAKSelf;
    [self.selectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark ----------- tableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.customBottomSelectSelectBlock){
        
        self.currentSelect = indexPath.section;
        self.customBottomSelectSelectBlock(indexPath.section);
        
        [self cancel];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.selectNameArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Hen_CustomBottomSelectTableViewCell getCellHeight];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Hen_CustomBottomSelectTableViewCell *cell = [Hen_CustomBottomSelectTableViewCell cellWithTableView:tableView];
    
    NSString *title = [self.selectNameArray objectAtIndex:indexPath.section];
    cell.title = title;
    
    return cell;
}

#pragma mark ----------- private

///显示上拉
-(void)showBottomView{
    if(self.isShow){
        return;
    }
    
    self.viewType = kCustomBottomSelectViewTypeOfBottom;
    
    [self showView];
}

///显示下拉
-(void)showDropdownView{
    if(self.isShow){
        return;
    }
    
    self.viewType = kCustomBottomSelectViewTypeOfRightTop;
    
    [self showView];
}

///更新显示内容
-(void)updateShowUIForNameArray:(NSArray<NSString*> *)selectNameArray{
    
    self.selectNameArray = selectNameArray;
    
    [self.selectTableView reloadData];
}

///显示选择
-(void)showView{
    
    CGRect startRect = CGRectZero;
    CGRect showRect = CGRectZero;
    if(self.viewType == kCustomBottomSelectViewTypeOfBottom){
        //蒙层
        [UIView animateWithDuration:0.2 animations:^{
            self.maskView.alpha = 0.5;
        } completion:^(BOOL finished) {
        }];
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self.maskView];
        
        startRect = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, Item_Height * self.selectNameArray.count);
        showRect = CGRectMake(0, kMainScreenHeight - Item_Height * self.selectNameArray.count, kMainScreenWidth, Item_Height * self.selectNameArray.count);
    }else if(self.viewType == kCustomBottomSelectViewTypeOfRightTop){
        //蒙层
        self.showTitleMaskView.alpha = 1.0f;
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self.showTitleMaskView];
        
        startRect = CGRectMake(kMainScreenWidth - 160, - Item_Height * ((int)self.selectNameArray.count), 160, Item_Height * self.selectNameArray.count);
        showRect = CGRectMake(kMainScreenWidth - 160, 64, 160, Item_Height * self.selectNameArray.count);
    }
    
    
    self.frame = startRect;
    self.alpha = 0.0f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0f;
        self.frame = showRect;
        self.isShow = YES;
    } completion:^(BOOL finished) {
    }];
}

///取消
-(void)cancel{
    
    CGRect startRect = CGRectZero;
    if(self.viewType == kCustomBottomSelectViewTypeOfBottom){
        startRect = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, Item_Height * self.selectNameArray.count);
    }else if(self.viewType == kCustomBottomSelectViewTypeOfRightTop){
        
        startRect = CGRectMake(kMainScreenWidth - 160, - Item_Height * ((int)self.selectNameArray.count), 160, Item_Height * self.selectNameArray.count);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0f;
        if(self.viewType == kCustomBottomSelectViewTypeOfBottom){
            self.maskView.alpha = 0.0f;
        }else if(self.viewType == kCustomBottomSelectViewTypeOfRightTop){
            self.showTitleMaskView.alpha = 0.0f;
        }
        self.frame = startRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(self.viewType == kCustomBottomSelectViewTypeOfBottom){
            [self.maskView removeFromSuperview];
        }else if(self.viewType == kCustomBottomSelectViewTypeOfRightTop){
            [self.showTitleMaskView removeFromSuperview];
        }
        self.isShow = NO;
    }];
}

#pragma mark ----------- action

-(void)onMaskGestureRecognizer{
    [self cancel];
}

#pragma mark ----------- getter,setter

-(UITableView*)selectTableView
{
    if(!_selectTableView){
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        [_selectTableView setScrollEnabled:NO];
    }
    return _selectTableView;
}

-(UIView*)maskView
{
    if(!_maskView){
        _maskView = [UIView createViewWithFrame:[UIScreen mainScreen].bounds backgroundColor:[UIColor blackColor]];
        _maskView.userInteractionEnabled = YES;
        _maskView.alpha = 0;
        
        UITapGestureRecognizer *maskGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskGestureRecognizer)];
        [_maskView addGestureRecognizer:maskGestureRecognizer];
    }
    
    return _maskView;
}

-(UIView*)showTitleMaskView{
    if(!_showTitleMaskView){
        _showTitleMaskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *maskGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMaskGestureRecognizer)];
        [_showTitleMaskView addGestureRecognizer:maskGestureRecognizer];
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, kMainScreenWidth, kMainScreenHeight)];
        maskImageView.image = [UIImage imageNamed:@"public_translucent_background"];
        [_showTitleMaskView addSubview:maskImageView];
    }
    
    return _showTitleMaskView;
}

@end
