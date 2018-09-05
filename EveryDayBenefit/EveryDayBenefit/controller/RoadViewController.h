//
//  RoadViewController.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/22.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface RoadViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>

//block声明
@property (nonatomic, copy) void (^transVaule)(NSString* name,NSString *address);

@property(strong,nonatomic)CLLocationManager * locationManager;

@property(nonatomic)NSString * lblLatitude;
@property(nonatomic)NSString * lblLongitude;
@end
