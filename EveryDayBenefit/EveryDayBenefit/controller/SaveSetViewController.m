//
//  SaveSetViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "SaveSetViewController.h"
#import "MineTableViewCell.h"
#import "LoginNewViewController.h"
#import "YZXTimeButton.h"
#import "CheckUtils.h"
#import "MBProgressHUD.h"

#define SendTime 60
@interface SaveSetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITableView* _tbView;
    UIView* _myAleareView;
    UITextField* _oldPwdField;
    BOOL _oldPwdPassFlag;
    UITextField* _updataPwdField;
    UITextField* _updataPwdAgainField;
    UITextField* _updataPhoneField;
    BOOL _isphoneAccress;
    UITextField* _senderFiled;
    BOOL _isRegistcodeSend;
    YZXTimeButton* _sendMessageBtn;
    
}
@end

@implementation SaveSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:@"安全设置"];
    _oldPwdPassFlag = NO;
    _isphoneAccress = NO;
    _isRegistcodeSend = NO;
    [self creatUI];
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth, 65*2) style:UITableViewStylePlain];
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    [self setExtraCellLineHidden:_tbView];
    //退出登录
    UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(40, _tbView.bottom+80, mScreenWidth - 80, 50);
    [exitBtn setImage:[UIImage imageNamed:@"exitloginsure"] forState:UIControlStateNormal];
    [self.view addSubview:exitBtn];
    [exitBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"MineTableViewCellID";
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineTableViewCell" owner:self options:nil]firstObject];
    }
    NSArray* titleArr = @[@"修改绑定手机号",@"修改密码"];
    NSArray* imgArr = @[@"icon-24",@"icon-25"];
    cell.titleLabel.text = titleArr[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [_grayView showView];
        [self updatePhoneUI];
    }else if (indexPath.row == 1){
        //修改密码
        [_grayView showView];
        [self updataPwdUI];
    }

}

- (void)exitBtnClick:(UIButton*)sender
{
    [self creatExiteUI];
}

- (UIView*)creatExiteUI
{
    if (_myAleareView == nil) {
        _myAleareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleareView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_myAleareView];
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myAleareView.width, _myAleareView.height)];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.alpha = 0.5;
        [_myAleareView addSubview:bgView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(creatExiteUIClosetapClick:)];
        [bgView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (mScreenHeight - 100)/2, mScreenWidth - 80, 100)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0f;
        [_myAleareView addSubview:windowView];
        
        UILabel* titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 45)];
        titlelabel.text = @"确定要退出当前账号吗？";
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.font = [UIFont systemFontOfSize:15];
        [windowView addSubview:titlelabel];
        UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        sureBtn.frame = CGRectMake(0, titlelabel.bottom, windowView.width/2, windowView.height - titlelabel.height);
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [windowView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(exitsureClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(sureBtn.right, sureBtn.top, sureBtn.width, sureBtn.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [windowView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(exitcloseClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView* rowline = [[UIView alloc]initWithFrame:CGRectMake(0, titlelabel.bottom, windowView.width, 1)];
        rowline.backgroundColor = LineColor;
        [windowView addSubview:rowline];
        UIView* lieline = [[UIView alloc]initWithFrame:CGRectMake(sureBtn.right, sureBtn.top, 1, sureBtn.height)];
        lieline.backgroundColor = LineColor;
        [windowView addSubview:lieline];
        
    }
    return _myAleareView;
}

- (void)creatExiteUIClosetapClick:(UITapGestureRecognizer*)tap
{
    [_myAleareView removeFromSuperview];
    _myAleareView = nil;
}

- (void)exitsureClick:(UIButton*)sender
{
    [self outlogin:sender];
}

- (void)exitcloseClick:(UIButton*)sender
{
    [_myAleareView removeFromSuperview];
    _myAleareView = nil;
}


- (void)outlogin:(UIButton*)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/outLogin.do"];
    NSLog(@"%@",urlstr);
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
        [hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"退出登录%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"退出登录"];
            [_myAleareView removeFromSuperview];
            _myAleareView = nil;
            [self.tabBarController setSelectedIndex:0];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERID];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERLINKER];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERLINKERID];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERPHONE];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:@"0" forKey:@"isAutoLogin"];
            [userDefault synchronize];
        }
        
    } fail:^(NSError *error) {
        [hud hide:YES];
        NSLog(@"退出登录错误信息,%@",error.localizedDescription);
    }];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _oldPwdField) {
        if (![textField.text isEqualToString:@""]) {
            [self OldPwdPassRequest:textField];
        }else{
            [self showAlert:@"请输入旧密码"];
        }
    }else if (textField == _updataPhoneField){
        if (![textField.text isEqualToString:@""]) {
            [self PhoneIsValueVerification:textField];
        }else{
            [self showAlert:@"请输入要绑定的手机号"];
        }
    }
}


