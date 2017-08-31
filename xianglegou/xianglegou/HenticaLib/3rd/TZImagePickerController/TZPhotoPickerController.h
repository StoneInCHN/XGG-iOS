//
//  TZPhotoPickerController.h
//  TZImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hen_BaseViewController.h"

@class TZAlbumModel;
@interface TZPhotoPickerController : Hen_BaseViewController

@property (nonatomic, strong) TZAlbumModel *model;

@end
