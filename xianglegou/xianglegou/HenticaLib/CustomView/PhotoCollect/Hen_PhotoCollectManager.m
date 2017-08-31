//
//  Hen_PhotoCollectManager.m
//  Peccancy
//
//  Created by mini2 on 16/11/11.
//  Copyright © 2016年 Peccancy. All rights reserved.
//

#import "Hen_PhotoCollectManager.h"
#import "TZImagePickerController.h"
#import "Hen_Util.h"

#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>

@interface Hen_PhotoCollectManager()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

///选择界面
@property(nonatomic, strong) Hen_CustomBottomSelectView *selectView;

///相机
@property (strong, nonatomic) UIImagePickerController *imagePicker;

///相册浏览
@property (strong, nonatomic) TZImagePickerController *imagePickerVc;

///视图控制器
@property(nonatomic, strong) UIViewController *viewController;

@end

@implementation Hen_PhotoCollectManager

-(id)init
{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return self;
}

///初始化
-(void)initDefault
{
    self.maxPhotoCount = 1;
    self.photoSize = 800;
}

///显示选择器
-(void)showSelectInViewController:(UIViewController*)vc
{
    self.viewController = vc;
    [self.selectView showBottomView];
}

#pragma mark -- private

///打开相机
-(void)openCamera
{
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        // 无权限 引导去开启
        //提示
        [DATAMODEL.alertManager showCustomButtonTitls:@[@"暂不", @"去设置"] message:@"相机授权未开启，请在系统设置中开启相机授权。"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
        return;
    }

    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self.viewController presentViewController:self.imagePicker animated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

///打开相册
-(void)openPhotoAlbum
{
    //相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        //无权限 引导去开启
        //提示
        [DATAMODEL.alertManager showCustomButtonTitls:@[@"暂不", @"去设置"] message:@"相册授权未开启，请在系统设置中开启相册授权。"];
        [DATAMODEL.alertManager setActionEventBoloc:^(NSInteger buttonIndex) {
            if(buttonIndex == 1){
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
        return;
    }
    
    
    _imagePickerVc= [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxPhotoCount delegate:self];
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [_imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    _imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & originalPhoto or not
    // 设置是否可以选择视频/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    //}
    if(self.maxPhotoCount == 1){
        _imagePickerVc.isSingleSelect = YES;
    }else{
        _imagePickerVc.isSingleSelect = NO;
    }
    _imagePickerVc.isCheckImageSize = NO;
    [self.viewController presentViewController:_imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
    
    if (orgImage) {
        UIImage *image = [[Hen_Util getInstance] scaleImage:orgImage maxEdge:self.photoSize];
        [self.delegate successCollectPhoto:[[NSMutableArray alloc] initWithArray:@[image]]];
    } else {
        [DATAMODEL.progressManager showHint:@"获取图片失败"];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}

#pragma mark ----------TZImagePickerControllerDelegate

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for(UIImage *orgImage in photos){
        UIImage *image = [[Hen_Util getInstance] scaleImage:orgImage maxEdge:self.photoSize];
        [array addObject:image];
    }
    
    [self.delegate successCollectPhoto:array];
}

#pragma mark -- getter,setter

///选择界面
-(Hen_CustomBottomSelectView*)selectView
{
    if(!_selectView){
        _selectView = [[Hen_CustomBottomSelectView alloc] initWithNameArray:@[@"拍照",@"从相册选择",@"取消"]];
        //回调
        WEAKSelf;
        _selectView.customBottomSelectSelectBlock = ^(NSInteger item){
            if(item == 0){ // 拍照
                [weakSelf openCamera];
            }else if(item == 1){// 从相册选择
                [weakSelf openPhotoAlbum];
            }
        };
    }
    return _selectView;
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

@end
