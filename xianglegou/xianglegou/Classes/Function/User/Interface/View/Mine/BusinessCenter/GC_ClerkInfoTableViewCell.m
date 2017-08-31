//
//  GC_ClerkInfoTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/7/8.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_ClerkInfoTableViewCell.h"

@interface GC_ClerkInfoTableViewCell ()
///头像
@property (nonatomic, weak) UIImageView *headImageView;
///昵称
@property (nonatomic, weak) UILabel *nameLabel;
///手机号
@property (nonatomic, weak) UILabel *mobileLabe;

@end

@implementation GC_ClerkInfoTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_ClerkInfoTableViewCell";
    GC_ClerkInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_ClerkInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(110);
}


///初始化
-(void)initDefault
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(36));
        make.width.mas_equalTo(FITSCALE(82/2));
        make.height.mas_equalTo(FITSCALE(82/2));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(40));
        make.left.equalTo(self.headImageView.mas_right).offset(WIDTH_TRANSFORMATION(15));
        make.right.equalTo(self.contentView).offset(WIDTH_TRANSFORMATION(-270));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-40));
    }];
    
    
    [self.mobileLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView).offset(OffSetToRight);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

///更新 ui
- (void)updateUiForSalesmanInfoData:(GC_SalesmanInfoDataModel *)data
{
    if(data){
        [self.headImageView sd_setImageWithUrlString:data.userPhoto defaultImageName:@"mine_moren"];
        
        self.nameLabel.text = data.nickName;
        self.mobileLabe.text = data.cellPhoneNum;
    }
}



#pragma mark -- getter,setter

///头像
- (UIImageView *)headImageView
{
    if(!_headImageView){
        UIImageView *imageView = [UIImageView createImageViewWithName:@""];
        [imageView makeRadiusForWidth:FITSCALE(82/2)];
        [self.contentView addSubview:_headImageView = imageView];
    }
    return _headImageView;
}
///昵称
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_nameLabel = label];
    }
    return _nameLabel;
}


///手机
- (UILabel *)mobileLabe
{
    if(!_mobileLabe){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.contentView addSubview:_mobileLabe = label];
    }
    return _mobileLabe;
}



@end
