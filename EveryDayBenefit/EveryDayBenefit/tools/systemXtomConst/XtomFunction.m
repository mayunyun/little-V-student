//
//  XtomFunction.m
//  WhbHelloWorld
//
//  Created by 山东三米 on 13-4-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "XtomFunction.h"
#import "Reachability.h"

@interface  XtomFunction()

@end
NS_ASSUME_NONNULL_BEGIN
@implementation XtomFunction

-(void)dealloc
{
    [super dealloc];
}


//全局函数==================================================================================

#pragma mark- 字符串相关
//隐藏手机号码的中间四位
+(NSString *)handleMobileNumber:(NSString *)number
{
    NSString *first = @"";
    NSString *last = @"";
    if (number != nil)
    {
        first = [[number substringFromIndex:0]substringToIndex:3];
        last = [[number substringFromIndex:7]substringToIndex:4];
        number = [NSString stringWithFormat:@"%@****%@",first,last];
    }
    return number;
}
//获取text文本高度(厚字体)
+ (CGSize)getSizeWithStr:(NSString*)str width:(float)width font:(float)font
{
    //CGSize temSize = [@" " sizeWithFont:[UIFont boldSystemFontOfSize:font] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:font]};
    CGSize temSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                               attributes:attribute        // 文字的属性
                                                  context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    
    if(![XtomFunction xfunc_check_strEmpty:str])
    {
        //temSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:font] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        temSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:attribute        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    }
    return temSize;
}
//获取text文本高度(正常字体)
+ (CGSize)getSizeWithStrNo:(NSString*)str width:(float)width font:(float)font
{
    //CGSize temSize = [@" " sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize temSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                    attributes:attribute        // 文字的属性
                                       context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    if(![XtomFunction xfunc_check_strEmpty:str])
    {
        //temSize = [str sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        temSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                 attributes:attribute        // 文字的属性
                                    context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    }
    return temSize;
}
+ (NSString*)getSecreatMobile:(NSString*)_mobile//获取隐藏的手机号
{
    if (_mobile.length<11)
    {
        return @"无";
    }
    NSRange temRange = NSMakeRange(3, 4);
    NSString *star = @"";
    for(int i = 0;i<temRange.length;i++)
    {
        star = [NSString stringWithFormat:@"%@*",star];
    }
    _mobile = [_mobile stringByReplacingCharactersInRange:temRange withString:star];
    return _mobile;
}

+ (NSString*)getSecreatEmail:(NSString*)_email//获取隐藏的邮箱号
{
    NSRange range = [_email rangeOfString:@"@"];
    if(range.length >0)
    {
        NSArray *emailArr = [_email componentsSeparatedByString:@"@"];
        NSString *temName = [emailArr objectAtIndex:0];
        int fromLen = (int)(temName.length/3);
        int middleLen = (int)(temName.length - fromLen*2);
        NSString *temStar = @"";
        for(int i = 0;i<middleLen;i++)
        {
            temStar = [NSString stringWithFormat:@"%@*",temStar];
        }
        NSRange temRange = NSMakeRange(fromLen, middleLen);
        temName = [temName stringByReplacingCharactersInRange:temRange withString:temStar];
        _email = [NSString stringWithFormat:@"%@@%@",temName,[emailArr objectAtIndex:1]];
    }
    return _email;
}
//获取字符串 为空返回@“”
+ (NSString*)getString:(id)value
{
    NSString *returnStr = @"";
    if(![XtomFunction xfunc_check_strEmpty:value])
    {
        returnStr = value;
    }
    return returnStr;
}

//函数功能：字符串判空
+(Boolean) xfunc_check_strEmpty:(NSString *) parmStr
{
    if (!parmStr) {
        return YES;
    }
    if ([parmStr isEqual:nil]) {
        return YES;
    }
    if ([parmStr isEqual:@""]) {
        return YES;
    }
    id tempStr=parmStr;
    if (tempStr==[NSNull null]) {
        return YES;
    }
    return NO;
}
+(Boolean)panDuanShiFouWeiKong:(NSString*)str
{
    if (str.length !=0) {
        return YES;
    }
    if (str == NULL) {
        return NO;
    }
    return NO;
}
//函数功能：字符串判空(手机号判断 废弃 用下一个函数)
+(Boolean) xfunc_check_mobile:(NSString *) parmStr
{
    if ([parmStr length]!=11) {
        [XtomFunction xfunc_show_msg:@"手机号码格式错误！"];
        return NO;
    }
    return YES;
    
}

+ (BOOL)xfunc_isMobileNumber:(NSString *)mobileNum
{
    NSString * myphone = @"^1\\d{10}$";
    NSPredicate *regextestmyphone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myphone];
    if ([regextestmyphone evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
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
    //NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)xfunc_isEmail:(NSString*)email
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:email];
}

//获取固定宽度的字符串存放长度的个数
+ (int)getLineSize:(NSString *)content startIndex:(int)start width:(float)width font:(float)font
{
    CFAttributedStringRef attrString;
    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:content];
    //创建字体及字号
    UIFont* temFont = [UIFont systemFontOfSize:font];
    CTFontRef helvetica = CTFontCreateWithName((CFStringRef)temFont.fontName, temFont.pointSize, NULL);
    //将字体设置给attributeString
    [astr addAttribute:(id)kCTFontAttributeName
                 value:(id)helvetica
                 range:NSMakeRange(0, [astr length])];
    CFRelease(helvetica);
    attrString = (CFAttributedStringRef)astr;
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString(attrString);
    CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, width);
    [astr release];
    CFRelease(typesetter);
    
    return (int)count;
}
//获取公里数
+ (NSString*)getDistance:(float)distance
{
    NSString *temStr;
    /*
     if (distance >= 1000)
     {
     temStr = [NSString stringWithFormat:@"%f",distance/1000];
     temStr = [temStr substringWithRange:NSMakeRange(0, temStr.length-7)];
     temStr = [NSString stringWithFormat:@"%@千米",temStr];
     }else
     {
     temStr = [NSString stringWithFormat:@"%f",distance];
     temStr = [temStr substringWithRange:NSMakeRange(0, temStr.length-7)];
     temStr = [NSString stringWithFormat:@"%@米",temStr];
     }
     */
    temStr = [NSString stringWithFormat:@"%f",distance/1000];
    if (distance/1000>=100)
    {
        temStr = [temStr substringWithRange:NSMakeRange(0, temStr.length-7)];
    }else
    {
        temStr = [temStr substringWithRange:NSMakeRange(0, temStr.length-4)];
    }
    
    
    //NSLog(@"temStr:%@",temStr);
    return temStr;
}
//经纬度之间的距离
+(double)distanceBetweenOrderBy:(double)lat1 :(double)lng1 :(double)lat2 :(double)lng2
{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}
//获取一个随机数
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from+(arc4random()%(to-from+1))); //+1,result is [from to]; else is [from, to)!!!!!!!
}
#pragma mark- 时间相关

