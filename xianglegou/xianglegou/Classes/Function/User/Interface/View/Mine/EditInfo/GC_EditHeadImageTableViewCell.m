//
//  GC_EditHeadImageTableViewCell.m
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "GC_EditHeadImageTableViewCell.h"


@implementation GC_UserPhotoDataModel

@end

@interface GC_EditHeadImageTableViewCell ()
///头像ImageView
@property (nonatomic, weak) UIImageView *headerImageView;
///标题
@property (nonatomic, weak) UILabel *titleLabel;

///Next
@property (nonatomic, weak) UIImageView *nextImageView;

///进度条
////@property (nonatomic, strong) UIProgressView *progressView;
///蒙层
/////@property(nonatomic, strong) UIView *markImage;

@end

@implementation GC_EditHeadImageTableViewCell

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"GC_EditHeadImageTableViewCell";
    GC_EditHeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[GC_EditHeadImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

///获取cell高度
+(CGFloat)getCellHeight
{
    return FITSCALE(220/2);
}

///初始化
-(void)initDefault
{
    
}

///加载子视图约束
-(void)loadSubviewConstraints
{
    
    //////[self.contentView addSubview:self.progressView];
    //////[self.contentView addSubview:self.markImage];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(OffSetToLeft);
    }];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(WIDTH_TRANSFORMATION(-70));
        make.width.mas_equalTo(FITSCALE(160/2));
        make.height.mas_equalTo(FITSCALE(160/2));
    }];
    
    
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headerImageView.mas_left).with.offset(WIDTH_TRANSFORMATION(10));
//        make.right.equalTo(self.headerImageView.mas_right).with.offset(WIDTH_TRANSFORMATION(-10));
//        make.height.equalTo(@(HEIGHT_TRANSFORMATION(8)));
//        make.center.equalTo(self.headerImageView);
//    }];
//    [self.markImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headerImageView);
//        make.right.equalTo(self.headerImageView);
//        make.top.equalTo(self.headerImageView);
//        make.bottom.equalTo(self.headerImageView);
//        make.center.equalTo(self.headerImageView);
//        make.width.mas_equalTo(FITSCALE(208/2));
//        make.height.mas_equalTo(FITSCALE(208/2));
//    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -- private
///更新头像
-(void)updateForData:(GC_UserPhotoDataModel*)data
{
    if(!data){
        return;
    }
    
    //加载
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.hidesWhenStopped = YES;
    [self addSubview:indicatorView];
    [indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headerImageView);
    }];
    
    /////self.progressView.hidden = YES;
    
    if(data.statue == 1){           //正在上传
        //////self.progressView.hidden = NO;
        [indicatorView startAnimating];
        //////self.progressView.progress = data.current / data.tatole;
        [self.headerImageView setImage:data.image];
    }else if(data.statue == 2){     //上传成功
        [self.headerImageView setImage:data.image];
        ///////self.progressView.hidden = YES;
        [indicatorView stopAnimating];
    }else if(data.statue == 3){     //已上传
        [self.headerImageView sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@",PngBaseUrl,data.image] defaultImageName:@"mine_moren"];
    }
}


///头像 信息
- (UIImageView *)headerImageView
{
    if(!_headerImageView){
        UIImageView *bgImage = [UIImageView createImageViewWithName:@"mine_head_bgred"];
        [bgImage makeRadiusForWidth:FITSCALE(208/2)];
        [self addSubview:bgImage];
        
        UIImageView *headerImage = [UIImageView createImageViewWithName:@"mine_moren"];
        [headerImage makeRadiusForWidth:FITSCALE(160/2)];
        [self addSubview:_headerImageView = headerImage];
        
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerImage);
            make.width.mas_equalTo(FITSCALE(208/2));
            make.height.mas_equalTo(FITSCALE(208/2));
        }];
    }
    return _headerImageView;
}


///标题
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        UILabel *titleLabel = [UILabel createLabelWithText:HenLocalizedString(@"头像") font:kFontSize_28];
        [self.contentView addSubview:_titleLabel = titleLabel];
    }
    return _titleLabel;
}

///NextImageVIew
- (UIImageView *)nextImageView
{
    if(!_nextImageView){
        UIImageView *nextImage = [UIImageView createImageViewWithName:@"public_next"];
        [self.contentView addSubview:_nextImageView = nextImage];
    }
    return _nextImageView;
}

//-(UIProgressView*)progressView
//{
//    if(!_progressView){
//        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
//        //设置进度条颜色
//        _progressView.trackTintColor = kFontColorGray;
//        //设置进度条上进度的颜色
//        _progressView.progressTintColor = kFontColorBlue;
//        _progressView.hidden = YES;
//    }
//    return _progressView;
//}

//-(UIView*)markImage
//{
//    if(!_markImage){
//        _markImage = [UIView createViewWithBackgroundColor:kFontColorGray];
//        [_markImage makeRadiusForWidth:FITSCALE(208/2)];
//        _markImage.alpha = 0.5f;
//        
//        _markImage.hidden = YES;
//    }
//    return _markImage;
//}
@end
