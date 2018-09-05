//
//  PayTypeTbVC.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "PayTypeTbVC.h"
//支付宝
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>

//测试微信分享
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiRequestHandler.h"
#define TIPSLABEL_TAG 10086
static NSString *kTextMessage = @"这是测试字段";
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import "XMLDictionary.h"
#import "LianhangViewController.h"
#import "KLianTongViewController.h"
#import "KLianTongKViewController.h"
#import "LoginNewViewController.h"
#import "OrderManageListModel.h"
#import "OrderDetailWaitViewController.h"
#import "OrderDetailReceiveViewController.h"
#import <sys/socket.h>

#import <sys/sockio.h>

#import <sys/ioctl.h>

#import <net/if.h>

#import <arpa/inet.h>
#import "RSADataSigner.h"
@interface PayTypeTbVC ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    UILabel * payprice;
    UITableView * tbview;
    NSArray * imgarray;
    NSArray * datasource;
    NSString* _prepay_id;
    NSString* _selectPayType;
}
@property (nonatomic) enum WXScene currentScene;
@property (nonatomic,strong)OrderManageListModel* orderdetailModel;

@end

@implementation PayTypeTbVC

@synthesize currentScene = _currentScene;
- (void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:AliPayTrue object:nil];
    //获取通知中心单例对象
    NSNotificationCenter * WXcenter = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [WXcenter addObserver:self selector:@selector(WXnotice:) name:WXPayTrue object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXPayTrue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayTrue object:nil];
}

- (void)notice:(NSNotificationCenter*)sender
{
//    UIViewController *viewCtl = self.navigationController.viewControllers[1];
//    [self.navigationController popToViewController:viewCtl animated:YES];
    [self ordernoRequest:[NSString stringWithFormat:@"%@",_orderno1]];
}

- (void)WXnotice:(NSNotificationCenter*)sender
{
    NSString* orderstr = [[NSUserDefaults standardUserDefaults]objectForKey:WXout_trade_no];
    [self shangChuan:orderstr money:self.orderMoney1 paymethod:@"0"];
    [self ordernoRequest:[NSString stringWithFormat:@"%@",orderstr]];
}


- (void)viewDidLoad {
    imgarray = [[NSArray alloc]init];
    datasource = [[NSArray alloc]init];
    datasource =  @[@"支付宝支付",@"微信支付",@"开联通支付",@"联行支付"];
    imgarray = @[@"zfb.png",@"wx.png",@"klt.png",@"lh.png"];
    [super viewDidLoad];
//    self.title = @"收银台";
//    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:@"选择支付方式"];
    [self createview];
    
}


- (void)backClick:(UIButton*)sender
{
    [self.tabBarController setSelectedIndex:0];
    NSArray* array = self.navigationController.viewControllers;
    if (array.count >2) {
        UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 1 - 2];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
}

- (void)createview
{
//    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 30)];
//    view1.backgroundColor   = [UIColor whiteColor];
//    [self.view addSubview:view1];
//    
//    self.view.backgroundColor = LineColor;
//    UILabel * fangshi = [[UILabel     alloc]initWithFrame:CGRectMake(10, 5, mScreenWidth, 20)];
//    fangshi.text = @"请选择支付方式";
//    fangshi.textColor = [UIColor lightGrayColor];
//    fangshi.font = [UIFont boldSystemFontOfSize:13];
//    [view1 addSubview:fangshi];
//    
//    payprice = [[UILabel  alloc]initWithFrame:CGRectMake(10, 5, mScreenWidth-20, 20)];
//    payprice.textAlignment = NSTextAlignmentRight;
//    payprice.textColor = [UIColor redColor];
//    payprice.text = [NSString stringWithFormat:@"¥ %@",_orderMoney1];
//    
//    payprice.font = [UIFont boldSystemFontOfSize:13];
//    [view1 addSubview:payprice];
    
    tbview = [[UITableView alloc]initWithFrame:CGRectMake(0, 2, mScreenWidth,170)];
    tbview.delegate =self;
    tbview.scrollEnabled = NO;
    tbview.dataSource =self;
    [self.view addSubview:tbview];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, tbview.bottom+60, mScreenWidth - 100, 50);
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 25;
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - tableview delegate
#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 44;
    }else{
        return 60;
    }
