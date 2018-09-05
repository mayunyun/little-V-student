//
//  CityModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/6.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface CityModel : BaseModel

@property (nonatomic,strong)NSString * Id;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * provinceid;
@property (nonatomic,strong)NSString * code;
@property (nonatomic,strong)NSString * type;


/*
 code":"138","id":138,"name":"济南市","provinceid":15,"type":"city"
 */
@end
