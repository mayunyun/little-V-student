//
//  NSString+Base64.h
//  lx
//
//  Created by 联祥 on 16/1/13.
//  Copyright © 2016年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#define __BASE64( text )        [NSString+Base64 base64StringFromText:text]
#define __TEXT( base64 )        [NSString+Base64 textFromBase64String:base64]

NS_ASSUME_NONNULL_BEGIN
@interface NSString_Base64 : NSObject


/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;
@end
NS_ASSUME_NONNULL_END
