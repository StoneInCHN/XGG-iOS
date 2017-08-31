//
//  QL_BusinessInfoView.m
//  Rebate
//
//  Created by mini2 on 17/3/21.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_BusinessInfoView.h"
#import "QL_CustomSegmentView.h"
#import "QL_HPBannerView.h"

@interface QL_BusinessInfoView()<QL_CustomSegmentDelegate>

///图片
@property(nonatomic, weak) QL_HPBannerView *pngView;
///选择
@property(nonatomic, weak) QL_CustomSegmentView *segmentView;

///信息view
@property(nonatomic, weak) UIView *infoView;
///标示
@property(nonatomic, weak) UILabel *markLabel;
///标示 图标
@property(nonatomic, weak) UIView *markbgImage;
///支持乐豆抵扣
@property (nonatomic, weak) UIImageView *leBeandikouImageView;
///名称
@property(nonatomic, weak) UILabel *nameLabel;
///评分
@property(nonatomic, weak) UILabel *commentScoreLabel;
///消费
@property(nonatomic, weak) UILabel *consumptionLabel;
///消费提示
@property(nonatomic, weak) UILabel *consumptionInfoLabel;

///地址view
@property(nonatomic, weak) UIView *addressView;
///地址
@property(nonatomic, weak) UILabel *addressLabel;
///距离
@property(nonatomic, weak) UILabel *distanceLabel;
///电话
@property(nonatomic, weak) UIButton *phoneButton;
///电话提示
@property(nonatomic, weak) UILabel *phoneLabel;

///电话
@property(nonatomic, strong) NSString *storePhone;
///图片数据
@property(nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation QL_BusinessInfoView

- (id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

#pragma mark -- override

//hitTest的作用:当在一个view上添加一个屏蔽罩，但又不影响对下面   view的操作，也就是可以透过屏蔽罩对下面的view进行操作，这个函数就很好用了。hitTest的用法：将下面的函数添加到UIView的子类中，也就是屏蔽罩类中即可。
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    if([result isKindOfClass:[UIImageView class]] || [result isKindOfClass:[UIButton class]] || [result isKindOfClass:[UILabel class]]){
        return result;
    }
    return nil;
}

#pragma mark -- private

///初始
- (void)initDefault
{
    self.frame = CGRectMake(0, 0, kMainScreenWidth, BI_ViewHeight);
    self.backgroundColor = kCommonBackgroudColor;
    
    [self loadSubViewAndConstraints];
}

///加载子视图及约束
- (void)loadSubViewAndConstraints
{
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.pngView.mas_bottom);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(140));
    }];
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(50));
        make.top.equalTo(self.infoView).offset(HEIGHT_TRANSFORMATION(28));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(90));
    }];
    
    [self.leBeandikouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.markLabel.mas_right).offset(WIDTH_TRANSFORMATION(22));
        make.centerY.equalTo(self.markbgImage);
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(39));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(39));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(190));
        
        make.left.equalTo(self.leBeandikouImageView.mas_right).offset(WIDTH_TRANSFORMATION(8));
        make.right.equalTo(self).offset(OffSetToRight);
        make.centerY.equalTo(self.markLabel);
    }];
    [self.consumptionInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.bottom.equalTo(self.infoView).offset(HEIGHT_TRANSFORMATION(-22));
    }];
    [self.commentScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.consumptionInfoLabel);
        make.right.equalTo(self).offset(OffSetToRight);
    }];
    [self.consumptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.consumptionInfoLabel);
        make.right.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-210));
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.centerX.equalTo(self);
        make.top.equalTo(self.infoView.mas_bottom).offset(HEIGHT_TRANSFORMATION(10));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(120));
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(WIDTH_TRANSFORMATION(50));
        make.top.equalTo(self.addressView).offset(HEIGHT_TRANSFORMATION(18));
        make.right.equalTo(self).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-180));
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(OffSetToLeft);
        make.bottom.equalTo(self.addressView).offset(HEIGHT_TRANSFORMATION(-10));
    }];
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.addressView);
        make.height.equalTo(self.addressView);
        make.width.mas_equalTo(FITWITH(168/2));
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.phoneButton);
        make.bottom.equalTo(self.addressView).offset(HEIGHT_TRANSFORMATION(-10));
    }];
    
    [self segmentView];
    
    [self pngView];
}

