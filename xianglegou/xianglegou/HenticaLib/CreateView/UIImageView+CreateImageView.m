//
//  UIImageView+CreateImageView.m
//  HelloWorld
//
//  Created by mini2 on 16/9/2.
//  Copyright © 2016年 HelloWorld. All rights reserved.
//

#import "UIImageView+CreateImageView.h"

@implementation UIImageView (CreateImageView)

///创建ImageVIew
+(UIImageView*)createImageViewWithName:(NSString*)name
{
    UIImageView *imageView = [[UIImageView alloc] init];
    if (name.length > 0) {
        imageView.image = [UIImage imageNamed:name];
    }
    
    return imageView;
}

///获取ImageView
+(UIImageView*)getImageViewForTag:(NSInteger)tag inParentView:(UIView*)view
{
    UIImageView *imageView = (UIImageView*)[view viewWithTag:tag];
    
    return imageView;
}

///图片圆形
-(void)makeRadiusForWidth:(CGFloat)width
{
    //告诉layer将位于它之下的layer都遮住
    self.layer.masksToBounds = YES;
    //设置layer的圆角，刚好是自身宽度的一半，这样就成了圆
    self.layer.cornerRadius = width*0.5;
    //设置边框宽度
    self.layer.borderWidth = 0;
    //设置边框颜色
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

///设置图片
-(void)setImageForName:(NSString*)imageName
{
    self.image = [UIImage imageNamed:imageName];
}

@end
