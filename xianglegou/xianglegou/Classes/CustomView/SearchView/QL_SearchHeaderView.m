//
//  QL_SearchHeaderView.m
//  safety
//
//  Created by mini3 on 16/1/21.
//  Copyright © 2016年 mini. All rights reserved.
//

#import "QL_SearchHeaderView.h"

@interface QL_SearchHeaderView()

///标题
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation QL_SearchHeaderView

-(id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initDefault];
    }
    return self;
}

-(void)dealloc
{
    [self.titleLabel removeFromSuperview];
    [self setTitleLabel:nil];
}

-(void)initDefault
{
    self.backgroundColor = kCommonBackgroudColor;
    
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(OffSetToLeft);
    }];
    [[self lineImage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.top.equalTo(self);
    }];
}


#pragma mark --------------- getter, setter

-(UILabel*)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel createLabelWithText:@"" font:kFontSize_28 textColor:kFontColorRed];
    }
    return _titleLabel;
}

-(UIImageView*)lineImage
{
    UIImageView *image = [UIImageView createImageViewWithName:@"public_line"];
    [self addSubview:image];

    return image;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

@end
