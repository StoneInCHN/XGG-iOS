//
//  GC_LoginIconTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  登录图标 -- cell
//

#import "GC_LoginIconTableViewCell.h"

@interface GC_LoginIconTableViewCell ()

///IconImageView
@property (nonatomic, weak) UIImageView *iconImageView;

@end

@implementation GC_LoginIconTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_LoginIconTableViewCell";
    GC_LoginIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_LoginIconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return FITHEIGHT(300/2);
}

- (void)dealloc
{
    
}

///初始化
-(void)initDefault
{
    [self unShowClickEffect];
    self.backgroundColor = [UIColor clearColor];
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(FITSCALE(144/2));
        make.height.mas_equalTo(FITSCALE(147/2));
    }];
}

//设置图片 是否隐藏
-(void)setImageForName:(NSString *)image andHidden:(BOOL)hidden;
{
    self.iconImageView.hidden = hidden;
    [self.iconImageView setImageForName:image];
}

#pragma mark -- getter,setter
///Icon ImageView
- (UIImageView *)iconImageView
{
    if(!_iconImageView){
        UIImageView *icon = [UIImageView createImageViewWithName:@"login_logo"];
        [self.contentView addSubview:_iconImageView = icon];
    }
    return _iconImageView;
}
@end
