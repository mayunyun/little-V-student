//
//  KLianTongViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/3.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "KLianTongViewController.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import "XMLDictionary.h"
//测试微信分享
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiRequestHandler.h"

#define ReceiveUrl @"/kailiantong/receivemobile.do"
#define PickupUrl @"/kailiantong/payordermobile.do"
#define KLTbaseURL @"https://mobile.openepay.com/mobilepay/index.do"//@"http://opsweb.koolyun.cn/mobilepay/index.do"//
#define Key @"XIAOwei123"//@"1234567890"//
#define MerchantId @"102900170118001";//@"100020091219001";//
#import "LoginNewViewController.h"
#import "OrderManageListModel.h"
#import "OrderDetailWaitViewController.h"
#import "OrderDetailReceiveViewController.h"


@interface KLianTongViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
}
@property (nonatomic,strong)OrderManageListModel* orderdetailModel;
@end

@implementation KLianTongViewController

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
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

- (void)backClick:(UIButton*)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:0];
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
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}


- (void)requestData
{
    /*
     http://opsweb.koolyun.cn/gateway/index.do
     inputCharset : UTF-8
     receiveUrl : 支付回调
     version : v1.0
     signType : 1
     merchantId : 100020091219001
     orderNo :订单号
     orderAmount : 单位为分
     orderDatetime : 时间戳
     productName :商品名称
     payType : 43
     signMsg : 签名
     pickupUrl :
     language : 1
     orderCurrency : 156
     ext1
     ext2
     extTL
     issuerId : wechat
     payerAcctNo : wx715e6354cc6497b7
     termId :IOS
     showSuccessPage : 0
     */
    NSString* inputCharset = @"1";
    NSString* receiveUrl = [NSString stringWithFormat:@"%@%@",ROOT_Path,ReceiveUrl];
    NSString* version = @"v1.0";
    NSString* signType = @"1";
    NSString* merchantId = MerchantId;
    NSString* orderNo = [self convertNull:self.orderno];//@"NO20161230171053";//
        int total_fee = (int)([@"0.12" floatValue]*100);//以分为单位
//    int total_fee = (int)([self.money floatValue]*100);//以分为单位
    NSString* orderAmount = [NSString stringWithFormat:@"%i",total_fee];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *  orderDatetime = [dateformatter stringFromDate:senddate];//@"20161230171053";//
    NSString* productName = [self convertNull:self.name];//@"御仓山御贡米";
    NSString* payType = @"20";//@"43";
    NSString* pickupUrl = [NSString stringWithFormat:@"%@%@",ROOT_Path,PickupUrl];
    NSString* language = @"1";
    NSString* orderCurrency = @"156";
    NSString* issuerId = @"wechat";
    NSString* payerAcctNo = @"wx715e6354cc6497b7";
    NSString* termId = @"IOS";//@"ANDROID";//
    NSString* showSuccessPage = @"0";
    NSArray* array = @[inputCharset,pickupUrl,receiveUrl,version,language,signType,merchantId,payerAcctNo,orderNo,orderAmount,orderCurrency,orderDatetime,productName,termId,payType,issuerId];
    NSString* signMsg = [self creatsignnew:array];
    NSLog(@"签名%@",signMsg);
    NSString* urlstr = [NSString stringWithFormat:KLTbaseURL];
    NSDictionary* parmas = @{@"inputCharset":inputCharset,@"issuerId":issuerId,@"language":language,@"merchantId":merchantId,@"orderAmount":orderAmount,@"orderCurrency":orderCurrency,@"orderDatetime":orderDatetime,@"orderNo":orderNo,@"payType":payType,@"payerAcctNo":payerAcctNo,@"pickupUrl":pickupUrl,@"productName":productName,@"receiveUrl":receiveUrl,@"signType":signType,@"termId":termId,@"version":version,@"showSuccessPage":showSuccessPage,@"signMsg":signMsg};
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        //
//        NSString* str = [[NSString alloc]initWithData:result encoding:kCFStringEncodingUTF8];
//        NSLog(@"返回的结果%@",str);
//        NSDictionary *dict = [NSDictionary dictionaryWithXMLString:str];
//        NSLog(@"test = %@",dict);
//        NSLog(@"__name:%@,respCode:%@,message:%@",[dict objectForKey:@"__name"],[dict objectForKey:@"respCode"],[dict objectForKey:@"message"]);
//        NSString* respCode = [dict objectForKey:@"respCode"];//
//        if ([respCode rangeOfString:@"200000"].location != NSNotFound) {
//            NSDictionary* message = [dict objectForKey:@"message"];
//            NSString* respMsg = [message objectForKey:@"respMsg"];
//            NSString* orderNo = [message objectForKey:@"orderNo"];
//            NSString* resprespMsg = [self replaceAllOthers:respMsg];
//            NSDictionary* respdict = [self dictionaryWithJsonString:resprespMsg];
//            //调起微信支付
//            PayReq *req = [[PayReq alloc] init];
//            req.openID=[respdict objectForKey:@"appid"];
//            req.nonceStr = [respdict objectForKey:@"noncestr"];
//            req.partnerId = [respdict objectForKey:@"partnerid"];
//            req.package = [respdict objectForKey:@"package"];
//            req.prepayId= respdict[@"prepayid"];
//            NSString* time = respdict[@"timestamp"];
//            req.timeStamp= [time intValue];
//            req.sign= respdict[@"sign"];
//            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
//            {
//                [WXApi sendReq:req];
//                [[NSUserDefaults standardUserDefaults] setValue:orderNo forKey:WXout_trade_no];
//            }else
//            {
//                UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:nil message:@"您没有安装微信客户端" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [aleartView show];
//            }
//            
//        }else{
//        
//            NSString *string = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
//            NSLog(@"返回的结果%@",string);
//            [_webView loadHTMLString:string baseURL:[NSURL URLWithString:KLTbaseURL]];
//        }
        NSString *string = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"返回的结果%@",string);
//        NSString* urlstr = @"<a href='http://weixin.qq.com/r/OEzUzGjEzTWyrSyv9xkq'></a>";
        [_webView loadHTMLString:string baseURL:[NSURL URLWithString:KLTbaseURL]];
    } fail:^(NSError *error) {
        
    }];
}

//请求到的是字符串需要处理一下
- (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return returnString;
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - - - - - - 签名
- (NSString*)creatsignnew:(NSArray*)pramaArr
{
    NSString* signstr = [NSString stringWithFormat:@"inputCharset=%@&pickupUrl=%@&receiveUrl=%@&version=%@&language=%@&signType=%@&merchantId=%@&payerAcctNo=%@&orderNo=%@&orderAmount=%@&orderCurrency=%@&orderDatetime=%@&productName=%@&termId=%@&payType=%@&issuerId=%@&key=%@",pramaArr[0],pramaArr[1],pramaArr[2],pramaArr[3],pramaArr[4],pramaArr[5],pramaArr[6],pramaArr[7],pramaArr[8],pramaArr[9],pramaArr[10],pramaArr[11],pramaArr[12],pramaArr[13],pramaArr[14],pramaArr[15],Key];
    NSLog(@"拼接的签名字符串%@",signstr);
    return [[self md5:signstr] uppercaseString];
}

//md5 16位加密 （大写）
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
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
