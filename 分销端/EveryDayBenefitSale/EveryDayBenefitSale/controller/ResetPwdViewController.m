//
//  ResetPwdViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "YZXTimeButton.h"
#define SendTime 60
#import "CheckUtils.h"
#import "LoginViewController.h"

@interface ResetPwdViewController ()<UITextFieldDelegate>
{
    BOOL _ischeckPhone;
    BOOL _isRegistcodeSend;
    
}

@property (nonatomic,strong) UIView* groundView;
@property (nonatomic,strong) UITextField * userFiled;
@property (nonatomic,strong) UITextField * senderFiled;
@property (nonatomic,strong) UIView* nextView;
@property (nonatomic,strong) UITextField * pwdFiled;
@property (nonatomic,strong) UITextField * pwdAgainFiled;
@property (nonatomic,strong) YZXTimeButton* sendMessageBtn;
@end

@implementation ResetPwdViewController

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
    _groundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    _groundView.backgroundColor = BackGorundColor;
    [self.view addSubview:_groundView];
    
    UILabel* userlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _groundView.width, 50)];
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
    _sendMessageBtn.buttonTitle = @"获取验证码";
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
    BOOL isphone = [CheckUtils isValidatePhone:_userFiled.text];
    if (!isphone) {
        [self showAlert:@"请输入正确的手机号"];
    }else if ([_userFiled.text isEqualToString:@""]) {
        [self showAlert:@"请先输入手机号"];
        
    }else if(_ischeckPhone == NO){
        [self showAlert:@"手机验证失败"];
        
    }else{
        [self getSendCode];
//                _isRegistcodeSend = YES;
    }

    
}

#pragma mark 下一步
- (void)nextBtnClick:(UIButton*)sender
{
    if ([_userFiled.text isEqualToString:@""]||[_senderFiled.text isEqualToString:@""]) {
        [self showAlert:@"输入不能为空"];
    }else if (_ischeckPhone == NO) {
        [self showAlert:@"手机验证未通过"];
    }else if (_isRegistcodeSend == NO){
        [self showAlert:@"获取验证码失败"];
    }else{
        [_groundView removeFromSuperview];
        [self creatNextViewUI];
    }
}
#pragma mark 完成修改
- (void)xiugaiBtnClick:(UIButton*)sender
{
    NSString* code = [[NSUserDefaults standardUserDefaults]objectForKey:REGITCODE];
    if ([_pwdAgainFiled.text isEqualToString:@""]||[_pwdFiled.text isEqualToString:@""]) {
        [self showAlert:@"密码输入不能为空"];
    }else if (![_pwdAgainFiled.text isEqualToString:_pwdFiled.text]){
        [self showAlert:@"请输入相同的密码"];
    }else if (_ischeckPhone == NO){
        [self showAlert:@"手机验证未通过"];
    }else if (_isRegistcodeSend == NO){
        [self showAlert:@"获取验证码失败"];
    }else if ([_senderFiled.text isEqualToString:@""]){
        [self showAlert:@"验证码输入不能为空"];
    }else if (![_senderFiled.text isEqualToString:code]){
        [self showAlert:@"随机码验证不正确"];
    }else{
        [self upSenderAndFenxiaoRequestData:sender];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _userFiled) {
        [self checkPhoneExistRequestData];
    }
}

- (void)checkPhoneExistRequestData
{
/*
 /login/checkPhoneExist.do
 mobile:true
 phone:手机号
 */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/checkPhoneExist.do"];
    NSDictionary* params = @{@"mobile":@"true",@"phone":_userFiled.text};
    [DataPost requestAFWithUrl:urlstr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"绑定手机号核查正确"];
            _ischeckPhone = YES;
            _sendMessageBtn.backgroundColor = NavBarItemColor;
        }else if ([str rangeOfString:@"false"].location != NSNotFound){
            [self showAlert:@"绑定手机号核查未通过"];
            _ischeckPhone = NO;
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
}


#pragma mark 获取验证码
- (void)getSendCode
{
    /*
     +/login/appregistcode.do
     */
    _isRegistcodeSend = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setObject:self.userFiled.text forKey:@"phone"];
    [param setObject:@"true" forKey:@"mobile"];
    NSDictionary *params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",self.userFiled.text]};
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/appregistcode.do",ROOT_Path];
    [DataPost requestAFWithUrl:urlStr params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString *returnStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"returnStr%@",returnStr);
        NSString* str = [Command replaceAllOthers:returnStr];
        if ([Command NUM:str]) {
            //验证码成功
            _isRegistcodeSend = YES;
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:REGITCODE];
        }else{
            [self showAlert:returnStr];
        }
//        if ([returnStr isEqualToString:@"true"]) {
//            //验证码成功
//            _isRegistcodeSend = YES;
//        }else if([returnStr isEqualToString:@"false"]){
//            //验证码发送失败
//        }else{
//            [self showAlert:returnStr];
//        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
    
}


- (void)upSenderAndFenxiaoRequestData:(UIButton*)sender
{
    /*
     /login/upSenderAndFenxiao.do
     mobile:true
     xiaoyanma:验证码
     password:密码
     */
    sender.enabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/upSenderAndFenxiao.do"];
    NSDictionary* parmas = @{@"mobile":@"true",@"xiaoyanma":_senderFiled.text,@"password":_pwdAgainFiled.text};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/login/upSenderAndFenxiao.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"upSenderAndFenxiao.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else if ([str rangeOfString:@"true"].location != NSNotFound){
            [self showAlert:@"密码修改成功"];
            NSArray* array = self.navigationController.viewControllers;
            if (array.count>=3) {
                UIViewController *viewCtl = self.navigationController.viewControllers[array.count - 3];
                [self.navigationController popToViewController:viewCtl animated:YES];
            }
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:AutoLogin];
        }else if ([str rangeOfString:@"false"].location != NSNotFound){
            [self showAlert:@"密码修改失败"];
        }else{
            [self showAlert:str];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        sender.enabled = YES;
    }];

}


@end
