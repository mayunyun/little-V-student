//
//  XTomGetImage.m
//  YYZZB
//
//  Created by lipeng on 13-5-14.
//  Copyright (c) 2013年 中国山东三米. All rights reserved.
//
#define REQUEST_BOUNDARY @"AaB03x"
#define Xtom_HOST_NAME @"www.baidu.com"
#define Xtom_NET_FAIL @"亲，网络不给力啊"
#define Xtom_NET_TIMEOUT @"网络不给力啊"
#define Xtom_NET_TIMEDURING 3 //网络请求允许的时间

#import "XTomGetImage.h"
#import "XtomFunction.h"
#import "Reachability.h"
@interface XTomGetImage()

@property(nonatomic,copy)NSString *filePath;
@property(nonatomic,retain)NSURLConnection *connection;
@end

@implementation XTomGetImage
@synthesize receiveData = _receiveData;
@synthesize target = _target;
@synthesize selector;
@synthesize tag;
@synthesize allLength;
@synthesize imageButton;
@synthesize imageType;
//私有属性 
@synthesize filePath = _filePath;
@synthesize connection = _connection;

- (void)dealloc
{
    if(_connection)
    {
        [_connection cancel];
        [_connection release];_connection = nil;
    }         
    [_receiveData release];_receiveData = nil;
    [_target release];_target = nil;
    selector = nil;
    [imageButton release];imageButton = nil;
    
    [_filePath release];_filePath = nil;
    //NSLog(@"图片请求关闭 ");
    [super dealloc];
}


- (void)addTarget:(id)target selector:(SEL)aselector requestWithURL:(NSString*)url document:(NSString*)document button:(UIButton*)imageBtn type:(XtomImageType)type
{
    self.target = target;
    self.imageButton = imageBtn;
    self.imageType = type;
    self.selector = aselector;
   
    
    NSString *temImgName = [self liGetImgNameFromURL:url];
    self.filePath = [self getFilePath:temImgName directory:document];
    if([[NSFileManager defaultManager] fileExistsAtPath:_filePath])
    {
        UIImage *img = [self getImagefrompath:_filePath];
        
        [self changeImage:img];
    }
    else
    {
        if([self canConnectNet])
        {
            NSMutableURLRequest* theRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:Xtom_NET_TIMEDURING] autorelease];
            
            [theRequest setHTTPMethod:@"POST"];
            [theRequest setHTTPBody:nil];
            [theRequest setValue:@"0" forHTTPHeaderField:@"Content-Length"];
            _receiveData = [[NSMutableData alloc] init];
            //NSLog(@"selfconut:%d",self.retainCount);
            _connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
            //NSLog(@"aselfconut:%d",self.retainCount);
        }
        else
        {
            //断网状态
           
        }
    }
    
}

#pragma mark- 视图相关
//显示图片
- (void)changeImage:(UIImage*)img
{
    if(XtomImageTypeDetail == imageType)
    {        
        UIProgressView *progressView = (UIProgressView*)[imageButton viewWithTag:999];
        [progressView setProgress:1.0 animated:YES];
        [[imageButton viewWithTag:999] removeFromSuperview];
        
        CGFloat imgWidth = img.size.width;
        CGFloat imgHeight = img.size.height;
        if(0 == imgWidth || 0 == imgHeight)
            return;
        CGSize imgSize;
        if(imgWidth > imgHeight)
        {
            imgSize = CGSizeMake(300.0, (300.0/imgWidth)*imgHeight);
            imageButton.frame = CGRectMake(0, 0, 300, imgSize.height);
        }
        else
        {
            imgSize = CGSizeMake((300.0/imgHeight)*imgWidth, 300.0);
            imageButton.frame = CGRectMake((300-imgSize.width)/2, 0, imgSize.width, 300);
        }
        [imageButton setBackgroundImage:img forState:UIControlStateNormal];
        imageButton.enabled = YES;
        [XtomFunction addBorderToView:imageButton borderWidth:2];
        
        if([_target respondsToSelector:self.selector])
        {
            [_target performSelector:selector withObject:self];
        }
    }
}

#pragma mark- 缓存相关
//由图片的url生成图片名
-(NSString*)liGetImgNameFromURL:(NSString*)url
{
    NSString *imgName = [url stringByReplacingOccurrencesOfString:@"//" withString:@""];
    NSRange range = [imgName rangeOfString:@"/"];
    imgName = [imgName substringFromIndex:range.location+range.length];
    imgName = [imgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return imgName;
}

//directoryName 例子：my/abc/img
-(NSString*)getFilePath:(NSString *)fileName directory:(NSString*)directoryName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [paths objectAtIndex:0];
    //
    NSString *strPath = [path stringByAppendingPathComponent:directoryName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPath]) {
        //NSLog(@"there is no Directory: %@",strPath);
        [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [path stringByAppendingFormat:@"/%@/%@",directoryName,fileName];
    return filePath;
}

//从文件获取图像
-(UIImage *)getImagefrompath:(NSString *)path
{
    return [[[UIImage alloc]initWithContentsOfFile:path] autorelease];
}
#pragma mark- 网络请求相关

//打开连接请求
- (void)openConnect
{
    if(_connection)
        [_connection start];
}

//关闭连接
- (void)closeConnect
{
    if(_connection)
    {
        [_connection cancel];
        [_connection release];_connection = nil;
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

#pragma mark NSUrlConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.allLength = response.expectedContentLength;
    //NSLog(@"all:%ld",self.allLength);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receiveData appendData:data];//NSLog(@"have:%lu",(unsigned long)_receiveData.length);
    UIProgressView *progressView = (UIProgressView*)[imageButton viewWithTag:999];
    [progressView setProgress:(_receiveData.length/self.allLength) animated:YES];    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_receiveData writeToFile:_filePath atomically:YES];
    UIImage *img = [UIImage imageWithData:_receiveData];    
    [self changeImage:img];
//    if(_connection)
//        [_connection cancel];[_connection release]; _connection = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   
    //NSLog(@"bselfconut:%d",self.retainCount);
//    NSString *msg = [NSString stringWithFormat:@"%@",[error localizedDescription]];//NSLog(@"error msg:%@",msg);
//    NSDictionary *dic=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"12",msg, nil] forKeys:[NSArray arrayWithObjects:@"status",@"msg", nil]];
//    if(_connection)
//        [_connection cancel];[_connection release]; _connection = nil;
    
}
@end
