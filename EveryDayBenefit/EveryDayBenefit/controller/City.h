//
//  City.h
//  GaoDeMap
//
//  Created by cty on 14-2-17.
//  Copyright (c) 2014年 cty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
@property(nonatomic,strong) NSString * cityNAme;//城市名称 
@property(nonatomic,strong) NSString * letter;//城市拼音
@property(nonatomic, assign) float latitude;//纬度
@property(nonatomic, assign) float longtitde;//经度
@end
