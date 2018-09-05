//
//  Httptool.h
//  zhicai
//
//  Created by 陈思思 on 15/7/21.
//  Copyright (c) 2015年 perfect. All rights reserved.
//
#import "AFNetworking.h"
#import <Foundation/Foundation.h>
//#define ZhiXuanLCHttpServer @"http://192.168.1.99:9191/fin/getview/app"
//#define ZhiXuanLCHttpServer @"http://192.168.1.205:8083/fin/getview/app"
//#define ZhiXuanLCHttpServer @"http://222.128.91.229:61803/fin/getview/app"//外网测试
#define ZhiXuanLCHttpServer @"http://222.128.91.229:28080/fin/getview/app"//@"http://192.168.1.99:9191/fin/getview/app"//第二版
//#define ZhiXuanLCHttpServer @"http://222.128.91.229:29191/fin/getview/app" //@"http://192.168.1.129:8080/fin/getview/app"

//#define ZhiXuanLPayProcol @"http://222.128.91.229:61803/fin/getview/app"


#define ZhiXuanhtml5Dir @"http://222.128.91.229:28080/fin"//@"http://192.168.1.205:8083/fin"

////#define ZhiXuanLCHttpServer @"http://222.128.91.229:29191/fin/getview/app"
//=======
//#define ZhiXuanLPayProcol  @"http:222.128.91.229:28080/fin"//@"http://222.128.91.229:61803/fin"
////#define ZhiXuanLCHttpServer @"http:222.128.91.229:28080/fin/getview/app"
//>>>>>>> .r316
//#define ZhiXuanLCHttpServer @"http://apps.zhixuanlicai.com:61800/tnloan2/getview/app"//外网
//#define ZhiXuanLCHttpServer @"http://222.128.91.229:61803/fin/getview/app"

//#define ZhiXuanLCHttpServer @"http://www-1.fuiou.com:18880/mobile_pay/findPay"
//公司介绍
#define ZhiXuanLCHTMLServer @"http://222.128.91.229:28080/fin/getview"//@"http://192.168.1.99:9191/fin/getview"
typedef NS_ENUM(NSInteger, HttpCode){
    kHttpStatusOK = 200,
    kHttpStatusRedirect = 302,
    kHttpBadRequest = 400,
    kHttpUnAuthorized = 401,
    kHttpForbidden = 403,
    kHttpNotFound = 404,
    kHttpInterError = 500,
    kHttpTimeout = 999,
    kHttpStatusToken = 100,
    kHttpTokenOutTime = 333,
    kHttpStatusNoLogin = 300,
};

@interface Httptool : NSObject

typedef void (^HttpToolsSuccess)(id json,HttpCode code);
typedef void (^HttpToolsFailure)(NSError *error);

typedef void(^FinishedBlock)(id result, HttpCode code, AFHTTPRequestOperation *operation);
typedef void(^FailuredBlock)(void);

@property (nonatomic, copy) FailuredBlock failureBlock;
/**
 * GET请求
 */
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure;

/**
 * POST请求
 */
+ (void)postWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure;


+ (void)postHtmlWithURL:(NSString *)url Params:(NSDictionary *)params Success:(HttpToolsSuccess)success Failure:(HttpToolsFailure)failure;





@end
