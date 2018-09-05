//
//  CheckUtils.m
//  HKAirlines
//
//  Created by Tian Neo on 12-4-25.
//  Copyright (c) 2012年 bbdtek. All rights reserved.
//

#import "CheckUtils.h"

@implementation CheckUtils
//校验邮箱
+ (BOOL)isValidateEmail:(NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

//校验身份证
+ (BOOL)isValidateIdCode:(NSString *) candidate {
    //NSString *idCodeRegex = @"((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])| (5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}";
    
    NSString *idCodeRegex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *idCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCodeRegex];
	
    return [idCodeTest evaluateWithObject:candidate];
}

//1-36位数字
+ (BOOL)isValidateNum:(NSString *) candidate {
    NSString *phoneRegex = @"^[0-9]{1,36}+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:candidate];
}

//校验手机号
+ (BOOL)isValidatePhone:(NSString *) candidate {
//    NSString *phoneRegex = @"(13[0-9]|14[7]|15[0-9]|17[0-9]|18[0|2|3|5|6|7|8|9])\\d{8}";
    NSString *phoneRegex = @"^1(3|4|5|7|8)\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex]; 
    return [phoneTest evaluateWithObject:candidate];
}


+ (BOOL)isPassword:(NSString *) candidate
{
    NSString *      regex = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:candidate];
}


//校验数字区间
+ (BOOL)isValidateNmuber:(NSString *)candidate stratIndex:(NSInteger) start endIndex:(NSInteger)end

{
    NSString *numberRegex =[NSString stringWithFormat:@"\\w{%ld,%ld}",(long)start,(long)end];
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)NUM:(NSString*) candidate
{
    NSString *phoneRegex = @"^[0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:candidate];

}

//校验字符串长度
+ (BOOL)isValidateNmuber:(NSString *)candidate length:(NSInteger) length

{
    NSString *numberRegex =[NSString stringWithFormat:@"\\w{%ld}",(long)length];
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [emailTest evaluateWithObject:candidate];
}

//校验仓位是否满仓
+ (BOOL)isValidateCabin:(NSString *)candidate {
    NSString *regex = @"[A1-9]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:candidate];
}

//检验英文姓名
+ (BOOL)isValidateUserName:(NSString *)userName {
    NSString * regex        = @"^[A-Za-z]{2,35}";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:userName];
}

// 只能为中文或字母
+ (BOOL)isCharOnly:(NSString *)string
{
    NSString *Regex = @"^[A-Za-z|\u4e00-\u9fa5]+$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:string];
}

+ (BOOL)isChineseCharacterAndLettersAndSpace:(NSString *)string
{
    NSInteger len=string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if(!(isalpha(a)
             ||(a==' ')
             ||(a==0x2006)
             ||(a>=0x2700 && a<0x2800) //输入法插入的不可见字符
             ||(a >= 0x4e00 && a <= 0x9fa6)
             ))
            return NO;
    }
    return YES;
}

// 验证是否为护照
+ (BOOL)isPassport:(NSString *)string
{
    return [self lengthIn:5 max:20 string:string] && [self regexMatches:@"^[a-zA-Z0-9]+$" string:string]&& [self regexMatches:@"^.*[0-9]+.*$" string:string];
}

//验证是否为军官证,士兵证
+ (BOOL)isSoldier:(NSString *)string
{
    return [self lengthIn:5 max:20 string:string];
}


// 身份证
/**
 * 功能:验证身份证是否合法
 * 参数:输入的身份证号
 */
