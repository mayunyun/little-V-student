//
//  AppDelegate.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "BaseNavViewController.h"
#import "BaseTabBarViewController.h"
#import "Reachability.h"
#import "LocaModel.h"
#import "DataPost.h"


//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>


@interface AppDelegate ()<BMKLocationServiceDelegate>
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
    BOOL ret = [_mapManager start:@"zhkyjHiOm3jzN5EYZx5HyM6wkF1LBQTu"  generalDelegate:nil];//xaNL6uSnAduwW2Geayrdpni6//aX73B4z9d5VXNGNL8rgt0GioVALxSllN//
    
    
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
    
  
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    LoginViewController* loginVC = [[LoginViewController alloc]init];
    BaseNavViewController* baseNav = [[BaseNavViewController alloc]initWithRootViewController:loginVC];
    
    self.window.rootViewController = baseNav;//[[BaseTabBarViewController alloc]init];//
    return YES;
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
    [[NSUserDefaults standardUserDefaults]setObject:self.lblLongitude forKey:LBLLONGITUDE];
    [[NSUserDefaults standardUserDefaults]setObject:self.lblLatitude forKey:LBLLATITUDE];
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
//                [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(id result) {
//                    NSString *str1 =[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
//                    NSLog(@"定时上传返回%@",str1);
//                } failureBlock:^(NSError *error) {
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

////勿扰时段内关闭本地通知
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lianxiang.EveryDayBenefitSale" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EveryDayBenefitSale" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EveryDayBenefitSale.sqlite"];
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



@end
