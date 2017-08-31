//
//  GC_BusinessNumTableViewCell.m
//  xianglegou
//
//  Created by mini3 on 2017/7/3.
//  Copyright © 2017年 xianglegou. All rights reserved.
//

#import "GC_BusinessNumTableViewCell.h"

@interface GC_BusinessNumTableViewCell ()
///图
@property (nonatomic, weak) UIImageView *pngNumImageView;
///类型
@property (nonatomic, weak) UILabel *titleLabel;
///个数
@property (nonatomic, weak) UILabel *numLabel;

///说明
@property (nonatomic, weak) UILabel *descLabel;
@end

@implementation GC_BusinessNumTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_BusinessNumTableViewCell";
    GC_BusinessNumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[GC_BusinessNumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return HEIGHT_TRANSFORMATION(435);
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
    [self.pngNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(300));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(300));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(30));
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-90));
        
    }];
    
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pngNumImageView);
        make.top.equalTo(self.pngNumImageView).offset(HEIGHT_TRANSFORMATION(150));
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(8));
        make.centerX.equalTo(self.pngNumImageView);
    }];
    
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(OffSetToLeft);
        make.bottom.equalTo(self.contentView).offset(HEIGHT_TRANSFORMATION(-3));
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
- (void)updateUiForBusinessCount:(NSString *)count andType:(NSInteger)type
{
    
    self.numLabel.text = count;
    if(type == 1){
        self.titleLabel.text = @"商家总数";
    }else if(type == 2){
        self.titleLabel.text = @"会员总数";
    }else if(type == 3){
        self.titleLabel.text = @"业务员总数";
    }
}

///地区ID
- (void)updateUiForAreaInfo:(NSString *)areaId
{
    if(areaId.length > 0){
        QL_AreaDataModel *model = [DATAMODEL.configDBHelper getAreaDataForId:areaId];
        self.descLabel.hidden = NO;
        self.descLabel.text = [NSString stringWithFormat:@"%@商家分布",model.name];
    }
}


#pragma mark -- getter,setter
///图
- (UIImageView *)pngNumImageView
{
    if(!_pngNumImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_number"];
        [self.contentView addSubview:_pngNumImageView = image];
    }
    return _pngNumImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *label = [UILabel createLabelWithText:@"总数" font:kFontSize_28 textColor:kFontColorWhite];
        [self.contentView addSubview:_titleLabel = label];
    }
    return _titleLabel;
}

///个数
- (UILabel *)numLabel
{
    if(!_numLabel){
        UILabel *label = [UILabel createLabelWithText:@"0" font:kFontSize_36 textColor:kFontColorWhite];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_numLabel = label];
    }
    return _numLabel;
}


///说明
- (UILabel *)descLabel
{
    if(!_descLabel){
        UILabel *label = [UILabel createLabelWithText:@"分布" font:kFontSize_28 textColor:kFontColorRed];
        label.hidden = YES;
        [self.contentView addSubview:_descLabel = label];
    }
    return _descLabel;
}
@end

