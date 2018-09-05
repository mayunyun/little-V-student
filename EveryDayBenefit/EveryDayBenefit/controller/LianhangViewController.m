//
//  LianhangViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/12/28.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "LianhangViewController.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import "XMLDictionary.h"
//测试微信分享
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiRequestHandler.h"
#import "GTMBase64.h"
#import "MBProgressHUD.h"
#define DealReturn @"/paySuccess.html"
#define DealNotify @"/order/payOrder3.do"
#define KLTbaseURL @"https://user.ecpay.cn/m/paygate.html"//@"http://user.sdecpay.com/m/paygate.html"//
#import "LoginNewViewController.h"
#import "OrderManageListModel.h"
#import "OrderDetailWaitViewController.h"
#import "OrderDetailReceiveViewController.h"

@interface LianhangViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
    MBProgressHUD* _hud;
}
@property (nonatomic,strong)OrderManageListModel* orderdetailModel;
@end

@implementation LianhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"订单详情"];
//    //清除cookies
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies])
//    {
//        [storage deleteCookie:cookie];
//    }
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    NSURLCache * cache = [NSURLCache sharedURLCache];
//    [cache removeAllCachedResponses];
//    [cache setDiskCapacity:0];
//    [cache setMemoryCapacity:0];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
}

- (void)backClick:(UIButton*)sender
{
//    [self.tabBarController setSelectedIndex:0];
    NSArray* array = self.navigationController.viewControllers;
    if (array.count >3) {
        UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 1 - 3];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
}

- (void)rightBarClick:(UIButton*)sender
{
    [self ordernoRequest:[NSString stringWithFormat:@"%@",self.orderno]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud hide:YES];
    NSLog(@"加载完成该页面");
    NSString* currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSArray *strarray = [currentURL componentsSeparatedByString:@"?"];
    NSLog(@"%@",strarray[0]);
    NSString* dealReturn = [NSString stringWithFormat:@"%@%@",ROOT_Path,DealReturn];
    if ([strarray[0] isEqualToString:dealReturn]) {
//        [self.tabBarController setSelectedIndex:0];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];

    }
}

- (void)timerFireMethod:(NSTimer*)time
{
    NSArray* array = self.navigationController.viewControllers;
    if (array.count >3) {
        UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 1 - 3];
        [self.navigationController popToViewController:viewCtl animated:YES];
        
    }
    [time invalidate];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_hud show:YES];
}


- (void)requestData
{
    /*
     http://user.sdecpay.com/m/paygate.html
     merId:商户编号
     dealName：测试商品名称
     dealOrder：订单编号
     dealFee：订单金额
     dealBank：银行编码
     header：头部信息
     dealReturn：支付结果返回的url
     dealNotify：支付结果通知的url
     dealSignure：订单数据数字签名
     */
    NSString* merId = @"294147";//@"225890";//
    NSString* dealOrder = [self convertNull:self.orderno];
    NSString* dealName = @"测试";
    NSString* dealFee = [self convertNull:self.money];//@"0.11";//
//    NSString* dealBank = @"ICBC";
    NSString* header = @"false";
    NSString* dealReturn = [NSString stringWithFormat:@"%@%@",ROOT_Path,DealReturn];
    NSString* dealNotify = [NSString stringWithFormat:@"%@%@",ROOT_Path,DealNotify];
    NSString* submit = @"联行支付";
    NSArray* array = @[merId,dealOrder,dealFee,dealReturn];
    NSString* dealSignure = [self creatsignnew:array];
    NSLog(@"签名%@",dealSignure);
    NSString* urlstr = [NSString stringWithFormat:KLTbaseURL];
    NSDictionary* parmas = @{@"merId":merId,@"dealOrder":dealOrder,@"dealName":dealName,@"dealFee":dealFee,@"header":header,@"dealReturn":dealReturn,@"dealNotify":dealNotify,@"dealSignure":dealSignure,@"submit":submit};
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString *string = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回的结果%@",string);
        [_webView loadHTMLString:string baseURL:[NSURL URLWithString:KLTbaseURL]];
        
    } fail:^(NSError *error) {
        [_hud hide:YES];
    }];
}

- (NSString*)creatsignnew:(NSArray*)pramaArr
{
#pragma mark - - - - - - 预支付签名
    NSString* key = @"CQYSvkFrNNk7GMD3acEmTcyj5EtwgGf4QCybGqCwGjBtTLtrhFqZ48b7CujnStv7uQmDKmywKKpTt8xNiCBQJ7e5xWkSHMNjzK8fTFX2y5taiPslCR7oJkxqV7PIBz8Y";//@"NCjN0hexZ8pMpONfd7cgMwV8jdFm71NeLmRQaRwk3DQU4QPUmUsTwasAOL4jC7I2jIa9YQ1jpAuHEB3hVTNeJaCegtzszKE2v9mClxDkGYGxcI56MwJSJqKnj1RVdJmt";//
    NSString* signstr = [NSString stringWithFormat:@"%@%@%@%@%@",pramaArr[0],pramaArr[1],pramaArr[2],pramaArr[3],key];
    
    NSLog(@"拼接的签名字符串%@",signstr);
    return [self sha1:signstr];
}

////sha1加密方式
//- (NSString *) sha1:(NSString *)input
//{
////    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
////    NSData *data = [NSData dataWithBytes:cstr length:input.length];
//    
//    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
//    
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//    
//    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
//    
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    
//    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
//        [output appendFormat:@"%02x", digest[i]];
//    }
//    
//    return output;
//}

- (NSString *) sha1:(NSString *)inputStr {
    
    const char *cstr = [inputStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:inputStr.length];
    
    
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
    
}

- (void)ordernoRequest:(NSString*)orderno
{
    /*
     /order/searchOrderDetail.do
     data{
     orderno:订单编号
     }
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/searchOrderDetail.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"/order/searchOrderDetail.do%@",array);
            if (array.count!=0) {
                if (array.count!=0) {
                    for (int i = 0; i < array.count; i++) {
                        _orderdetailModel = [[OrderManageListModel alloc]init];
                        [_orderdetailModel setValuesForKeysWithDictionary:array[i]];
                    }
                    if ([_orderdetailModel.orderstatus integerValue] == 0 || [_orderdetailModel.orderstatus integerValue] == -1) {
                        //未付款
                        OrderDetailWaitViewController* VC= [[OrderDetailWaitViewController alloc]init];
                        if (!IsEmptyValue(orderno)) {
                            VC.orderNo = [NSString stringWithFormat:@"%@",orderno];
                            [self.navigationController pushViewController:VC animated:YES];
                        }
                    }else if ([_orderdetailModel.orderstatus integerValue] == 1){
                        //确认收货
                        OrderDetailReceiveViewController* vc = [[OrderDetailReceiveViewController alloc]init];
                        if (!IsEmptyValue(orderno)) {
                            vc.orderNo = [NSString stringWithFormat:@"%@",orderno];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }else if ([_orderdetailModel.orderstatus integerValue] == 6){
                        //确认发货
                        OrderDetailReceiveViewController* vc = [[OrderDetailReceiveViewController alloc]init];
                        if (!IsEmptyValue(orderno)) {
                            vc.orderNo = [NSString stringWithFormat:@"%@",orderno];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                }
            }

        }
    } fail:^(NSError *error) {
        
    }];

}


@end
