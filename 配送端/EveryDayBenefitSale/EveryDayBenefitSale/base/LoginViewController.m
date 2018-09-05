//
//  LoginViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/8.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPwdViewController.h"
#import "BaseTabBarViewController.h"
#import "XtomFunction.h"
#import "NSString+Base64.h"
#import "LoginModel.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    NSString* _versionUrl;
    MBProgressHUD *_hud;
    UIScrollView* groundView;
    BOOL _isRemember;
    UIImageView * jizhu;
    BOOL _isAutologin;
    UIImageView * _autologin;
}
@property (nonatomic,strong) UITextField * userFiled;
@property (nonatomic,strong) UITextField * pwdFiled;
@property (nonatomic,strong) UIButton * loginBtn;
@property (nonatomic,strong) UIButton * registerBtn;
@property (nonatomic,strong) UIButton * forgetBtn;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

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
    NSString* phone = [[NSUserDefaults standardUserDefaults]objectForKey:AutoUSERPHONE];
    NSString* pwd = [[NSUserDefaults standardUserDefaults]objectForKey:AutoUSERPWD];
    if (!IsEmptyValue(phone)&&!IsEmptyValue(pwd)) {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:AutoLogin] isEqualToString:@"1"]) {
            _isAutologin = YES;
            [self autoLoginPhone:phone pwd:pwd];
        }else{
            _isAutologin = NO;
        }
    }
    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame = CGRectMake(0, 0, 60, 40);
    [leftBtn setTitle:@"登录" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = left;
    [leftBtn addTarget:self action:@selector(leftBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(0, 0, 80, 40);
    [rightBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [rightBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    [rightBtn addTarget:self action:@selector(rightBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self creatSubViews];
    
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud hide:YES];
    [self versionRequest];
    
}

- (void)creatSubViews
{
    //底图
    groundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 , mScreenWidth, mScreenHeight-64-49)];
    groundView.backgroundColor = [UIColor whiteColor];
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
    
    UIImageView* headerView = [[UIImageView alloc]initWithFrame:CGRectMake((mScreenWidth - 100)/2, 100, 100, 100)];
    headerView.image = [UIImage imageNamed:@"loginlogo"];
    [groundView addSubview:headerView];
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.bottom , mScreenWidth, 150)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.userInteractionEnabled = YES;
    [groundView addSubview:topView];
    
    UILabel* userLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, mScreenWidth - 30, 50)];
    userLabel.backgroundColor = [UIColor whiteColor];
    [topView addSubview:userLabel];
    UILabel* userleftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, userLabel.top, 50, 49)];
    userleftLabel.text = @"账号";
    userleftLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:userleftLabel];
    _userFiled = [[UITextField alloc]initWithFrame:CGRectMake(userleftLabel.right+10, userLabel.top, mScreenWidth - 10 - userleftLabel.width - 10, 49)];
    _userFiled.delegate = self;
    _userFiled.tag = 10;
    _userFiled.font = [UIFont systemFontOfSize:14];
    _userFiled.placeholder = @"请输入用户名";
    _userFiled.keyboardType = UIKeyboardTypeDefault;
    [topView addSubview:_userFiled];
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(userLabel.left, _userFiled.bottom, userLabel.width, 1)];
    line.backgroundColor = LineColor;
    [topView addSubview:line];
    
    UILabel* pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, userLabel.bottom, mScreenWidth-30, 50)];
    pwdLabel.backgroundColor = [UIColor whiteColor];
    [topView addSubview:pwdLabel];
    UILabel* pwdleftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, pwdLabel.top, 50, 49)];
    pwdleftLabel.text = @"密码";
    pwdleftLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:pwdleftLabel];
    _pwdFiled = [[UITextField alloc]initWithFrame:CGRectMake(pwdleftLabel.right+10, pwdLabel.top, mScreenWidth - 10 - pwdleftLabel.width - 10, 49)];
    _pwdFiled.delegate = self;
    _pwdFiled.tag = 20;
    //_pwdFiled.secureTextEntry = YES;//密码遮掩
    _pwdFiled.placeholder = @"请输入密码";
    _pwdFiled.font = [UIFont systemFontOfSize:14];
    _pwdFiled.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
    _pwdFiled.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(pwdLabel.left, _pwdFiled.bottom, pwdLabel.width, 1)];
    line1.backgroundColor = LineColor;
    [topView addSubview:_pwdFiled];
    [topView addSubview:line1];
    jizhu = [[UIImageView alloc]initWithFrame:CGRectMake(15, line1.bottom+15, 20, 20)];
    jizhu.image = [UIImage imageNamed:@""];
    jizhu.backgroundColor = [UIColor whiteColor];
    [jizhu.layer setCornerRadius:5];
    [topView addSubview:jizhu];
    UILabel * jizhuyonghu = [[UILabel alloc]initWithFrame:CGRectMake(45, line1.bottom+10, 100, 30)];
    jizhuyonghu.text = @"记住用户名";
    jizhuyonghu.textColor = [UIColor lightGrayColor];
    jizhuyonghu.font = [UIFont boldSystemFontOfSize:14];
    [topView addSubview:jizhuyonghu];
    UIButton * jzbtn = [[UIButton alloc]initWithFrame:CGRectMake(15, line1.bottom+10, 130, 30)];
    jzbtn.backgroundColor = [UIColor clearColor];
    [topView addSubview:jzbtn];
    [jzbtn addTarget:self action:@selector(jizhubtn:) forControlEvents:UIControlEventTouchUpInside];
    if (_isRemember == YES) {
        jizhu.image =[UIImage imageNamed:@"remember1"];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        _userFiled.text = [userDefault objectForKey:@"account"];
    }else {
        jizhu.image = [UIImage imageNamed:@"remember2"];
    }
    //自动登录
    _autologin = [[UIImageView alloc]initWithFrame:CGRectMake(jizhuyonghu.right+10, jizhu.top, 20, 20)];
    _autologin.image = [UIImage imageNamed:@""];
    _autologin.backgroundColor = [UIColor whiteColor];
    _autologin.layer.cornerRadius = 5.0;
    [topView addSubview:_autologin];
    UILabel* autologinLabel = [[UILabel alloc]initWithFrame:CGRectMake(_autologin.right+10, jizhuyonghu.top, 100, 30)];
    autologinLabel.text = @"自动登录";
    autologinLabel.textColor = [UIColor lightGrayColor];
    autologinLabel.font = [UIFont boldSystemFontOfSize:14];
    [topView addSubview:autologinLabel];
    UIButton* autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoBtn.frame = CGRectMake(jizhuyonghu.right+10, autologinLabel.top, 130, 30);
    autoBtn.backgroundColor = [UIColor clearColor];
    [topView addSubview:autoBtn];
    [autoBtn addTarget:self action:@selector(autoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:AutoLogin] isEqualToString:@"1"]) {
        _autologin.image = [UIImage imageNamed:@"remember1"];
    }else{
        _autologin.image = [UIImage imageNamed:@"remember2"];
    }
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginBtn.frame = CGRectMake(15, 50+ 30 + pwdLabel.bottom + 120+80, mScreenWidth - 30, 50) ;
    _loginBtn.backgroundColor = COLOR(19, 85, 154, 1);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [groundView addSubview:_loginBtn];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 10.0;
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(mScreenWidth - 85, _loginBtn.bottom+5, 80, 40);
    [rightBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR(19, 85, 154, 1) forState:UIControlStateNormal];
    [groundView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
- (void)leftBarBtnClick:(UIButton*)sender
{

}

- (void)rightBarBtnClick:(UIButton*)sender
{
    //忘记密码
    ForgetPwdViewController* forgetVC = [[ForgetPwdViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark 底图手势
- (void)hideKey:(UITapGestureRecognizer*)tap
{
    
    
}

- (void)loginBtnClick:(UIButton*)sender
{
    if (_userFiled.text.length == 0)
    {
        [XtomFunction openIntervalHUD:@"用户名不能为空" view:self.view];
        return;
    }
    if (_pwdFiled.text.length == 0)
    {
        [XtomFunction openIntervalHUD:@"密码不能为空" view:self.view];
        return;
    }else {
        
        [self requestLogin:sender];
        
    }



}




#pragma mark - 请求登录
- (void)requestLogin:(UIButton*)sender {
    /*
     /login/appLogin.do
     account:用户名
     password:密码
     mobile:true
     */
    [_hud show:YES];
    sender.enabled = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* datastr =[NSString stringWithFormat:@"{\"account\":\"%@\",\"password\":\"%@\"}",self.userFiled.text,_pwdFiled.text];
    [param setObject:datastr forKey:@"data"];
    [param setObject:@"true" forKey:@"mobile"];
    //    [param setObject:[NSString_Base64 base64StringFromText:_pwdFiled.text]forKeyedSubscript:@"pwd"];
    //    NSLog(@"加密数据%@",[NSString_Base64 base64StringFromText:_pwdFiled.text]);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appLogin.do"];
    NSLog(@"登录数据%@-----%@",urlStr,param);
    [DataPost requestAFWithUrl:urlStr params:param finishDidBlock:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"登录数据%@",str);
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        
        if ([str rangeOfString:@"msg"].location != NSNotFound) {
            NSLog(@"登录失败");
            [self showAlert:array[0][@"msg"]];
        }else{
            if (array!=0){
                NSLog(@"登录成功");
                LoginModel* model = [[LoginModel alloc]init];
                [model setValuesForKeysWithDictionary:array[0]];
                [[NSUserDefaults standardUserDefaults] setValue:model.Id forKey:USERID];
                [[NSUserDefaults standardUserDefaults] setObject:model.phone forKey:USERPHONE];
                [[NSUserDefaults standardUserDefaults] setObject:model.name forKey:USERNAME];
                if (_isAutologin == YES) {
                    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:AutoLogin];
                    [[NSUserDefaults standardUserDefaults]setObject:model.phone forKey:AutoUSERPHONE];
                    [[NSUserDefaults standardUserDefaults]setObject:_pwdFiled.text forKey:AutoUSERPWD];
                }else{
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:AutoLogin];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if ([model.isvalid integerValue] == 0) {
                    [self showAlert:@"账号已停用"];
                }else if ([model.custtypeid integerValue] != 1){
                    [self showAlert:@"账号非配送端账户"];
                }
                else{
                    BaseTabBarViewController* tabBar = [[BaseTabBarViewController alloc]init];
                    [self presentViewController:tabBar animated:YES completion:nil];
                }
            }else{
                [self showAlert:@"登录失败"];
            }
        }
        [_hud hide:YES];
    } failureBlock:^(NSError *error) {
        sender.enabled = YES;
        NSLog(@"error=====%@",error);
        [_hud hide:YES];
        
    }];
    
}

- (void)autoLoginPhone:(NSString*)phone pwd:(NSString*)pwd
{
    /*
     /login/appLogin.do
     account:用户名
     password:密码
     mobile:true
     */
    [_hud show:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* datastr =[NSString stringWithFormat:@"{\"account\":\"%@\",\"password\":\"%@\"}",phone,pwd];
    [param setObject:datastr forKey:@"data"];
    [param setObject:@"true" forKey:@"mobile"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appLogin.do"];
    NSLog(@"登录数据%@-----%@",urlStr,param);
    [DataPost requestAFWithUrl:urlStr params:param finishDidBlock:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"登录数据%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([str rangeOfString:@"msg"].location != NSNotFound) {
            NSLog(@"登录失败");
            [self showAlert:array[0][@"msg"]];
        }else{
            if (array!=0){
                NSLog(@"登录成功");
                LoginModel* model = [[LoginModel alloc]init];
                [model setValuesForKeysWithDictionary:array[0]];
                [[NSUserDefaults standardUserDefaults] setValue:model.Id forKey:USERID];
                [[NSUserDefaults standardUserDefaults] setObject:model.phone forKey:USERPHONE];
                if (_isAutologin == YES) {
                    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:AutoLogin];
                    [[NSUserDefaults standardUserDefaults]setObject:model.phone forKey:AutoUSERPHONE];
                    [[NSUserDefaults standardUserDefaults]setObject:_pwdFiled.text forKey:AutoUSERPWD];
                }else{
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:AutoLogin];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                if ([model.isvalid integerValue] == 0) {
                    [self showAlert:@"账号已停用"];
                }else if ([model.custtypeid integerValue] != 1){
                    [self showAlert:@"账号非配送账号"];
                }else{
                    BaseTabBarViewController* tabBar = [[BaseTabBarViewController alloc]init];
                    [self presentViewController:tabBar animated:YES completion:nil];
                }
            }else{
                [self showAlert:@"登录失败"];
            }
        }
        [_hud hide:YES];
    } failureBlock:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [_hud hide:YES];
        
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

- (void)autoBtnClick:(UIButton*)sender
{
    if (_isAutologin == YES) {
        _autologin.image = [UIImage imageNamed:@"remember2"];
        _autologin.backgroundColor = [UIColor whiteColor];
        _isAutologin = NO;
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:AutoLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        _autologin.image = [UIImage imageNamed:@"remember1"];
        _autologin.backgroundColor = [UIColor clearColor];
        _isAutologin = YES;
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


#pragma mark -－－－－－－－－－－－－－－ 版本更新－－－－－－－－－－－－－－－－－－－－－－－－－－－
//版本更新
- (void)versionRequest{
    /*lxpub/app/version?
     
     action=getVersionInfo
     project=lx
     联祥           applelianxiang
     京新           applejingxin
     易软通         appleyiruantong
     华抗           applehuakang
     济南智圣医疗    applejnzsyl
     圣地宝         applesdb
     康普善         applekps
     金易销         applejyx
     中抗           applezk
     */
    NSString *project;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSLog(@"app名字%@",appName);
    
    if ([appName isEqualToString:@"徒河食品"]) {
        project = @"appletuheshipin";
    }
    if ([appName isEqualToString:@"华抗药业"]) {
        project = @"applehuakang";
    }
    if ([appName isEqualToString:@"京新药业"]) {
        project = @"applejingxin";
    }
    if ([appName isEqualToString:@"中抗药业"]) {
        project = @"applezk";
    }
    if ([appName isEqualToString:@"联祥网络"]) {
        project = @"applelianxiang";
    }
    if ([appName isEqualToString:@"金易销"]) {
        project = @"applejyx";
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version",Ver_Address];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"text/html",@"text/plain",@"image/png",nil];
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"applexiaoweiSZ"]};
    
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        // NSLog(@"版本信息:%@",dic);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDic));
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSLog(@"当前版本号%@",appVersion);
        NSString *version = dic[@"app_version"];
        NSString *nessary = dic[@"app_necessary"];
        NSLog(@"请求版本号%@",appVersion);
        _versionUrl = dic[@"app_url"];
        //[self showAlert];
        if ([version isEqualToString:appVersion]) {
            
        }else if(![version isEqualToString:appVersion]){
            if ([nessary isEqualToString:@"0"]) {
                
                [self showAlert];
            }else if([nessary isEqualToString:@"1"]){
                
                [self showAlert1];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"更新检测请求失败");

    }];
    
}
//选择更新
- (void)showAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:@"以后再说"
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10001;
    [alert show];
    
}
//强制更新
- (void)showAlert1{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新"
                                                    message:@"发现新版本，是否马上更新？"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"下载", nil];
    alert.tag = 10002;
    [alert show];
    
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    // 拼接url 防止读取缓存
    NSString *sign = [NSString stringWithFormat:@"%zi",[self getRandomNumber:1 to:1000]];
    
    if (alertView.tag==10001) {
        
        if (buttonIndex==1) {
            NSString *str = [NSString stringWithFormat:@"itms-services://?v=%@&action=download-manifest&url=%@",sign,_versionUrl];
            
            //            NSString *str1 = @"https://www.pgyer.com/lOJg";//http://www.pgyer.com/CxLm
            //            NSURL *url = [NSURL URLWithString:str1];
            NSURL *url = [NSURL URLWithString:str];
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }else if (alertView.tag == 10002){
        
        if (buttonIndex == 0) {
            
            NSString *str = [NSString stringWithFormat:@"itms-services://?v=%@&action=download-manifest&url=%@",sign,_versionUrl];
            
            //            NSString *str1 = @"https://www.pgyer.com/lOJg";
            //            NSURL *url = [NSURL URLWithString:str1];
            
            NSURL *url = [NSURL URLWithString:str];
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
    
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}






@end
