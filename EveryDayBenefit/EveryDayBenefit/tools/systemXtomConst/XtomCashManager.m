//
//  XtomCashManager.m
//  YYZZB
//
//  Created by lipeng on 13-5-17.
//  Copyright (c) 2013年 中国山东三米. All rights reserved.
//

#import "XtomCashManager.h"
#import "XtomConst.h"
#import "BBImgView.h"
#import "Reachability.h"

static XtomCashManager *sharedCashManager = nil;
@implementation XtomCashManager
@synthesize myIOQueue;
@synthesize myAvatarQueue;
@synthesize mySQLQueue;


#pragma mark- 接口相关
//删除文件
- (BOOL)removeDocument:(NSString*)document
{
    NSString *directory = [self getFilePath:document];
    return [self deleteFileAtPaths:directory];
}

//把图片设为按钮的背景
-(void)addImgToBtnFromDocumentORURL:(UIButton*)btn document:(NSString*)document url:(NSString*)url
{
    //[btn setBackgroundImage:nil forState:UIControlStateNormal];
    //[btn setBackgroundImage:nil forState:UIControlStateDisabled];
    
    NSString *temImgName = [self liGetImgNameFromURL:url];btn.titleLabel.text = url;
    NSString *temImgPath = [self getFilePath:temImgName directory:document];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        UIImage *img = [self getImagefrompath:temImgPath];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn setBackgroundImage:img forState:UIControlStateDisabled];
    }
    else
    {
        Reachability *reache=[Reachability reachabilityWithHostname:@"www.baidu.com"];
        if ([reache currentReachabilityStatus] != ReachableViaWiFi)
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:GDownLoad]integerValue] != 1)
            {
                return;
            }
        }
        //[self addActivity:btn];
        dispatch_async([self runOnIOThread], [self BlockWithAutoreleasePool:^(void){
            UIImage *img = [self loadImagefromUrl:url];
            [self savepicturefromimage:img path:temImgPath];
            if([btn.titleLabel.text isEqualToString:url])
            {
                dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
                    //[self stopActivity:btn];
                    if(btn)
                    {
                        if (img)
                        {
                            [btn setBackgroundImage:img forState:UIControlStateNormal];
                            [btn setBackgroundImage:img forState:UIControlStateDisabled];
                        }
                    }
                }]);
            }
            else
            {
                //NSLog(@"不一致");
            }
            
        }]);
    }
}