//获取当前时间
+ (NSDate *)xfunc_get_now
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSDate*)getDateNow
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString*)getStringNow
{
    NSDate *date = [NSDate date];
    //NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //NSInteger interval = [zone secondsFromGMTForDate: date];
    //NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    //NSLog(@"如今时间:%@",dateStr);
    return dateStr;
}

+ (NSString*)getStringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateStr;
}

+(NSString  *)  xfunc_get_time
{
    return @"03:55";
}

//是否大于当前时间

// 获取操作在多久之前(用于发表话题、帖子、评论时)
+(NSString *)getTimeFromDate:(NSString *)fromDate
{
    if ([XtomFunction xfunc_check_strEmpty:fromDate])
    {
        return @"今天";
    }
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:fromDate];
    [dateFormatter release];
    
    NSString *nowdate = [XtomFunction getStringNow];
    NSRange temRange = NSMakeRange(0, 10);
    NSString *timeStrNow = [nowdate substringWithRange:temRange];
    NSString *timeStrOld = [fromDate substringWithRange:temRange];
    
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags=NSHourCalendarUnit|NSMinuteCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dateComponent=[calendar components:unitFlags fromDate:oldDate toDate:date options:0];
    [calendar release];
    //NSInteger difMonth=[dateComponent month];
    //NSInteger difDay=[dateComponent day];
    NSInteger difHour=[dateComponent hour];
    NSInteger diffMin=[dateComponent minute];
    NSString *timer = nil;
    
    if ([timeStrNow isEqualToString:timeStrOld])//当天的
    {
        if (difHour == 0)//不到一个小时
        {
            if (diffMin == 0)
            {
                timer=[NSString stringWithFormat:@"刚刚"];
            }else
            {
                timer=[NSString stringWithFormat:@"%d分钟前",(int)diffMin];
            }
            
        }else
            timer=[NSString stringWithFormat:@"今天%@",[fromDate substringWithRange:NSMakeRange(11, 5)]];
    }else
    {
        temRange = NSMakeRange(0, 4);
        timeStrNow = [nowdate substringWithRange:temRange];
        timeStrOld = [fromDate substringWithRange:temRange];
        if ([timeStrNow isEqualToString:timeStrOld])//今年的
            timer=[NSString stringWithFormat:@"%@",[fromDate substringWithRange:NSMakeRange(5, 11)]];
        else
            timer=[NSString stringWithFormat:@"%@",[fromDate substringWithRange:NSMakeRange(0, 10)]];
    }
    return timer;
}
// 获取操作在多久之前(用于及时聊天时)
+(NSString *)getTimeFromDateChat:(NSString *)fromDate
{
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:fromDate];
    [dateFormatter release];
    
    NSString *nowdate = [XtomFunction getStringNow];
    NSRange temRange = NSMakeRange(0, 10);
    NSString *timeStrNow = [nowdate substringWithRange:temRange];
    NSString *timeStrOld = [fromDate substringWithRange:temRange];
    
    NSCalendar *calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags=NSHourCalendarUnit|NSMinuteCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dateComponent=[calendar components:unitFlags fromDate:oldDate toDate:date options:0];
    [calendar release];
    //NSInteger difMonth=[dateComponent month];
    //NSInteger difDay=[dateComponent day];
    NSInteger difHour=[dateComponent hour];
    NSInteger diffMin=[dateComponent minute];
    NSString *timer = nil;
    
    if ([timeStrNow isEqualToString:timeStrOld])//当天的
    {
        if (difHour == 0)//不到一个小时
        {
            if (diffMin == 0)
            {
                timer=[NSString stringWithFormat:@"刚刚"];
            }else
            {
                timer=[NSString stringWithFormat:@"%d分钟前",(int)diffMin];
            }
            
        }else
            timer=[NSString stringWithFormat:@"今天%@",[fromDate substringWithRange:NSMakeRange(11, 5)]];
    }else
    {
        temRange = NSMakeRange(0, 4);
        timeStrNow = [nowdate substringWithRange:temRange];
        timeStrOld = [fromDate substringWithRange:temRange];
        if ([timeStrNow isEqualToString:timeStrOld])//今年的
            timer=[NSString stringWithFormat:@"%@",[fromDate substringWithRange:NSMakeRange(5, 11)]];
        else
            timer=[NSString stringWithFormat:@"%@",[fromDate substringWithRange:NSMakeRange(0, 10)]];
    }
    return timer;
}
//获取时间差
+ (CGFloat)getDateDifference:(NSString*)oldDateStr newDate:(NSString*)newDateStr
{
    CGFloat timeDifference = 0.0;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [formatter dateFromString:oldDateStr];
    NSDate *newDate = [formatter dateFromString:newDateStr];
    NSTimeInterval oldTime = [oldDate timeIntervalSince1970];
    NSTimeInterval newTime = [newDate timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}


//函数功能：打开一个含提示信息的系统弹窗
+(void) xfunc_show_msg:(NSString *)parmStr
{
    NSString *msgStr = [NSString stringWithFormat:@"%@%@", @"\n\n", parmStr];
    //对话框控件==================================================================================
    UIAlertView * xtomAlert= [[UIAlertView alloc] initWithTitle:@"系统提示" message:msgStr delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    //[xtomAlert addButtonWithTitle:@"取消"];    //添加取消按钮
    
    [xtomAlert show];   //将这个UIAlerView 显示出来
    //固定显示3秒后自动关闭
    [self performSelector:@selector(msgCloseHandler:) withObject:xtomAlert afterDelay:3];
    [xtomAlert release];
    
}

//函数功能：中间函数（源自：xfunc_show_msg）
+(void)msgCloseHandler:(UIAlertView *)parmAlert
{
    if(parmAlert!=nil)
    {
        [parmAlert dismissWithClickedButtonIndex:0 animated:YES];  //退出Alert对话框
    }
}

#pragma mark- 视图相关
//寻找子view
+ (UIView *)findView:(UIView *)aView withName:(NSString *)name
{
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;
}
//添加阴影 以下两个方法主要用于筛选框
+ (void)addShadowToView:(UIView*)view
{
    UIColor *temColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1];
    view.backgroundColor = temColor;
    
    CALayer *temLayer = [view layer];
    
    [temLayer setCornerRadius:5];
    
    [temLayer setShadowOffset:CGSizeMake(0, 1.5)];
    [temLayer setShadowColor:[UIColor blackColor].CGColor];
    [temLayer setShadowRadius:3];
    [temLayer setShadowOpacity:0.8];
}



//设置选择样式
+ (void)setCellSelectedStyle:(UITableViewCell*)cell
{
    cell.contentView.backgroundColor = BB_Blake;
}

//添加边角
+ (BOOL)addBorderToView:(UIView*)view
{
    CALayer *layer = [view layer];
    [layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [layer setBorderWidth:0.5];
    [layer setCornerRadius:4];
    [layer setMasksToBounds:YES];
    return YES;
}

+ (BOOL)addBorderToView:(UIView*)view borderWidth:(CGFloat)width
{
    CALayer *layer = [view layer];
    [layer setBorderColor:[UIColor whiteColor].CGColor];
    [layer setBorderWidth:width];
    [layer setMasksToBounds:YES];
    return YES;
}

+ (BOOL)addbordertoView:(UIView*)view radius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color
{
    CALayer *layer = [view layer];
    [layer setBorderColor:color.CGColor];
    [layer setBorderWidth:width];
    [layer setCornerRadius:radius];
    [layer setMasksToBounds:YES];
    return YES;
}
//隐藏tabBar
+ (BOOL) hideTabBar:(UITabBarController *) tabbarcontroller duration:(NSTimeInterval)duration
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            //NSLog(@"height:%f",view.frame.size.height);
            [view setFrame:CGRectMake(view.frame.origin.x-320, UI_View_Hieght+64-BB_TabBar_Height, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, UI_View_Hieght+64)];
        }
    }
    [UIView commitAnimations];
    return YES;
    
}

