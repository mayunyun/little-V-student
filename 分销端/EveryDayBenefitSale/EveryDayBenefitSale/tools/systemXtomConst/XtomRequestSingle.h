//
//  XtomRequestSingle.h
//  BiaoBiao
//
//  Created by 山东三米 on 14-3-17.
//  Copyright (c) 2014年 山东三米. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XtomRequestSingle : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
+ (XtomRequestSingle*)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters;
- (void)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters;
//- (void)closeConnect;//手动关闭网络连接

+ (XtomRequestSingle*)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters type:(BOOL)_stringStyle;//字符串类型
@end
