//
//  ServiceCenterModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/6.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceCenterModel : BaseModel

@property (nonatomic,strong)NSString * Id;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * areaid;



/*
 "areaid":1,"code":18,"id":18,"name":"a+业务中心","type":"servicecenter"
 */

@end
