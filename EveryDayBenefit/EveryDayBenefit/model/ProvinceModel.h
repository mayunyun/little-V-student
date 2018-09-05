//
//  ProvinceModel.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/6.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@interface ProvinceModel : BaseModel

@property (nonatomic,strong)NSString * Id;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSString * code;
@property (nonatomic,strong)NSString * type;
/*
 "code":"1","id":1,"name":"北京市","type":"province"
 */

@end
