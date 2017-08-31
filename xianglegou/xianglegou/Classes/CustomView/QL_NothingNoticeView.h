//
//  QL_NothingNoticeView.h
//  Ask
//
//  Created by mini2 on 16/12/20.
//  Copyright © 2016年 Ask. All rights reserved.
//
// 什么都没有提示view
//

#import <UIKit/UIKit.h>

@interface QL_NothingNoticeView : UIView

///初始化
-(id)initWithIsHaveSomething:(BOOL)isHave;

///设置图标
- (void)setIconImageViewForImageName:(NSString *)imageName;

@end
