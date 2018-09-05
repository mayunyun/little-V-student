//
//  LoginViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"
#import "BaseTabBarViewController.h"
#import "XtomFunction.h"
#import "NSString+Base64.h"
#import "HomeViewController.h"
#import "LoginModel.h"
#import "RegisterNewViewController.h"

#import <RongIMKit/RongIMKit.h>

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIScrollView* groundView;
     BOOL _isRemember;
    UIImageView * jizhu;
}

@property (nonatomic,strong) UITextField * userFiled;
@property (nonatomic,strong) UITextField * pwdFiled;
@property (nonatomic,strong) UIButton * loginBtn;
@property (nonatomic,strong) UIButton * registerBtn;
@property (nonatomic,strong) UIButton * forgetBtn;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"登录";
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"存储的%@",[userDefault objectForKey:@"isRemember"]);
    NSInteger j  = [[userDefault objectForKey:@"isRemember"]integerValue];
    if (j == 1) {
        _isRemember = YES;
    }else{
        _isRemember = NO;
    }
    
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame = CGRectMake(0, 0, 60, 40);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;
    [leftBtn addTarget:self action:@selector(leftBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    [rightBtn addTarget:self action:@selector(rightBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self creatSubViews];
    
}

- (void)creatSubViews
{
    //底图
    groundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 , mScreenWidth, mScreenHeight-64-49)];
    groundView.backgroundColor = BackGorundColor;
    groundView.userInteractionEnabled = YES;
    groundView.showsVerticalScrollIndicator = NO;
    groundView.bounces = NO;
    [self.view addSubview:groundView];
    [groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).with.offset(0);
        make.bottom.mas_equalTo(self.view.bottom).with.offset(0);
        make.left.mas_equalTo(self.view.left).with.offset(0);
        make.right.mas_equalTo(self.view.right).with.offset(0);
    }];
    UITapGestureRecognizer *textTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKey:)];
    groundView.userInteractionEnabled = YES;
    [groundView addGestureRecognizer:textTap];
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, mScreenWidth, 100)];
    topView.userInteractionEnabled = YES;
    topView.backgroundColor = [UIColor whiteColor];
    [groundView addSubview:topView];
    
    UILabel* userLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    userLabel.backgroundColor = [UIColor whiteColor];
    [topView addSubview:userLabel];
    _userFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, userLabel.top, mScreenWidth - 10 , 49)];
    _userFiled.delegate = self;
    _userFiled.tag = 10;
    _userFiled.placeholder = @"请输入手机号";
    [topView addSubview:_userFiled];
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(userLabel.left, _userFiled.bottom, userLabel.width, 1)];
    line.backgroundColor = LineColor;
    [topView addSubview:line];
    
    UILabel* pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, userLabel.bottom, mScreenWidth, 50)];
    pwdLabel.backgroundColor = [UIColor whiteColor];
    [topView addSubview:pwdLabel];
    _pwdFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, pwdLabel.top, mScreenWidth - 10, 49)];
    _pwdFiled.delegate = self;
    _pwdFiled.tag = 20;
    _pwdFiled.secureTextEntry = YES;//密码遮掩
    _pwdFiled.placeholder = @"请输入密码";
    _pwdFiled.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
    _pwdFiled.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(pwdLabel.left, _pwdFiled.bottom, pwdLabel.width, 1)];
    line1.backgroundColor = LineColor;
    [topView addSubview:_pwdFiled];
    [topView addSubview:line1];
    
    jizhu = [[UIImageView alloc]initWithFrame:CGRectMake(40, topView.bottom+5, 20, 20)];
    jizhu.image = [UIImage imageNamed:@""];
    jizhu.backgroundColor = [UIColor whiteColor];
    [jizhu.layer setCornerRadius:5];
    [self.view addSubview:jizhu];
    UILabel * jizhuyonghu = [[UILabel alloc]initWithFrame:CGRectMake(65, topView.bottom+5, 100, 30)];
    jizhuyonghu.text = @"记住用户名";
    jizhuyonghu.textColor = [UIColor lightGrayColor];
    jizhuyonghu.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:jizhuyonghu];
    UIButton * jzbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [jzbtn setFrame:CGRectMake(30, topView.bottom+5, 130, 30)];
    jzbtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:jzbtn];
    [jzbtn addTarget:self action:@selector(jizhubtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isRemember == YES) {
        jizhu.image =[UIImage imageNamed:@"remember1"];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        _userFiled.text = [userDefault objectForKey:@"account"];
    }else {
        jizhu.image = [UIImage imageNamed:@"remember2"];
    }
    _loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginBtn.frame = CGRectMake(10, 40 + topView.bottom, mScreenWidth - 20, 50) ;
    _loginBtn.backgroundColor = NavBarItemColor;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [groundView addSubview:_loginBtn];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5.0;
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _registerBtn.frame = CGRectMake(10, 10 + _loginBtn.bottom, mScreenWidth/2 - 10, 30);
    _registerBtn.backgroundColor = [UIColor clearColor];
    _registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    [groundView addSubview:_registerBtn];
    [_registerBtn addTarget:self action:@selector(refisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _forgetBtn.frame = CGRectMake(mScreenWidth/2, 10 + _loginBtn.bottom, mScreenWidth/2 - 10, _registerBtn.height);
    _forgetBtn.backgroundColor = [UIColor clearColor];
    _forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_forgetBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    [groundView addSubview:_forgetBtn];
    [_forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView* bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, groundView.bottom - 150, mScreenWidth, 150)];
    bottomView.backgroundColor = [UIColor clearColor];
//    [groundView addSubview:bottomView];
    
    UIView* leftline = [[UIView alloc]initWithFrame:CGRectMake(10, 15, (mScreenWidth - 60 - 20)/2, 1)];
    leftline.backgroundColor = LineColor;
    [bottomView addSubview:leftline];
    UILabel* bottomTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftline.right, 0, 60, 30)];
    bottomTitleLabel.backgroundColor = [UIColor clearColor];
    bottomTitleLabel.text = @"第三方登录";
    bottomTitleLabel.font = [UIFont systemFontOfSize:10];
    bottomTitleLabel.textColor = GrayTitleColor;
    [bottomView addSubview:bottomTitleLabel];
    UIView* rightline = [[UIView alloc]initWithFrame:CGRectMake(bottomTitleLabel.right, leftline.top, leftline.width, leftline.height)];
    rightline.backgroundColor = LineColor;
    [bottomView addSubview:rightline];
    
    
    NSArray* bottomImgArr = @[@"icon-weixin",@"icon-weibo",@"icon-qq"];
    CGFloat bottomimgwidth = 40;
    CGFloat bottomleftgap = (mScreenWidth - bottomimgwidth*bottomImgArr.count)/(bottomImgArr.count+1);
    for (int i = 0 ; i < bottomImgArr.count; i ++) {
        UIButton* imgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imgbtn setImage:[UIImage imageNamed:bottomImgArr[i]] forState:UIControlStateNormal];
        imgbtn.frame = CGRectMake(bottomleftgap + i*(bottomleftgap+bottomimgwidth), (bottomView.height - bottomimgwidth)/2, bottomimgwidth, bottomimgwidth);
        imgbtn.tag = 30+i;
        [bottomView addSubview:imgbtn];
        [imgbtn addTarget:self action:@selector(bottomImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
}





#pragma mark 左侧导航按钮点击事件
- (void)leftBarBtnClick:(UIButton*)sender
{
    NSArray* array = self.navigationController.viewControllers;
    if (array.count == 0) {
        APPDelegate.window.rootViewController = nil;
         APPDelegate.window.rootViewController = [[BaseTabBarViewController alloc]init];//baseNav;
    }else{
//        [self.navigationController popViewControllerAnimated:YES];
        [self.tabBarController setSelectedIndex:0];
        UIViewController *viewCtl = self.navigationController.viewControllers[0];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
}

- (void)rightBarBtnClick:(UIButton*)sender
{
//    RegisterViewController* regVC = [[RegisterViewController alloc]init];
//    [self.navigationController pushViewController:regVC animated:YES];
    RegisterNewViewController* regVC = [[RegisterNewViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
}

#pragma mark 底图手势
- (void)hideKey:(UITapGestureRecognizer*)tap
{
    
    
}

- (void)loginBtnClick:(UIButton*)sender
{
    sender.enabled = NO;
    if (_userFiled.text.length == 0)
    {
        sender.enabled = YES;
        [XtomFunction openIntervalHUD:@"用户名不能为空" view:self.view];
        return;
    }
    if (_pwdFiled.text.length == 0)
    {
        sender.enabled = YES;
        [XtomFunction openIntervalHUD:@"密码不能为空" view:self.view];
        return;
    }else {
//        [self ssionDestoryRequestData:sender];
        [self requestLogin:sender];
    }


}

- (void)refisterBtnClick:(UIButton*)sender
{
//    RegisterViewController* regVC = [[RegisterViewController alloc]init];
//    [self.navigationController pushViewController:regVC animated:YES];
    RegisterNewViewController* regVC = [[RegisterNewViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];

}

- (void)forgetBtnClick:(UIButton*)sender
{
    ForgetPwdViewController* forVC = [[ForgetPwdViewController alloc]init];
    [self.navigationController pushViewController:forVC animated:YES];

}

- (void)bottomImgBtnClick:(UIButton*)sender
{
    switch (sender.tag) {
        case 30:{
            //微信
        
        }
            
            break;
        case 31:{
            //微博
        
        }
            
            break;
        case 32:{
        //球球
            
        }
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 请求登录
- (void)requestLogin:(UIButton*)sender {
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
    NSString* datastr =[NSString stringWithFormat:@"{\"account\":\"%@\",\"password\":\"%@\"}",self.userFiled.text,_pwdFiled.text];
    [param setObject:datastr forKey:@"data"];
    [param setObject:@"true" forKey:@"mobile"];
//    [param setObject:[NSString_Base64 base64StringFromText:_pwdFiled.text]forKeyedSubscript:@"pwd"];
//    NSLog(@"加密数据%@",[NSString_Base64 base64StringFromText:_pwdFiled.text]);
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
//                    [[NSUserDefaults standardUserDefaults] setValue:model.linker forKey:USERLINKER];
//                    [[NSUserDefaults standardUserDefaults] setObject:model.linkerid forKey:USERLINKERID];
                    [[NSUserDefaults standardUserDefaults] setObject:model.phone forKey:USERPHONE];
                    
                    [self getTokenwithId:model.Id name:model.name];
                    
                    NSArray* array = self.navigationController.viewControllers;
                    NSLog(@"-------%@",array);
                    if (array.count == 1 && [array[0] isKindOfClass:[LoginViewController class]] ) {
                        APPDelegate.window.rootViewController = nil;
                        APPDelegate.window.rootViewController = [[BaseTabBarViewController alloc]init];//baseNav;
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
            }else{
                [self showAlert:@"登录超时"];
            }
        }
        [hud hide:YES];
    } fail:^(NSError *error) {
        sender.enabled = YES;
        NSLog(@"error=====%@",error);
        [hud hide:YES];
    }];
    
}


-(void)jizhubtn:(UIButton*)btn
{
    
    if(_isRemember == NO)
    {
        jizhu.image = [UIImage imageNamed:@"remember1"];
        jizhu.backgroundColor = [UIColor clearColor];
        _isRemember = YES;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:_userFiled.text forKey:@"account"];
        [userDefault setObject:@"1" forKey:@"isRemember"];
        
        [userDefault synchronize];
        
    } else {
        jizhu.image=[UIImage imageNamed:@"remember2"];
        jizhu.backgroundColor = [UIColor whiteColor];
        _isRemember = NO;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"account"];
        [userDefault setObject:@"0" forKey:@"isRemember"];
        [userDefault synchronize];
    }
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_isRemember==YES) {
        jizhu.image = [UIImage imageNamed:@"remember1"];
        jizhu.backgroundColor = [UIColor clearColor];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:_userFiled.text forKey:@"account"];
        NSLog(@"%@",_userFiled.text);
        [userDefault synchronize];
    }else {
        jizhu.image=[UIImage imageNamed:@"remember2"];
        jizhu.backgroundColor = [UIColor whiteColor];
        _isRemember = NO;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"account"];
        [userDefault synchronize];
    }
}

- (void)ssionDestoryRequestData:(UIButton*)sender
{
/*
 /login/ssionDestory.do
 */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    sender.enabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/sessionDestory.do"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
        [hud hide:YES];
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/login/ssionDestory.do%@",str);
        if ([str rangeOfString:@"true"].location !=NSNotFound) {
            [self requestLogin:sender];
        }
    } fail:^(NSError *error) {
        [hud hide:YES];
        sender.enabled = YES;
        NSLog(@"%@",error.localizedDescription);
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
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
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





@end
