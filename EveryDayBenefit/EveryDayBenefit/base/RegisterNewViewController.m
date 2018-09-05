//
//  RegisterNewViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/12/27.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "RegisterNewViewController.h"
#import "YZXTimeButton.h"
#import "ZBarSDK.h"
#import "ORCodeViewController.h"
#import "CheckUtils.h"
#import "MBProgressHUD.h"
#import "AddressPickerView.h"
#import "RegisterSalesModel.h"
#import "InviteCodeAddrModel.h"
#import "ThirdAddressPickerView.h"
#import "ThirdAddressPickerViewModel.h"
#define SendTime 60
#import "RegisterSureViewController.h"

#define BlueColor [UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1]
@interface RegisterNewViewController ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int oldnum;
    BOOL oldupOrdown;
    NSTimer * oldtimer;
    BOOL _isphoneAccress;
    BOOL _isRegistcodeSend;
    YZXTimeButton* _sendMessageBtn;
    
    UIView* _myAleartView;
    UITextView* _detailAddressTView;
    BOOL _ismyAleartView;
    NSString* _invitBtnId;
    
    UIView* _addrAleartView;
    UIButton* _addrNewBtn;
    UITextField* _addrDetailTextField;
    NSMutableArray* _villageArray;
    NSMutableArray* _communityArray;
    NSMutableArray* _roomnumberArray;
    NSString* _curAccountID;
    NSString* _curAccount1ID;
    NSString* _curAccount2ID;

}
@property (nonatomic, strong) UIImageView * line;
@property (nonatomic,strong) UIView* groundView;
@property (nonatomic,strong) UITextField * accountFiled;
@property (nonatomic,strong) UITextField * nameFiled;
@property (nonatomic,strong) UITextField * usernameTf;
@property (nonatomic,strong) UITextField * userFiled;
@property (nonatomic,strong) UITextField * senderFiled;
@property (nonatomic,strong) UIButton * addressBtn;
@property (nonatomic,strong) UIScrollView* nextView;
@property (nonatomic,strong) UITextField * pwdFiled;
@property (nonatomic,strong) UITextField * pwdAgainFiled;
@property (nonatomic,strong) UITextField * invitFiled;
@property (nonatomic,strong) UIButton* invitBtn;
@property (nonatomic,strong) AddressPickerViewModel* addmodel;
@property (nonatomic,strong) NSString* detailaddress;
@property (nonatomic,strong) NSMutableArray* fxCustArray;//分销人员数组
@property (nonatomic,strong) UITableView* fxCustTableView;
@property (nonatomic,strong) NSMutableArray* addrArray;
@property (nonatomic,strong) UITableView* addrTbView;
@property (nonatomic,strong) UITableView* addrCodeTbView;
@property (nonatomic,strong) InviteCodeAddrModel* selectAddModel;
@property (nonatomic,strong) ThirdAddressPickerViewModel* villageaddmodel;

@end

