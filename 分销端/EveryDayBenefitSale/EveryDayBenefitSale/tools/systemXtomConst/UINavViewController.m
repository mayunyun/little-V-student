//
//  UINavViewController.m
//  BAOWEN
//
//  Created by 山东三米 on 13-9-5.
//  Copyright (c) 2013年 山东三米. All rights reserved.
//
#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define MoveWidth 20
#import "UINavViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UINavViewController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    
    BOOL isCanNotMove;
}
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;
@end

@implementation UINavViewController
@synthesize screenShotsList;
@synthesize backgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.screenShotsList = [[[NSMutableArray alloc]initWithCapacity:2]autorelease];
        self.canDragBack = YES;
    }
    return self;
}
- (void)dealloc
{
    [screenShotsList release];
    screenShotsList = nil;
    
    [backgroundView removeFromSuperview];
    backgroundView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setNeedsStatusBarAppearanceUpdate];
    //ios7设置BarButtonItem字体颜色，则会显示出来，不包括返回箭头
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    //设置BarButtonItem颜色，包括返回箭头
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    return;
    
    UIImageView *shadowImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]]autorelease];
    shadowImageView.frame = CGRectMake(-10, 64, 10, self.view.frame.size.height-64);
    [self.view addSubview:shadowImageView];
    
    UIPanGestureRecognizer *recognizer = [[[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)]autorelease];
    [recognizer delaysTouchesBegan];
    
    UIView *temView = [[[UIView alloc]init]autorelease];
    [temView setFrame:CGRectMake(0, 64, 15, self.view.frame.size.height-64)];
    [temView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:temView];
    
    [temView addGestureRecognizer:recognizer];
    
    /*
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        UINavViewController *weakSelf = self;
        
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
     */
    return;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0) forBarMetrics:UIBarMetricsDefault];
    //设置BarButtonItem颜色，包括返回箭头
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    
    if ([self.navigationBar respondsToSelector:@selector(setTranslucent:)])
    {
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = [UIColor redColor];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0]};
        //[[UIBarButtonItem appearance] setTintColor:[UIColor orangeColor]];
    }
}
/*
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
}
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}
 */
/*
//状态栏的 貌似不起作用
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return YES;
}
*/
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotsList addObject:[self capture]];
    if (self.viewControllers.count)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    
    //NSLog(@"Move to:%f",x);
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
    
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    //NSLog(@"我去呢：%f,%f",touchPoint.x,touchPoint.y);
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        if (touchPoint.x > MoveWidth)
        {
            isCanNotMove = YES;
            return;
        }
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)]autorelease];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)]autorelease];
            blackMask.backgroundColor = [UIColor whiteColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[[UIImageView alloc]initWithImage:lastScreenShot]autorelease];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (isCanNotMove)
        {
            isCanNotMove = NO;
            return;
        }
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        if (isCanNotMove)
        {
            isCanNotMove = NO;
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}


//横竖屏
-(NSUInteger)supportedInterfaceOrientations
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
