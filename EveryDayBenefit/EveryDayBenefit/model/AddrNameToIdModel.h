//
//  AddrNameToIdModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface AddrNameToIdModel : BaseModel

@property (nonatomic,strong)NSString* areaid;
@property (nonatomic,strong)NSString* cityid;
@property (nonatomic,strong)NSString* provinceid;

@property (nonatomic,strong)NSString* serviceid;
@property (nonatomic,strong)NSString* villageid;

/*
 [{"areaid":"1349","cityid":"138","provinceid":"15"}]
 */

@end