//显示tabBar
+ (BOOL) showTabBar:(UITabBarController *) tabbarcontroller duration:(NSTimeInterval)duration
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(0, (UI_View_Hieght+64-BB_TabBar_Height), view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,(UI_View_Hieght+64-BB_TabBar_Height))];
        }
    }
    
    [UIView commitAnimations];
    return YES;
}

//获取导航标题
+ (UIView*)getTitlView:(NSString*)title target:(id)target action:(SEL)action
{
    NSString *str2 = title;
    //CGSize size2 = [str2 sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]};
    CGSize size2 = [str2 boundingRectWithSize:CGSizeMake(300, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                    attributes:attribute        // 文字的属性
                                       context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    titleBtn.frame = CGRectMake(0, 0, size2.width+40.0f, 44);
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, size2.width, 44)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = title;
    titleLab.shadowColor = [UIColor darkGrayColor];
    titleLab.shadowOffset = CGSizeMake(0, -1);
    [titleBtn addSubview:titleLab];[titleLab release];
    
    UIImageView *titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(size2.width+20+8, 20, 12, 7)];
    titleImgView.image = [UIImage imageNamed:@"筛选三角下.png"];
    titleImgView.tag = 999;
    [titleBtn addSubview:titleImgView];[titleImgView release];
    
    UIImageView *filterImgView = [[UIImageView alloc] init];
    filterImgView.image = [UIImage imageNamed:@"下拉菜单三角.png"];
    filterImgView.tag = 998;
    [titleBtn addSubview:filterImgView];[filterImgView release];
    filterImgView.frame = CGRectMake(size2.width/2+20-8, 38, 16, 8);
    filterImgView.hidden = YES;
    
    return titleBtn;
}

