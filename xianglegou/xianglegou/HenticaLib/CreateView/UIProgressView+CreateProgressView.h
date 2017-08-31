//
//  UIProgressView+CreateProgressView.h
//  Ask
//
//  Created by mini2 on 16/12/30.
//  Copyright © 2016年 Ask. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIProgressView (CreateProgressView)

///创建ProgressView
+(UIProgressView*)createProgressView;

///获取ProgressView
+(UIProgressView*)getProgressViewForTag:(NSInteger)tag inParentView:(UIView*)view;

@end
