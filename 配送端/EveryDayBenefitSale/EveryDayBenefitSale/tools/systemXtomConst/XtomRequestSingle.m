//
//  XtomRequestSingle.m
//  BiaoBiao
//
//  Created by 山东三米 on 14-3-17.
//  Copyright (c) 2014年 山东三米. All rights reserved.
//
#define REQUEST_BOUNDARY @"AaB03x"
#define Xtom_HOST_NAME @"www.baidu.com"
#define Xtom_NET_FAIL @"网络不给力啊"
#define Xtom_NET_TIMEOUT @"网络不给力啊"
#define Xtom_NET_TIMEDURING 20 //网络请求允许的时间

#import "XtomRequestSingle.h"
#import "Reachability.h"
#import "JSONKit.h"
#import "XtomConst.h"

static XtomRequestSingle *sharedMyManager = nil;
@interface XtomRequestSingle()
{
    BOOL isFile;
    NSURLConnection *connector;
    NSTimer *myTimer;
    BOOL isStringStyle;//返回结题是string类型的
    //BOOL isSending;//是否正在请求数据
}
@property(nonatomic,copy)NSURL *requestURL;
@property(nonatomic,retain)NSMutableDictionary *requestParameters;
@property(nonatomic,retain)NSMutableData *receiveData;//服务器返回的数据
@property(nonatomic,strong)id backTarget;//获取数据后的响应目标
@property(nonatomic,assign)SEL backSelector;//响应方法
@property(nonatomic,assign)int requestType;//0 是纯文本 1 image/JPEG 2text/plain
@property(nonatomic,assign)BOOL isStringStyle;
@property(nonatomic,assign)BOOL isSending;//是否正在请求数据
@property(nonatomic,retain)NSMutableArray *datalist;//请求队列数组
@end

@implementation XtomRequestSingle
@synthesize requestURL = _requestURL;
@synthesize requestParameters = _requestParameters;
@synthesize receiveData = _receiveData;
@synthesize backTarget = _backTarget;
@synthesize backSelector = _backSelector;
@synthesize requestType = _requestType;
@synthesize isStringStyle;
@synthesize isSending;
@synthesize datalist;

- (void)dealloc
{
    //NSLog(@"连接销毁");
    [_requestURL release];_requestURL = nil;
    [_requestParameters release];_requestParameters = nil;
    [_receiveData release];_receiveData = nil;
    [_backTarget release];_backTarget = nil;
    [datalist release];datalist = nil;
    _backSelector = nil;
    connector = nil;
    [super dealloc];
}

+ (XtomRequestSingle*)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters
{
    XtomRequestSingle *request = [[[XtomRequestSingle alloc] init] autorelease];
    [request requestWithURL:url target:aTarget selector:aSelector parameter:paramters];
    return request;
}

+ (XtomRequestSingle*)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSDictionary*)paramters type:(BOOL)_stringStyle
{
    XtomRequestSingle *request = [[[XtomRequestSingle alloc] init] autorelease];
    request.isStringStyle = _stringStyle;
    [request requestWithURL:url target:aTarget selector:aSelector parameter:paramters];
    return request;
}

- (void)requestWithURL:(NSString*)url target:(id)aTarget selector:(SEL)aSelector parameter:(NSMutableDictionary*)paramters
{
    if (!datalist)
    {
        self.datalist = [[[NSMutableArray alloc]init]autorelease];
    }
    if (isSending)
    {
        [self.datalist addObject:paramters];
        return;
    }
    isSending = YES;
    
    if(!self.requestURL)
        self.requestURL = [NSURL URLWithString:url];
    if(!self.backTarget)
        self.backTarget = aTarget;
    if(!self.backSelector)
        self.backSelector = aSelector;
    /*
    if(!self.requestParameters)
    {
        self.requestParameters = paramters;
    }
     */
    self.requestParameters = paramters;
    
    //NSLog(@"link:%@ parameter:%@",self.requestURL,self.requestParameters);
    
    if([self canConnectNet])
    {
        self.requestType = [self getRequestType:_requestParameters];
        //self.requestType = 0;
        
        NSMutableURLRequest* theRequest = [[[NSMutableURLRequest alloc] initWithURL:_requestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Xtom_NET_TIMEDURING] autorelease];
        if(0 == _requestType)
        {
            [theRequest setHTTPMethod:@"POST"];
            NSData *postData = [self getPostData];
            [theRequest setHTTPBody:postData];
            [theRequest setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
        }
        if(1 == _requestType)
        {
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", REQUEST_BOUNDARY]forHTTPHeaderField:@"Content-Type"];
            [theRequest setHTTPBody:[self getPostData]];
        }
        [self openConnector:theRequest];
    }
    else
    {
        //断网状态
        NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"11",Xtom_NET_FAIL, nil] forKeys:[NSArray arrayWithObjects:@"error_code",@"status",@"msg", nil]];
        [_backTarget performSelector:_backSelector withObject:dic];
    }
    
}

