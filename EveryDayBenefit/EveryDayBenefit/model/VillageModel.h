//
//  VillageModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/6.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface VillageModel : BaseModel

@property (nonatomic,strong)NSString * Id;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * servicecenterid;

/*
 "id":10,"name":"5555","servicecenterid":17,"type":"village"
 */

@end
