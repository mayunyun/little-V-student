//
//  BaseTabBarViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "OrderViewController.h"
#import "ReturnViewController.h"
#import "MineViewController.h"
#import "BaseNavViewController.h"
#import "Reachability.h"
#import "UIViewController+HTHud.h"

@interface BaseTabBarViewController ()

@property (nonatomic , strong) UILabel *hintContrl;
@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVC];
    [self netConnect];
    //通知 监听一下tabbar的隐藏与显示
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(TabbarHidden:) name:NotificationTabBarHidden object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationTabBarHidden object:nil];
}

- (void)initVC
{
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    OrderViewController *homVC = [[OrderViewController alloc]init];
    BaseNavViewController *naVC  = [[BaseNavViewController alloc]initWithRootViewController:homVC];
    naVC.tabBarItem.enabled          = YES;
    //    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    //    bgView.backgroundColor = TabBarColor;
    //    [self.tabBar insertSubview:bgView atIndex:0];
    homVC.title = @"订单";
    
    ReturnViewController *listVC = [[ReturnViewController alloc]init];
    BaseNavViewController *listNav = [[BaseNavViewController alloc]initWithRootViewController:listVC];
    listNav.tabBarItem.enabled = YES;
    listVC.title = @"退货";

    
    MineViewController *mineVC = [[MineViewController alloc]init];
    BaseNavViewController *mineNav = [[BaseNavViewController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem.enabled = YES;
    mineVC.title = @"个人";
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:naVC,listNav,mineNav,nil];
    self.viewControllers = list;
    
    //标题默认颜色
    UIColor *normalColor = GrayTitleColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    //标题选择时的高亮颜色
    UIColor *titleHighlightedColor = NavBarItemColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    NSArray *imgArray = @[@"icon-0",
                          @"icon_01",
                          @"icon_02"];
    NSArray *selectImgArray =   @[@"icon-00-1",
                                  @"icon-01-1",
                                  @"icon-02-1"];
    for (int i = 0; i < imgArray.count; i++) {
        UIViewController *vc = list[i];
        vc.tabBarItem.tag = i;
        
        NSString *imageStr = imgArray[i];
        NSString *selectImageStr = selectImgArray[i];
        if (IOS7) {
            //渲染模式
            vc.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            //            [vc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectImageStr] withFinishedUnselectedImage:[UIImage imageNamed:imageStr]];
            vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:selectImageStr] selectedImage:[UIImage imageNamed:imageStr]];
            
        }
        
    }
    
    
}


- (void)TabbarHidden:(NSNotification *)noti
{
    if ([noti.object isEqualToString:@"yes"]) {
        self.tabBar.hidden = YES;
    }
    else if ([noti.object isEqualToString:@"no"]) {
        self.tabBar.hidden = NO;
    }
}

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

- (void)netConnect
{
    
    //初始化提示界面
    self.hintContrl = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 160)/2, (mScreenHeight - 90) / 2, 160, 30)];
    self.hintContrl.backgroundColor = COLOR(0, 0, 0, .9);
    self.hintContrl.font = [UIFont systemFontOfSize:14];
    self.hintContrl.textColor = [UIColor whiteColor];
    self.hintContrl.textAlignment = NSTextAlignmentCenter;
    
    
    //添加网络切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChangeAction:) name:kReachabilityChangedNotification object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Reachable");
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Unreachable");
        });
    };
    
    [reach startNotifier];
}
#pragma mark 通知事件
- (void)netWorkChangeAction:(NSNotification *)notification
{
    Reachability * reach = [notification object];
    if([reach currentReachabilityStatus] == NotReachable)
    {
        //当前无网络连接
        [self showHint:@"当前无网络连接!"];
        
    }else if ([reach currentReachabilityStatus] == ReachableViaWWAN)
    {
        //当前处于2G/3G/4G网络环境!"];
        [self showHint:@"当前处于2G/3G/4G网络环境!"];
        
    }else if ([reach currentReachabilityStatus] == ReachableViaWiFi)
    {
        //当前处于WiFi网络环境!"];
        [self showHint:@"当前处于WiFi网络环境!"];
        
    }
    
}

- (void)showHint:(NSString *)text
{
    self.hintContrl.text = text;
    self.hintContrl.alpha = 1;
    [APPDelegate.window addSubview:self.hintContrl];

    
    [self performBlock:^{
        [self hideHint];
    } afterDelay:4];
}

- (void)hideHint
{
    [UIView animateWithDuration:.5 animations:^{
        self.hintContrl.alpha = 0;
    } completion:^(BOOL finished) {
        [self.hintContrl removeFromSuperview];
    }];
}


@end