@implementation RegisterNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fxCustArray = [[NSMutableArray alloc]init];
    _addrArray = [[NSMutableArray alloc]init];
    _selectAddModel = [[InviteCodeAddrModel alloc]init];
    _villageArray = [[NSMutableArray alloc]init];
    _communityArray = [[NSMutableArray alloc]init];
    _roomnumberArray = [[NSMutableArray alloc]init];
    
    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, 60, 40);
    UIImageView* leftBarimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
    leftBarimgView.image = [UIImage imageNamed:@"icon-back"];
    [leftBarBtn addSubview:leftBarimgView];
    UILabel* leftBarLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftBarimgView.right+10, 0, leftBarBtn.width - leftBarimgView.width - 10, leftBarBtn.height)];
    leftBarLabel.text = @"注册";
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
    
    
    UILabel* username = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _groundView.width, 50)];
    username.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:username];
    _usernameTf = [[UITextField alloc]initWithFrame:CGRectMake(10, username.top, username.width - 10, 49)];
    _usernameTf.delegate = self;
    _usernameTf.placeholder = @"请输入用户名（必填）";
    _usernameTf.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    UIView* uline = [[UIView alloc]initWithFrame:CGRectMake(0, _usernameTf.bottom, username.width, 1)];
    uline.backgroundColor = LineColor;
    [_groundView addSubview:_usernameTf];
    [_groundView addSubview:uline];
    
    UILabel* userlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, username.bottom, _groundView.width, 50)];
    userlabel.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:userlabel];
    _userFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, userlabel.top, userlabel.width - 10, 49)];
    _userFiled.delegate = self;
    _userFiled.placeholder = @"请输入手机号（必填）";
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
    _senderFiled.placeholder = @"请输入验证码（必填）";
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
    
    UILabel* invitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, pwdLabel.bottom +1, _groundView.width, 50)];
    invitLabel.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:invitLabel];
    _invitFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, invitLabel.top, invitLabel.width - 50, invitLabel.height)];
    _invitFiled.delegate = self;
    _invitFiled.placeholder = @"*请输入邀请码（必填）";
    _invitFiled.keyboardType = UIKeyboardTypeASCIICapable;
    [_groundView addSubview:_invitFiled];
    UIImageView* invitImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_invitFiled.right,_invitFiled.top +5, 30, 30)];
    invitImgView.image = [UIImage imageNamed:@"icon-erweima"];
    invitImgView.userInteractionEnabled = YES;
    [invitLabel addSubview:invitImgView];
    UITapGestureRecognizer* invitImgtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(invitImgViewTapClick:)];
    [invitImgView addGestureRecognizer:invitImgtap];
    [_groundView addSubview:invitImgView];
    
    
    UIButton* nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.backgroundColor = NavBarItemColor;
    nextBtn.frame = CGRectMake(10, invitLabel.bottom+20, _groundView.width - 20, 50) ;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_groundView addSubview:nextBtn];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5.0;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(30, nextBtn.bottom+10, mScreenWidth - 60, 30)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    lab.text = @"点击“下一步”同意《软件许可协议》";
    lab.textColor = GrayTitleColor;
    [self changeTextColor:lab Txt:lab.text changeTxt:@"《软件许可协议》"];
    [_groundView addSubview:lab];
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreeTapGesture:)];
    lab.userInteractionEnabled = YES;
    [lab addGestureRecognizer:aTap];
    
}


//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1683fb"] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}



- (void)creatNextViewAddUI
{
    _nextView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    _nextView.backgroundColor = BackGorundColor;
    [self.view addSubview:_nextView];
    
    UILabel* userlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, _nextView.width, 50)];
    userlabel.backgroundColor = [UIColor whiteColor];
    [_nextView addSubview:userlabel];
    _pwdFiled = [[UITextField alloc]initWithFrame:CGRectMake(10, userlabel.top, userlabel.width - 10, 49)];
    _pwdFiled.delegate = self;
    _pwdFiled.secureTextEntry = YES;
    _pwdFiled.placeholder = @"请输入密码";
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
    
}



#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _userFiled) {
        BOOL isphone = [CheckUtils isValidatePhone:_userFiled.text];
        if (![_userFiled.text isEqualToString:@""]) {
            if (!isphone) {
                [self showAlert:@"请输入正确的手机号"];
            }
        }
    }else if (textField == _senderFiled){
        
    }else if (textField == _pwdFiled){
        
    }else if (textField == _pwdAgainFiled){
        
    }
}

