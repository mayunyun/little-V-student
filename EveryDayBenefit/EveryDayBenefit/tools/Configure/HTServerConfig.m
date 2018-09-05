//
//  HTServerConfig.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTServerConfig.h"

static NSString *HTConfigEnv;  //环境参数 00: 测试环境,01: 生产环境

@implementation HTServerConfig

+(void)setHTConfigEnv:(NSString *)value
{
    HTConfigEnv = value;
}

+(NSString *)HTConfigEnv
{
    return HTConfigEnv;
    
}
//获取服务器地址
+ (NSString *)getHTServerAddr{
    if ([HTConfigEnv isEqualToString:@"00"]) {
        return @"http://124.130.131.94:8087";
    }else{
        return @"http://124.130.131.94:8087";
    }
}
//获取图片地址
+ (NSString *)getHTServerPicture{
    if ([HTConfigEnv isEqualToString:@"00"]) {
        return @"http://124.130.131.94:8087";
    }else{
        return @"http://124.130.131.94:8087";
    }
}
@end
