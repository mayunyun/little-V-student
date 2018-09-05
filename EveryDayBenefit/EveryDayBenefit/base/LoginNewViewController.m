//
//  LoginNewViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/12/30.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "LoginNewViewController.h"
#import "BaseTabBarViewController.h"
#import "MBProgressHUD.h"
#import "LoginModel.h"
#import <RongIMKit/RongIMKit.h>
#import "RegisterNewViewController.h"
#import "ForgetPwdViewController.h"

#define statusbarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

@interface LoginNewViewController ()<UITextFieldDelegate,UINavigationControllerDelegate>
{
    UITextField* _userFiled;
    UITextField* _pwdFiled;
    BOOL _isRemember;
    BOOL _isAutoLogin;
    UIButton* _leftimgBtn;
    UIButton* _rightimgBtn;
    
    
}
@end

@implementation LoginNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"存储的%@",[userDefault objectForKey:@"isRemember"]);
    NSInteger j  = [[userDefault objectForKey:@"isRemember"]integerValue];
    NSInteger m = [[userDefault objectForKey:@"isAutoLogin"]integerValue];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon-back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor orangeColor]];
    
    if (j == 1) {
        _isRemember = YES;
    }else{
        _isRemember = NO;
    }
    if (m == 1) {
        _isAutoLogin = YES;
    }else{
        _isAutoLogin = NO;
    }
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

//#pragma mark - UINavigationControllerDelegate
//// 将要显示控制器
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 判断要显示的控制器是否是自己
//    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
//
//    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
//}

