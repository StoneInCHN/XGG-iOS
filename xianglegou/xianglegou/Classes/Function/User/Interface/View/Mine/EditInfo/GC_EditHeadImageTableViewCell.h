//
//  GC_EditHeadImageTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/3/28.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  头像 -- cell
//

#import "Hen_BaseTableViewCell.h"


@interface GC_UserPhotoDataModel : Hen_JsonModel
///图片/图片URL
@property(nonatomic, strong) id image;
///上传总数
@property(nonatomic, assign) CGFloat tatole;
///当前数
@property(nonatomic, assign) CGFloat current;
///状态 0：未知；1：正在上传；2：上传成功；3：已上传
@property(nonatomic, assign) NSInteger statue;
@end

@interface GC_EditHeadImageTableViewCell : Hen_BaseTableViewCell
///更新头像
-(void)updateForData:(GC_UserPhotoDataModel*)data;
@end
