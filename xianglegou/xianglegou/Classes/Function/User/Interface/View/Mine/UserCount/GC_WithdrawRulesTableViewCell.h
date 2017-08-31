//
//  GC_WithdrawRulesTableViewCell.h
//  Rebate
//
//  Created by mini3 on 17/4/1.
//  Copyright © 2017年 Rebate. All rights reserved.
//
//  提现规则 -- cell
//

#import "Hen_BaseTableViewCell.h"

@interface GC_WithdrawRulesTableViewCell : Hen_BaseTableViewCell

///获取cell高度
+(CGFloat)getCellHeightForLeScoreInfo:(NSString*)leScoreInfo andURulesInfo:(NSString*)uRuleInfo andBRulesInfo:(NSString*)bRuleInfo;



///获取高度
+ (CGFloat)getCellHeightForLeScoreInfo:(NSString *)leScoreInfo andRuleInfo:(NSString*)ruleInfo;


///更新 ui
-(void)setUpdateUiForWithdrawInfoData:(GC_MResWithdrawInfoDataModel*)data andPrice:(NSString *)price;
@end