-(UIView*)updataPwdUI
{
    if (_myAleareView == nil) {
        _myAleareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
        _myAleareView.backgroundColor = [UIColor clearColor];
//        [APPDelegate.window addSubview:_myAleareView];
        [self.view addSubview:_myAleareView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myAleareView.width, _myAleareView.height)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleareView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closemyAleartViewTap:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleareView.height - 260)/2, _myAleareView.width- 80, 260)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        [_myAleareView addSubview:windowView];
        
        UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        titleView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:titleView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(titleView.width - 60, 0, 60, titleView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [windowView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _oldPwdField = [[UITextField alloc]initWithFrame:CGRectMake(10, titleView.bottom+20, windowView.width- 20, 44)];
        _oldPwdField.delegate = self;
        _oldPwdField.secureTextEntry = YES;
        _oldPwdField.placeholder = @"请输入旧密码";
        _oldPwdField.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
        _oldPwdField.enablesReturnKeyAutomatically = YES;
        [windowView addSubview:_oldPwdField];
        
        _updataPwdField = [[UITextField alloc]initWithFrame:CGRectMake(10, _oldPwdField.bottom, windowView.width - 20, 44)];
        _updataPwdField.delegate = self;
        _updataPwdField.secureTextEntry = YES;//密码遮掩
        _updataPwdField.placeholder = @"请输入密码";
        _updataPwdField.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
        _updataPwdField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
        [windowView addSubview:_updataPwdField];
        
        _updataPwdAgainField = [[UITextField alloc]initWithFrame:CGRectMake(_updataPwdField.left, _updataPwdField.bottom, _updataPwdField.width, 44)];
        _updataPwdAgainField.delegate = self;
        _updataPwdAgainField.secureTextEntry = YES;
        _updataPwdAgainField.placeholder = @"请再次确认密码";
        _updataPwdAgainField.keyboardType = UIKeyboardTypeASCIICapable;
        _updataPwdAgainField.enablesReturnKeyAutomatically =YES;
        [windowView addSubview:_updataPwdAgainField];
        
        UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 5.0;
        sureBtn.frame = CGRectMake(20, windowView.height - 50, windowView.width - 40, 40);
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.backgroundColor = NavBarItemColor;
        [windowView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myAleareView;
}

- (void)closemyAleartViewTap:(UITapGestureRecognizer*)tap
{
    [_grayView hideView];
    [_myAleareView removeFromSuperview];
    _myAleareView = nil;
}

- (void)closeBtnClick:(UIButton*)sender
{
    [_grayView hideView];
    [_myAleareView removeFromSuperview];
    _myAleareView = nil;
}

- (void)sureBtnClick:(UIButton*)sender
{
    if ([_updataPwdField.text isEqualToString:@""]||[_updataPwdAgainField.text isEqualToString:@""]) {
        sender.enabled = YES;
        [self showAlert:@"密码不能为空"];
    }else if (![_updataPwdField.text isEqualToString:_updataPwdAgainField.text]) {
        sender.enabled = YES;
        [self showAlert:@"两次密码输入不同"];
    }else if (![CheckUtils isPassword:_updataPwdField.text]){
        [self showAlert:@"请输入6-20为数字或英文"];
    }else if (_oldPwdPassFlag == NO){
        sender.enabled = YES;
        [self showAlert:@"旧密码验证失败"];
    }else{
        [self appupdatePassRequest:sender];
    }
}

- (void)OldPwdPassRequest:(UITextField*)sender
{
    /*
     /login/confirmPassword.do
     mobile:true
     password:用户密码
     custid:用户id
     */
    sender.enabled = NO;
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/confirmPassword.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];
    [parmas setObject:_oldPwdField.text forKey:@"password"];
    [parmas setObject:userid forKey:@"custid"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"confirmPassword.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            _oldPwdPassFlag = YES;
            [self showAlert:@"旧密码验证成功"];
        }else{
            [self showAlert:@"旧密码验证失败"];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
    }];
}