//函数功能：返回一个右侧按钮
+ (UIBarButtonItem*)getPlainButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action
{
    UIImage *rightImage = [UIImage imageNamed:@"next1"];
    UIImage *rightImagePressed = [UIImage imageNamed:@"next2"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [rightButton setBackgroundImage:rightImagePressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    return [rightButton autorelease];
}

//函数功能：返回一个左侧按钮
+ (UIBarButtonItem*)getBackButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action
{
    UIImage *BackImage = [UIImage imageNamed:@"back1"];
    UIImage *BackImagePressed = [UIImage imageNamed:@"back2"];
    UIBarButtonItem *BackButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [BackButton setBackgroundImage:BackImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [BackButton setBackgroundImage:BackImagePressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    return [BackButton autorelease];
}


#pragma mark 对UIView 添加动画
+(void)xfunc_BeginAnimations:(NSTimeInterval)duration view:(UIView*)view withHandler:(void(^)(UIView * temView))block
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:nil cache:NO];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:nil];
    block(view);
    [UIView commitAnimations];
}
//大图查看动画
+(void)pushToView:(UIViewController*)myView nav:(UINavigationController*)nav
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5f];
    [animation setType: kCATransitionFade];
    [animation setSubtype: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [nav pushViewController:myView animated:NO];
    [nav.view.layer addAnimation:animation forKey:nil];
}
#pragma mark 图片相关
//绘制阴影
+ (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius
                       color:(UIColor *)color opacity:(CGFloat)opacity view:(UIView*)myview
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, myview.bounds);
    myview.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    myview.layer.shadowColor = color.CGColor;
    myview.layer.shadowOffset = offset;
    myview.layer.shadowRadius = radius;
    myview.layer.shadowOpacity = opacity;
    
    myview.clipsToBounds = NO;
}
//绘制四周阴影
+ (void)dropShadow:(CGSize)offset radius:(CGFloat)radius
             color:(UIColor *)color opacity:(CGFloat)opacity view:(UIView*)myview
{
    myview.layer.shadowColor = color.CGColor;//shadowColor阴影颜色
    myview.layer.shadowOffset = offset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    myview.layer.shadowOpacity = opacity;//阴影透明度，默认0
    myview.layer.shadowRadius = radius;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = myview.bounds.size.width;
    float height = myview.bounds.size.height;
    float x = myview.bounds.origin.x;
    float y = myview.bounds.origin.y;
    float addWH = 1;
    
    CGPoint topLeft      = myview.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    myview.layer.shadowPath = path.CGPath;
}
//等比缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scale