//    }else if (indexPath.section == 3){
//        return 90;
//    }
//
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    if (indexPath.section == 0) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth-100)*0.5, 0, 100, 44)];
        view.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:view];
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (view.height - 20)*0.5, 20, 20)];
        [imgView setImage:[UIImage imageNamed:@"xuanzhong.png"]];
        [view addSubview:imgView];
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgView.right, 0, view.width - imgView.right, view.height)];
        titleLabel.text = @"订单提交成功";
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:titleLabel];
    }else if (indexPath.section == 1){
        UILabel* orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, mScreenWidth - 30*2, 44/2)];
        orderLabel.textAlignment = NSTextAlignmentLeft;
        orderLabel.text = [NSString stringWithFormat:@"订 单 号:%@",self.orderno1];
        orderLabel.font = [UIFont systemFontOfSize:10];
        [cell.contentView addSubview:orderLabel];
    
        UILabel* moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(orderLabel.left, orderLabel.bottom, orderLabel.width, 44/2)];
        moneyLabel.textAlignment = NSTextAlignmentLeft;
        moneyLabel.font = [UIFont systemFontOfSize:10];
        moneyLabel.text = [NSString stringWithFormat:@"应付金额:%@",self.orderMoney1];
        [cell.contentView addSubview:moneyLabel];
    }else if (indexPath.section == 2){
        for (UIView* view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        CGFloat gap = 30;
        for (int i = 0; i < 2; i++) {
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake(gap*(i+1)+(mScreenWidth - gap*3)*0.5*i, 10, (mScreenWidth - gap*3)*0.5, 60-20)];
            [cell.contentView addSubview:view];
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.height, view.height)];
            imgView.image = [UIImage imageNamed:imgarray[i]];
            [view addSubview:imgView];
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(imgView.right, 0, view.width - view.height*1.5, view.height)];
            label.text = datasource[i];
            label.font = [UIFont systemFontOfSize:12];
            [view addSubview:label];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(label.right, view.height*0.25, view.height*0.5, view.height*0.5);
            [btn setImage:[UIImage imageNamed:@"weixuanzhong.png"] forState:UIControlStateNormal];
            btn.tag = indexPath.section*1000+i;
            [view addSubview:btn];
            [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)selectBtnClick:(UIButton*)sender
{
    NSLog(@"sender.tag是----%ld",(long)sender.tag);
    NSMutableArray* btnArray = [[NSMutableArray alloc]init];
    UIButton* selectBtn0 = (UIButton*)[self.view viewWithTag:2000];
    UIButton* selectBtn1 = (UIButton*)[self.view viewWithTag:2001];
    //UIButton* selectBtn2 = (UIButton*)[self.view viewWithTag:3000];
    //UIButton* selectBtn3 = (UIButton*)[self.view viewWithTag:3001];
    [btnArray addObject:selectBtn0];
    [btnArray addObject:selectBtn1];
    //[btnArray addObject:selectBtn2];
    //[btnArray addObject:selectBtn3];
    for (UIButton* btn in btnArray) {
        btn.selected = NO;
        if (btn.tag == sender.tag) {
            btn.selected = YES;
            [btn setImage:[UIImage imageNamed:@"xuanzhong.png"] forState:UIControlStateNormal];
        }else{
            btn.selected = NO;
            [btn setImage:[UIImage imageNamed:@"weixuanzhong.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)sureBtnClick:(UIButton*)sender
{
    NSLog(@"sender.tag是----%ld",(long)sender.tag);
    NSMutableArray* btnArray = [[NSMutableArray alloc]init];
    UIButton* selectBtn0 = (UIButton*)[self.view viewWithTag:2000];
    UIButton* selectBtn1 = (UIButton*)[self.view viewWithTag:2001];
    //UIButton* selectBtn2 = (UIButton*)[self.view viewWithTag:3000];
    //UIButton* selectBtn3 = (UIButton*)[self.view viewWithTag:3001];
    [btnArray addObject:selectBtn0];
    [btnArray addObject:selectBtn1];
    //[btnArray addObject:selectBtn2];
    //[btnArray addObject:selectBtn3];
    for (UIButton* btn in btnArray) {
        if (btn.selected) {
            switch (btn.tag) {
                case 2000:
                {
                    _selectPayType = @"1";
                    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/newuuid.do"];
                    NSString* datastr = [NSString stringWithFormat:@"{\"uniqueidentiteny\":\"%@\"}",self.ordernewUUid];
                    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
                    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
                        
                        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
                        
                        NSString *str1 = [str substringFromIndex:1];
                        
                        self.ordernewUUid = [str1 substringToIndex:str1.length-1];
                        [self zhiFuBaoname:_name titile:_mssage1 price:_orderMoney1 orderId:self.ordernewUUid orderStr:self.orderstr];
                    } fail:^(NSError *error) {
                        
                    }];
                    
                }
                    break;
                case 2001:
                {
                    _selectPayType = @"0";
                    if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
                    {
                        NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/newuuid.do"];
                        NSString* datastr = [NSString stringWithFormat:@"{\"uniqueidentiteny\":\"%@\"}",self.ordernewUUid];
                        NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
                        NSLog(@">>>%@",self.ordernewUUid);
                        [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
                            
                            NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
                            
                            NSString *str1 = [str substringFromIndex:1];
                            
                            self.ordernewUUid = [str1 substringToIndex:str1.length-1];
                            [self prepayIdRequest];
                        } fail:^(NSError *error) {
                            
                        }];
                        
                        
//                        UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"攻城狮正在努力开发中" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [aleartView show];
                    }
                    else
                    {
                        UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"您没有安装微信客户端" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [aleartView show];
                    }
//                    KLianTongViewController* vc = [[KLianTongViewController alloc]init];
//                    vc.orderno = [NSString stringWithFormat:@"%@",self.orderno1];
//                    vc.money = [NSString stringWithFormat:@"%@",self.orderMoney1];
//                    vc.name = [NSString stringWithFormat:@"%@",self.name];
//                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3000:
                {
                    //开联通
                    KLianTongKViewController* vc = [[KLianTongKViewController alloc]init];
                    vc.orderno = [NSString stringWithFormat:@"%@",self.orderno1];
                    vc.money = self.orderMoney1;
                    vc.name = self.name;
                    vc.orderDatetime = self.time;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3001:
                {
                    //联行支付
                    NSLog(@"联行支付%@%@",self.orderno1,self.orderMoney1);
                    LianhangViewController* vc = [[LianhangViewController alloc]init];
                    vc.orderno = self.orderno1;
                    vc.money = self.orderMoney1;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
            
        }
    }

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
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",orderno];
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
                for (int i = 0; i < array.count; i++) {
                    _orderdetailModel = [[OrderManageListModel alloc]init];
                    [_orderdetailModel setValuesForKeysWithDictionary:array[i]];
                }
                if ([_orderdetailModel.orderstatus integerValue] == 0 || [_orderdetailModel.orderstatus integerValue] == -1) {
                    //未付款
                    OrderDetailWaitViewController* VC= [[OrderDetailWaitViewController alloc]init];
                    if (!IsEmptyValue(orderno)) {
                        VC.orderNo = [NSString stringWithFormat:@"%@",orderno];
                    }
                    [self.navigationController pushViewController:VC animated:YES];
                }else if ([_orderdetailModel.orderstatus integerValue] == 1){
                    //确认收货
                    OrderDetailReceiveViewController* vc = [[OrderDetailReceiveViewController alloc]init];
                    if (!IsEmptyValue(orderno)) {
                        vc.orderNo = [NSString stringWithFormat:@"%@",orderno];
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([_orderdetailModel.orderstatus integerValue] == 6){
                    //确认发货
                    OrderDetailReceiveViewController* vc = [[OrderDetailReceiveViewController alloc]init];
                    if (!IsEmptyValue(orderno)) {
                        vc.orderNo = [NSString stringWithFormat:@"%@",orderno];
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
//                    UIViewController *viewCtl = self.navigationController.viewControllers[1];
//                    [self.navigationController popToViewController:viewCtl animated:YES];
                }
            }else{
//                UIViewController *viewCtl = self.navigationController.viewControllers[1];
//                [self.navigationController popToViewController:viewCtl animated:YES];
            }
        }
    } fail:^(NSError *error) {
        
    }];
    
}




#pragma mark - - - - - 支付宝
- (void)zhiFuBaoname: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId orderStr:(NSString*)orderStr{
    //NSString *partner = Partner;//支付宝账号
    //NSString *seller = Seller;//支付宝seller
    NSString *privateKey = PRIVATEKEY;//支付宝秘钥
    
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = AliPay_APPID;
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = privateKey;
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    order.notify_url = [NSString stringWithFormat:@"%@/order/payOrder2.do",ROOT_Path];
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = orderId;
    order.biz_content.subject = [NSString stringWithFormat:@"%@  %.2f元",name,[price floatValue]];
    order.biz_content.out_trade_no = [NSString stringWithFormat:@"%@",orderId]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [price floatValue]]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"xiaoweitongxue";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:resultDic];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }];
    }
}
//- (void)zhiFuBaoname: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId orderStr:(NSString*)orderStr
//{
//
//    NSString *partner = Partner;//支付宝账号
//    NSString *seller = Seller;//支付宝seller
//    NSString *privateKey = PRIVATEKEY;//支付宝秘钥
//
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 || [seller length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = orderId; //订单ID（由商家自行制定）
//    order.productName = name; //商品标题
//    order.productDescription = title; //商品描述
//    order.amount = price; //@"0.01";//商品价格//
////    NSString* str = @"http://192.168.1.251/danshi1/getNotifyAction";
////        NSString *str = [NSString stringWithFormat:@"%@%@",@"http://182.92.96.58:8004/qitao/",@"getNotifyAction"];
//    NSString *str = [NSString stringWithFormat:@"%@/order/payOrder2.do",ROOT_Path]; ;
//    //回调URL
//    order.notifyURL = str;
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
//
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"xiaoweitongxue";
//
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    //NSLog(@"%@",privateKey);
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        NSLog(@"str=%@",orderString);
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
//                NSLog(@"str%@",str);
//                NSLog(@"支付成功== %@",resultDic);
//                [self shangChuan:order.tradeNO money:order.amount paymethod:@"1"];
//                //创建一个消息对象
//                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
//                //发送消息
//                [[NSNotificationCenter defaultCenter]postNotification:notice];
//            }
//        }];
//        [[AlipaySDK defaultService] payUrlOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//
//            NSLog(@"resultDic%@",resultDic);
//            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
//                NSLog(@"str%@",str);
//                NSLog(@"支付成功== %@",resultDic);
//                [self shangChuan:order.tradeNO money:order.amount paymethod:@"1"];
//                //创建一个消息对象
//                NSNotification * notice = [NSNotification notificationWithName:AliPayTrue object:nil userInfo:nil];
//                //发送消息
//                [[NSNotificationCenter defaultCenter]postNotification:notice];
//            }
//        }];
//    }
//}



- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock
{
    
}

- (void)authWithInfo:(APayAuthInfo *)authInfo
            callback:(CompletionBlock)completionBlock
{
    
}

- (void)auth_V2WithInfo:(NSString *)infoStr
             fromScheme:(NSString *)schemeStr
               callback:(CompletionBlock)completionBlock
{
    
}

- (void)processAuth_V2Result:(NSURL *)resultUrl
             standbyCallback:(CompletionBlock)completionBlock
{
    
}
#pragma  mark 支付成功后订单传给后台。
- (void)shangChuan:(NSString*)orderno money:(NSString*)money paymethod:(NSString*)paymethod
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
//    userid = [self convertNull:userid];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/payOrder.do?1=1"];
//    NSDictionary *params = @{@"mobile":@"true",@"data":[NSString stringWithFormat:@"{\"orderno\":\"%@\",\"payno\":\"\",\"custid\":\"%@\",\"paymethod\":\"%@\",\"money\":\"%@\"}",orderno,userid,paymethod,money]};
//    NSLog(@"上传的url%@,上传参数%@",urlStr,params);
//    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
//        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
//        NSLog(@"/order/payOrder.do%@",str);
//        if ([str rangeOfString:@"true"].location != NSNotFound) {
//            NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
//            UIViewController *viewCtl = self.navigationController.viewControllers[1];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            NSLog(@"updateOrderType%@",array);
//            if ([paymethod integerValue] == 1) {
//                [self showAlert:@"支付成功"];
//            }
//        }else{
////            [self showAlert:@"更新支付状态失败"];
//        }
//    } failureBlock:^(AFHTTPRequestOperationManager *operationdata
//                     , NSError *error) {
//        NSInteger errorCode = error.code;
//        NSLog(@"错误信息%ld%@",(long)errorCode,error);
//        
//    }];
    
}