- (void)appupdatePassRequest:(UIButton*)sender
{
   /*
     /login/appupdatePass.do
    password：密码
    mobile:true
    */
    sender.enabled = NO;
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appupdatePass.do"];
    _updataPwdAgainField.text = [self convertNull:_updataPwdAgainField.text];
    NSString* pwd = [NSString stringWithFormat:@"%@",_updataPwdAgainField.text];
    NSDictionary* params = @{@"password":pwd,@"mobile":@"true"};
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        sender.enabled =YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"修改密码返回的字段%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            LoginNewViewController* vc = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound){
            [_grayView hideView];
            [_myAleareView removeFromSuperview];
            _myAleareView = nil;
            [self showAlert:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert:@"修改密码失败"];
        }
        
    } fail:^(NSError *error) {
        sender.enabled = YES;
        NSLog(@"修改密码请求失败%@",error.localizedDescription);
    }];

}

- (UIView*)updatePhoneUI
{
    if (_myAleareView == nil) {
        _myAleareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
        _myAleareView.backgroundColor = [UIColor clearColor];
//        [APPDelegate.window addSubview:_myAleareView];
        [self.view addSubview:_myAleareView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myAleareView.width, _myAleareView.height)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleareView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closemyAleartViewTap:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleareView.height - 260)/2, _myAleareView.width- 80, 260)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        [_myAleareView addSubview:windowView];
        
        UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        titleView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:titleView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(titleView.width - 60, 0, 60, titleView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [windowView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _updataPhoneField = [[UITextField alloc]initWithFrame:CGRectMake(10, titleView.bottom+20, windowView.width - 20, 44)];
        _updataPhoneField.delegate = self;
        _updataPhoneField.placeholder = @"请输入手机号";
        _updataPhoneField.keyboardType = UIKeyboardTypeASCIICapable;
        [windowView addSubview:_updataPhoneField];
        
        _senderFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, _updataPhoneField.bottom, _updataPhoneField.width - 80, 49)];
        _senderFiled.delegate = self;
        _senderFiled.placeholder = @"请输入验证码";
        _senderFiled.keyboardType = UIKeyboardTypeASCIICapable;//数组英文键盘
        _senderFiled.enablesReturnKeyAutomatically = YES;
        _sendMessageBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_senderFiled.right, _senderFiled.top+5, 80, 30)];
        _sendMessageBtn.backgroundColor = BackGorundColor;
        _sendMessageBtn.buttonTitle = @"获取验证码";
        [_sendMessageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendMessageBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [windowView addSubview:_sendMessageBtn];
        [windowView addSubview:_senderFiled];

        
        
        UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 5.0;
        sureBtn.frame = CGRectMake(20, windowView.height - 50, windowView.width - 40, 40);
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.backgroundColor = NavBarItemColor;
        [windowView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(surePhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myAleareView;

}

#pragma mark 手机验证是否注册过
- (void)PhoneIsValueVerification:(UITextField*)textField
{
    /*
     +/login/appcheckPhone.do
     phone:手机号
     */
    _isphoneAccress = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    textField.text =[self convertNull:textField.text];
    [param setObject:textField.text forKey:@"phone"];
    [param setObject:@"ture" forKey:@"mobile"];
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/appcheckPhone.do&phone=%@",ROOT_Path,textField.text];//'+callback1
    NSLog(@"%@",urlStr);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:param success:^(id result) {
        NSString *returnStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"returnStr%@",returnStr);
        if (returnStr.length!=0) {
            if ([returnStr rangeOfString:@"false"].location != NSNotFound) {
                //没有注册过
                _isphoneAccress = YES;
                 _sendMessageBtn.backgroundColor = NavBarItemColor;
            }else if ([returnStr rangeOfString:@"true"].location != NSNotFound){
                //已经注册
                [self showAlert:@"已经注册"];
            }else{
                [self showAlert:returnStr];
            }
        }
        //        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        //        [_hud hide:YES];
    }];
    
}