{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scale, image.size.height*scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width*scale, image.size.height*scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//自定长宽
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
//剪切view
+ (UIImage*)captureView:(UIView *)aView

{
    CGRect rect = aView.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//获取一个纯色图片
+(UIImage*)getImageWithSize:(CGSize)contentSize color:(UIColor*)color
{
    //初始化画布
    UIGraphicsBeginImageContext(contentSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, contentSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //fill color
    CGColorRef fillColor = color.CGColor;
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, contentSize.height);
    CGContextAddLineToPoint(context, 0.0f, contentSize.height);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
//拍照或者从相册获取图片结束后裁剪图片
+(UIImage*)getImage:(UIImage*)image
{
    CGFloat scale = image.size.width>image.size.height?640/image.size.width:640/image.size.height;
    UIImage *temImg = image;
    if(scale < 1)
    {
        temImg = [XtomFunction scaleImage:image toScale:scale];
    }
    return temImg;
}
//添加上下黑边的方法
+(UIImage*)imageToSquare:(UIImage*)image
{
    if(image.size.width <= image.size.height)
    {
        return image;
    }
    CGSize contentSize = CGSizeMake(image.size.width, image.size.width);
    CGFloat yCoordinate = (contentSize.height-image.size.height)/2;//NSLog(@"y:%f",yCoordinate);
    
    //初始化画布
    UIGraphicsBeginImageContext(contentSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, contentSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //fill color
    CGColorRef fillColor = [[UIColor clearColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, 0.0f);
    CGContextAddLineToPoint(context, contentSize.width, contentSize.height);
    CGContextAddLineToPoint(context, 0.0f, contentSize.height);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    //画图
    CGContextDrawImage(context, CGRectMake(0.0, yCoordinate, contentSize.width, image.size.height), image.CGImage);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
+ (UIImage*)getFangImage:(UIImage*)oldImage wantSize:(CGSize)wantSize
{
    UIGraphicsBeginImageContext(wantSize);//打开画布
    CGFloat scale;//老图片与显示框的比率
    CGFloat temHeight = 0.0;//新图片的高度
    CGFloat temWidth = 0.0;
    if(oldImage.size.width>oldImage.size.height)
    {
        scale = oldImage.size.height/wantSize.height;
        temHeight = scale>1?oldImage.size.height/scale:oldImage.size.height;
        temWidth = scale>1?oldImage.size.width/scale:oldImage.size.width;
    }
    else
    {
        scale = oldImage.size.width/wantSize.width;
        temHeight = oldImage.size.height/scale;
        temWidth = oldImage.size.width/scale;
    }
    
    CGFloat temY = (wantSize.height - temHeight)/2;
    CGFloat temX = (wantSize.width - temWidth)/2;
    [oldImage drawInRect:CGRectMake(temX, temY, temWidth, temHeight)];
    
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//对图片进行旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
//图形上下文方法
+(UIImage*)getMapImage:(UIImage*)myimg
{
    //获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //保存这个上下文，因为我们需要上下翻转它
    //CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    UIImage *image = [UIImage imageNamed:@"地图头像.png"];
    UIImage *imagecore = myimg;
    CGSize sz = [image size];
    CGSize szcore = [imagecore size];
    
    CGImageRef imageLeft = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, sz.width, sz.height));//获取图片左侧部分
    CGImageRef imageRight = CGImageCreateWithImageInRect([imagecore CGImage], CGRectMake(0, 0, szcore.width, szcore.height));//获取图片右侧部分
    UIGraphicsBeginImageContext(CGSizeMake(sz.width, sz.height));//指定要绘画图片的大小
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(con, 0, sz.height);
    CGContextScaleCTM(con, 1.0, -1.0);      //向上翻转图像上下文
    
    //绘制图片  con:绘制图片的上下文  CGRectMake:图片的原点和大小  imageLeft:当前的CGImage
    CGContextDrawImage(con, CGRectMake(13, sz.height/2-2, szcore.width*0.4+2, szcore.height*0.4+2), imageRight);
    CGContextDrawImage(con, CGRectMake(0, 0, sz.width, sz.height), imageLeft);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    return img;
}
+(UIImage*)getMapImageByUrl:(NSString*)imgurl
{
    UIImageView *temImg = [[[UIImageView alloc]init]autorelease];
    temImg.backgroundColor = [UIColor clearColor];
    [temImg setImage:[UIImage imageNamed:@"默认图标其它.png"]];
    
    if(![XtomFunction xfunc_check_strEmpty:imgurl])
    {
        NSString *document = [NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_AVATAR];
        [[XtomCashManager sharedManager] addImgToImgViewFromDocumentORURL:temImg document:document url:imgurl];
    }else
    {
        [temImg setImage:[UIImage imageNamed:@"默认图标其它.png"]];
        UIImage *image = [UIImage imageNamed:@"新其它.png"];
        return image;
    }
    
    //获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //保存这个上下文，因为我们需要上下翻转它
    //CGContextSaveGState(context);
    UIGraphicsPushContext(context);
    
    UIImage *image = [UIImage imageNamed:@"新地点.png"];
    UIImage *imagecore = temImg.image;
    CGSize sz = [image size];
    CGSize szcore = [imagecore size];
    
    CGImageRef imageLeft = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 0, sz.width, sz.height));//获取图片左侧部分
    CGImageRef imageRight = CGImageCreateWithImageInRect([imagecore CGImage], CGRectMake(0, 0, szcore.width, szcore.height));//获取图片右侧部分
    UIGraphicsBeginImageContext(CGSizeMake(sz.width, sz.height));//指定要绘画图片的大小
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(con, 0, sz.height);
    CGContextScaleCTM(con, 1.0, -1.0);      //向上翻转图像上下文
    
    //绘制图片  con:绘制图片的上下文  CGRectMake:图片的原点和大小  imageLeft:当前的CGImage
    CGContextDrawImage(con, CGRectMake(0, 0, sz.width, sz.height), imageLeft);
    CGContextDrawImage(con, CGRectMake(10, 40, szcore.width/2.3, szcore.height/2.3), imageRight);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    return img;
    
    //return temImg.image;
}
//更改图片的颜色
+(UIImage *)invertImage:(UIImage *)originalImage myColor:(UIColor*)myColor
{
    UIGraphicsBeginImageContext(originalImage.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    CGRect imageRect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    [originalImage drawInRect:imageRect];
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, originalImage.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    CGContextClipToMask(UIGraphicsGetCurrentContext(), imageRect,  originalImage.CGImage);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),myColor.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, originalImage.size.width, originalImage.size.height));
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;
}
#pragma mark 弹窗相关
//显示黑色等待弹窗
+ (MBProgressHUD*)openHUD:(NSString*)message view:(UIView*)myview
{
    //MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:myview];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:[XtomFunction xfuncGetAppdelegate].window];
    //[myview addSubview:HUD];
    [[XtomFunction xfuncGetAppdelegate].window addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.yOffset = -50.0f;
    [HUD show:YES];
    return HUD;
}
+ (void)closeHUD:(MBProgressHUD*)HUD
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
    [HUD release];
}
//显示黑色定时弹窗 view
+ (void)openIntervalHUD:(NSString*)message view:(UIView*)myview
{
    MBProgressHUD *HUD;
    //HUD = [[MBProgressHUD alloc] initWithView:myview];
    HUD = [[MBProgressHUD alloc] initWithWindow:[XtomFunction xfuncGetAppdelegate].window];
    //[myview addSubview:HUD];
    [[XtomFunction xfuncGetAppdelegate].window addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeText;
    //HUD.color = [UIColor redColor];
    //HUD.mode = MBProgressHUDModeCustomView;
    //HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"勾选.png"]] autorelease];
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    HUD.yOffset = -50.0f;
    //HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.8);
    } completionBlock:^{
        [HUD removeFromSuperview];
        [HUD release];
    }];
}
//显示黑色定时弹窗(带对勾的表示发表成功之类的)
+ (void)openIntervalHUDOK:(NSString*)message view:(UIView*)myview
{
    MBProgressHUD *HUD;
    //HUD = [[MBProgressHUD alloc] initWithView:myview];
    //[myview addSubview:HUD];
    HUD = [[MBProgressHUD alloc] initWithWindow:[XtomFunction xfuncGetAppdelegate].window];
    [[XtomFunction xfuncGetAppdelegate].window addSubview:HUD];
    
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"对号.png"]] autorelease];
    HUD.yOffset = -50.0f;
    //HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1.5);
    } completionBlock:^{
        [HUD removeFromSuperview];
        [HUD release];
    }];
}

