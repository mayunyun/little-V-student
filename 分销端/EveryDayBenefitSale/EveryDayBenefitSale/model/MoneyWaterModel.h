//
//  MoneyWaterModel.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface MoneyWaterModel : BaseModel

@property (nonatomic,strong)NSString* Id;
@property (nonatomic,strong)NSString* date;
@property (nonatomic,strong)NSString* orderno;
@property (nonatomic,strong)NSString* changemoney;
@property (nonatomic,strong)NSString* currentmoney;
@property (nonatomic,strong)NSString* type;//类型

@end
