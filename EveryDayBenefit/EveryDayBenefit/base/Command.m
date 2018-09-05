//
//  Command.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "Command.h"
#import <AVFoundation/AVFoundation.h>

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

+ (BOOL)isEmptyValueProAndCityAndArea
{
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    if (IsEmptyValue1(provinceid)||IsEmptyValue1(cityid)||IsEmptyValue1(areaid)) {
        return YES;
    }else{
        return NO;
    }
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

//+ (NSString*)minDateTonowDate:(NSString*)str
//{
//    NSDate *nowDate = [NSDate date];
//    
//    // 格式化时间
//    NSDateFormatter* dateFomatter = [[NSDateFormatter alloc] init];
//    dateFomatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
//    [dateFomatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFomatter setTimeStyle:NSDateFormatterShortStyle];
//    [dateFomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    // 毫秒值转化为秒
//    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]/ 1000.0];
//    NSString *datastring = [dateFomatter stringFromDate:date2];
//    // 截止时间字符串格式
//    NSString *expireDateStr = datastring;
//    // 当前时间字符串格式
//    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
//    // 截止时间data格式
//    NSDate *expireDate = [dateFomatter dateFromString:expireDateStr];
//    // 当前时间data格式
//    nowDate = [dateFomatter dateFromString:nowDateStr];
//    // 当前日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // 需要对比的时间数据
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
//    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    // 对比时间差
//    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
//    
//
//}

+ (void)soundCreat
{
    //1.获得音效文件的全路径
    
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"buyao.wav" withExtension:nil];
    
    //2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
    SystemSoundID soundID=0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    
    //把需要销毁的音效文件的ID传递给它既可销毁
    //AudioServicesDisposeSystemSoundID(soundID);
    
    //3.播放音效文件
    //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
    AudioServicesPlayAlertSound(soundID);
    //AudioServicesPlaySystemSound(<#SystemSoundID inSystemSoundID#>)
}

+ (CGFloat)detailLabelHeight:(NSString*)text width:(CGFloat)width fontsize:(NSInteger)index
{
    NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:index]};
    CGSize size1 =  [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    return size1.height;
}
//将html中的字符串取出来
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

//请求到的是字符串需要处理一下
+ (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return returnString;
}

// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

@end