+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title target:(id)target type:(NSUInteger)type
{
    UIAlertView *alert = nil;
    
    //type: 0 等待; 1带取消按钮
    if(0 == type)
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];[alert release];
        //UIFont *font = [UIFont systemFontOfSize:14];//UILabel.font
        UILabel *lab = [[UILabel alloc] init];
        //CGSize size = [title sizeWithFont:lab.font];
        NSDictionary *attribute = @{NSFontAttributeName: lab.font};
        CGSize size = [title boundingRectWithSize:CGSizeMake(300, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:attribute        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
        
        lab.frame = CGRectMake(0, 0, size.width+20, size.height+30);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = title;lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor clearColor];
        alert.bounds = CGRectMake(0, 0, lab.frame.size.width, size.height+30+30);
        [alert addSubview:lab];[lab release];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //indicatorView.center = alert.center;
        indicatorView.center = CGPointMake(alert.bounds.size.width/2, size.height+30);
        [alert addSubview:indicatorView];[indicatorView release];
        [indicatorView startAnimating];
    }
    if(1 == type)
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:title delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];[alert release];
    }
    
    
    return alert;
}

+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title message:(NSString*)msg target:(id)target type:(NSUInteger)type
{
    UIAlertView *alert = nil;
    
    //type: 0 等待; 1带取消按钮
    if(0 == type)
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];[alert release];
        //UIFont *font = [UIFont systemFontOfSize:14];//UILabel.font
        UILabel *lab = [[UILabel alloc] init];
        NSString *myTitle = title?title:msg;
        //CGSize size = [myTitle sizeWithFont:lab.font];
        NSDictionary *attribute = @{NSFontAttributeName: lab.font};
        CGSize size = [title boundingRectWithSize:CGSizeMake(300, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                       attributes:attribute        // 文字的属性
                                          context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
        
        lab.frame = CGRectMake(0, 0, size.width+60, size.height+30);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = myTitle;
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor clearColor];
        alert.bounds = CGRectMake(0, 0, lab.frame.size.width, size.height+30+30);
        [alert addSubview:lab];[lab release];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //indicatorView.center = alert.center;
        indicatorView.center = CGPointMake(alert.bounds.size.width/2, size.height+30);
        [alert addSubview:indicatorView];[indicatorView release];
        [indicatorView startAnimating];
    }
    if(1 == type)
    {
        alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:target cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];[alert release];
    }
    
    return alert;
}

