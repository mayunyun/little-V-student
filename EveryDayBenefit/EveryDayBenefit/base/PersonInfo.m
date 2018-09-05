//
//  PersonInfo.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/10.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "PersonInfo.h"

@implementation PersonInfo
//单例类的静态实例对象，因对象需要唯一性，故只能是static类型
static PersonInfo *defaultManager = nil;

/**单例模式对外的唯一接口，用到的dispatch_once函数在一个应用程序内只会执行一次，且dispatch_once能确保线程安全
 */
+(PersonInfo*)defaultManager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(defaultManager == nil)
        {
            defaultManager = [[self alloc] init];
        }
    });
    return defaultManager;
}

/**覆盖该方法主要确保当用户通过[[Singleton alloc] init]创建对象时对象的唯一性，alloc方法会调用该方法，只不过zone参数默认为nil，因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone:zone]
 */
+(id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(defaultManager == nil)
        {
            defaultManager = [super allocWithZone:zone];
        }
    });
    return defaultManager;
}
//自定义初始化方法，本例中只有name这一属性
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.hasNet = NO;
    }
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
- (id)copy
{
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
- (id)mutableCopy
{
    return self;
}
//自定义描述信息，用于log详细打印
- (NSString *)description
{
    return [NSString stringWithFormat:@"memeory address:%p,property name:%i",self,self.hasNet];
}




@end



