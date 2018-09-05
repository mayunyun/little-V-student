//
//  Command.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "Command.h"

@interface Command ()
{
    NSString* _islogin;
    BOOL _log;
}
@end

@implementation Command

- (instancetype)init
{
    self = [super init];
    if (!self) {
        
    }
    return self;
}

+ (BOOL)islogin
{
    NSString* str = [[NSUserDefaults standardUserDefaults]objectForKey:IsLogin];
    if (!IsEmptyValue1(str)&&[str integerValue] == 1) {
        return YES;
    }else{
        return NO;
    }
}

//请求到的是字符串需要处理一下
+ (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return returnString;
}

+ (BOOL)NUM:(NSString*) candidate
{
    NSString *phoneRegex = @"^[0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:candidate];
    
}

+ (NSString*)convertNull:(id)object{
    
    // 转换空串
    
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}

+ (NSString*)sendtimeChangeData:(NSString*)str
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]/ 1000.0];
    NSString *datastring = [formatter stringFromDate:date2];
    return datastring;
}


@end
