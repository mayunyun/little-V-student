//
//  DataPost.m
//  YiRuanTong
//
//  Created by 联祥 on 15/8/6.
//  Copyright (c) 2015年 联祥. All rights reserved.
//

#import "DataPost.h"

@implementation DataPost
+ (AFHTTPSessionManager *)requestAFWithUrl:(NSString *)urlString
                                             params:(NSDictionary *)params

                                     finishDidBlock:(FinishDidBlock)finishDidBlock
                                       failureBlock:(FailureBlock)failureBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    #if DEBUG
            NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            // DebugLog(@"\n\n urlString : %@ \n%@\n\n",urlString,string);
    #endif
            if (finishDidBlock) {
                finishDidBlock(responseObject);
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) {
                failureBlock(error);
            }
    }];
    
    
    
    
    
    
    
    return manager;
    
    
}






+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}











- (NSString *)replaceOhter:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"null(\"" withString:@""];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"\")" withString:@""];
    return returnString;
}




@end