- (void)creatUI
{
    UIScrollView* bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    bgView.contentSize = CGSizeMake(mScreenWidth, mScreenHeight);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.bounces = NO;
    [self.view addSubview:bgView];
    
//    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    leftBarBtn.frame = CGRectMake(20, 20, 30, 40);
//    UIImageView* leftBarimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
//    [leftBarimgView setImage:[UIImage imageNamed:@"icon-back"]];
//    [leftBarBtn addSubview:leftBarimgView];
//    [leftBarBtn addTarget:self action:@selector(leftBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:leftBarBtn];
    
    UIImageView* bottomimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 185-statusbarHeight-20, mScreenWidth, 180)];
    bottomimgView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomimgView setImage:[UIImage imageNamed:@"loginbottom.png"]];
    [bgView addSubview:bottomimgView];
    
    UIImageView* iconeView = [[UIImageView alloc]initWithFrame:CGRectMake((mScreenWidth - 100)/2, 60, 110, 110)];
    iconeView.image = [UIImage imageNamed:@"loginicone.png"];
    [bgView addSubview:iconeView];
    
    
    UIImageView* phoneimgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, iconeView.bottom+40, bgView.width - 80, 60)];
    phoneimgView.userInteractionEnabled = YES;
    phoneimgView.image = [UIImage imageNamed:@"logincell.png"];
    [bgView addSubview:phoneimgView];
    UIImageView* loginren = [[UIImageView alloc]initWithFrame:CGRectMake(phoneimgView.height/2 , (phoneimgView.height - 30)/2, 15, 15)];
    loginren.image = [UIImage imageNamed:@"loginren.png"];
    [phoneimgView addSubview:loginren];
    _userFiled = [[UITextField alloc]initWithFrame:CGRectMake(loginren.right+5, 0, phoneimgView.width - loginren.right - 10 , phoneimgView.left)];
    _userFiled.delegate = self;
    _userFiled.tag = 10;
    _userFiled.placeholder = @"用户名";
    [phoneimgView addSubview:_userFiled];
    
    UIImageView* pwdimgView = [[UIImageView alloc]initWithFrame:CGRectMake(phoneimgView.left, phoneimgView.bottom+15, phoneimgView.width, phoneimgView.height)];
    pwdimgView.image = [UIImage imageNamed:@"logincell.png"];
    pwdimgView.userInteractionEnabled = YES;
    [bgView addSubview:pwdimgView];
    UIImageView* pwdlock = [[UIImageView alloc]initWithFrame:CGRectMake(pwdimgView.height/2, (pwdimgView.height - 30)/2, 15, 15)];
    pwdlock.image = [UIImage imageNamed:@"loginlock.png"];
    [pwdimgView addSubview:pwdlock];
    _pwdFiled = [[UITextField alloc]initWithFrame:CGRectMake(pwdlock.right+5, 0, pwdimgView.width - pwdlock.right - 10, pwdimgView.height)];
    _pwdFiled.delegate = self;
    _pwdFiled.tag = 20;
    _pwdFiled.secureTextEntry = YES;//密码遮掩
    _pwdFiled.placeholder = @"请输入密码";
    _pwdFiled.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
    _pwdFiled.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    [pwdimgView addSubview:_pwdFiled];
    
    
    UIView* typeView = [[UIView alloc]initWithFrame:CGRectMake(pwdimgView.left, pwdimgView.bottom, pwdimgView.width, 40)];
    typeView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:typeView];
    _leftimgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftimgBtn.frame = CGRectMake(pwdlock.left, (typeView.height - 15)/2, 15, 15);
    if (_isRemember == YES) {
        [_leftimgBtn setImage:[UIImage imageNamed:@"remember1"] forState:UIControlStateNormal];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        _userFiled.text = [userDefault objectForKey:@"account"];
        _pwdFiled.text = [userDefault objectForKey:@"pwd"];
    }else {
        [_leftimgBtn setImage:[UIImage imageNamed:@"fuxuanbtn.png"] forState:UIControlStateNormal];
    }
    [typeView addSubview:_leftimgBtn];
    [_leftimgBtn addTarget:self action:@selector(jizhubtn:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(_leftimgBtn.right+10, 0, 60, typeView.height)];
    leftlabel.font = [UIFont systemFontOfSize:12];
    leftlabel.text = @"记住密码";
    leftlabel.textColor = GrayTitleColor;
    [typeView addSubview:leftlabel];
    
    _rightimgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightimgBtn.frame = CGRectMake(leftlabel.right+10, (typeView.height - 15)/2, 15, 15);
    [typeView addSubview:_rightimgBtn];
    [_rightimgBtn addTarget:self action:@selector(autologin:) forControlEvents:UIControlEventTouchUpInside];
    if (_isAutoLogin == YES) {
        [_rightimgBtn setImage:[UIImage imageNamed:@"remember2"] forState:UIControlStateNormal];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        _userFiled.text = [userDefault objectForKey:@"account"];
        _pwdFiled.text = [userDefault objectForKey:@"pwd"];
        [self loginClick:nil];
    }else {
        [_rightimgBtn setImage:[UIImage imageNamed:@"fuxuanbtn.png"] forState:UIControlStateNormal];
    }
    UILabel* rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(_rightimgBtn.right+10, 0, 100, typeView.height)];
    rightlabel.font = [UIFont systemFontOfSize:12];
    rightlabel.text = @"下次自动登录";
    rightlabel.textColor = GrayTitleColor;
    [typeView addSubview:rightlabel];
    
    UIButton* logininBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logininBtn.frame = CGRectMake(phoneimgView.left, typeView.bottom, phoneimgView.width, phoneimgView.height);
    [logininBtn setImage:[UIImage imageNamed:@"loginsure.png"] forState:UIControlStateNormal];
    [bgView addSubview:logininBtn];
    [logininBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registBtn.frame = CGRectMake(logininBtn.left+logininBtn.height/2, logininBtn.bottom, 60, 30);
    [bgView addSubview:registBtn];
    [registBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    registBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [registBtn setAttributedTitle:[self NSUnderlineStyleSingle:@"注册"] forState:UIControlStateNormal];
    
    UIButton* forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetBtn addTarget:self action:@selector(forgetClick:) forControlEvents:UIControlEventTouchUpInside];
    forgetBtn.frame = CGRectMake(logininBtn.right - logininBtn.height/2 - 80, registBtn.top, 80, 30);
    [bgView addSubview:forgetBtn];
    [forgetBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    forgetBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [forgetBtn setAttributedTitle:[self NSUnderlineStyleSingle:@"忘记密码"] forState:UIControlStateNormal];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _userFiled) {
        textField.secureTextEntry = NO;
    }else{
        textField.secureTextEntry = YES;
    }
    return YES;
}
#pragma mark 左侧导航按钮点击事件
- (void)leftBarBtnClick
{
    NSArray* array = self.navigationController.viewControllers;
    if (array.count == 0) {
        APPDelegate.window.rootViewController = nil;
        APPDelegate.window.rootViewController = [[BaseTabBarViewController alloc]init];//baseNav;
    }else{
        [self.tabBarController setSelectedIndex:0];
        UIViewController *viewCtl = self.navigationController.viewControllers[0];
        [self.navigationController popToViewController:viewCtl animated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSAttributedString*)NSUnderlineStyleSingle:(NSString*)text
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    //改变颜色
    [str addAttribute:NSForegroundColorAttributeName value:COLOR(221, 0, 16, 1) range:strRange];
    return str;
}

-(void)jizhubtn:(UIButton*)btn
{
    if(_isRemember == NO)
    {
        [_leftimgBtn setImage:[UIImage imageNamed:@"remember1.png"] forState:UIControlStateNormal];
        _isRemember = YES;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"1" forKey:@"isRemember"];
        [userDefault synchronize];
    } else {
        [_leftimgBtn setImage:[UIImage imageNamed:@"fuxuanbtn.png"] forState:UIControlStateNormal];
        _isRemember = NO;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"account"];
        [userDefault removeObjectForKey:@"pwd"];
        [userDefault setObject:@"0" forKey:@"isRemember"];
        [userDefault synchronize];
    }
}

