//
//  ForgetPwdViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
#import "CheckUtils.h"
#import "MBProgressHUD.h"
@interface ForgetPwdViewController ()<UITextFieldDelegate>
{
    BOOL _isRegistcodeSend;
    BOOL _isphoneAccress;
}

@property (nonatomic,strong) UIScrollView* groundView;
@property (nonatomic,strong) UITextField * userFiled;
@property (nonatomic,strong) UITextField * usernameFiled;
@property (nonatomic,strong) UITextField * senderFiled;
@property (nonatomic,strong) UIView* nextView;
@property (nonatomic,strong) UITextField * pwdFiled;
@property (nonatomic,strong) UITextField * pwdAgainFiled;
@property (nonatomic,strong) YZXTimeButton* sendMessageBtn;
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, 200, 40);
    UIImageView* leftBarimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
    leftBarimgView.image = [UIImage imageNamed:@"icon-back"];
    [leftBarBtn addSubview:leftBarimgView];
    UILabel* leftBarLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftBarimgView.right+10, 0, leftBarBtn.width - leftBarimgView.width - 10, leftBarBtn.height)];
    leftBarLabel.text = @"密码找回";
    leftBarLabel.textColor = [UIColor blackColor];
    [leftBarBtn addSubview:leftBarLabel];
    UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = left;
    [leftBarBtn addTarget:self action:@selector(leftBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self creatGroundViewUI];
    
}