///更新ui
- (void)updateUIForData:(QL_BussinessDetialsDataModel *)data
{
    if(data){
        self.markLabel.text = data.sellerCategory.categoryName;
        
        CGFloat markWidth = [[Hen_Util getInstance] calculateWidthForString:data.sellerCategory.categoryName andTextHeight:HEIGHT_TRANSFORMATION(24) anFont:kFontSize_22];
        [self.markLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(markWidth + WIDTH_TRANSFORMATION(10));
        }];
        
        
        self.nameLabel.text = data.name;
        self.commentScoreLabel.text = [NSString stringWithFormat:@"总分%@分",data.rateScore.length > 0 ? [DATAMODEL.henUtil string:data.rateScore showDotNumber:1] : @"0.0"];
        self.consumptionLabel.text = [NSString stringWithFormat:@"人均%@元", data.avgPrice.length > 0 ? data.avgPrice : @"1"];
        self.addressLabel.text = data.address.length > 0 ? data.address : @" ";
        self.consumptionInfoLabel.text = [NSString stringWithFormat:@"消费%@赠送%@积分", data.unitConsume, data.rebateScore];
        self.distanceLabel.text = data.distance.length > 0 ? [NSString stringWithFormat:@"%@km", data.distance] : @" ";
        self.phoneLabel.text = data.businessTime;
        
        self.storePhone = data.storePhone;
        
        if([data.isBeanPay isEqualToString:@"1"]){
            self.leBeandikouImageView.hidden = NO;
            [self.leBeandikouImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(WIDTH_TRANSFORMATION(39));
            }];
        }else{
            self.leBeandikouImageView.hidden = YES;
            [self.leBeandikouImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(WIDTH_TRANSFORMATION(0));
            }];
        }
        
    }
}

///更新图片
- (void)updatePngForImageArray:(NSMutableArray *)imageArray
{
    self.imageArray = imageArray;
    [self.pngView updateUIForImages:imageArray];
}

#pragma mark -- QL_CustomSegmentDelegate

///当前选中项
-(void)customSegmentCurrentItem:(NSInteger)item
{
    if(self.onSelectItemBlock){
        self.onSelectItemBlock(item);
    }
}

#pragma mark -- event response

///点击电话
- (void)onPhoneAction:(UIButton *)sender
{
    [DATAMODEL.henUtil customerPhone:self.storePhone];
}

///点击地址
- (void)onAddressAction:(id)sender
{
    if(self.onAddressBlock){
        self.onAddressBlock();
    }
}

#pragma mark -- getter,setter

///图片
- (QL_HPBannerView *)pngView
{
    if(!_pngView){
        QL_HPBannerView *view = [[QL_HPBannerView alloc] initWithHeight:HEIGHT_TRANSFORMATION(450)];
        [self addSubview:_pngView = view];
        //回调
        WEAKSelf;
        view.onPngClickBlock = ^(NSInteger item){
            //显示大图
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for(NSString *url in weakSelf.imageArray){
                [array addObject:[NSString stringWithFormat:@"%@%@", PngBaseUrl, url]];
            }
            [DATAMODEL.henUtil clickShowBigPicture:array forView:self andCurrentTouch:item];
        };
    }
    return _pngView;
}

///信息view
- (UIView *)infoView
{
    if(!_infoView){
        UIView *view = [UIView createViewWithBackgroundColor:kCommonWhiteBg];
        [self addSubview:_infoView = view];
        
        UIImageView *lineImage = [UIImageView createImageViewWithName:@"public_line"];
        [view addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(view);
            make.centerX.equalTo(view);
            make.bottom.equalTo(view);
        }];
    }
    return _infoView;
}

///名称
- (UILabel *)nameLabel
{
    if(!_nameLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_38 textColor:kBussinessFontColorBlack];
        [label lableAutoLinefeed];
        [self addSubview:_nameLabel = label];
    }
    return _nameLabel;
}

///标志
- (UILabel *)markLabel
{
    if(!_markLabel){
        UILabel *label = [UILabel createLabelWithText:@"主营" font:kFontSize_22 textColor:kFontColorRed];
        [label setTextAlignment:NSTextAlignmentCenter];
        UIView *bgImage = [UIView createViewWithBackgroundColor:kCommonWhiteBg];
        //将图层的边框设置为圆脚
        bgImage.layer.cornerRadius = 2;
        bgImage.layer.masksToBounds = YES;
        bgImage.layer.borderColor = [kFontColorRed CGColor];
        bgImage.layer.borderWidth = 1;
        
        [self addSubview:_markbgImage = bgImage];
        [self addSubview:_markLabel = label];
        
        [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(label);
            make.left.equalTo(label.mas_left).with.offset(WIDTH_TRANSFORMATION(-16));
            make.left.equalTo(label).with.priorityLow();
            make.right.equalTo(label.mas_right).with.offset(WIDTH_TRANSFORMATION(16));
            make.right.equalTo(label).with.priorityLow();
            make.top.equalTo(label.mas_top).with.offset(HEIGHT_TRANSFORMATION(-2));
            make.top.equalTo(label).with.priorityLow();
            make.bottom.equalTo(label.mas_bottom).with.offset(HEIGHT_TRANSFORMATION(2));
            make.bottom.equalTo(label).with.priorityLow();
        }];
    }
    return _markLabel;
}

