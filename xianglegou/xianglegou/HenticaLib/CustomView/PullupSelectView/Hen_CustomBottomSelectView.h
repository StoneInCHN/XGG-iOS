//
//  QL_CustomBottomSelectView.h
//  CRM
//
//  Created by mini2 on 16/6/12.
//  Copyright © 2016年 hentica. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomBottomSelectViewType){
    kCustomBottomSelectViewTypeOfBottom = 1,    // 下面
    kCustomBottomSelectViewTypeOfRightTop = 2   // 右上
};

@interface Hen_CustomBottomSelectTableViewCell : UITableViewCell

///标题
@property(nonatomic, strong) NSString *title;

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView;

///获取cell高度
+(CGFloat)getCellHeight;

@end

@interface Hen_CustomBottomSelectView : UIView

///选择回调
@property(nonatomic, copy) void(^customBottomSelectSelectBlock)(NSInteger item);

///初始化
-(id)initWithNameArray:(NSArray<NSString*> *)selectNameArray;

///更新显示内容
-(void)updateShowUIForNameArray:(NSArray<NSString*> *)selectNameArray;

///显示上拉
-(void)showBottomView;

///显示下拉
-(void)showDropdownView;

@end
