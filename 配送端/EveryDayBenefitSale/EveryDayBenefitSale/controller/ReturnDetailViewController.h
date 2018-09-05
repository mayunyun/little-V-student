//
//  ReturnDetailViewController.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/29.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "BaseViewController.h"
#import "ZBarSDK.h"
#import "ExiteOrderModel.h"

@interface ReturnDetailViewController : BaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    int oldnum;
    BOOL oldupOrdown;
    NSTimer * oldtimer;
    
    CLLocationCoordinate2D _loc;
    BMKLocationService *_locService;
}
@property (nonatomic, strong) UIImageView * line;

//@property (nonatomic, strong)NSString* exiteno;
@property (nonatomic,strong)NSString* Id;
@property (nonatomic, strong)NSString* sendstatus;
@property (nonatomic,strong)ExiteOrderModel* orderdetailModel;

//地图
@property(strong,nonatomic)CLLocationManager * locationManager;

@property(nonatomic)NSString * lblLatitude;
@property(nonatomic)NSString * lblLongitude;

@property(nonatomic,strong)BMKMapView *mapView;

@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;

@end