///评分
- (UILabel *)commentScoreLabel
{
    if(!_commentScoreLabel){
        UILabel *label = [UILabel createLabelWithText:@"0分" font:kFontSize_26];
        [self addSubview:_commentScoreLabel = label];
    }
    return _commentScoreLabel;
}

///消费
- (UILabel *)consumptionLabel
{
    if(!_consumptionLabel){
        UILabel *label = [UILabel createLabelWithText:@"人均0元" font:kFontSize_26];
        [self addSubview:_consumptionLabel = label];
    }
    return _consumptionLabel;
}

///消费提示
- (UILabel *)consumptionInfoLabel
{
    if(!_consumptionInfoLabel){
        UILabel *label = [UILabel createLabelWithText:@"消费0赠送0积分" font:kFontSize_28 textColor:kFontColorRed];
        [self addSubview:_consumptionInfoLabel = label];
    }
    return _consumptionInfoLabel;
}

///地址view
- (UIView *)addressView
{
    if(!_addressView){
        UIView *view = [UIView createViewWithBackgroundColor:kCommonWhiteBg];
        [self addSubview:_addressView = view];
        
        UIImageView *topLineImage = [UIImageView createImageViewWithName:@"public_line"];
        [view addSubview:topLineImage];
        [topLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(view);
            make.centerX.equalTo(view);
            make.top.equalTo(view);
        }];
        UIImageView *bottomLineImage = [UIImageView createImageViewWithName:@"public_line"];
        [view addSubview:bottomLineImage];
        [bottomLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(view);
            make.centerX.equalTo(view);
            make.bottom.equalTo(view);
        }];
    }
    return _addressView;
}

///距离
- (UILabel *)distanceLabel
{
    if(!_distanceLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_20 textColor:kFontColorGray];
        [self addSubview:_distanceLabel = label];
    }
    return _distanceLabel;
}

///地址
- (UILabel *)addressLabel
{
    if(!_addressLabel){
        UILabel *label = [UILabel createLabelWithText:@"" font:kFontSize_26];
        [label lableAutoLinefeed];
        [self addSubview:_addressLabel = label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddressAction:)];
        [label addGestureRecognizer:tap];
        label.userInteractionEnabled = YES;
        
        UIImageView *image = [UIImageView createImageViewWithName:@"public_icon_location"];
        [self addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label);
            make.right.equalTo(label.mas_left).offset(WIDTH_TRANSFORMATION(-4));
        }];
    }
    return _addressLabel;
}

///电话
- (UIButton *)phoneButton
{
    if(!_phoneButton){
        UIButton *button = [UIButton createButtonWithTitle:@"" normalImage:@"homepage_telephone" pressImage:@"homepage_telephone_press" target:self action:@selector(onPhoneAction:)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
        [self addSubview:_phoneButton = button];
        
        UIImageView *verLineImage = [UIImageView createImageViewWithName:@"public_line2"];
        [self addSubview:verLineImage];
        [verLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button).offset(2);
            make.bottom.equalTo(button).offset(-2);
            make.right.equalTo(button.mas_left);
        }];
    }
    return _phoneButton;
}

///电话提示
- (UILabel *)phoneLabel
{
    if(!_phoneLabel){
        UILabel *label = [UILabel createLabelWithText:@"8:30-18:30" font:kFontSize_20 textColor:kFontColorGray];
        [self addSubview:_phoneLabel = label];
    }
    return _phoneLabel;
}


///选择view
-(QL_CustomSegmentView*)segmentView
{
    if(!_segmentView){
        QL_CustomSegmentView *segmentView = [[QL_CustomSegmentView alloc] initWithHeight:BI_SegmentHeight];
        segmentView.frame = CGRectMake(0, self.frame.size.height - BI_SegmentHeight, segmentView.frame.size.width, segmentView.frame.size.height);
        segmentView.delegate = self;
        [segmentView setItems:@[@"服务评论",@"店铺简介"]];
        [segmentView setSelectItem:0];
        [self addSubview:_segmentView = segmentView];
    }
    return _segmentView;
}

- (UIImageView *)leBeandikouImageView
{
    if(!_leBeandikouImageView){
        UIImageView *image = [UIImageView createImageViewWithName:@"public_ledou"];
        image.hidden = YES;
        [self addSubview:_leBeandikouImageView = image];
    }
    return _leBeandikouImageView;
}
@end