//时间
- (void)showAlert:(NSString *)message{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

//提示弹出框
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

//#pragma mark - - - -测试微信分享
//- (void)onSelectTimelineScene {
//    _currentScene = WXSceneTimeline;
//
//    UILabel *tips = (UILabel *)[self.view viewWithTag:TIPSLABEL_TAG];
//    tips.text = @"分享场景:朋友圈";
//    [self sendTextContent];
//}
//- (void)sendTextContent {
//    [WXApiRequestHandler sendText:kTextMessage
//                          InScene:_currentScene];
//}

#pragma mark  - - - - - - - 微信支付
// 此方法随机产生32位字符串， 修改代码红色数字可以改变 随机产生的位数。
- (NSString *)ret32bitString
{
    char data[32];
    
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString*)creatsign:(NSArray*)pramaArr
{
#pragma mark - - - - - - 预支付签名
    //    NSString* signstr = @"appid=wx956f59da3ba662b6&body=测试&mch_id=1230000109&nonce_str=5K8264ILTKCH16CQ2502SI8ZNMTM67VS&notify_url=http://182.92.96.58:8004/qitao/getNotifyAction&out_trade_no=11112222&spbill_create_ip=14.23.150.211&total_fee=1&trade_type=APP&key=192006250b4c09247ec02edce69f6a2d";
    NSString* signstr = [NSString stringWithFormat:@"appid=%@&body=%@&mch_id=%@&nonce_str=%@&notify_url=%@&out_trade_no=%@&spbill_create_ip=%@&total_fee=%@&trade_type=%@&key=%@",pramaArr[0],pramaArr[1],pramaArr[2],pramaArr[3],pramaArr[4],pramaArr[5],pramaArr[6],pramaArr[7],pramaArr[8],WXPay_key];
    NSLog(@"拼接的签名字符串%@",signstr);
    return [[self md5:signstr] uppercaseString];
}

- (NSString*)creatPaysign:(NSArray*)pramaArr
{
#pragma mark - - - - - - 支付签名
    NSString* signstr = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%@&key=%@",pramaArr[0],pramaArr[1],pramaArr[2],pramaArr[3],pramaArr[4],pramaArr[5],WXPay_key];
    NSLog(@"拼接的签名字符串%@",signstr);
    return [[self md5:signstr] uppercaseString];
}


- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)prepayIdRequest
{
    //    https://api.mch.weixin.qq.com/pay/unifiedorder
    /*
     appid      应用ID：wxd678efh567hg6787
     mch_id     商户号：1230000109
     nonce_str  随机字符串：5K8264ILTKCH16CQ2502SI8ZNMTM67VS
     sign       签名：C380BEC2BFD727A4B6845133519F3AD6
     body       商品描述
     out_trade_no商户订单号
     total_fee  总金额(Int)
     spbill_create_ip终端IP
     notify_url 通知地址
     trade_type 交易类型：APP
     */
    NSString* appid = WXPay_APPID;
    NSString* body = self.name;
    NSString* mch_id = WXPay_mch_id;
    NSString* nonce_str = [self ret32bitString];// @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS";//;//
    NSLog(@"随机字符串生成%@",nonce_str);
    NSString* notify_url = [NSString stringWithFormat:@"%@/order/payOrder1.do",ROOT_Path];
    NSString* out_trade_no = self.ordernewUUid;
    //NSString* spbill_create_ip = [self getIPAddress];
    NSString* spbill_create_ip = [self getDeviceIPAddresses];
//    int total_fee = (int)([@"0.01" floatValue]*100);//以分为单位
    int total_fee = (int)([self.orderMoney1 floatValue]*100);//以分为单位
    NSString* trade_type = @"APP";
    NSString* totalfeestr = [NSString stringWithFormat:@"%i",total_fee];
    NSArray* parmaArray = @[appid,body,mch_id,nonce_str,notify_url,out_trade_no,spbill_create_ip,totalfeestr,trade_type];
    NSString* sign = [self creatsign:parmaArray];//@"C380BEC2BFD727A4B6845133519F3AD6";
    NSLog(@"sign = %@",sign);
    NSString *urlStr = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
    //        NSString *strURL=[[NSBundle mainBundle]pathForResource:@"xml" ofType:@"txt"];
    //        //将路径下文件得内容加载到字符串中
    //        NSString *str=[[NSString alloc]initWithContentsOfFile:strURL encoding:NSUTF8StringEncoding error:nil];
    NSString *xmlstr = [NSString stringWithFormat:@"<xml><appid>%@</appid><body>%@</body><mch_id>%@</mch_id><nonce_str>%@</nonce_str><notify_url>%@</notify_url><out_trade_no>%@</out_trade_no><spbill_create_ip>%@</spbill_create_ip><total_fee>%i</total_fee><trade_type>%@</trade_type><sign>%@</sign></xml>",appid,body,mch_id,nonce_str,notify_url,out_trade_no,spbill_create_ip,total_fee,trade_type,sign];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    //
    NSData *data = [xmlstr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *data1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"支付宝预处理returnStr%@",returnStr);
    NSDictionary *dict = [NSDictionary dictionaryWithXMLString:returnStr];
    NSLog(@"test = %@",dict);
    NSLog(@"__name:%@,return_code:%@,return_msg:%@",[dict objectForKey:@"__name"],[dict objectForKey:@"return_code"],[dict objectForKey:@"return_msg"]);
    if ([[dict objectForKey:@"return_code"]isEqualToString:@"SUCCESS"]) {
        //预处理成功
        if ([[dict objectForKey:@"result_code"]isEqualToString:@"SUCCESS"]) {
            _prepay_id = [dict objectForKey:@"prepay_id"];
            
            //调起微信支付
            PayReq *req = [[PayReq alloc] init];
            req.openID=WXPay_APPID;
            req.nonceStr = dict[@"nonce_str"];
            req.partnerId = dict[@"mch_id"];
            req.package = @"Sign=WXPay";
            req.prepayId= dict[@"prepay_id"];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//            NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//            [formatter setTimeZone:timeZone];
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            req.timeStamp= [datenow timeIntervalSince1970];
            NSArray* array = @[req.openID,req.nonceStr,req.package,req.partnerId,req.prepayId,timeSp];
            req.sign= [self creatPaysign:array];
            
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                [WXApi sendReq:req];
                [[NSUserDefaults standardUserDefaults] setValue:_orderno1 forKey:WXout_trade_no];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",WXPay_APPID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                //                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:ORDER_PAY_NOTIFICATION object:nil];//监听一个通知
            }else
            {
                UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:nil message:@"您没有安装微信客户端" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [aleartView show];
            }
            
        }else{
            
        }
    }else{
        //预处理失败
        UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:nil message:[dict objectForKey:@"return_msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aleartView show];
    }
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
            {
                NSLog(@"支付成功");
            }
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}


-(NSString *)getDeviceIPAddresses {
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    　 close(sockfd);
    
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        
        if (ips.count > 0) {
            
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
            
        }
        
    }
    
    return deviceIP;
    
}




@end
