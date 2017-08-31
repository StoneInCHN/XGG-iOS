//
//  QL_ListSelectView.h
//  Rebate
//
//  Created by mini2 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//
// 列表选择view
//

#import <UIKit/UIKit.h>

@interface QL_ListSelectViewData : Hen_JsonModel

///id
@property(nonatomic, strong) NSString *id;
///名字
@property(nonatomic, strong) NSString *name;

@end

@interface QL_ListSelectViewTableViewCell : Hen_BaseTableViewCell

///内容
@property(nonatomic, strong) NSString *content;

///是否选中
@property(nonatomic, assign) BOOL isSelect;

@end

@interface QL_ListSelectView : UIView

@property(nonatomic, copy) void(^onSelectBlock)(QL_ListSelectViewData *model);

///更新数据
-(void)updateDatas:(NSMutableArray<QL_ListSelectViewData*> *)datas;

///显示
- (void)showViewForSelectId:(NSString *)selectId;

@end

@interface QL_ListScreenSelectView : UIView

@property(nonatomic, copy) void(^onSelectBlock)(NSString *selectId);

///显示
- (void)showViewForSelectId:(NSString *)selectId;

@end
