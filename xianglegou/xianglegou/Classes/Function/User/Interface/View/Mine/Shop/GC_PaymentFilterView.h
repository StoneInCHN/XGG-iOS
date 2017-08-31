//
//  GC_PaymentFilterView.h
//  xianglegou
//
//  Created by mini3 on 2017/7/14.
//  Copyright © 2017年 xianglegou. All rights reserved.
//
//  货款筛选 -- view
//

#import <UIKit/UIKit.h>


@interface GC_PaymentFilterDataModel : Hen_JsonModel
///名称
@property (nonatomic, strong) NSString *name;
///ID
@property (nonatomic, strong) NSString *itemId;

///是否选中
@property (nonatomic, assign) BOOL isSelected;
@end


@interface GC_PaymentFilterView : UIView
///完成 回调
@property (nonatomic, copy) void(^onFinshBlock)(NSString *item);

///显示
- (void)showView;
@end