//往imgView添加图片
-(void)addImgToImgViewFromDocumentORURL:(UIImageView*)imgView document:(NSString*)document url:(NSString*)url
{
    //imgView.image = nil;
    NSString *temImgName = [self liGetImgNameFromURL:url];
    NSString *temImgPath = [self getFilePath:temImgName directory:document];
    
    BBImgView *yyImgView = nil;
    if([imgView isKindOfClass:[BBImgView class]])
    {
        yyImgView = (BBImgView*)imgView;
        yyImgView.imgURL = url;
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        UIImage *img = [self getImagefrompath:temImgPath];
        imgView.image = img;
    }
    else
    {
        Reachability *reache=[Reachability reachabilityWithHostname:@"www.baidu.com"];
        if ([reache currentReachabilityStatus] != ReachableViaWiFi)
        {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:GDownLoad]integerValue] != 1)
            {
                return;
            }
        }
        //[self addActivity:imgView];
        dispatch_async([self runOnIOThread], [self BlockWithAutoreleasePool:^(void){
            UIImage *img = [self loadImagefromUrl:url];
            [self savepicturefromimage:img path:temImgPath];
            
            if(yyImgView)
            {
                if([yyImgView.imgURL isEqualToString:url])
                {
                    dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
                        //[self stopActivity:imgView];
                        if(imgView)
                        {
                            if (img)
                            {
                                imgView.image = img;
                            }
                        }
                    }]);
                }
                else
                {
                    
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
                    //[self stopActivity:imgView];
                    if(imgView)
                    {
                        if (img)
                        {
                            imgView.image = img;
                        }
                    }
                }]);
            }
            
        }]);
    }
}
//左滑删除视频
-(void)deleteCashVideo:(NSString*)url
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    
    NSArray *temArr = [url componentsSeparatedByString:@"/"];
    NSString *temImgName = [temArr lastObject];
    
    NSString *filePath = [docsDir stringByAppendingFormat:@"/%@",temImgName];
    NSLog(@"我去啊：%@,%@",temImgName,filePath);
    
    [self deleteFileAtPaths:filePath];
}
//缓存声音
-(BOOL)downloadAudioFromDocumentORURL:(NSString*)document url:(NSString*)url
{
    NSString *temImgName = [self liGetImgNameFromURL:url];
    
    NSString *temImgPath = [self getFilePath:temImgName directory:document];
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        NSString *temAudioName = [[XtomCashManager sharedManager] liGetImgNameFromURL:url];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSString *docsDir = [dirPaths objectAtIndex:0];
        //NSString *docsDir = NSTemporaryDirectory();
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [paths objectAtIndex:0];
        
        NSString *soundFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@",BB_CASH_DOCUMENT,BB_CASH_AUDIO,temAudioName]];
        NSData *temDataDownload = [NSData dataWithContentsOfFile:soundFilePath];
        
        NSData *temDataLiu = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        //NSLog(@"长度 下载：%d 一共：%d 名字：%@",temDataDownload.length,temDataLiu.length,temImgName);
        if (temDataDownload.length == temDataLiu.length)
        {
            return YES;
        }
        return NO;
    }
    dispatch_async([self runOnIOThread], [self BlockWithAutoreleasePool:^(void){
        NSData *temData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [temData writeToFile:temImgPath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
        }]);
    }]);
    return NO;
}
//缓存视频
-(BOOL)downloadVideoFromDocumentORURL:(NSString*)document url:(NSString*)url
{
    NSString *temImgName = [self liGetImgNameFromURL:url];
    //NSLog(@"播放视频....:%@",temImgName);
    NSString *temImgPath = [self getFilePath:temImgName directory:document];
    if([[NSFileManager defaultManager] fileExistsAtPath:temImgPath])
    {
        NSString *temAudioName = [[XtomCashManager sharedManager] liGetImgNameFromURL:url];
        //NSLog(@"播放视频:%@",temAudioName);
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSString *docsDir = [dirPaths objectAtIndex:0];
        //NSString *docsDir = NSTemporaryDirectory();
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [paths objectAtIndex:0];
        
        NSString *soundFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@",BB_CASH_DOCUMENT,BB_CASH_VIDEO,temAudioName]];
        //NSLog(@"地址:%@",soundFilePath);
        NSData *temDataDownload = [NSData dataWithContentsOfFile:soundFilePath];
        //NSLog(@"大小：%d",temDataDownload.length);
        NSData *temDataLiu = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        //NSLog(@"视频长度 下载：%d 一共：%d 名字：%@",temDataDownload.length,temDataLiu.length,temImgName);
        if (temDataDownload.length == temDataLiu.length)
        {
            return YES;
        }
        return NO;
    }
    dispatch_async([self runOnIOThread], [self BlockWithAutoreleasePool:^(void){
        NSData *temData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [temData writeToFile:temImgPath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), [self BlockWithAutoreleasePool:^(void){
        }]);
    }]);
    return NO;
}
#pragma mark- 文件相关

//获取文件完整路陉
-(NSString*)getFilePath:(NSString*)fileName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString * path = [paths objectAtIndex:0];
    //NSString *path = NSTemporaryDirectory();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *filePath = [path stringByAppendingPathComponent:fileName];//NSLog(@"filePath:%@",filePath);
    return filePath;
}

//获取博文图片目录
- (NSString*)getBlogDocument
{
    NSString *blogDocument = [self getFilePath:[NSString stringWithFormat:@"%@/%@",BB_CASH_DOCUMENT,BB_CASH_BLOG]];
    return blogDocument;
}

