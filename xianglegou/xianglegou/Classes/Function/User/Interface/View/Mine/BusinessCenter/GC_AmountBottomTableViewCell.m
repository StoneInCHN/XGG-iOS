//
//  GC_AmountBottomTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_AmountBottomTableViewCell.h"

@interface GC_AmountBottomTableViewCell ()

///背景图
@property (nonatomic, weak) UIImageView *bgImage;
@end



@implementation GC_AmountBottomTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_AmountBottomTableViewCell";
    GC_AmountBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_AmountBottomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(43);
}

///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = kCommonBackgroudColor;
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(30));
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-30));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(43));
        make.bottom.equalTo(self.contentView);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIImageView *)bgImage
{
    if(!_bgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_page2"];
        [self.contentView addSubview:_bgImage = image];
    }
    return _bgImage;
}
@end