//手动关闭连接
- (void)closeConnect
{
    if(connector)
    {
        [connector cancel];connector = nil;
    }
    if(myTimer)
    {
        [myTimer invalidate];myTimer = nil;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//打开连接请求
- (void)openConnector:(NSMutableURLRequest*)request
{
    //"正在连接"状态打开
    connector = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connector)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //_receiveData = [[NSMutableData alloc] init];
        self.receiveData = [[[NSMutableData alloc] init] autorelease];
        //myTimer = [NSTimer scheduledTimerWithTimeInterval:Xtom_NET_TIMEDURING target:self selector:@selector(checkData:) userInfo:nil repeats:NO];
    }
    else
    {
        NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"12",Xtom_NET_FAIL, nil] forKeys:[NSArray arrayWithObjects:@"error_code",@"status",@"msg", nil]];
        [_backTarget performSelector:_backSelector withObject:dic];
        [self closeConnect];
    }
}

//判断是否接收到了数据，如果没有，关闭连接
-(void)checkData:(id)sender
{
    if (0 == _receiveData.length)
    {
        if (connector)
        {
            [connector cancel];connector = nil;
        }
        
        //如果不是超时状态 弹出超时错误 打开超时状态
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"13", nil] forKeys:[NSArray arrayWithObjects:@"status", nil]];
        if([_backTarget respondsToSelector:_backSelector])
        {
            [_backTarget performSelector:_backSelector withObject:dic];
        }
    }
}

//检测网络状态
- (BOOL)canConnectNet
{
    Reachability *reache=[Reachability reachabilityWithHostName:Xtom_HOST_NAME];
    
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable://无网络
            return NO;
        case ReachableViaWiFi://wifi网络
            return YES;
        case ReachableViaWWAN://wwlan网络
            return YES;
        default:
            break;
    }
    return NO;
}