+ (BOOL)isID:(NSString *)certID
{
   // NSLog(@"validateID.id=%@,length=%lu", certID, (unsigned long)certID.length);
    //add by liliumei 2014-12-04 使小x也能验证通过
    certID = [certID stringByReplacingOccurrencesOfString:@"x" withString:@"X"];
    
    //判断位数
    if (certID.length != 15 && certID.length != 18) {
        return NO;
    }
    
    NSString *carid = certID;
    long lSumQT =0;
    //加权因子
    int R[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11] = {'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:certID];
    if ([certID length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    //年份
    int strYear = [[self getStringWithLocation:6 length:4 withString:certID] intValue];
    //月份
    int strMonth = [[self getStringWithLocation:10 length:2 withString:certID] intValue];
    //日
    int strDay = [[self getStringWithLocation:12 length:2 withString:certID] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    //校验数字
    for (int i=0; i<18; i++)
    {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
        {
            return NO;
        }
    }
    //验证最末的校验码
    for (int i=0; i<=16; i++)
    {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] )
    {
        return NO;
    }
    
    return YES;
}
+ (BOOL)lengthIn:(int)min max:(int)max string:(NSString *)string
{
    return string.length >= min && string.length <= max;
}
//正则匹配
+ (BOOL)regexMatches:(NSString *)regex string:(NSString *)string
{
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:string];
}

/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */
+ (NSString *)getStringWithLocation:(NSUInteger)start length:(NSUInteger )length withString:(NSString *)str
{
    return [str substringWithRange:NSMakeRange(start, length)];
}

/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
+(BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

//订单状态的汉字表现样式
+ (NSString *)orderStatusWithString:(NSString *)string
{
    NSString *tempStr = [NSString string];
    NSString *subStr = [string substringWithRange:NSMakeRange(0, 1)];
    if ([subStr isEqualToString:@"0"]&&string.length>1) {
        switch ([string intValue]) {
            case 0:
                tempStr = @"订座成功";
                break;
            case 1:
                tempStr = @"已取消";
                break;
            case 2:
                tempStr = @"出票成功";
                break;
            case 3:
                tempStr = @"出票失败";
                break;
            case 4:
                tempStr = @"已退款";
                break;
            case 5:
                tempStr = @"订座失败";
                break;
            case 6:
                tempStr = @"改签申请中";
                break;
            case 7:
                tempStr = @"升舱申请中";
                break;
            case 8:
                tempStr = @"退票申请中";
                break;
            case 9:
                tempStr = @"全部退票";
                break;
                
            default:
                break;
        }
    }else if ([subStr isEqualToString:@"-"]) {
        tempStr = @"已取消";
    }else if ([subStr isEqualToString:@"9"]){
        tempStr = @"订单取消";
    }else{
        switch ([string intValue]) {
            case 0:
//                tempStr = @"未支付");
                tempStr = @"待确认";//申请中
                break;
            case 1:
                tempStr = @"订座成功";//与"等待支付"是一回事
                break;
            case 2:
                tempStr = @"等待出票";//支付成功
                break;
            case 3:
                tempStr = @"出票完成";
                break;
            case 4:
                tempStr = @"支付宝申请退费";
                break;
            case 5:
                tempStr = @"退款成功";
                break;
            case 6:
                tempStr = @"已取消";
                break;
            case 7:
                tempStr = @"暂时不能出票";
                break;
            case 8:
                tempStr = @"退票已审核，等待退款";
                break;
//            case 9:
//                tempStr = @"出票完成，申请退费";
//                break;
            case 10:
                tempStr = @"出票完成，申请退费";//退票处理中
                break;
            case 11:
                tempStr = @"出票中";
                break;
            case 12:
                tempStr = @"订单作废";
                break;
            case 13:
                tempStr = @"暂不能退费票";
                break;
            case 14:
                tempStr = @"等待审核退费票";
                break;
            case 15:
                tempStr = @"PNR生成失败";
                break;
            case 16:
                tempStr = @"等待PNR生成";
                break;
            case 17:
                tempStr = @"已审核退废票";
                break;
            case 18:
                tempStr = @"等待供应审核特价票";
                break;
            case 19:
                tempStr = @"供应审核未通过特价票";
                break;
            case 22:
                tempStr = @"等待竞标";
                break;
            case 23:
                tempStr = @"预订失败";
                break;
            case 24:
                tempStr = @"退票中";
                break;
            case 25:
                tempStr = @"部分退票中";
                break;
            case 26:
                tempStr = @"退票成功";
                break;
            case 27:
                tempStr = @"部分退票成功";
                break;
            case 9999:
                tempStr = @"订单错误";
                break;
            default:
                break;
        }
    }
    return tempStr;
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0125-9]|7[0])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (NSString *)replaceOthers:(NSString *)responseString
{
    
    responseString = [responseString substringWithRange:NSMakeRange(1, responseString.length-2)];
    return responseString;
}


+ (NSString *)replaceChar:(NSString *)EnString
{
    NSString *returnString = [EnString stringByReplacingOccurrencesOfString:@"+" withString:@"＋"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"%" withString:@"％"];
    return returnString;
}

+ (NSString *)getNumber:(NSString *)numString{
    
    NSString *numStr;
    //转double
    double m ;
    m = [numString doubleValue];
    //转int
    int n;
    n = [numString intValue];
    //判断是否进位
    if ((m-n) < 0.5 ) {
        numStr = [NSString stringWithFormat:@"%zi",n];
    }else{
        numStr = [NSString stringWithFormat:@"%zi",n + 1];
    }
    return numStr;
}


+ (NSDecimalNumber *)notRounding:(double)number afterPoint:(NSInteger)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return ouncesDecimal;
}

@end
