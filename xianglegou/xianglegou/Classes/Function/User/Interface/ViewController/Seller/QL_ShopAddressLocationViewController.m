//
//  QL_AddAddressViewController.m
//  MenLi
//
//  Created by mini2 on 16/6/29.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import "QL_ShopAddressLocationViewController.h"

@interface QL_ShopAddressLocationViewController ()<BMKMapViewDelegate>

///地图View
@property(nonatomic, strong) UIView *mapSuperView;

///地图
@property(nonatomic, weak) BMKMapView* mapView;

///标注
@property(nonatomic, strong) UIImageView *pointImage;

///信息view
@property(nonatomic, weak) UIView *infoView;
///名字
@property(nonatomic, weak) UILabel *nameLabel;
///地址
@property(nonatomic, weak) UILabel *addressLabel;

///省名字
@property(nonatomic, strong) NSString *proName;
///市名字
@property(nonatomic, strong) NSString *cityName;
///区名字
@property(nonatomic, strong) NSString *areaName;

@end

@implementation QL_ShopAddressLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.proName = @"";
    self.cityName = @"";
    self.areaName = @"";
    
    [self initMapUitl];
    
    [self loadNavigationBar];
    [self loadCustomView];
    [self loadBaiduMap];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 子类必须重写并实现
///清除数据
-(void)cleanUpData
{
}
///清除强引用视图
-(void)cleanUpStrongSubView
{
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    
    [DATAMODEL.baiduMapUtil cleanMap];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadNavigationBar
{
    self.navigationItem.title = @"地址定位";
}

-(void)loadCustomView
{
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(200));
    }];
    [self.view addSubview:self.mapSuperView];
    
    WEAKSelf;
    [self.mapSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(self.infoView.mas_top);
    }];
}

-(void)loadBaiduMap
{
    BMKMapView * mapView = [[BMKMapView alloc] init];
    [mapView setZoomLevel:17];
    mapView.delegate = self;
    [self.mapSuperView addSubview:_mapView = mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mapSuperView);
        make.height.equalTo(self.mapSuperView);
        make.center.equalTo(self.mapSuperView);
    }];
    
    [self.mapSuperView addSubview:self.pointImage];
    [self.pointImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mapSuperView);
        make.bottom.equalTo(self.mapSuperView.mas_centerY);
    }];
    
    //先定位，定位失败显示输入地址
    [DATAMODEL.baiduMapUtil loadLocation];
}

#pragma mark ------------------ action

-(void)onFinishAction:(UIButton *)sender
{
    if(self.onFinishBlock){
        self.onFinishBlock(self.longitude, self.latitude, self.address);
    }
    if(self.onFinishWithAreaBlock){
        self.onFinishWithAreaBlock(self.longitude, self.latitude, self.address, self.proName, self.cityName, self.areaName);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//拖动地图
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D pt = self.mapView.centerCoordinate;
    [DATAMODEL.baiduMapUtil mapSearchLocationCoordinate2D:pt];
        
    self.longitude = [NSString stringWithFormat:@"%f", pt.longitude];
    self.latitude = [NSString stringWithFormat:@"%f", pt.latitude];
}

#pragma mark ------------------- getter, setter

-(UIView*)mapSuperView
{
    if(!_mapSuperView){
        _mapSuperView = [[UIView alloc] init];
        _mapSuperView.backgroundColor = kCommonWhiteBg;
    }
    return _mapSuperView;
}

-(UIImageView*)pointImage
{
    if(!_pointImage){
        _pointImage = [UIImageView createImageViewWithName:@"homepage_map_locating_seller"];
    }
    return _pointImage;
}

///信息view
- (UIView *)infoView
{
    if(!_infoView){
        UIView *view = [UIView createViewWithBackgroundColor:kCommonWhiteBg];
        [self.view addSubview:_infoView = view];
        
        UILabel *nameLabel = [UILabel createLabelWithText:self.sellerName font:kFontSize_34 textColor:kBussinessFontColorBlack];
        [view addSubview:_nameLabel = nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(OffSetToLeft);
            make.top.equalTo(view).offset(HEIGHT_TRANSFORMATION(30));
        }];
        UILabel *addressLabel = [UILabel createLabelWithText:[NSString stringWithFormat:@"地址：%@", self.address] font:kFontSize_28];
        [addressLabel lableAutoLinefeed];
        [view addSubview:_addressLabel = addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(OffSetToLeft);
            make.right.equalTo(view).offset(WIDTH_TRANSFORMATION(-200));
            make.top.equalTo(view).offset(HEIGHT_TRANSFORMATION(100));
        }];
        UIButton *button = [UIButton createButtonWithTitle:@"完成" backgroundNormalImage:@"public_botton_map_address_box_button" backgroundPressImage:@"public_botton_map_address_box_button_press" target:self action:@selector(onFinishAction:)];
        [button setTitleClor:kFontColorWhite];
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.right.equalTo(view).offset(OffSetToRight);
        }];
    }
    return _infoView;
}

///地图类
- (void)initMapUitl
{
    WEAKSelf;
    //回调
    DATAMODEL.baiduMapUtil.onMapSearchAddressBlock = ^(NSString *address){
        weakSelf.address = address;
        weakSelf.addressLabel.text = [NSString stringWithFormat:@"地址：%@", address];
    };
    DATAMODEL.baiduMapUtil.onLocationBlock = ^(NSString *longitude, NSString *latitude){
        if([longitude isEqualToString:@""] && [latitude isEqualToString:@""]){ // 定位失败，显示输入地址
            if(weakSelf.latitude.length > 0  && weakSelf.longitude.length > 0){ //有地址
                CLLocationCoordinate2D location;
                location.latitude = [weakSelf.latitude doubleValue];
                location.longitude = [weakSelf.longitude doubleValue];
                weakSelf.mapView.centerCoordinate = location;
                
                [DATAMODEL.baiduMapUtil mapSearchLocationCoordinate2D:location];
            }
        }else{
            weakSelf.longitude = longitude;
            weakSelf.latitude = latitude;
            
            CLLocationCoordinate2D location;
            location.latitude = [self.latitude doubleValue];
            location.longitude = [self.longitude doubleValue];
            weakSelf.mapView.centerCoordinate = location;
        }
    };
    DATAMODEL.baiduMapUtil.onMapSearchAreaBlock = ^(NSString *proName, NSString *cityName, NSString *areaName){
        weakSelf.proName = proName;
        weakSelf.cityName = cityName;
        weakSelf.areaName = areaName;
    };
}

@end
