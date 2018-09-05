//
//  XtomManager.m
//  YYZZB
//
//  Created by 李朋 on 13-4-20.
//  Copyright (c) 2013年 中国山东三米. All rights reserved.
//

#import "XtomManager.h"

static XtomManager *sharedMyManager = nil;
@implementation XtomManager
@synthesize isNetConnecting;
@synthesize motherInfor;
@synthesize userID;
@synthesize userToken;
@synthesize myinitInfor;
@synthesize fromDic;
@synthesize push_aps;

- (void)dealloc {

    [motherInfor release];motherInfor = nil;
    [userID release];userID = nil;
    [userToken release];userToken = nil;
    [myinitInfor release];myinitInfor = nil;
    [push_aps release];push_aps = nil;
    [super dealloc];
}

#pragma mark 初始化
- (void)cleanInfor
{
    [motherInfor release];motherInfor = nil;
    [fromDic release];fromDic = nil;
    [userID release];userID = nil;
    [userToken release];userToken = nil;
    [push_aps release];push_aps = nil;
}
#pragma mark 自定义属性
- (id)motherInfor
{
    return motherInfor;
}

#pragma mark Singleton Methods
+ (id)sharedManager {
    
    @synchronized(self) {
        
        if(sharedMyManager == nil)
            
            sharedMyManager = [[super allocWithZone:NULL] init];
        
    }
    
    return sharedMyManager;    
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [[self sharedManager]retain];
    
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
    
}

- (id)retain {
    
    return self;
    
}

- (unsigned)retainCount {
    
    return UINT_MAX; //denotes anobject that cannot be released
    
}

- (oneway void)release {
    
    // never release
    
}

- (id)autorelease {
    
    return self;
    
}

- (id)init {
    
    if (self = [super init])
    {
        isNetConnecting = YES;
        self.fromDic = [[NSMutableDictionary alloc]init];
    }
    
    return self;
    
}

#pragma mark- 自定义
@end