- (void)autologin:(UIButton*)sender
{
    
    if(_isAutoLogin == NO)
    {
        [_rightimgBtn setImage:[UIImage imageNamed:@"remember1.png"] forState:UIControlStateNormal];
        _isAutoLogin = YES;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"1" forKey:@"isAutoLogin"];
        [userDefault synchronize];
        
    } else {
        [_rightimgBtn setImage:[UIImage imageNamed:@"fuxuanbtn.png"] forState:UIControlStateNormal];
        _isAutoLogin = NO;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"0" forKey:@"isAutoLogin"];
        [userDefault synchronize];
    }
}

//登录的点击事件
- (void)loginClick:(UIButton*)sender
{
    /*
     /login/appLogin.do
     data{
     account:用户名
     password:密码
     }
     mobile:true
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* datastr =[NSString stringWithFormat:@"{\"account\":\"%@\",\"password\":\"%@\"}",_userFiled.text,_pwdFiled.text];
    [param setObject:datastr forKey:@"data"];
    [param setObject:@"true" forKey:@"mobile"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appLogin.do"];
    NSLog(@"登录数据%@-----%@",urlStr,param);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:param success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"登录数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([str rangeOfString:@"msg"].location != NSNotFound) {
            NSLog(@"登录失败");
            [self showAlert:array[0][@"msg"]];
        }else{
            if (array.count!=0){
                NSLog(@"登录成功");
                LoginModel* model = [[LoginModel alloc]init];
                [model setValuesForKeysWithDictionary:array[0]];
                if ([model.isvalid integerValue] == 0) {
                    [self showAlert:@"您的账号已失效"];
                }else if ([model.custtypeid integerValue] != 0){
                    [self showAlert:@"账号非客户端账号"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setValue:model.Id forKey:USERID];
                    [[NSUserDefaults standardUserDefaults] setObject:model.phone forKey:USERPHONE];
                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault setObject:_userFiled.text forKey:@"account"];
                    [userDefault setObject:_pwdFiled.text forKey:@"pwd"];
                    [self getTokenwithId:model.Id name:model.name];
                    
                    NSArray* array = self.navigationController.viewControllers;
                    NSLog(@"-------%@",array);
                    if (array.count == 1 && [array[0] isKindOfClass:[LoginNewViewController class]] ) {
                        APPDelegate.window.rootViewController = nil;
                        APPDelegate.window.rootViewController = [[BaseTabBarViewController alloc]init];//baseNav;
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
//                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                    
                    
                }
                
            }else{
                [self showAlert:@"登录超时"];
            }
        }
        [hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [hud hide:YES];
    }];
    
}



- (void)getTokenwithId:(NSString*)userid name:(NSString*)name
{
    /*
     /rongcloud/getToken.do
     mobile:true
     data{
     id:客户id
     name:客户名字
     }
     */
    userid = [self convertNull:userid];
    name = [self convertNull:name];
    //获取token
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/rongcloud/getToken.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"name\":\"%@\"}",userid,name];
    NSDictionary* params = @{@"data":datastr,@"mobile":@"true"};
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* restr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([restr rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getToken.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            //            NSRange range = {1,restr.length - 2};
            //            NSString *str  = [restr substringWithRange:range];
            //            str = [self replaceAllOthers:str];
            //            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSString* token = dict[@"token"];
            NSLog(@"转换===%@",token);
            // 连接融云服务器。
            // 设置 deviceToken。
            [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%ld", (long)status);
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
            }];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}


- (void)registBtnClick:(UIButton*)sender
{
    NSLog(@"--------%@%@%@",self.navigationController.topViewController,self.navigationController.visibleViewController,self.navigationController.viewControllers);
    RegisterNewViewController* reVC = [[RegisterNewViewController alloc]init];
    [self.navigationController pushViewController:reVC animated:YES];
}


- (void)forgetClick:(UIButton*)sender
{
    NSLog(@"--------%@%@%@",self.navigationController.topViewController,self.navigationController.visibleViewController,self.navigationController.viewControllers);
    ForgetPwdViewController* vc = [[ForgetPwdViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
