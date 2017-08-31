//
//  UIImageView+CreateImageView.h
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CreateImageView)

///创建ImageVIew
+(UIImageView*)createImageViewWithName:(NSString*)name;

///获取ImageView
+(UIImageView*)getImageViewForTag:(NSInteger)tag inParentView:(UIView*)view;

///图片圆形
-(void)makeRadiusForWidth:(CGFloat)width;

///设置图片
-(void)setImageForName:(NSString*)imageName;

@end
