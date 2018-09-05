//
//  BaseModel.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{

}

- (void)setValue:(id)value forKey:(NSString *)key {
    // ignore null value
    // 转换空串
    if ([value isEqual:[NSNull null]]) {
        value = @"";
    }
    else if ([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    else if (value==nil){
        value = @"";
    }
    [super setValue:value forKey:key];
}

@end
