//
//  AppDelegate.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h> //声音提示
#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginNewViewController.h"
#import "BaseNavViewController.h"
#import "BaseTabBarViewController.h"
#import "Reachability.h"
#import "LocaModel.h"
//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import <AlipaySDK/AlipaySDK.h>//支付宝
#import "WXApi.h"//微信
#import "WXApiManager.h"

#import <RongIMKit/RongIMKit.h>
#import "RCDRCIMDataSource.h"
//#import "RCDHttpTool.h"


@interface AppDelegate ()<BMKLocationServiceDelegate,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>
{
    NSString *_account;
    NSString *_locationhz;
    NSString *_imeicode;
    BMKLocationService *_locService;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"mngHDHfc03sCVg7C7axD7wiWUePHibS0"  generalDelegate:nil];//@"xaNL6uSnAduwW2Geayrdpni6"//aX73B4z9d5VXNGNL8rgt0GioVALxSllN//mngHDHfc03sCVg7C7axD7wiWUePHibS0
    
    
    if (!ret) {
        NSLog(@"MapManager start failed!");
    }
    if (launchOptions != nil)
    {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil)
        {
            NSString *elert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            NSLog(@"%@",elert);
        }
    } else{
    }
    [self locate];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _account = [userDefault objectForKey:@"account"];
    _locationhz = [[userDefault objectForKey:@"locationhz"] stringValue];
    _imeicode = [userDefault objectForKey:@"imeicode"];
    //当初次登陆时(初次登录时无值) 让时间默认为1分钟
    if (_locationhz.length == 0) {
        _locationhz = @"1";
    }
    int a = [_locationhz intValue];
    int b = a * 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:b
                                              target:self
                                            selector:@selector(uploadLocation)
                                            userInfo:nil
                                             repeats:YES];
    
    //向微信注册
    [WXApi registerApp:WXPay_APPID withDescription:@"demo 2.0"];
    //融云
    [[RCIM sharedRCIM] initWithAppKey:@"sfci50a7csn2i"];//8luwapkvuvfil//
    
    
    //    // 注册自定义测试消息
    //    [[RCIM sharedRCIM] registerMessageType:[RCDTestMessage class]];
    
    //设置会话列表头像和会话界面头像
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    
    //设置群组内用户信息源。如果不使用群名片功能，可以不设置
    //  [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
    //  [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    
    //    //开启发送已读回执
    //    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP)];
    //
    //    //开启多端未读状态同步
    //    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList  = @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP)];
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    //群成员数据源
    [RCIM sharedRCIM].groupMemberDataSource = RCDDataSource;
    
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = YES;
    
    [RCIM sharedRCIM].disableMessageAlertSound = NO;
    
    // 本地通知的内容
    //    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //    LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
    //    BaseNavViewController* baseNav = [[BaseNavViewController alloc]initWithRootViewController:loginVC];
    
    
    self.window.rootViewController = [[BaseTabBarViewController alloc]init];//baseNav;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    return YES;
}

// AppDelegate class

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    // notification为本地通知的内容
    //震动
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //    AudioServicesPlaySystemSound(1007);
}


- (void)locate
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    self.lblLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.lblLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSLog(@"经纬度%@ - %@",self.lblLongitude,self.lblLatitude);
    [_locService stopUserLocationService];
    
    
}

