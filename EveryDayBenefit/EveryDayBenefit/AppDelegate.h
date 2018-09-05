//
//  AppDelegate.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager *_mapManager;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString *lblLongitude;
@property (nonatomic,strong) NSString *lblLatitude;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