#pragma mark 发送验证码
- (void)sendBtnClick:(YZXTimeButton*)sender
{
    sender.recoderTime = @"yes";
    [sender setKaishi:SendTime];
    BOOL isphone = [CheckUtils isValidatePhone:_updataPhoneField.text];
    if (!isphone) {
        [self showAlert:@"请输入正确的手机号"];
    }else if ([_updataPhoneField.text isEqualToString:@""]) {
        [self showAlert:@"请先输入手机号"];
        
    }else if(_isphoneAccress == NO){
        [self showAlert:@"手机验证失败"];
        
    }else{
        [self getSendCode];
        //        _isRegistcodeSend = YES;
    }
}
#pragma mark 获取验证码
- (void)getSendCode
{
    /*
    /login/appregistcode.do
     data{
     phone:手机号
     }
     */
    _isRegistcodeSend = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    _updataPhoneField.text = [self convertNull:_updataPhoneField.text];
    [param setObject:_updataPhoneField.text forKey:@"phone"];
    [param setObject:@"true" forKey:@"mobile"];
    NSDictionary *params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",_updataPhoneField.text]};
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/appregistcode.do",ROOT_Path];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:param success:^(id result) {
        NSString *returnStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"returnStr%@",returnStr);
        NSString* str = [Command replaceAllOthers:returnStr];
        if ([CheckUtils NUM:str]) {
            //验证码成功
            _isRegistcodeSend = YES;
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:REGITCODE];
        }else{
            [self showAlert:returnStr];
        }
//        if ([returnStr isEqualToString:@"true"]) {
//            //验证码成功
//            _isRegistcodeSend = YES;
//            
//        }else if([returnStr isEqualToString:@"false"]){
//            //验证码发送失败
//            [self showAlert:returnStr];
//        }else{
//            [self showAlert:returnStr];
//        }
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)surePhoneBtnClick:(UIButton*)sender
{
    NSString* code = [[NSUserDefaults standardUserDefaults]objectForKey:REGITCODE];
    if ([_updataPhoneField.text isEqualToString:@""]) {
        [self showAlert:@"手机号不能为空"];
    }else if (_isphoneAccress == NO){
        [self showAlert:@"手机验证失败"];
    }else if (_isRegistcodeSend == NO){
        [self showAlert:@"验证码发送失败"];
    }else if ([_senderFiled.text isEqualToString:@""]){
        [self showAlert:@"验证码输入不能为空"];
    }else if (![_senderFiled.text isEqualToString:code]){
        [self showAlert:@"验证码填写不正确"];
    }else{
        [self appupdatePhoneRequest:sender];
    }
}
- (void)appupdatePhoneRequest:(UIButton*)sender
{
    /*
     /login/appupdatePhone.do   修改绑定手机号
     mobile:true
     phone:手机号
     xiaoyanma：验证码
     */
    sender.enabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appupdatePhone.do"];
    _updataPhoneField.text = [self convertNull:_updataPhoneField.text];
    NSDictionary* parmas = @{@"mobile":@"true",@"phone":[NSString stringWithFormat:@"%@",_updataPhoneField.text],@"xiaoyanma":[NSString stringWithFormat:@"%@",_senderFiled.text]};
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"绑定手机号返回%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"appupdatePhone.do重新登录");
            LoginNewViewController* vc = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound){
            [_grayView hideView];
            [_myAleareView removeFromSuperview];
            _myAleareView = nil;
            [self showAlert:@"手机修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert:@"手机修改失败"];
        }
        
    } fail:^(NSError *error) {
        sender.enabled = YES;
        NSLog(@"绑定时手机号更新失败%@",error.localizedDescription);
    }];
    
}





@end