#pragma mark 左侧导航事件
- (void)leftBarBtnClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 发送验证码
- (void)sendBtnClick:(YZXTimeButton*)sender
{
    BOOL isphone = [CheckUtils isValidatePhone:_userFiled.text];
    if (!isphone) {
        [self showAlert:@"请输入正确的手机号"];
        return;
    }else if ([self.userFiled.text isEqualToString:@""]) {
        [self showAlert:@"请先输入手机号"];
        return;
    }else{
        sender.recoderTime = @"yes";
        [sender setKaishi:SendTime];
        [self getSendCode];
    }
    //手机验证是否注册过
    /*
     +/login/appcheckPhone.do
     mobile:true
     phone:手机号
     */
//    _isphoneAccress = NO;
//    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
//    self.userFiled.text =[self convertNull:self.userFiled.text];
//    [param setObject:self.userFiled.text forKey:@"phone"];
//    //[param setObject:@"ture" forKey:@"mobile"];
//    NSString* urlStr = [NSString stringWithFormat:@"%@/login/appcheckPhone.do",ROOT_Path];//'+callback1
//    NSLog(@"%@",urlStr);
//    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:param success:^(id result) {
//        NSString *returnStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
//        NSLog(@"returnStr%@",returnStr);
//        if (returnStr.length!=0) {
//            if ([returnStr rangeOfString:@"false"].location != NSNotFound) {
//                //没有注册过
//                _isphoneAccress = YES;
//                _sendMessageBtn.backgroundColor = NavBarItemColor;
//            }else if ([returnStr rangeOfString:@"true"].location != NSNotFound){
//                //已经注册
//                [self showAlert:@"已经注册"];
//            }else{
//                [self showAlert:returnStr];
//            }
//
//
//            if(_isphoneAccress == NO){
//                [self showAlert:@"手机验证失败"];
//            }else{
//                sender.recoderTime = @"yes";
//                [sender setKaishi:SendTime];
//
//                //        _isRegistcodeSend = YES;
//            }
//        }
//
//    } fail:^(NSError *error) {
//        NSLog(@"error=====%@",error);
//
//    }];
    
    
    
}
#pragma mark 获取分销员
- (void)invitBtnClick:(UIButton*)sender
{
    if ([_invitFiled.text isEqualToString:@""]) {
        if (!IsEmptyValue(_addmodel.village_id)) {
            [self FxCustRequest];
            [self creatFxCustUI];
        }
    }
}

- (UIView*)creatFxCustUI{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_myAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFxCustAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleartView.height - 350)/2, _myAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _fxCustTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _fxCustTableView.backgroundColor = [UIColor grayColor];
        _fxCustTableView.delegate = self;
        _fxCustTableView.dataSource = self;
        [windowView addSubview:_fxCustTableView];
        
    }
    return _myAleartView;
}

- (UIView*)creatAddrUI{
    if (_addrAleartView == nil) {
        _addrAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _addrAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_addrAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_addrAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAddrTapAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_addrAleartView.height - 350)/2, _addrAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_addrAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAddrAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _addrTbView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _addrTbView.backgroundColor = [UIColor grayColor];
        _addrTbView.delegate = self;
        _addrTbView.dataSource = self;
        [windowView addSubview:_addrTbView];
        
    }
    return _addrAleartView;
}

- (UIView*)creatInviteCodeAddrUI
{
    if (_addrAleartView == nil) {
        _addrAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _addrAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_addrAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_addrAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAddrTapAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_addrAleartView.height - 350)/2, _addrAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_addrAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAddrAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _addrCodeTbView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _addrCodeTbView.backgroundColor = [UIColor grayColor];
        _addrCodeTbView.delegate = self;
        _addrCodeTbView.dataSource = self;
        [windowView addSubview:_addrCodeTbView];
        
    }
    return _addrAleartView;
}


#pragma mark 地址点击
- (void)addressClick:(UIButton*)sender
{
    if ([_invitFiled.text isEqualToString:@""]) {
        [self addressAleartView];
    }
}

