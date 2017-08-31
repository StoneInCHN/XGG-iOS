//
//  Hen_PhotoCollectManager.h
//  Peccancy
//
//  Created by mini2 on 16/11/11.
//  Copyright © 2016年 Peccancy. All rights reserved.
//
// 照片采集管理类
//

#import <Foundation/Foundation.h>

@protocol Hen_PhotoCollectManagerDelegate

@optional
///成功采集照片
-(void)successCollectPhoto:(NSMutableArray<UIImage*>*)photos;

@end

@interface Hen_PhotoCollectManager : NSObject

///代理
@property(nonatomic, assign) id<Hen_PhotoCollectManagerDelegate> delegate;

///最多张数
@property(nonatomic, assign) NSInteger maxPhotoCount;

///照片大小
@property(nonatomic, assign) CGFloat photoSize;

///显示选择器
-(void)showSelectInViewController:(UIViewController*)vc;

@end
