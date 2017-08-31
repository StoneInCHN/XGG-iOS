//
//  QL_AddressLocationViewController.m
//  Rebate
//
//  Created by mini2 on 17/3/24.
//  Copyright © 2017年 Rebate. All rights reserved.
//

#import "QL_AddressLocationViewController.h"
#import "PosistionUtil.h"

@interface QL_AddressLocationViewController ()<BMKMapViewDelegate, BMKRouteSearchDelegate, BMKLocationServiceDelegate>

@property(nonatomic, strong) BMKMapView* mapView;
@property(nonatomic, strong) BMKLocationService *locationService;

@property(nonatomic, assign) CLLocationCoordinate2D houseLoacation;
@property(nonatomic, strong) BMKPointAnnotation *housePoint;
@property(nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property(nonatomic, strong) BMKPointAnnotation *currentPoint;

///选择器
@property(nonatomic, strong) Hen_CustomBottomSelectView *selectView;

@end

@implementation QL_AddressLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"地址定位";
    [self loadSubView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil; // 不用时，置nil
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

#pragma mark -- private

///加载子视图
-(void)loadSubView
{
    _mapView = [[BMKMapView alloc] init];
    [_mapView setZoomLevel:20];
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
        make.center.equalTo(self.view);
    }];
    _mapView.delegate = self;

    // 初始化位置百度位置服务
    _locationService = [[BMKLocationService alloc] init];
    //设置更新位置频率(单位：米;必须要在开始定位之前设置)
    _locationService.distanceFilter = 6.0f;
    _locationService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [_locationService startUserLocationService];

    _mapView.centerCoordinate = _houseLoacation;
    [self addHousePointAnnotation];
}

-(void)addHousePointAnnotation
{
    _housePoint = [[BMKPointAnnotation alloc]init];
    _housePoint.coordinate = _houseLoacation;
    _housePoint.title = @"";
    [_mapView addAnnotation:_housePoint];
}

-(void)addCurrentPointAnnotation
{
    _currentPoint = [[BMKPointAnnotation alloc]init];
    _currentPoint.coordinate = _currentLocation;
    _currentPoint.title = @"";
    [_mapView addAnnotation:_currentPoint];
    
    if(_currentLocation.latitude == 0 && _currentLocation.longitude == 0){
        [DATAMODEL.progressManager showHint:@"定位失败，有可能是您的手机权限未打开！"];
    }
}

///设置经纬度
-(void)setLatitude:(NSString*)latitude andLongitude:(NSString*)longitude
{
    _houseLoacation.latitude = [latitude floatValue];
    _houseLoacation.longitude = [longitude floatValue];
}

#pragma mark -- 百度相关

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if(annotation == _housePoint){
        
        NSString *AnnotationViewID = @"myAnnotation";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = NO;
            // 显示气泡
            [annotationView setSelected:YES];
            //设置大头针图标
            annotationView.image = [UIImage imageNamed:@"homepage_map_locating_seller"];
            
            //自定义气泡
            BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc] initWithCustomView:[self popView]];
            annotationView.paopaoView=paopao;
        }
        return annotationView;
    }else if(annotation == _currentPoint){
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = NO;
            // 设置可拖拽
            annotationView.draggable = NO;
            annotationView.image = [UIImage imageNamed:@"homepage_map_locating_mine"];
        }
        return annotationView;
    }
    return nil;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    NSLog(@"经度:%lf,纬度:%lf",pt.latitude,pt.longitude);
    
    _currentLocation = pt;
    [self addCurrentPointAnnotation];
    
    [_locationService stopUserLocationService];
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark -- event response

-(void)onToHereAction:(UIButton *)sender
{
    //是否有百度
    BOOL isBaidu = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]];
    //是否有高德
    BOOL isGaode = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]];
    
    [self.selectView updateShowUIForNameArray:@[isBaidu ? @"百度地图" : @"百度地图（AppStore下载）", isGaode ? @"高德地图":@"高德地图（AppStore下载）", @"取消"]];
    [self.selectView showBottomView];
}

#pragma mark -- getter,setter

///气泡view
- (UIView *)popView
{
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FITWITH(662/2), HEIGHT_TRANSFORMATION(183))];
    //设置弹出气泡图片
    UIImageView *imageView = [UIImageView createImageViewWithName:@""];
    UIImage *image = [UIImage imageNamed:@"homepage_map_address_box"];
    // 左端盖宽度
    NSInteger leftCapWidth = image.size.width * 0.5f;
    // 顶端盖高度
    NSInteger topCapHeight = image.size.height * 0.5f;
    // 重新赋值
    image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    imageView.image = image;
    [popView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(popView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //按钮
    UIButton *toButton = [UIButton createButtonWithTitle:@"到这去" backgroundNormalImage:@"public_botton_small_order_red" backgroundPressImage:@"public_botton_small_order_red_press" target:self action:@selector(onToHereAction:)];
    [toButton setTitleColor:kFontColorWhite forState:UIControlStateNormal];
    [popView addSubview:toButton];
    [toButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popView).offset(HEIGHT_TRANSFORMATION(46));
        make.right.equalTo(popView).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-40));
        make.width.mas_equalTo(WIDTH_TRANSFORMATION(140));
        make.height.mas_equalTo(HEIGHT_TRANSFORMATION(66));
    }];
    
    //地址
    UILabel *addressLabel = [UILabel createLabelWithText:[NSString stringWithFormat:@"地址：%@", self.addressString] font:kFontSize_28];
    addressLabel.numberOfLines = 2;
    [popView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(popView).offset(POSITION_WIDTH_FIT_TRANSFORMATION(30));
        make.right.equalTo(toButton.mas_left).offset(POSITION_WIDTH_FIT_TRANSFORMATION(-20));
        make.right.equalTo(toButton.mas_left).with.priorityLow();
        make.top.equalTo(popView).offset(HEIGHT_TRANSFORMATION(20));
    }];
    
    //距离
    UILabel *distenceLabel = [UILabel createLabelWithText:[NSString stringWithFormat:@"距离：%@", self.distanceString] font:kFontSize_24 textColor:kFontColorGray];
    [popView addSubview:distenceLabel];
    [distenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel);
        make.bottom.equalTo(popView).offset(HEIGHT_TRANSFORMATION(-40));
    }];
    
    return popView;
}

-(Hen_CustomBottomSelectView*)selectView
{
    if(!_selectView){
        _selectView = [[Hen_CustomBottomSelectView alloc] initWithNameArray:@[@"百度地图", @"高德地图", @"取消"]];
        
        __weak NSString *urlScheme = [NSString stringWithFormat:@"%@://", [Hen_DeviceUtil getBundleID]];
        __weak NSString *appName = [Hen_DeviceUtil getExecutableFile];
        
        Gps *gps = [PosistionUtil bd09_To_Gcj02:_houseLoacation.latitude lon:_houseLoacation.longitude];
        
        WEAKSelf;
        _selectView.customBottomSelectSelectBlock = ^(NSInteger item){
            if(item == 0){ // 百度地图
                if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
                    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving",weakSelf.houseLoacation.latitude, weakSelf.houseLoacation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSLog(@"%@",urlString);
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",@"452186370"]]];
                }
            }else if(item == 1){ // 高德地图
                if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
                    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,gps.wgLat, gps.wgLon] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSLog(@"%@",urlString);
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",@"461703208"]]];
                }
            }
        };
    }
    return _selectView;
}


@end