- (void)creatGroundViewUI
{
    _groundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    _groundView.backgroundColor = BackGorundColor;
    [self.view addSubview:_groundView];
    
    UILabel* usernameTf = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _groundView.width, 50)];
    usernameTf.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:usernameTf];
    _usernameFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, usernameTf.top, usernameTf.width - 10, 49)];
    _usernameFiled.delegate = self;
    _usernameFiled.placeholder = @"请输入用户名";
    _usernameFiled.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    UIView* uline = [[UIView alloc]initWithFrame:CGRectMake(0, _usernameFiled.bottom, usernameTf.width, 1)];
    uline.backgroundColor = LineColor;
    [_groundView addSubview:_usernameFiled];
    [_groundView addSubview:uline];
    
    UILabel* userlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, usernameTf.bottom, _groundView.width, 50)];
    userlabel.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:userlabel];
    _userFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, userlabel.top, userlabel.width - 10, 49)];
    _userFiled.delegate = self;
    _userFiled.placeholder = @"请输入手机号";
    _userFiled.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
    _userFiled.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, _userFiled.bottom, userlabel.width, 1)];
    line.backgroundColor = LineColor;
    [_groundView addSubview:_userFiled];
    [_groundView addSubview:line];
    
    UILabel* pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, userlabel.bottom, _groundView.width, 50)];
    pwdLabel.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:pwdLabel];
    _senderFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, pwdLabel.top, pwdLabel.width - 20 - 80, 49)];
    _senderFiled.delegate = self;
    _senderFiled.placeholder = @"请输入验证码";
    _senderFiled.keyboardType = UIKeyboardTypeASCIICapable;//数组英文键盘
    _senderFiled.enablesReturnKeyAutomatically = YES;
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _senderFiled.bottom, pwdLabel.width, 1)];
    line1.backgroundColor = LineColor;
    _sendMessageBtn = [[YZXTimeButton alloc]initWithFrame:CGRectMake(_senderFiled.right, _senderFiled.top+5, 80, 30)];
    _sendMessageBtn.backgroundColor = BackGorundColor;
    [_sendMessageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendMessageBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:_sendMessageBtn];
    [_groundView addSubview:_senderFiled];
    [_groundView addSubview:line1];
    
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.backgroundColor = NavBarItemColor;
    nextBtn.frame = CGRectMake(10, pwdLabel.bottom+20, _groundView.width - 20, 50) ;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_groundView addSubview:nextBtn];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5.0;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)creatNextViewUI
{
    _nextView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    _nextView.backgroundColor = BackGorundColor;
    [self.view addSubview:_nextView];
    
    UILabel* userlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _nextView.width, 50)];
    userlabel.backgroundColor = [UIColor whiteColor];
    [_nextView addSubview:userlabel];
    _pwdFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, userlabel.top, userlabel.width - 10, 49)];
    _pwdFiled.delegate = self;
    _pwdFiled.secureTextEntry = YES;
    _pwdFiled.placeholder = @"请输入新密码";
    _pwdFiled.keyboardType = UIKeyboardTypeASCIICapable;//数字英文键盘
    _pwdFiled.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, _pwdFiled.bottom, userlabel.width, 1)];
    line.backgroundColor = LineColor;
    [_nextView addSubview:_pwdFiled];
    [_nextView addSubview:line];
    
    UILabel* pwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, userlabel.bottom, _nextView.width, 50)];
    pwdLabel.backgroundColor = [UIColor whiteColor];
    [_nextView addSubview:pwdLabel];
    _pwdAgainFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, pwdLabel.top, pwdLabel.width - 10, 49)];
    _pwdAgainFiled.delegate = self;
    _pwdAgainFiled.secureTextEntry = YES;
    _pwdAgainFiled.placeholder = @"请再次输入";
    _pwdAgainFiled.keyboardType = UIKeyboardTypeASCIICapable;//数组英文键盘
    _pwdAgainFiled.enablesReturnKeyAutomatically = YES;
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _pwdAgainFiled.bottom, pwdLabel.width, 1)];
    line1.backgroundColor = LineColor;
    [_nextView addSubview:_pwdAgainFiled];
    [_nextView addSubview:line1];
    
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerBtn.frame = CGRectMake(10, pwdLabel.bottom+20, _nextView.width - 20, 50);
    registerBtn.backgroundColor = NavBarItemColor;
    [registerBtn setTitle:@"完成修改" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextView addSubview:registerBtn];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 5.0;
    [registerBtn addTarget:self action:@selector(xiugaiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark 返回键
- (void)leftBarBtnClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 发送验证码
- (void)sendBtnClick:(YZXTimeButton*)sender
{
    sender.recoderTime = @"yes";
    [sender setKaishi:SendTime];
    [self getSendCode];
//    _isRegistcodeSend = YES;
}

#pragma mark 下一步
- (void)nextBtnClick:(UIButton*)sender
{
    if ([_usernameFiled.text isEqualToString:@""]) {
        [self showAlert:@"用户名不能为空"];
        return;
    }else{
        [self checkUsernameIsRegist];
    }
}
#pragma mark 完成修改
- (void)xiugaiBtnClick:(UIButton*)sender
{
    
    if (self.pwdFiled.text == 0 || self.pwdAgainFiled.text == 0 || ![self.pwdFiled.text isEqualToString:self.pwdAgainFiled.text]) {
        [self showAlert:@"请输入密码"];
    }else{
        [self ForgetPwdRequest:sender];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _userFiled) {
//        [self PhoneIsValueVerification];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _userFiled) {
        // Check for non-numeric characters
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            //只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
            
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11)
            return NO;//限制长度
        return YES;
    }else if (textField == _senderFiled){
        // Check for non-numeric characters
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            //只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 6)
            return NO;//限制长度
        return YES;
    }else if(textField == _pwdFiled||textField == _pwdAgainFiled){
        //        NSUInteger lengthOfString = string.length;
        //        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        //            //只允许数字输入
        //            unichar character = [string characterAtIndex:loopIndex];
        //            if (character < 48) return NO; // 48 unichar for 0
        //            if (character > 57 && character < 65) return NO; // 57 unichar for 9
        //            if (character >90 && character <97) return NO;
        //            if (character>122) return NO;
        //        }
        //        // Check for total length
        //        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        //        if (proposedNewLength > MAX_LENGTH)
        //            return NO;//限制长度
        //        if (proposedNewLength > 5) {
        //            nextBtn.backgroundColor = [UIColor colorWithHexString:@"0046DD"];
        //            nextBtn.enabled = YES;
        //        }else if (proposedNewLength <=5)
        //        {
        //            nextBtn.backgroundColor = [UIColor colorWithHexString:@"D4D4D4"];
        //            nextBtn.enabled = NO;
        //        }
        return YES;
    }else{
        
        // Check for non-numeric characters
        
        //        NSUInteger lengthOfString = string.length;
        //        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        //            //只允许数字输入
        //            unichar character = [string characterAtIndex:loopIndex];
        //            if (character < 48) return NO; // 48 unichar for 0
        //            if (character > 57 && character < 65) return NO; // 57 unichar for 9
        //            if (character >90 && character <97) return NO;
        //            if (character>122) return NO;
        //        }
        //        // Check for total length
        //        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        //        if (proposedNewLength > MAX_LENGTH)
        //            return NO;//限制长度
        //        if (proposedNewLength > 5) {
        //            nextBtn.backgroundColor = [UIColor colorWithHexString:@"0046DD"];
        //            nextBtn.enabled = YES;
        //        }else if (proposedNewLength <=5)
        //        {
        //            nextBtn.backgroundColor = [UIColor colorWithHexString:@"D4D4D4"];
        //            nextBtn.enabled = NO;
        //        }
        return YES;
    }
    
}
-(void)checkUsernameIsRegist{
    NSString* code = [[NSUserDefaults standardUserDefaults]objectForKey:REGITCODE];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/custisexite.do"];
    NSDictionary* parmas = @{@"data":[NSString stringWithFormat:@"{\"account\":\"%@\"}",_usernameFiled.text]};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"----%@",str);
        if (![str isEqualToString:@"true"]) {
            [self showAlert:@"该用户名未注册"];
            return ;
        }else{
            if (self.userFiled.text.length == 0) {
                [self showAlert:@"手机号不能为空"];
                return;
            }
            if (self.senderFiled.text.length == 0){
                [self showAlert:@"输入验证码"];
                return;
            }
            if (_isRegistcodeSend == NO){
                [self showAlert:@"发送验证码未通过"];
                return;
            }
            if(![self.senderFiled.text isEqualToString:code]){
                [self showAlert:@"随机码填写不正确"];
                return;
            }
            [_groundView removeFromSuperview];
            [self creatNextViewUI];
        }
    } fail:^(NSError *error) {
        
    }];
}

