//
//  CashSearchyueModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface CashSearchyueModel : BaseModel

@property (nonatomic,strong)NSString* createtime;
@property (nonatomic,strong)NSString* departandaccountid;//提现人的id
@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* money;
@property (nonatomic,strong)NSString* type;//5分销6配送

/*
 [{"createtime":1477907728000,"departandaccountid":106,"id":198,"money":122.56,"type":6}]
 */

@end