//获取带文件夹的文件路径 例子：my/abc/img
-(NSString*)getFilePath:(NSString *)fileName directory:(NSString*)directoryName
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString * path = [paths objectAtIndex:0];
    //NSString *path = NSTemporaryDirectory();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    //
    NSString *strPath = [path stringByAppendingPathComponent:directoryName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:strPath]) {
        //NSLog(@"there is no Directory: %@",strPath);
        [[NSFileManager defaultManager] createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [path stringByAppendingFormat:@"/%@/%@",directoryName,fileName];
    return filePath;
}

//删除文件
-(BOOL)deleteFileAtPaths:(NSString *)path
{
    NSFileManager *manage=[NSFileManager defaultManager];
    BOOL flag=[manage removeItemAtPath:path error:nil];
    return flag;
}

//由图片的url生成图片名
-(NSString*)liGetImgNameFromURL:(NSString*)url
{
    NSString *imgName = [url stringByReplacingOccurrencesOfString:@"//" withString:@""];
    NSRange range = [imgName rangeOfString:@"/"];
    if(imgName.length > (range.location+range.length))
    {
        imgName = [imgName substringFromIndex:range.location+range.length];
        imgName = [imgName stringByReplacingOccurrencesOfString:@"/" withString:@""];
        return imgName;
    }
    
    return nil;
}
//由声音的url生成图片名
-(NSString*)liGetAudioNameFromURL:(NSString*)url
{
    NSString *temName = [url substringWithRange:NSMakeRange(40, url.length-40)];
    
    return temName;
}

//从文件获取图像
-(UIImage *)getImagefrompath:(NSString *)path
{
    return [[[UIImage alloc]initWithContentsOfFile:path] autorelease];
}

//下载网络上的图像
-(UIImage*)loadImagefromUrl:(NSString*)url
{
    UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    return img;
}

//把图片存入本地
-(void)savepicturefromimage:(UIImage*)image path:(NSString *)path
{
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    
}

//往view添加等待菊花
-(void)addActivity:(UIView*)view
{
    UIActivityIndicatorView *topImgActivity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    topImgActivity.hidesWhenStopped=YES;
    [view addSubview:topImgActivity];
    [topImgActivity release];
    topImgActivity.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    [topImgActivity startAnimating];
}

//关闭等待菊花
-(void)stopActivity:(UIView*)view
{
    for(UIView *subView in view.subviews)
    {
        if([subView isKindOfClass:[UIActivityIndicatorView class]])
        {
            UIActivityIndicatorView *temActivity = (UIActivityIndicatorView*)subView;
            [temActivity stopAnimating];
        }
    }
}

#pragma mark- 线程相关
//自动释放池
-(void)withAutoPool:(dispatch_block_t)myblock
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    myblock();
    [pool release];
}

-(dispatch_block_t) BlockWithAutoreleasePool:(dispatch_block_t)block
{
    return [[^{
        [self withAutoPool:block];
    } copy] autorelease];
}

//获取限程
-(dispatch_queue_t)runOnIOThread
{
    
    if(!myIOQueue)
    {
        myIOQueue = dispatch_queue_create("myIOQueue", nil);
    }
    return myIOQueue;
}

-(dispatch_queue_t)runOnAvatarThread
{
    
    if(!myAvatarQueue)
    {
        myAvatarQueue = dispatch_queue_create("myAvatarQueue", nil);
    }
    return myAvatarQueue;
}

-(dispatch_queue_t)runOnSQLThread
{
    if(!mySQLQueue)
    {
        mySQLQueue = dispatch_queue_create("mySQLQueue", nil);
    }
    return mySQLQueue;
}

#pragma mark- Singleton Methods
+ (id)sharedManager
{
    
    @synchronized(self)
    {
        if(sharedCashManager == nil)
            sharedCashManager = [[super allocWithZone:NULL] init];
        
    }
    return sharedCashManager;
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
    return UINT_MAX; //denotes anobject that cannot be released
}

- (oneway void)release
{
    // never release
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
