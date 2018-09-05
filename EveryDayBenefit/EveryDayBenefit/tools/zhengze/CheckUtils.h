//
//  CheckUtils.h
//  HKAirlines
//
//  Created by Tian Neo on 12-4-25.
//  Copyright (c) 2012年 bbdtek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckUtils : NSObject
//校验邮箱
+ (BOOL)isValidateEmail:(NSString *)candidate;

//校验身份证
+ (BOOL)isValidateIdCode:(NSString *)candidate;

//校验手机号
+ (BOOL)isValidatePhone:(NSString *)candidate;

+ (BOOL)isPassword:(NSString *) candidate;

//校验数字区间
+ (BOOL)isValidateNmuber:(NSString *)candidate stratIndex:(NSInteger) start endIndex:(NSInteger)end;
+ (BOOL)NUM:(NSString*) candidate;
//校验字符串长度
+ (BOOL)isValidateNmuber:(NSString *)candidate length:(NSInteger) length;

//校验仓位是否满仓
+ (BOOL)isValidateCabin:(NSString *)candidate;

+ (BOOL)isValidateUserName:(NSString *)userName ;

+ (BOOL)isValidateNum:(NSString *) candidate;
// 只能为中文或字母
+ (BOOL)isCharOnly:(NSString *)string;
/**
 *  是否为中文英文和空格
 *
 *  @param string 待校验字符串
 *
 *  @return BOOL
 */
+ (BOOL)isChineseCharacterAndLettersAndSpace:(NSString *)string;

// 验证是否为护照
+ (BOOL)isPassport:(NSString *)string;
//验证是否为军官证,士兵证
+ (BOOL)isSoldier:(NSString *)string;

// 身份证
/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
+ (BOOL)isID:(NSString *)certID;

//订单状态的汉字表现样式
+ (NSString *)orderStatusWithString:(NSString *)string;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString *)replaceOthers:(NSString *)responseString;

+ (NSString *)replaceChar:(NSString *)EnString;

+ (NSString *)getNumber:(NSString *)numString;

+ (NSDecimalNumber *)notRounding:(double)number afterPoint:(NSInteger)position;

@end
