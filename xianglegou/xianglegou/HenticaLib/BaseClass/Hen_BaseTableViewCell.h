//
//  QL_BaseTableViewCell.h
//  MenLi
//
//  Created by mini2 on 16/6/21.
//  Copyright © 2016年 MenLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hen_BaseTableViewCell : UITableViewCell

///上长分界线
@property(nonatomic, weak) UIImageView *topLongLineImage;
///上短分界线
@property(nonatomic, weak) UIImageView *topShortLineImage;
///下长分界线
@property(nonatomic, weak) UIImageView *bottomLongLineImage;
///下短分界线
@property(nonatomic, weak) UIImageView *bottomShortLineImage;

///创建
+(instancetype)cellWithTableView:(UITableView*)tableView;

///获取cell高度
+(CGFloat)getCellHeight;

///获取cell高度
+(CGFloat)getCellHeightForContent:(NSString*)content;

///初始化
-(void)initDefault;

///加载子视图约束
-(void)loadSubviewConstraints;

///加载分界线
-(void)loadLine;

///不显示点击效果
-(void)unShowClickEffect;
///显示点击效果
- (void)showClickEffect;

@end
