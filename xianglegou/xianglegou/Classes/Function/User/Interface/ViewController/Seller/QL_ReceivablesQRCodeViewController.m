//
//  QL_ReceivablesQRCodeViewController.m
//  Rebate
//
//  Created by mini2 on 17/4/8.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_ReceivablesQRCodeViewController.h"
#import "QL_ShopModel.h"

@interface QL_ReceivablesQRCodeViewController ()

///信息背景
@property(nonatomic, weak) UIImageView *infoBgImage;
///logo图片
@property(nonatomic, weak) UIImageView *logoImage;
///名字
@property(nonatomic, weak) UILabel *nameLabel;
///地区
@property(nonatomic, weak) UILabel *areaLabel;
///二维码图片
@property(nonatomic, weak) UIImageView *qrImage;

///数据
@property(nonatomic, strong) QL_ShopQRCodeInfoDataModel *infoData;

@end

@implementation QL_ReceivablesQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- override

///清除数据
- (void)cleanUpData
{
}

///清除强引用视图
- (void)cleanUpStrongSubView
{
}

///时间状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

///加载navigationBar背景
-(void)loadNavigationBarBackground
{
    [((Hen_BaseNavigationViewController*)self.navigationController) setDefaultBackground];
    [((Hen_BaseNavigationViewController*)self.navigationController) setBackgroundHidden:YES];
    [self.navigationController.navigationBar setTintColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setNavigationBarTitleColor:kFontColorWhite];
    [((Hen_BaseNavigationViewController*)self.navigationController) setShadowViewHidden:YES];
}

#pragma mark -- private

///加载子视图
- (void)loadSubView
{
    self.navigationItem.title = @"收款二维码";
    
    [[self bgImageView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(-64, 0, 0, 0));
    }];
    [self.infoBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(OffSetToLeft);
        make.right.equalTo(self.view).offset(OffSetToRight);
        make.top.equalTo(self.view).offset(HEIGHT_TRANSFORMATION(60));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(958));
    }];
    
    [self loadData];
}

///加载数据
- (void)loadData
{
    //参数
    NSMutableDictionary *parma = [NSMutableDictionary dictionaryWithCapacity:0];
    [parma setObject:DATAMODEL.userInfoData.id forKey:@"userId"];
    [parma setObject:DATAMODEL.token forKey:@"token"];
    [parma setObject:self.sellerId forKey:@"entityId"];
    //显示加载
    [self showPayHud:@""];
    //请求
    WEAKSelf;
    [[Hen_MessageManager shareMessageManager] requestWithAction:@"/rebate-interface/seller/getQrCode.jhtml" dictionaryParam:parma withResultBlock:^(NSString *code, NSString *desc, id msg, id page) {
        //取消加载
        [weakSelf hideHud];
        if([code isEqualToString:@"0000"]){ // 成功
            weakSelf.infoData = [[QL_ShopQRCodeInfoDataModel alloc] initWithDictionary:msg];
            
            [weakSelf updateUI];
        }else{
            //提示
            [weakSelf showHint:desc];
        }
    }];
}

///更新ui
- (void)updateUI
{
    [self.logoImage sd_setImageWithUrlString:[NSString stringWithFormat:@"%@%@", PngBaseUrl, self.infoData.storePictureUrl] defaultImageName:@""];
    self.nameLabel.text = self.infoData.name;
    self.areaLabel.text = self.infoData.area.fullName;
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:self.infoData.qrImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
    self.qrImage.image = [UIImage imageWithData:imageData];
}

#pragma mark -- getter,setter

///背景
- (UIImageView *)bgImageView
{
    UIImageView *image = [UIImageView createImageViewWithName:@"mine_qr_code_bg"];
    [self.view addSubview:image];
    
    return image;
}

///信息背景
- (UIImageView *)infoBgImage
{
    if(!_infoBgImage){
        UIImageView *image = [UIImageView createImageViewWithName:@"mine_fee_charging_qr_code"];
        [self.view addSubview:_infoBgImage = image];
        
        UIImageView *logoImage = [UIImageView createImageViewWithName:@""];
        logoImage.backgroundColor = kCommonBackgroudColor;
        [image addSubview:_logoImage = logoImage];
        [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(image.mas_left).offset(WIDTH_TRANSFORMATION(70));
            make.top.equalTo(image.mas_top).offset(HEIGHT_TRANSFORMATION(70));
            make.width.and.height.mas_equalTo(FITSCALE(85));
        }];
        UILabel *nameLabel = [UILabel createLabelWithText:@"" font:kFontSize_34 textColor:kBussinessFontColorBlack];
        [nameLabel lableAutoLinefeed];
        [self.view addSubview:_nameLabel = nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logoImage.mas_right).offset(WIDTH_TRANSFORMATION(10));
            make.top.equalTo(logoImage);
            make.right.equalTo(image).offset(OffSetToRight);
        }];
        UILabel *areaLabel = [UILabel createLabelWithText:@"" font:kFontSize_28];
        [self.view addSubview:_areaLabel = areaLabel];
        [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.top.equalTo(nameLabel.mas_bottom).offset(HEIGHT_TRANSFORMATION(20));
        }];
        UIImageView *qrImage = [UIImageView createImageViewWithName:@""];
        qrImage.backgroundColor = kCommonBackgroudColor;
        [self.view addSubview:_qrImage = qrImage];
        [qrImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(image).offset(HEIGHT_TRANSFORMATION(-170));
            make.width.and.height.mas_equalTo(WIDTH_TRANSFORMATION(440));
        }];
        
        UILabel *noticeLabel = [UILabel createLabelWithText:@"用享个购扫一扫二维码，向我付款" font:kFontSize_28];
        [self.view addSubview:noticeLabel];
        [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(image).offset(HEIGHT_TRANSFORMATION(-80));
        }];
    }
    return _infoBgImage;
}

@end
