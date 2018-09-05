
//  BaseViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//
//总的基类 设置屏幕延伸的范围 设置导航栏的颜色 设置信号栏字体颜色 设置横竖屏
#import "BaseViewController.h"
#import "GetCustInfoModel.h"
#import "PersonInfo.h"

@interface BaseViewController ()
{
    BOOL _log;
    PersonInfo* _personInfo;
}
@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] shouldPlayInputClicks];
    [self isLogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackGorundColor;
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _grayView = [[ShowAnimationView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
    //
//    [self monitorNetworkState];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoadDataBase:) name:KLoadDataBase object:nil];
    
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)backBarButtonItemTarget:(id)target action:(SEL)action
{
    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBarBtn.frame = CGRectMake(0, 0, 30, 40);
    UIImageView* leftBarimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
    [leftBarimgView setImage:[UIImage imageNamed:@"icon-back"]];
    [leftBarBtn addSubview:leftBarimgView];
    [leftBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = left;
    
}

- (void)backBarTitleButtonItemTarget:(id)target action:(SEL)action text:(NSString*)str
{
    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBarBtn.frame = CGRectMake(0, 0, mScreenWidth/2, 40);
    UIImageView* leftBarimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
    [leftBarimgView setImage:[UIImage imageNamed:@"icon-back"]];
    [leftBarBtn addSubview:leftBarimgView];
    UILabel* leftBarLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftBarimgView.right, 0, leftBarBtn.width - leftBarimgView.width, 40)];
    leftBarLabel.text = [NSString stringWithFormat:@"%@",str];
    [leftBarBtn addSubview:leftBarLabel];
    [leftBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = left;
    
}

- (void)rightBarTitleButtonTarget:(id)target action:(SEL)action text:(NSString*)str{
    
    NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:20.0]};
    CGSize size1 =  [str boundingRectWithSize:CGSizeMake(mScreenWidth - 20.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    NSLog(@"size.width=%f, size.height=%f", size1.width, size1.height);
    UIButton* rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBarBtn.frame = CGRectMake(0, 0, size1.width, 30);
    [rightBarBtn setTitle:str forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    [rightBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)rightBarImgButtonTarget:(id)target action:(SEL)action imgname:(NSString*)str{
    UIButton* rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBarBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBarBtn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [rightBarBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = right;
}


#pragma mark - 横竖屏
//横竖屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationPortrait)
    {
        return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotate
{
    if ([[UIApplication sharedApplication]statusBarOrientation] == 3)
    {
        return NO;
    }
    return NO;
}

//提示弹出框
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
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

//取消多余cell
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

-(NSString*)convertNull:(id)object{
    // 转换空串
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    else if (object==nil){
        return @"";
    }
    return object;
    
}

//NSString* string =@"2016-08-31“转化成数组中
- (NSArray*)separateDateStr:(NSString*)str
{
//    NSString *timeStamp2 = str;
//    long long int date1 = (long long int)[timeStamp2 intValue];
//    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
//    NSLog(@"时间戳转日期 %@  = %@", timeStamp2, date2);
    
//    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:timeZone];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    // 毫秒值转化为秒
    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]/ 1000.0];
    
    NSString *datastring = [formatter stringFromDate:date2];
    NSArray *array = [datastring componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
    NSMutableArray* numarray = [[NSMutableArray alloc]init];
    NSString* string1;
    for (NSString* str in array) {
        string1=[str stringByReplacingOccurrencesOfString:@"-"withString:@""];
        [numarray addObject:string1];
    }
    NSLog(@"replaceStr=%@",string1);
    return numarray;
}

#pragma mark 类方法-判断程序是否第一次启动
- (void)isLogin
{
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/ifLogin.do"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"ifLogin.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            if (!IsEmptyValue([[NSUserDefaults standardUserDefaults]objectForKey:USERID])) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERID];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERPHONE];
            }
            if (!IsEmptyValue([[NSUserDefaults standardUserDefaults]objectForKey:IsLogin])) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:IsLogin];
            }
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(dict)) {
                GetCustInfoModel* model = [[GetCustInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [[NSUserDefaults standardUserDefaults] setValue:model.Id forKey:USERID];
                [[NSUserDefaults standardUserDefaults] setObject:model.phone forKey:USERPHONE];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:IsLogin];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:IsLogin object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}


//#pragma mark - 监测网络状态
//- (void)monitorNetworkState{
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager startMonitoring];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@"没有网络");
//                _personInfo.hasNet = NO;
//                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KLoadDataBase object:nil userInfo:@{@"netType":@"NotReachable"}]];
//                
//                break;
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未知");
//                if(!_personInfo.hasNet){
//                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KLoadDataBase object:nil userInfo:@{@"netType":@"Unknown"}]];
//                }
//                _personInfo.hasNet = YES;
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"WiFi");
//                if(!_personInfo.hasNet){
//                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KLoadDataBase object:nil userInfo:@{@"netType":@"WiFi"}]];
//                }
//                _personInfo.hasNet = YES;
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"3G|4G");
//                if(!_personInfo.hasNet){
//                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KLoadDataBase object:nil userInfo:@{@"netType":@"WWAN"}]];
//                }
//                _personInfo.hasNet = YES;
//                break;
//            default:
//                break;
//        }
//    }];
//    
//}
//
////用来有网的时候刷新数据用的
//- (void)getLoadDataBase:(NSNotification *)text{
//    NSLog(@"开始重新加载网络");
//}
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter ]removeObserver:self name:KLoadDataBase object:nil];
//}




@end
