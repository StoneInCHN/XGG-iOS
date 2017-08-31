//
//  QL_NothingNoticeView.m
//  Ask
//
//  Created by mini2 on 16/12/20.
//  Copyright © 2016年 Ask. All rights reserved.
//

#import "QL_NothingNoticeView.h"

@interface QL_NothingNoticeView()

///图标
@property(nonatomic, weak) UIImageView *iconImageView;
///提示
@property(nonatomic, weak) UILabel *noticeLabel;

@end

@implementation QL_NothingNoticeView

///初始化
-(id)initWithIsHaveSomething:(BOOL)isHave
{
    self = [super init];
    if(self){
        if(isHave){
            [self initDefaultHaveSomething];
        }else{
            [self initDefault];
        }
    }
    return self;
}

///初始有
-(void)initDefaultHaveSomething
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, CGFLOAT_MIN);
}

///初始
-(void)initDefault
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, HEIGHT_TRANSFORMATION(430));
    self.backgroundColor = [UIColor clearColor];
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
-(void)loadSubViewAndConstraints
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(HEIGHT_TRANSFORMATION(90));
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(HEIGHT_TRANSFORMATION(60));
    }];
}

///设置图标
- (void)setIconImageViewForImageName:(NSString *)imageName
{
    [self.iconImageView setImageForName:imageName];
}

#pragma mark -- getter,setter

-(UIImageView*)iconImageView
{
    if(!_iconImageView){
        UIImageView *imageView = [UIImageView createImageViewWithName:@"public_abnormal1"];
        [self addSubview:_iconImageView = imageView];
    }
    return _iconImageView;
}

-(UILabel*)noticeLabel
{
    if(!_noticeLabel){
        UILabel *label = [UILabel createLabelWithText:@"什么都木有啊" font:kFontSize_28];
        [self addSubview:_noticeLabel = label];
    }
    return _noticeLabel;
}

@end