- (UIView*)addressAleartView
{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_myAleartView];
        
        UIImageView* grayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _myAleartView.width, _myAleartView.height)];
        grayView.userInteractionEnabled = YES;
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        UITapGestureRecognizer* garytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAleartClick:)];
        [grayView addGestureRecognizer:garytap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 300, _myAleartView.width, 300)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        AddressPickerView* pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, windowView.height)];
        [pickerView setTransVaule:^(AddressPickerViewModel * model,NSString * address,BOOL istrue) {
            _addmodel = [[AddressPickerViewModel alloc]init];
            _addmodel = model;
            _detailaddress = address;
            _addmodel.province = [self convertNull:_addmodel.province];
            _addmodel.city = [self convertNull:_addmodel.city];
            _addmodel.district = [self convertNull:_addmodel.district];
            _addmodel.sevicecenter = [self convertNull:_addmodel.sevicecenter];
            _addmodel.village = [self convertNull:_addmodel.village];
            NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@ %@ %@", _addmodel.province, _addmodel.city, _addmodel.district,_addmodel.sevicecenter,_addmodel.village];
            NSLog(@"地址选择器返回值%@",showMsg);
            if (istrue) {
                [_addressBtn setTitle:showMsg forState:UIControlStateNormal];
                if (!IsEmptyValue(_addmodel.village_id)) {
                    [self FxCustRequestDefault:_addmodel.village_id];
                    [self villageidgetAddressRequestDataDefault:_addmodel.village_id];
                }
            }else{
                [_addressBtn setTitle:@"请选择业务中心地址" forState:UIControlStateNormal];
            }
            _ismyAleartView = YES;
            [_myAleartView removeFromSuperview];
            _myAleartView = nil;
        }];
        [windowView addSubview:pickerView];
        
    }
    return _myAleartView;
}
#pragma mark 收货地址点击
- (void)addNewClick:(UIButton*)sender
{
    
    if (![_invitFiled.text isEqualToString:@""]) {
        //        [self creatInviteCodeAddrUI];
        //        [self inviteCodegetAddressRequestData:_invitFiled.text];
        if (!IsEmptyValue(_selectAddModel.villageid)) {
            [_grayView showView];
            [self creatAddrUI:[NSString stringWithFormat:@"%@",_selectAddModel.villageid]];
        }
    }else{
        //        if (!IsEmptyValue(_addmodel.village_id)) {
        //            [self villageidgetAddressRequestData:_addmodel.village_id];
        //            [self creatAddrUI];
        //        }
        if (!IsEmptyValue(_addmodel.village_id)) {
            [_grayView showView];
            [self creatAddrUI:[NSString stringWithFormat:@"%@",_addmodel.village_id]];
        }
    }
}

- (UIView*)creatAddrUI:(NSString*)village_id{
    if (_addrAleartView == nil) {
        _addrAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
        _addrAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_addrAleartView];
        
        UIImageView* grayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _addrAleartView.width, _addrAleartView.height)];
        grayView.userInteractionEnabled = YES;
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_addrAleartView addSubview:grayView];
        UITapGestureRecognizer* garytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAddrTapAleartView1:)];
        [grayView addGestureRecognizer:garytap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (mScreenHeight - 300)/2, _addrAleartView.width-20, 300)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        [_addrAleartView addSubview:windowView];
        
        UIScrollView* sView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, windowView.height)];
        [windowView addSubview:sView];
        
        ThirdAddressPickerView* pickerView = [[ThirdAddressPickerView alloc]initWithFrame:CGRectMake(0, 0, windowView.width , windowView.height) Id:village_id];
        [pickerView setTransVaule:^(ThirdAddressPickerViewModel * model,BOOL istrue) {
            _villageaddmodel = [[ThirdAddressPickerViewModel alloc]init];
            _villageaddmodel = model;
            _villageaddmodel.village = [self convertNull:_villageaddmodel.village];
            _villageaddmodel.comunity = [self convertNull:_villageaddmodel.comunity];
            _villageaddmodel.roomnumber = [self convertNull:_villageaddmodel.roomnumber];
            NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@",_villageaddmodel.village,_villageaddmodel.comunity,_villageaddmodel.roomnumber];
            NSLog(@"地址选择器返回值%@",showMsg);
            if (istrue) {
                [_addrNewBtn setTitle:showMsg forState:UIControlStateNormal];
            }else{
                [_addrNewBtn setTitle:@"绑定收货地址" forState:UIControlStateNormal];
            }
            [_addrAleartView removeFromSuperview];
            _addrAleartView = nil;
            [_grayView hideView];
        }];
        [sView addSubview:pickerView];
    }
    return _addrAleartView;
}

