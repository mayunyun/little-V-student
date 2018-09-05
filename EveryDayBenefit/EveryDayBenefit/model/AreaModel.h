//
//  AreaModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/6.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface AreaModel : BaseModel

@property (nonatomic,strong)NSString * Id;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * cityid;
@property (nonatomic,strong)NSString * code;
@property (nonatomic,strong)NSString * type;

/*
 "cityid":15,"code":"208","id":208,"name":"市辖区","type":"area"
 */

@end