//获取请求类型
- (int)getRequestType:(NSDictionary*)para
{
    for(NSObject *object in para.allValues)
    {
        if([object isKindOfClass:[NSData class]])//检索是不是含有文件
        {
            return 1;
        }
    }
    return 0;
}
//设置请求数据
- (NSData*)getPostData
{
    NSData *returnData = nil;
    if(0 == _requestType)
    {
        NSMutableString *temMutableString = [NSMutableString stringWithString:@""];
        for(NSString *key in _requestParameters.allKeys)
        {
            [temMutableString appendFormat:@"&%@=%@",key,[_requestParameters objectForKey:key]];
        }
        returnData = [temMutableString dataUsingEncoding:NSUTF8StringEncoding];
    }
    if(1 == _requestType)
    {
        NSMutableData *temMutableData = [[[NSMutableData alloc] init] autorelease];
        NSString *boundary = REQUEST_BOUNDARY;
        //rfc1867协议样式
        //        --AaB03x\r\n Content-Disposition:form-data;name="title"\r\n \r\n value\r\n
        //        --AaB03x\r\n Content-Disposition:form-data;name="imagetitle";filename="ab.jpg"\r\n Content-Type:image/JPEG\r\n \r\n datavalue\r\n
        //        --AaB03x--\r\n
        for(NSString *key in _requestParameters.allKeys)
        {
            if([[_requestParameters objectForKey:key] isKindOfClass:[NSString class]])
            {
                NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n%@\r\n",boundary,key,[_requestParameters objectForKey:key]];
                [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                NSString *temStr = [NSString stringWithFormat:@"--%@\r\nContent-Disposition:form-data;name=\"%@\";filename=ab.jpg\r\n Content-Type:image/JPEG\r\n\r\n",boundary,key];
                [temMutableData appendData:[temStr dataUsingEncoding:NSUTF8StringEncoding]];
                [temMutableData appendData:[_requestParameters objectForKey:key]];
                [temMutableData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        NSString *endStr = [NSString stringWithFormat:@"--%@--\r\n",boundary];
        [temMutableData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
        returnData = temMutableData;
    }
    return returnData;
}

#pragma mark- NSUrlConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //可以获取数据的长度
    //NSLog(@"response:%@",response);
    //NSLog(@"length:%lld",response.expectedContentLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(isStringStyle)//如果返回是字符串形式
    {
        NSString *backStr = [[[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding]autorelease];
        if(_backTarget && _backSelector)
        {
            if([_backTarget respondsToSelector:_backSelector])
            {
                [_backTarget performSelector:_backSelector withObject:backStr];
            }
        }
    }
    else
    {
        //解析json数据
        NSDictionary *resultDictionary = [_receiveData objectFromJSONData];
        //#warning //NSLog
        /*
        NSString *str=[[[NSMutableString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding]autorelease];
        str=[str stringByReplacingOccurrencesOfString:@"," withString:@",\n"];
        str=[str stringByReplacingOccurrencesOfString:@"{" withString:@"{\n"];
        str=[str stringByReplacingOccurrencesOfString:@"}" withString:@"\n}"];
         */
        //NSLog(@"%@",str);
        //NSLog(@"request info:%@",resultDictionary);
        //NSLog(@"请求的数据原始版:%@",str);
        NSString *status = [resultDictionary objectForKey:@"status"];
        //如果token有误请重新连接 否则把数据发到请求方
        if(0 == [status intValue]&&200 ==[[resultDictionary objectForKey:@"error_code"] intValue])
        {
            //NSLog(@"error msg:%@",[resultDictionary objectForKey:@"msg"]);
            //[self requestWithURL:self.requestURL target:self.backTarget selector:self.backSelector parameter:self.requestParameters];
            [self loginInBackground];
        }
        else
        {
            //返回数据
            if(_backTarget && _backSelector)
            {
                if([_backTarget respondsToSelector:_backSelector])
                {
                    [_backTarget performSelector:_backSelector withObject:resultDictionary];
                }
            }
        }
        
    }
    //如果不为空的话
    isSending = NO;
    
    if (datalist.count != 0)
    {
        NSMutableDictionary *temDic = [[[NSMutableDictionary alloc]init]autorelease];
        NSDictionary *temDict = [datalist lastObject];
        for(NSString *key in temDict.allKeys)
        {
            NSString *value = [temDict objectForKey:key];
            if(![XtomFunction xfunc_check_strEmpty:value])
            {
                [temDic setObject:value forKey:key];
            }
        }
        //NSLog(@"你猜：%@",temDic);
        [self requestWithURL:nil target:nil selector:nil parameter:temDic];
        [datalist removeAllObjects];
    }else
    {
        [self closeConnect];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //    //关闭时钟
    //    if(myTimer)
    //    {
    //        [myTimer invalidate];
    //        myTimer = nil;
    //    }
    NSString *msg = [NSString stringWithFormat:@"%@",[error localizedDescription]];//NSLog(@"error msg:%@",msg);
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"12",msg, nil] forKeys:[NSArray arrayWithObjects:@"status",@"msg", nil]];
    if([_backTarget respondsToSelector:_backSelector])
    {
        [_backTarget performSelector:_backSelector withObject:dic];
    }
    [self closeConnect];
}

#pragma mark 登录
- (void)loginInBackground
{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSString *deviceID = [userDefaults objectForKey:@"deviceid"];//设备硬件标识,用于推送
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//客户端软件当前版本
    
    NSString *temUsername = [[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_LOGINNAME];
    NSString *temPawssword = [[NSUserDefaults standardUserDefaults] objectForKey:BB_XCONST_LOCAL_PASSWORD];
    
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:temUsername forKey:@"username"];
    [dic setObject:temPawssword forKey:@"password"];
    //[dic setObject:[XtomFunction xfuncGetAppdelegate].mydeviceid?[XtomFunction xfuncGetAppdelegate].mydeviceid:@"无"  forKey:@"deviceid"];
    [dic setObject:@"1" forKey:@"devicetype"];
    [dic setObject:currentVersion forKey:@"lastloginversion"];
    
    [XTomRequest requestWithURL:[NSString stringWithFormat:@"%@%@",REQUEST_MAINLINK,REQUEST_LOGIN_LINK] target:self selector:@selector(responseLogin:) parameter:dic];
}
- (void)responseLogin:(NSDictionary*)info
{
    if(1 == [[info objectForKey:@"status"] intValue])
    {
        //保存信息
        NSArray *temArray = [info objectForKey:@"infor"];
        NSDictionary *dic = [temArray objectAtIndex:0];
        NSMutableDictionary *temDic = [[[NSMutableDictionary alloc] init] autorelease];
        for(NSString * key in dic.allKeys)
        {
            if(![XtomFunction xfunc_check_strEmpty:[dic objectForKey:key]])
            {
                NSString*value = [dic objectForKey:key];
                [temDic setValue:value forKey:key];
            }
        }
        XtomManager *myManager = [XtomManager sharedManager];
        myManager.motherInfor = temDic;
        myManager.userID = [dic objectForKey:@"id"];
        myManager.userToken = [dic objectForKey:@"token"];
        
        //[XtomFunction xfuncGetAppdelegate].isLogin = YES;
        
        //重新连接服务器请求数据
        [self.requestParameters setObject:myManager.userToken forKey:@"token"];
        [self requestWithURL:nil target:nil selector:nil parameter:nil];
    }else
    {
        
    }
}

#pragma mark Singleton Methods
+ (id)sharedManager
{
    @synchronized(self)
    {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager]retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    
}

- (id)autorelease
{
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

@end
