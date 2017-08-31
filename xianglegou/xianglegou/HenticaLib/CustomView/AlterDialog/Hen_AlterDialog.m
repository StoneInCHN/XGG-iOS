//
//  QLAlterDialog.m
//  MedicalMember
//
//  Created by mini2 on 16/3/2.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import "Hen_AlterDialog.h"
#import "define.h"

@interface Hen_AlterDialog()

@property (nonatomic, strong) UIImageView *maskImageView;  /**< 萌层 */

///背景图
@property(nonatomic, strong) UIView *bgView;

///标题
@property(nonatomic, strong) UILabel *titleLabel;

///内容
@property(nonatomic, strong) UILabel *contentLabel;

///按钮
@property(nonatomic, strong) NSMutableArray *buttons;

///关闭按钮
@property(nonatomic, strong) UIButton *closeButton;

@end


@implementation Hen_AlterDialog

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

#pragma mark - view init
//初始化按钮
-(void)defaultInit{
    
    self.frame = [UIScreen mainScreen].bounds;
    
    //背景
    self.bgView = [UIImageView createImageViewWithName:@"public_remind_frame"];
    self.bgView.tag = Base_Tag+1;
    [self addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(WIDTH_TRANSFORMATION(50));
        make.right.equalTo(self.mas_right).with.offset(WIDTH_TRANSFORMATION(-50));
        make.center.equalTo(self);
        make.height.equalTo(@(HEIGHT_TRANSFORMATION(430)));
    }];
    
    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = kFontColorRed;
    self.titleLabel.font = kFontSize_28;
    //文字居中显示
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //默认值
    self.titleLabel.text = @"提示";
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).with.offset(WIDTH_TRANSFORMATION(34));
        make.top.equalTo(self.bgView.mas_top);
        make.height.equalTo(@(HEIGHT_TRANSFORMATION(100)));
    }];

    [[self lineImageView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
    }];
    
    //信息
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = kFontColorBlack;
    self.contentLabel.font = kFontSize_28;
    //文字居中显示
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    //自动折行设置
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bgView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(WIDTH_TRANSFORMATION(40));
        make.right.equalTo(self.bgView.mas_right).with.offset(WIDTH_TRANSFORMATION(-40));
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(HEIGHT_TRANSFORMATION(40));
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.bgView);
        make.width.equalTo(@(WIDTH_TRANSFORMATION(120)));
        make.height.equalTo(@(HEIGHT_TRANSFORMATION(90)));
    }];
}

///设置按钮
-(void)setButtonTitles:(NSArray*)titles{
    
    //清除按钮
    for(UIButton *button in self.buttons){
        [button removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    
    if(titles.count == 1){//一个按钮
        
        UIButton *firstButton = [UIButton createButtonWithTitle:[titles objectAtIndex:0] backgroundNormalImage:@"public_botton_remind_botton_ok" backgroundPressImage:@"public_botton_remind_botton_ok_press" target:self action:@selector(onButtonClick:)];
        firstButton.tag = Base_Tag+2;
        [firstButton setTitleColor:kFontColorRed forState:UIControlStateNormal];
        firstButton.titleLabel.font = kFontSize_28;
        [firstButton setTag:0];
        [self addSubview:firstButton];
        
        [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.bgView.mas_bottom).with.offset(HEIGHT_TRANSFORMATION(-40));
        }];
        
        [self.buttons addObject:firstButton];
    }else if(titles.count == 2){//两个按钮
        UIButton *firstButton = [UIButton createButtonWithTitle:[titles objectAtIndex:0] backgroundNormalImage:@"public_botton_remind_botton_ok" backgroundPressImage:@"public_botton_remind_botton_ok_press"target:self action:@selector(onButtonClick:)];
        firstButton.tag = Base_Tag+3;
        [firstButton setTitleColor:kFontColorRed forState:UIControlStateNormal];
        firstButton.titleLabel.font = kFontSize_28;
        [firstButton setTag:0];
        [self addSubview:firstButton];
        
        [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).with.offset(WIDTH_TRANSFORMATION(40));
            make.bottom.equalTo(self.bgView.mas_bottom).with.offset(HEIGHT_TRANSFORMATION(-40));
            make.right.equalTo(self.mas_centerX).with.offset(WIDTH_TRANSFORMATION(-20));
        }];
        
        [self.buttons addObject:firstButton];
        
        UIButton *secondButton = [UIButton createButtonWithTitle:[titles objectAtIndex:1] backgroundNormalImage:@"public_botton_remind_botton_cancel" backgroundPressImage:@"public_botton_remind_botton_cancel_press"target:self action:@selector(onButtonClick:)];
        secondButton.tag = Base_Tag+4;
        [secondButton setTitleColor:kFontColorWhite forState:UIControlStateNormal];
        secondButton.titleLabel.font = kFontSize_28;
        [secondButton setTag:1];
        [self addSubview:secondButton];
        
        [secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).with.offset(WIDTH_TRANSFORMATION(-40));
            make.bottom.equalTo(self.bgView.mas_bottom).with.offset(HEIGHT_TRANSFORMATION(-40));
            make.left.equalTo(self.mas_centerX).with.offset(WIDTH_TRANSFORMATION(20));
        }];
        
        [self.buttons addObject:secondButton];
    }
}

///设置内容
-(void)setContentString:(NSString*)content{
    if(self.contentLabel){
        self.contentLabel.text = content;
    }
}

///设置按钮点击回调
-(void)setButtonClickBlock:(QLAlterDialogButtonClickBlock)block{
    self.clickBlock = block;
}

///按钮点击事件
-(void)onButtonClick:(UIButton*)sender{
    if(self.clickBlock){
        self.clickBlock(sender.tag);
    }
    [self cancel];
}

- (void)onCloseAction:(UIButton *)sender
{
    [self cancel];
}

///显示
-(void)show{
    
    self.maskImageView.alpha = 0.5f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.maskImageView];
    
    self.alpha = 0.0f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

///取消
-(void)cancel{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0f;
        self.maskImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskImageView removeFromSuperview];
    }];
}

#pragma mark ------------------- 属性

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskImageView.image = [UIImage imageNamed:@"public_mongolia_layer"];
        _maskImageView.backgroundColor = [UIColor blackColor];
        _maskImageView.alpha = 0;
        _maskImageView.userInteractionEnabled = YES;
    }
    return _maskImageView;
}

-(NSMutableArray*)buttons{
    if(!_buttons){
        _buttons = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _buttons;
}

-(UIButton*)closeButton
{
    if(!_closeButton){
        _closeButton = [UIButton createButtonWithTitle:@"" normalImage:@"public_remind_close" pressImage:@"public_remind_close" target:self action:@selector(onCloseAction:)];
        _closeButton.tag = 1;
    }
    return _closeButton;
}

-(UIImageView*)lineImageView
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self addSubview:image];
    
    return image;
}

@end
