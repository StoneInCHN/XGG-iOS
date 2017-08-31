//
//  Hen_BaiduMapUtil.m
//  Peccancy
//
//  Created by mini2 on 16/11/7.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_BaiduMapUtil.h"
#import<CoreLocation/CoreLocation.h>

@interface Hen_BaiduMapUtil()<CLLocationManagerDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate>

@property(nonatomic, strong) BMKGeoCodeSearch *geocodesearch;

@property(nonatomic, strong) BMKLocationService *locationService;

@property(nonatomic, strong) BMKSuggestionSearch *suggestionSearch;

@end

@implementation Hen_BaiduMapUtil

///初始化百度地图
-(void)initBaiduMap
{
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager* mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:BD_APP_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }else {
        NSLog(@"onGetPermissionState %d",iError);
    }

    //定位
    [self loadLocation];
}

///定位
-(void)loadLocation
{
    [self.locationService startUserLocationService];
}

///地址检索
-(void)mapSearchLocationCoordinate2D:(CLLocationCoordinate2D) location
{
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    
        if(self.onMapSearchAddressBlock){
            self.onMapSearchAddressBlock(@"");
        }
    }
}

///地址检索
-(void)mapSearchCity:(NSString*)city address:(NSString*)addr
{
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= city;
    geocodeSearchOption.address = addr;
    BOOL flag = [self.geocodesearch geoCode:geocodeSearchOption];
    if(flag){
        NSLog(@"geo检索发送成功");
    }else{
        NSLog(@"geo检索发送失败");
        
        if(self.onMapSearchCoordinate2DBlock){
            self.onMapSearchCoordinate2DBlock(@"", @"");
        }
    }
}

///地址检索
-(void)mapSearchForAddress:(NSString*)addr
{
    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
    option.keyword = addr;
    BOOL flag = [self.suggestionSearch suggestionSearch:option];
    if(flag){
        NSLog(@"搜索发送成功");
    }else{
        NSLog(@"搜索发送失败");
        
        if(self.onMapSearchCoordinate2DBlock){
            self.onMapSearchCoordinate2DBlock(@"", @"");
        }
    }
}

///清除
- (void)cleanMap
{
    self.onLocationCityBlock = nil;
    self.onLocationBlock = nil;
    self.onMapSearchAddressBlock = nil;
    self.onMapSearchCoordinate2DBlock = nil;
    self.onMapSearchAreaBlock = nil;
}

#pragma mark -- 百度相关

///反向地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        NSLog(@"反向地理编码==%f,%f==%@",result.location.latitude, result.location.longitude, result.address);
        
        if(self.onLocationCityBlock){
            self.onLocationCityBlock(result.addressDetail.city);
        }
        
        if(self.onMapSearchAddressBlock){
            self.onMapSearchAddressBlock(result.address);
        }
        
        if(self.onMapSearchAreaBlock){
            self.onMapSearchAreaBlock(result.addressDetail.province, result.addressDetail.city, result.addressDetail.district);
        }
    }else{
        if(self.onMapSearchAddressBlock){
            self.onMapSearchAddressBlock(@"");
        }
    }
}

//正向地理编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
    
        if(self.onMapSearchCoordinate2DBlock){
            self.onMapSearchCoordinate2DBlock( [NSString stringWithFormat:@"%f", result.location.longitude],  [NSString stringWithFormat:@"%f", result.location.latitude]);
        }
    }else{
        if(self.onMapSearchCoordinate2DBlock){
            self.onMapSearchCoordinate2DBlock(@"", @"");
        }
    }
}

///用户位置更新后，会调用此函数
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    NSLog(@"经度:%lf,纬度:%lf",pt.longitude, pt.latitude);
    if(self.onLocationBlock){
        self.onLocationBlock([NSString stringWithFormat:@"%lf", pt.longitude], [NSString stringWithFormat:@"%lf", pt.latitude]);
    }
    
    [self.locationService stopUserLocationService];
    
    [self mapSearchLocationCoordinate2D:pt];
}

///定位失败后，会调用此函数
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self.locationService stopUserLocationService];
    NSLog(@"定位失败！");
    if(self.onLocationCityBlock){
        self.onLocationCityBlock(@"");
    }
}

/**
 *返回suggestion搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        if(result.ptList.count > 0){
            NSValue *val = result.ptList.firstObject;
            CLLocationCoordinate2D coor;
            [val getValue:&coor];
            if(self.onMapSearchCoordinate2DBlock){
                self.onMapSearchCoordinate2DBlock([NSString stringWithFormat:@"%f", coor.longitude],  [NSString stringWithFormat:@"%f", coor.latitude]);
            }
        }else{
            if(self.onMapSearchCoordinate2DBlock){
                self.onMapSearchCoordinate2DBlock(@"", @"");
            }
        }
    }else{
        if(self.onMapSearchCoordinate2DBlock){
            self.onMapSearchCoordinate2DBlock(@"", @"");
        }
    }
}

#pragma mark -- getter,setter

- (BMKGeoCodeSearch *)geocodesearch
{
    if(!_geocodesearch){
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
    }
    return _geocodesearch;
}

- (BMKLocationService *)locationService
{
    if(!_locationService){
        _locationService = [[BMKLocationService alloc] init];
        //设置更新位置频率(单位：米;必须要在开始定位之前设置)
        _locationService.distanceFilter = 6.0f;
        _locationService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationService.delegate = self;
    }
    return _locationService;
}

- (BMKSuggestionSearch *)suggestionSearch
{
    if(!_suggestionSearch){
        _suggestionSearch = [[BMKSuggestionSearch alloc] init];
        _suggestionSearch.delegate = self;
    }
    return _suggestionSearch;
}

@end