#pragma mark - 实时定位上传
- (void)uploadLocation
{
    //检测网络状态
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        NSLog(@"未检测到网络！");
        //获取当前定位时间点
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr =[dateFormatter stringFromDate:currentDate];
        [_locService startUserLocationService];
        
        double lon = [self.lblLongitude doubleValue];
        double la = [self.lblLatitude doubleValue];
        if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
            NSLog(@"loc %@--%@",self.lblLongitude,self.lblLatitude);
            NSLog(@"位置信息异常!");
        }else{
            
            LocaModel *model = [[LocaModel alloc] init];
            model.lblLongitude = self.lblLongitude;
            model.lblLatitude = self.lblLatitude;
            model.timeStr = dateStr;
            [model save];
        }
        
        
        
        
        
    }else{
        //取出存储的数据
        NSMutableArray *array = [LocaModel findAll];
        if (array.count == 0) {
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            _account = [userDefault objectForKey:@"account"];
            [_locService startUserLocationService];
            
            double lon = [self.lblLongitude doubleValue];
            double la = [self.lblLatitude doubleValue];
            if (lon < 70.0 || lon > 140.0 || la < 3.0 || la > 53.0) {
                NSLog(@"loc %@--%@",self.lblLongitude,self.lblLatitude);
                NSLog(@"位置信息异常!");
            }else{
                
#warning datarequest withUnLog/location
                //                NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location"];
                //                NSDictionary *params = @{@"mobile":@"true",@"action":@"setSalerLoction",@"data":[NSString stringWithFormat:@"{\"longitude\":\"%@\",\"latitude\":\"%@\",\"account\":\"%@\",\"imei\":\"%@\"}",self.lblLongitude,self.lblLatitude,_account,_imeicode]};
                //                [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
                //                    NSString *str1 =[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
                //                    NSLog(@"定时上传返回%@",str1);
                //                } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
                //                    NSLog(@"定时上传失败");
                //                }];
                
                
            }
            
        }else  if(array.count > 0){
            /*
             {"longitude":"117.15097","latitude":"36.6705","account":"yph","imei":"867064014296733","localList":[{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:02:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:03:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:04:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:05:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:06:52"},{"latitude":"36.670405","longitude":"117.150942","time":"2015-07-21 11:07:52"}]}
             */
            
            NSLog(@"存储数据的数目%zi",array.count);
            
#warning mark datarequest /withUnLog/location
            //            //每次上传获取一下当前经纬度
            //            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            //            _account = [userDefault objectForKey:@"account"];
            //            [_locService startUserLocationService];
            //            NSString *urlStr = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,@"/withUnLog/location"];
            //            NSURL *url = [NSURL URLWithString:urlStr];
            //            NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            //            [request setHTTPMethod:@"POST"];
            //            NSMutableString *str =[NSMutableString  stringWithFormat:@"mobile=true&action=setSalerLoction&data={\"longitude\":\"%@\",\"latitude\":\"%@\",\"account\":\"%@\",\"imei\":\"%@\",}",self.lblLongitude,self.lblLatitude,_account,_imeicode];
            //            //拼接无网络时存储的数据
            //            NSMutableString  *dataStr = [NSMutableString stringWithFormat:@"\"localList\":[]"];
            //            for (LocaModel *model in array) {
            //                [dataStr insertString:[NSString stringWithFormat:@"{\"latitude\":\"%@\",\"longitude\":\"%@\",\"time\":\"%@\"},",model.lblLatitude,model.lblLongitude,model.timeStr] atIndex:dataStr.length - 1];
            //            }
            //            [dataStr deleteCharactersInRange:NSMakeRange(dataStr.length - 2, 1)];
            //            [str insertString:[NSString stringWithFormat:@"%@",dataStr] atIndex:str.length-1];
            //            NSLog(@"存储上传字符串%@",str);
            //            NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
            //            [request setHTTPBody:data];
            //            NSData *data1 =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            //            NSString *str1 =[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
            //            NSLog(@"存储上传返回信息%@",str1);
            //            //根据返回信息处理存储的数据选择是否清除
            //            if(str1.length != 0){
            //                NSRange range =  {1, str1.length-2};
            //                NSString *realStr = [str1 substringWithRange:range];
            //                if ([realStr isEqualToString:@"true"]){
            //                    [LocaModel clearTable];
            //                    [array removeAllObjects];
            //                    NSLog(@"清空后数据数目%zi",array.count);
            //                }else{
            //                    NSLog(@"存储上传失败");
            //                    [LocaModel clearTable];
            //                    [array removeAllObjects];
            //                    NSLog(@"失败后清空%zi",array.count);
            //
            //                }
            //
            //            }
            
        }
        
    }
    
}

/**
 *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 *
 *  @param application <#application description#>
 *  @param deviceToken <#deviceToken description#>
 */
// 获取苹果推送权限成功。
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"------登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"-----登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"------token错误");
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"获取token失败:%@",error);
}




/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"0" forKey:@"isAutoLogin"];
        [userDefault synchronize];
        LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
        BaseNavViewController* baseNav = [[BaseNavViewController alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = nil;
        self.window.rootViewController = baseNav;
    }
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSNumber *left = [notification.userInfo objectForKey:@"left"];
    if ([RCIMClient sharedRCIMClient].sdkRunningMode ==
        RCSDKRunningMode_Background &&
        0 == left.integerValue) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)]];
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        unreadMsgCount;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient]
                              getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP)
                                               ]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
}

////勿扰时段内关闭本地通知
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:ManualPositioning];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:ManualPositioning];
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lianxiang.EveryDayBenefit" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EveryDayBenefit" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EveryDayBenefit.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    
    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
}


//支付宝回调接口
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"支付成功== %@",resultDic);
                NSString* str = [resultDic objectForKey:@"result"];
                NSArray *array = [str componentsSeparatedByString:@"&"]; //从字符A中分隔成2个元素的数组
                NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
                //旧版本处理支付宝返回信息的办法
//                NSString*string =array[2];
//                NSRange range = [string rangeOfString:@"out_trade_no="];//匹配得到的下标
//                NSLog(@"rang:%@",NSStringFromRange(range));
//                NSInteger start = range.length - range.location;
//                string = [string substringFromIndex:start];//截取范围类的字符串
//                NSLog(@"截取的值为：%@",string);
//                NSString* fee = array[5];
//                NSRange range1 = [fee rangeOfString:@"total_fee="];
//                NSInteger feestart = range1.length - range1.location;
//                fee = [fee substringFromIndex:feestart];
//                NSLog(@"截取的值为fee：%@",fee);
//                NSString* stopstr = [self replaceAllOthers:string];
//                NSLog(@"最终字符串：%@",stopstr);
//                //新版本支付宝返回信息处理办法
//                NSDictionary* dict = array[0];
//                NSDictionary* infodict = dict[@"alipay_trade_app_pay_response"];
//                NSString* string =infodict[@"out_trade_no"];
//                NSString* fee = infodict[@"total_amount"];
//                [self shangChuan:string paymethod:@"1" money:fee];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                NSLog(@"支付成功== %@",resultDic);
                NSString* str = [resultDic objectForKey:@"result"];
                NSArray *array = [str componentsSeparatedByString:@"&"]; //从字符A中分隔成2个元素的数组
                NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
                //旧版本处理支付宝返回信息的办法
