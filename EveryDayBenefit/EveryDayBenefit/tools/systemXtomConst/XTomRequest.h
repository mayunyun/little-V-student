//
//  XTomRequest.h
//  MontherAndBabyApp2
//
//  Created by 李朋 on 13-4-21.
//
//

#import <Foundation/Foundation.h>

@interface XTomRequest : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

+ (XTomRequest*)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters;
- (void)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters;
//- (void)closeConnect;//手动关闭网络连接

+ (XTomRequest*)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters type:(BOOL)_stringStyle;//字符串类型

+ (XTomRequest*)requestWithAudioURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters;
- (void)requestWithAudioURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters;
+ (XTomRequest*)requestWithAudioURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters type:(BOOL)_stringStyle;

//视频
+ (XTomRequest*)requestWithVideoURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters;
+ (XTomRequest*)requestWithVideoURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters type:(BOOL)_stringStyle;
- (void)requestWithVideoURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters;
@end
