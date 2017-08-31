//
//  QL_InditorView.m
//  safety
//
//  Created by mini3 on 16/1/25.
//  Copyright © 2016年 mini1. All rights reserved.
//

#import "QL_InditorView.h"

@implementation QL_InditorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.inditorLable];
    self.backgroundColor = kCommonBackgroudColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    
}

-(void)dealloc
{
    [self.inditorLable removeFromSuperview];
    [self setInditorLable:nil];
}

#pragma mark
#pragma mark -- getter
- (UILabel *)inditorLable {
    if (!_inditorLable) {
        _inditorLable = [[UILabel alloc] initWithFrame:self.bounds];
        _inditorLable.center = self.center;
        _inditorLable.textAlignment = NSTextAlignmentCenter;
        _inditorLable.textColor = kFontColorRed;
    }
    return _inditorLable;
}


@end
