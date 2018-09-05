//
//  LocaModel.m
//  YiRuanTong
//
//  Created by 联祥 on 15/7/21.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "LocaModel.h"

@interface LocaModel ()

@property (nonatomic, copy) NSString *duty;

@end

@implementation LocaModel

#pragma mark - override method

+(NSArray *)transients
{
    return [NSArray arrayWithObjects:@"duty",nil];
}

@end
