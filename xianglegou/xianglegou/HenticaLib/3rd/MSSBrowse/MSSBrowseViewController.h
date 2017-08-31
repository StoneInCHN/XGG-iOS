//
//  MSSBrowseViewController.h
//  MSSBrowse
//
//  Created by 于威 on 15/12/23.
//  Copyright © 2015年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSSBrowseViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate>

///是否图片移动原位置关闭
@property(nonatomic, assign) BOOL isImageMoveClose;

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex;
- (void)showBrowseViewController;

@end
