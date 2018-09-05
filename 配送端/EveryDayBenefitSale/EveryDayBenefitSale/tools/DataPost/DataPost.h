//
//  DataPost.h
//  YiRuanTong
//
//  Created by 联祥 on 15/8/6.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^FinishDidBlock)(id result);
typedef void (^FailureBlock)(NSError *error);

@interface DataPost : NSObject
+ (AFHTTPSessionManager *)requestAFWithUrl:(NSString *)urlString
                                             params:(NSDictionary *)params
                                     finishDidBlock:(FinishDidBlock)finishDidBlock
                                       failureBlock:(FailureBlock)failureBlock;



+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
@end
