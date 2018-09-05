//
//  BaseNavViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/9.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseNavViewController.h"
#import "PopVCInfo.h"
#import "LoginNewViewController.h"
#import "PayTypeTbVC.h"


@interface BaseNavViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic) BOOL isSwitching;
// 记录push标志
@property (nonatomic, getter=isPushing) BOOL pushing;

@property (nonatomic, strong)NSMutableArray* popVCAnimateQueue;

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _popVCAnimateQueue = [[NSMutableArray alloc]init];
    self.delegate = self;
    if(IOS7)
    {
        self.navigationBar.translucent = NO;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    }
//    if (self.pushing == YES) {
//        NSLog(@"被拦截");
//        return;
//    } else {
//        NSLog(@"push");
//        self.pushing = YES;
//    }
    
//    if (animated) {
//        if (self.isSwitching) {
//            return; // 1. 如果是动画，并且正在切换，直接忽略
//        }
//        self.isSwitching = YES; // 2. 否则修改状态
//    }
    if (![[super topViewController] isKindOfClass:[viewController class]]) {
        [super pushViewController:viewController animated:animated];
    }
}

#pragma mark - UINavigationController

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!self.isSwitching) {
        NSArray* array = self.viewControllers;
        NSLog(@"navigationController的栈%@",array);
        if (array.count>2) {
            if ([viewController isKindOfClass:[PayTypeTbVC class]]) {
//                for (int i = array.count-1; i < array.count && i>0; i--) {
//                    
//                }
//                UIViewController *viewCtl = array[array.count - 1 - 2];
//                [self popToViewController:viewCtl animated:YES];
                return nil;
            }
        }
        return [super popToViewController:viewController animated:animated];
    } else {
        [self enqueuePopViewController:viewController animate:animated];
        return nil;
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (!self.isSwitching) {
        NSArray* array = self.viewControllers;
        NSLog(@"navigationController的栈%@",array);
        if (array.count>2) {
            if ([array[array.count-1-1] class] == [PayTypeTbVC class]) {
                UIViewController *viewCtl = array[array.count - 1 - 2];
                [self popToViewController:viewCtl animated:YES];
                return nil;
            }
        }
        return [super popViewControllerAnimated:animated];
    } else {
        [self enqueuePopViewController:nil animate:animated];
        return nil;
    }
}

- (void)enqueuePopViewController:(UIViewController*)vc animate:(BOOL)animate
{
    PopVCInfo* info = [[PopVCInfo alloc]init];
    info.controller = vc;
    info.animate = animate;
    [self.popVCAnimateQueue addObject:info];
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.isSwitching = NO; // 3. 还原状态
    self.pushing = NO;
    // 显示完毕之后判断是否需要Pop
    if (self.popVCAnimateQueue.count) {
        PopVCInfo *info = [self.popVCAnimateQueue firstObject];
        [self.popVCAnimateQueue removeObjectAtIndex:0];
        if (info.controller) {
            [self.navigationController popToViewController:info.controller animated:info.animate];
        } else {
            [self.navigationController popViewControllerAnimated:info.animate];
        }
    }
}






//- (UIBarButtonItem *)backBarButtonItemTarget:(id)target action:(SEL)action
//{
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
//    button.frame=CGRectMake(0, 0, 30, 21);
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    return [[UIBarButtonItem alloc] initWithCustomView:button];
//}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSInteger countOfViewControllers = self.viewControllers.count;
    while (countOfViewControllers > 0) {
        
        [self popViewControllerAnimated:NO];
        countOfViewControllers--;
    }
    return nil;
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







@end