//#pragma mark 手机验证是否注册过
//- (void)PhoneIsValueVerification
//{
//    /*
//     +/login/appcheckPhone.do
//     */
//    _isphoneAccress = NO;
//    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
//    [param setObject:self.userFiled.text forKey:@"phone"];
//    [param setObject:@"ture" forKey:@"mobile"];
//    NSString* urlStr = [NSString stringWithFormat:@"%@/login/appcheckPhone.do&phone=%@",ROOT_Path,self.userFiled.text];//'+callback1
//    NSLog(@"%@",urlStr);
//    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:param success:^(id result) {
//        NSString *returnStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
//        NSLog(@"returnStr%@",returnStr);
//        if (returnStr.length!=0) {
//            if ([returnStr rangeOfString:@"false"].location != NSNotFound) {
//                //没有注册过
//
//            }else if ([returnStr rangeOfString:@"true"].location != NSNotFound){
//                //已经注册
//                _isphoneAccress = YES;
//                _sendMessageBtn.backgroundColor = NavBarItemColor;
//            }else{
//                [self showAlert:returnStr];
//            }
//        }
//        //        [_hud hide:YES];
//    } fail:^(NSError *error) {
//        NSLog(@"error=====%@",error);
//        //        [_hud hide:YES];
//
//    }];
//
//}


#pragma mark 忘记密码
- (void)ForgetPwdRequest:(UIButton*)sender
{
    /*
     login/appupdPwd.do+callback1;
     data{
     xiaoyanma:验证码
     phone:电话
     password:密码
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    sender.enabled = NO;
    NSDictionary *params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\",\"password\":\"%@\",\"xiaoyanma\":\"%@\",\"account\":\"%@\"}",self.userFiled.text,self.pwdAgainFiled.text,self.senderFiled.text,_usernameFiled.text]};
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/appupdPwd.do",ROOT_Path];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        [hud hide:YES];
        NSString *returnStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"returnStr%@",returnStr);
        sender.enabled = YES;
        
        if ([returnStr rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"密码修改完成"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert:returnStr];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [hud hide:YES];
    }];

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
    [param setObject:self.userFiled.text forKey:@"phone"];
    [param setObject:@"true" forKey:@"mobile"];
    NSDictionary *params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",self.userFiled.text]};
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/appregistcode.do",ROOT_Path];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
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
//            
//        }else if([returnStr isEqualToString:@"false"]){
//            //验证码发送失败
//            
//        }else{
//            [self showAlert:returnStr];
//        }
    } fail:^(NSError *error) {
        
    }];
    
}



@end
