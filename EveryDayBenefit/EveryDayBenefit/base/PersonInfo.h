//
//  PersonInfo.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInfo : NSObject
@property(nonatomic,assign) BOOL hasNet;
+(PersonInfo*)defaultManager;
@end