//                NSString*string =array[2];
//                NSRange range = [string rangeOfString:@"out_trade_no="];//匹配得到的下标
//                NSLog(@"rang:%@",NSStringFromRange(range));
//                NSInteger start = range.length - range.location;
//                string = [string substringFromIndex:start];//截取范围类的字符串
//                NSLog(@"截取的值为：%@",string);
//                NSString* stopstr = [self replaceAllOthers:string];
//                NSLog(@"最终字符串：%@",stopstr);
//                NSString* fee = array[5];
//                NSRange range1 = [fee rangeOfString:@"total_fee="];
//                NSInteger feestart = range1.length - range1.location;
//                fee = [fee substringFromIndex:feestart];
//                NSLog(@"截取的值为fee：%@",fee);
//                [self shangChuan:string paymethod:@"1" money:fee];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}


//请求到的是字符串需要处理一下
- (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return returnString;
}

#pragma  mark 支付成功后订单传给后台。
- (void)shangChuan:(NSString*)orderno paymethod:(NSString*)index money:(NSString*)money
{
    /*
     /order/payOrder.do
     mobile:true
     data{
     orderno    //订单号
     payno      //交易单号 空
     custid     //用户id
     paymethod  //1支付宝0微信
     money
     }
     */
    //    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    //    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/payOrder.do?1=1"];
    //    NSDictionary *params = @{@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"orderno\":%@,\"payno\":\"\",\"custid\":\"%@\",\"paymethod\":\"%@\",\"money\":%@}",orderno,userid,index,money]};
    //
    //    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
    //        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
    //        NSLog(@"updateOrderType%@",array);
    //
    //        //创建一个消息对象
    //        NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
    //        //发送消息
    //        [[NSNotificationCenter defaultCenter]postNotification:notice];
    //
    //    } failureBlock:^(AFHTTPRequestOperationManager *operationdata
    //                     , NSError *error) {
    //        NSInteger errorCode = error.code;
    //        NSLog(@"错误信息%ld",(long)errorCode);
    //    }];
    
}

#pragma mark - - - - - - 微信openURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}



//融云接收消息的回调方法
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    NSLog(@"未读消息的内容%@",message.content);
    if (message.conversationType == ConversationType_GROUP) {
        NSLog(@"这是群发的消息");
    }else if (message.conversationType == ConversationType_PRIVATE){
        NSLog(@"这是单聊的消息");
    }else if (message.conversationType == ConversationType_DISCUSSION){
        NSLog(@"这是讨论组");
    }else if (message.conversationType == ConversationType_CHATROOM){
        NSLog(@"这是liaotianshi");
    }else if (message.conversationType == ConversationType_CUSTOMERSERVICE){
        NSLog(@"这是客服");
    }else if (message.conversationType == ConversationType_SYSTEM){
        NSLog(@"这是系统回话");
    }
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *msg = (RCTextMessage*)message.content;
        NSLog(@"文本消息%@",msg.content);
    }
    if ([message.content
         isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg =
        (RCInformationNotificationMessage *)message.content;
        NSString *str = [NSString stringWithFormat:@"%@",msg.message];
        NSLog(@"未读消息%@",str);
        if ([msg.message rangeOfString:@"你已添加了"].location != NSNotFound) {
            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
                                 complete:^(NSMutableArray *friends){
                                 }];
        }
    } else if ([message.content
                isMemberOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage *msg =
        (RCContactNotificationMessage *)message.content;
        if ([msg.operation
             isEqualToString:
             ContactNotificationMessage_ContactOperationAcceptResponse]) {
            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
                                 complete:^(NSMutableArray *friends){
                                 }];
        }
    } else if ([message.content
                isMemberOfClass:[RCGroupNotificationMessage class]]) {
        RCGroupNotificationMessage *msg =
        (RCGroupNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:@"Dismiss"] &&
            [msg.operatorUserId
             isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP
                                                    targetId:message.targetId];
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP
                                                         targetId:message.targetId];
            } else if ([msg.operation isEqualToString:@"Rename"]) {
                //                [RCDHTTPTOOL getGroupByID:message.targetId
                //                        successCompletion:^(RCDGroupInfo *group) {
                //                            [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                //                            [[RCIM sharedRCIM] refreshGroupInfoCache:group
                //                                                         withGroupId:group.groupId];
                //                        }];
            }
    }
    
}

//当App处于后台时，接收到消息并弹出本地通知的回调方法
- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName
{
    return NO;
}
//当App处于前台时，接收到消息并播放提示音的回调方法
- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message
{
    //    //震动
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //    AudioServicesPlaySystemSound(1007);
    return NO;
}





@end