- (void)closeAddrTapAleartView1:(UITapGestureRecognizer*)tap
{
    [_grayView hideView];
    [_addrAleartView removeFromSuperview];
    _addrAleartView = nil;
}


#pragma mark 下一步
- (void)nextBtnClick:(UIButton*)sender
{
    
    NSString* invitStr  = [self inviteCodeDeal:_invitFiled.text];
    if ([self.usernameTf.text isEqualToString:@""]) {
        [self showAlert:@"用户名不能为空"];
    }else{
        [self checkUsernameIsRegist:invitStr];
    }
    
    
    
    
}
-(void)checkUsernameIsRegist:(NSString *)invitStr{
    NSString* code = [[NSUserDefaults standardUserDefaults]objectForKey:REGITCODE];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/custisexite.do"];
    NSDictionary* parmas = @{@"data":[NSString stringWithFormat:@"{\"account\":\"%@\"}",_usernameTf.text]};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"----%@",str);
        if ([str isEqualToString:@"true"]) {
            [self showAlert:@"该用户名已经注册"];
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
            if (![_invitFiled.text isEqualToString:@""]) {
                [self inviteCodegetAddressRequestData:invitStr];
            }else{
                [self showAlert:@"请输入邀请码"];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark 注册协议点击方法
- (void)agreeTapGesture:(UITapGestureRecognizer*)tap
{
    //点击注册协议
}
#pragma mark 点击了邀请二维码
- (void)invitImgViewTapClick:(UITapGestureRecognizer*)tap
{
    NSLog(@"点击了邀请验证码");
    if(IOS7)
    {
        ORCodeViewController * rt = [[ORCodeViewController alloc]init];
        [rt setTransVaule:^(NSString *code) {
            _invitFiled.text = code;
            NSString* codestr = [[NSUserDefaults standardUserDefaults]objectForKey:REGITCODE];
            if (self.userFiled.text.length == 0) {
                [self showAlert:@"手机号不能为空"];
            }else if (self.senderFiled.text.length == 0){
                [self showAlert:@"输入验证码"];
            }else if (_isRegistcodeSend == NO){
                [self showAlert:@"发送验证码未通过"];
            }else if(![self.senderFiled.text isEqualToString:codestr]){
                [self showAlert:@"随机码填写不正确"];
            }else{
                if (![_invitFiled.text isEqualToString:@""]) {
                    NSString* str = [self inviteCodeDeal:_invitFiled.text];
                    [self inviteCodegetAddressRequestData:str];
                }
            }
        }];
        [self presentViewController:rt animated:YES completion:^{
            
        }];
        
    }
    else
    {
        [self checkAVAuthorizationStatus];
    }
}


#pragma mark 取消aleartView
- (void)closeAleartClick:(UIButton*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
    
}
//点击空白处这个View
- (void)closeFxCustAleartView:(UITapGestureRecognizer*)tap
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}
//取消
- (void)closeAleartView:(UIButton*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

- (void)closeAddrTapAleartView:(UITapGestureRecognizer*)tap
{
    [_addrAleartView removeFromSuperview];
    _addrAleartView = nil;
}
- (void)closeAddrAleartView:(UIButton*)sender
{
    [_addrAleartView removeFromSuperview];
    _addrAleartView = nil;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _fxCustTableView) {
        return _fxCustArray.count;
    }else if (tableView == _addrTbView){
        return _addrArray.count;
    }else if (tableView == _addrCodeTbView){
        return _addrArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    if (tableView == _fxCustTableView) {
        RegisterSalesModel* model = _fxCustArray[indexPath.row];
        cell.textLabel.text = model.account;
        return cell;
    }
    if (tableView == _addrTbView) {
        if (_addrArray.count!=0) {
            InviteCodeAddrModel* addrmodel = _addrArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",addrmodel.province,addrmodel.city,addrmodel.area,addrmodel.servicecenter,addrmodel.housenumber,addrmodel.community,addrmodel.roomnumber];
        }
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
    if (tableView == _addrCodeTbView) {
        if (_addrArray.count!=0) {
            InviteCodeAddrModel* addrmodel = _addrArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",addrmodel.province,addrmodel.city,addrmodel.area,addrmodel.servicecenter,addrmodel.housenumber,addrmodel.community,addrmodel.roomnumber];
        }
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _fxCustTableView) {
        RegisterSalesModel* model = _fxCustArray[indexPath.row];
        model.account = [self convertNull:model.account];
        [_invitBtn setTitle:model.account forState:UIControlStateNormal];
        _invitBtnId = model.Id;
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    }else if (tableView == _addrTbView){
        if (_addrArray.count!=0) {
            InviteCodeAddrModel* addrmodel = _addrArray[indexPath.row];
            _selectAddModel = addrmodel;
            [_addrAleartView removeFromSuperview];
            _addrAleartView = nil;
            addrmodel.province = [self convertNull:addrmodel.province];
            addrmodel.city = [self convertNull:addrmodel.city];
            addrmodel.area = [self convertNull:addrmodel.area];
            addrmodel.servicecenter = [self convertNull:addrmodel.servicecenter];
            addrmodel.housenumber = [self convertNull:addrmodel.housenumber];
            addrmodel.community = [self convertNull:addrmodel.community];
            addrmodel.roomnumber = [self convertNull:addrmodel.roomnumber];
            [_addrNewBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@%@%@%@",addrmodel.province,addrmodel.city,addrmodel.area,addrmodel.servicecenter,addrmodel.housenumber,addrmodel.community,addrmodel.roomnumber] forState:UIControlStateNormal];
        }
        
    }else if (tableView == _addrCodeTbView){
        if (_addrArray.count!=0) {
            InviteCodeAddrModel* addrmodel = _addrArray[indexPath.row];
            _selectAddModel = addrmodel;
            [_addrAleartView removeFromSuperview];
            _addrAleartView = nil;
            RegisterSureViewController* vc = [[RegisterSureViewController alloc]init];
            vc.selectAddModel = addrmodel;
            vc.phone = [NSString stringWithFormat:@"%@",_userFiled.text];
            vc.code = [NSString stringWithFormat:@"%@",_senderFiled.text];
            vc.linkerid = [NSString stringWithFormat:@"%@",addrmodel.linkerid];
            if (!IsEmptyValue(addrmodel.linkerid)) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
    }
}


#pragma mark 获取验证码
- (void)getSendCode
{
    /*
     /login/appregistcode.do
     mobile:true
     data{
     phone:手机号
     }
     */
    _isRegistcodeSend = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    self.userFiled.text = [self convertNull:self.userFiled.text];
    [param setObject:self.userFiled.text forKey:@"phone"];
    [param setObject:@"true" forKey:@"mobile"];
    NSDictionary *params = @{@"data":[NSString stringWithFormat:@"{\"phone\":\"%@\"}",self.userFiled.text]};
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/appregistcode.do",ROOT_Path];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        NSString *returnStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"验证码返回%@",returnStr);
        NSString* str = [Command replaceAllOthers:returnStr];
        if ([CheckUtils NUM:str]) {
            //验证码成功
            _isRegistcodeSend = YES;
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:REGITCODE];
        }else{
            [self showAlert:returnStr];
        }
        //        if ([returnStr isEqualToString:@"true"]) {
        //
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

#pragma mark 接口----获取分销人列表
- (void)FxCustRequest
{
    /*
     ///login/fxCust.do
     villageid:业务中心ID
     */
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/fxCust.do",ROOT_Path];
    _addmodel.village_id = [self convertNull:_addmodel.village_id];
    NSDictionary* params = @{@"villageid":[NSString stringWithFormat:@"%@",_addmodel.village_id]};
    NSLog(@"urlStr---%@params---%@",urlStr,params);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"FxCustRequeststr%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"FxCustRequestarray%@",array);
        if (array.count!=0) {
            [_fxCustArray removeAllObjects];
            for (int i = 0; i < array.count; i++) {
                RegisterSalesModel* model = [[RegisterSalesModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                [_fxCustArray addObject:model];
            }
            [_fxCustTableView reloadData];
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"FxCustRequest请求错误，错误原因%@",error.localizedDescription);
    }];
}

- (void)FxCustRequestDefault:(NSString*)str
{
    /*
     ///login/fxCust.do
     villageid:业务中心ID
     */
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/fxCust.do",ROOT_Path];
    NSDictionary* params = @{@"villageid":[NSString stringWithFormat:@"%@",str]};
    NSLog(@"urlStr---%@params---%@",urlStr,params);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"FxCustRequeststr%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"FxCustRequestarray%@",array);
        if (array.count!=0) {
            RegisterSalesModel* model = [[RegisterSalesModel alloc]init];
            [model setValuesForKeysWithDictionary:array[0]];
            model.account = [self convertNull:model.account];
            [_invitBtn setTitle:model.account forState:UIControlStateNormal];
            _invitBtnId = model.Id;
        }
        
    } fail:^(NSError *error) {
        NSLog(@"FxCustRequest请求错误，错误原因%@",error.localizedDescription);
    }];
}

#pragma mark 接口----用邀请码获取到对应的地址
- (void)inviteCodegetAddressRequestData:(NSString*)invitecode
{
    /*
     /login/InviteCodegetAddress.do
     mobile:true
     invitecode:邀请码
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/InviteCodegetAddress.do"];
    NSDictionary* parmas = @{@"mobile":@"true",@"invitecode":invitecode};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/login/InviteCodegetAddress.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                InviteCodeAddrModel* addrmodel = [[InviteCodeAddrModel alloc]init];
                [addrmodel setValuesForKeysWithDictionary:array[0]];
                RegisterSureViewController* vc = [[RegisterSureViewController alloc]init];
                vc.selectAddModel = addrmodel;
                vc.phone = [NSString stringWithFormat:@"%@",_userFiled.text];
                vc.code = [NSString stringWithFormat:@"%@",_senderFiled.text];
                vc.aconunt = [NSString stringWithFormat:@"%@",_usernameTf.text];
                vc.linkerid = [NSString stringWithFormat:@"%@",addrmodel.linkerid];
                if (!IsEmptyValue(addrmodel.linkerid)) {
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                [self showAlert:@"分销不存在"];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}


#pragma mark 接口----用业务中心的id获取对应的收货地址的五级。
- (void)villageidgetAddressRequestData:(NSString*)str
{
    /*
     /login/VillageidgetAddress.do
     mobile:true
     villageid:villageid
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/VillageidgetAddress.do"];
    NSDictionary* parmas = @{@"mobile":@"true",@"villageid":str};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/login/VillageidgetAddress.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                [_addrArray removeAllObjects];
                for (int i = 0; i < array.count; i ++) {
                    InviteCodeAddrModel* addrmodel = [[InviteCodeAddrModel alloc]init];
                    [addrmodel setValuesForKeysWithDictionary:array[i]];
                    [_addrArray addObject:addrmodel];
                }
                [_addrTbView reloadData];
            }else{
                [self showAlert:@"请更换业务中心重新尝试"];
            }
        }
    } fail:^(NSError *error) {
        
    }];
    
}


- (void)villageidgetAddressRequestDataDefault:(NSString*)str
{
    /*
     /login/VillageidgetAddress.do
     mobile:true
     villageid:villageid
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/VillageidgetAddress.do"];
    NSDictionary* parmas = @{@"mobile":@"true",@"villageid":str};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/login/VillageidgetAddress.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                InviteCodeAddrModel* addrmodel = [[InviteCodeAddrModel alloc]init];
                [addrmodel setValuesForKeysWithDictionary:array[0]];
                _selectAddModel = addrmodel;
                addrmodel.province = [self convertNull:addrmodel.province];
                addrmodel.city = [self convertNull:addrmodel.city];
                addrmodel.area = [self convertNull:addrmodel.area];
                addrmodel.servicecenter = [self convertNull:addrmodel.servicecenter];
                addrmodel.housenumber = [self convertNull:addrmodel.housenumber];
                addrmodel.community = [self convertNull:addrmodel.community];
                addrmodel.roomnumber = [self convertNull:addrmodel.roomnumber];
                [_addrNewBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@%@%@%@",addrmodel.province,addrmodel.city,addrmodel.area,addrmodel.servicecenter,addrmodel.housenumber,addrmodel.community,addrmodel.roomnumber] forState:UIControlStateNormal];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}



#pragma mark --------二维码扫描-------
- (void)checkAVAuthorizationStatus
{
    if (IOS7) {
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        //    NSString *tips = NSLocalizedString(@"AVAuthorization", @"您没有权限访问相机");
        if(status == AVAuthorizationStatusAuthorized) {
            // authorized
            [self scanBtnAction];
        } else if (status == AVAuthorizationStatusNotDetermined) {
            //            if ([AVCaptureDevice instancesRespondToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    [self scanBtnAction];
                }else{
                    [self showAlert:@"用户拒绝申请"];
                }
                
            }];
            //            }else{
            //                [self showAlert:@"拒绝"];
            //            }
        } else if (status == AVAuthorizationStatusDenied) {
            [self showAlert:@"用户关闭了权限"];
            AVAuthorizationStatus status1 = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status1 == AVAuthorizationStatusAuthorized) {
                [self scanBtnAction];
            }
        } else if(status == AVAuthorizationStatusRestricted){
            [self showAlert:@"您没有权限访问相机"];
        }
        
    }else{
        [self scanBtnAction];
    }
}

- (void)scanBtnAction
{
    oldnum = 0;
    oldupOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    oldtimer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:^{
        
    }];
    
    
}

-(void)animation1
{
    if (oldupOrdown == NO) {
        oldnum ++;
        _line.frame = CGRectMake(30, 10+2*oldnum, 220, 2);
        if (2*oldnum == 260) {
            oldupOrdown = YES;
        }
    }
    else {
        oldnum --;
        _line.frame = CGRectMake(30, 10+2*oldnum, 220, 2);
        if (oldnum == 0) {
            oldupOrdown = NO;
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [oldtimer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    oldnum = 0;
    oldupOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [oldtimer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    oldnum = 0;
    oldupOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        NSLog(@"%@",result);
        //        [self showAlert:result];
        _invitFiled.text = result;
        NSString* codestr = [[NSUserDefaults standardUserDefaults]objectForKey:REGITCODE];
        if (self.userFiled.text.length == 0) {
            [self showAlert:@"手机号不能为空"];
        }else if (self.senderFiled.text.length == 0){
            [self showAlert:@"输入验证码"];
        }else if (_isRegistcodeSend == NO){
            [self showAlert:@"发送验证码未通过"];
        }else if(![self.senderFiled.text isEqualToString:codestr]){
            [self showAlert:@"随机码填写不正确"];
        }else{
            if (![_invitFiled.text isEqualToString:@""]) {
                NSString* str = [self inviteCodeDeal:_invitFiled.text];
                [self inviteCodegetAddressRequestData:str];
            }
        }
    }];
}

- (NSString*)inviteCodeDeal:(NSString*)str
{
    if ([str rangeOfString:@"fx"].location != NSNotFound) {
        //删除字符串两端的尖括号
        NSMutableString *mString = [NSMutableString stringWithString:str];
        //删除字符串中的空格
        NSString *str2 = [mString stringByReplacingOccurrencesOfString:@"fx" withString:@""];
        NSLog(@"str2:%@",str2);
        return str2;
    } else {
        return @"";
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




@end