#pragma mark- 获取系统变量
//获取主appdelegate
+ (AppDelegate*)xfuncGetAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+ (XtomManager*)xfuncGetXtomManager
{
    return [XtomManager sharedManager];
}
//获得后台服务根目录
+ (NSString*)getRootPath
{
    NSString *url = [[[XtomManager sharedManager] myinitInfor] objectForKey:@"sys_web_service"];
    if ([XtomFunction xfunc_check_strEmpty:url])
    {
        return REQUEST_MAINLINK_INIT;
    }
    NSLog(@"%@",[[[XtomManager sharedManager] myinitInfor] objectForKey:@"sys_web_service"]);
    return [[[XtomManager sharedManager] myinitInfor] objectForKey:@"sys_web_service"];
}
+ (NSString*)getChatPath
{
    NSString *url = [[[XtomManager sharedManager] myinitInfor] objectForKey:@"sys_chat_ip"];
    if ([XtomFunction xfunc_check_strEmpty:url])
    {
        return REQUEST_CHAT_INIT;
    }
    return [[[XtomManager sharedManager] myinitInfor] objectForKey:@"sys_chat_ip"];
}
+ (NSString*)getChatPort
{
    NSString *url = [[[XtomManager sharedManager] myinitInfor] objectForKey:@"sys_chat_port"];
    if ([XtomFunction xfunc_check_strEmpty:url])
    {
        return REQUEST_CHAT_PORT;
    }
    return [[[XtomManager sharedManager] myinitInfor] objectForKey:@"sys_chat_poot"];
}
#pragma mark- 声音视频播放相关
//提示声
+ (void)playPoint:(NSString*)sound
{
    AVAudioPlayer *avAudioPlayer;   //播放器player
    //从budle路径下读取音频文件
    NSString *string = [[NSBundle mainBundle] pathForResource:sound ofType:@"mp3"];
    //把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    //NSLog(@"url:%@,%@",url,string);
    //初始化音频类 并且添加播放文件
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    //设置初始音量大小
    // avAudioPlayer.volume = 1;
    //设置音乐播放次数  -1为一直循环
    avAudioPlayer.numberOfLoops = 0;
    //播放
    [avAudioPlayer play];
    //NSLog(@"播放");
}
//捕捉在线视频第一帧
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[[AVURLAsset alloc] initWithURL:videoURL options:nil] autorelease];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[[AVAssetImageGenerator alloc] initWithAsset:asset] autorelease];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[[UIImage alloc] initWithCGImage:thumbnailImageRef] autorelease] : nil;
    return thumbnailImage;
}
//获取视频的大小
+ (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[[NSFileManager alloc]init] autorelease];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue]/1024;
        else
            return -1;
    }
    else
    {
        return -1;
    }
}
//获取视频的时间
+ (CGFloat) getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}
#pragma mark- 导航条
//获得导航条文字
+ (UIView*)getNewView:(NSString*)title
{
    UIView *temView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)]autorelease];
    UILabel *customLab = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)]autorelease];
    [customLab setTextColor:BB_TitleColor];
    customLab.backgroundColor = [UIColor clearColor];
    customLab.textAlignment = NSTextAlignmentCenter;
    [customLab setText:title];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    [temView addSubview:customLab];
    temView.backgroundColor = [UIColor clearColor];
    return temView;
}
//寻找第一响应者
+ (id) traverseResponderChainForUIViewController:(UIView*)view
{
    for(id next = [view nextResponder];true;next = [next nextResponder])
    {
        if([next isKindOfClass:[UIViewController class]])
        {
            return next;
        }
    }
    
    return nil;
}
#pragma mark- 网络
//检测网络状态
+(BOOL)canConnectNet
{
    Reachability *reache=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable://无网络
            return NO;
        case ReachableViaWiFi://wifi网络rr
            return YES;
        case ReachableViaWWAN://wwlan网络
            return YES;
        default:
            break;
    }
    return NO;
}
@end
NS_ASSUME_NONNULL_END
