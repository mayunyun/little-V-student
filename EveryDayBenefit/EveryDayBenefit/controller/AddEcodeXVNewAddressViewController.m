//
//  AddEcodeXVNewAddressViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/16.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "AddEcodeXVNewAddressViewController.h"
#import "LoginNewViewController.h"
#import "MBProgressHUD.h"
#import "PopListTableViewController.h"
#import "ServiceCenterModel.h"
#import "VillageModel.h"
#import "CommunityModel.h"
#import "RoomnumberModel.h"

#import "Account.h"
#define inputH 35

@interface AddEcodeXVNewAddressViewController ()<UITextFieldDelegate,AccountDelegate>
{
    /*
     *收货地址
     */
    UILabel* _shdetailLabel;
    UISwitch* _setSwitch;
    UITextField* _detailTextField;
    UITextField* _nameTextField;
    
    UIButton* _curAccount;
    UIButton* _curAccount1;
    UIButton* _curAccount2;
    UIButton* _curAccount3;
    NSString* _curAccountID;
    NSString* _curAccount1ID;
    NSString* _curAccount2ID;
    NSString* _curAccount3ID;
    
    NSMutableArray* _serviceArray;
    NSMutableArray* _villageArray;
    NSMutableArray* _communityArray;
    NSMutableArray* _roomnumberArray;
    
}
@property (nonatomic,strong)PopListTableViewController* accountList;
@property (nonatomic,strong)PopListTableViewController* accountList1;
@property (nonatomic,strong)PopListTableViewController* accountList2;
@property (nonatomic,strong)PopListTableViewController* accountList3;
@property (nonatomic,assign)CGRect listFrame;
@property (nonatomic,assign)CGRect listFrame1;
@property (nonatomic,assign)CGRect listFrame2;
@property (nonatomic,assign)CGRect listFrame3;

@end

@implementation AddEcodeXVNewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _villageArray = [[NSMutableArray alloc]init];
    _communityArray = [[NSMutableArray alloc]init];
    _roomnumberArray = [[NSMutableArray alloc]init];
    _serviceArray = [[NSMutableArray alloc]init];
    _selectAddModel.province = [self convertNull:_selectAddModel.province];
    _selectAddModel.city = [self convertNull:_selectAddModel.city];
    _selectAddModel.area = [self convertNull:_selectAddModel.area];
    _selectAddModel.servicecenter = [self convertNull:_selectAddModel.servicecenter];
    _selectAddModel.linker = [self convertNull:_selectAddModel.linker];
    _selectAddModel.linkerid = [self convertNull:_selectAddModel.linkerid];
    NSLog(@"_selectAddModel---%@,%@,%@,%@,%@",_selectAddModel.provinceid,_selectAddModel.cityid,_selectAddModel.areaid,_selectAddModel.serviceid,_selectAddModel.linkerid);
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:@"添加收货地址"];
    [self creatUI];
    
}

- (BOOL)isExiteEcode
{
    if (!IsEmptyValue(self.selectAddModel.provinceid)&&!IsEmptyValue(self.selectAddModel.cityid)&&!IsEmptyValue(self.selectAddModel.areaid)&&!IsEmptyValue(self.selectAddModel.serviceid)) {
        return YES;
    }else{
        return NO;
    }
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    UIScrollView* bgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth, mScreenHeight - 64 - 10)];
    bgView.bounces = NO;
    bgView.contentSize = CGSizeMake(mScreenWidth, 560);
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIFont* leftFont = [UIFont systemFontOfSize:14];
    UIFont* rightFont = [UIFont systemFontOfSize:12];
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    titleLabel.text = @"收货信息";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = leftFont;
    titleLabel.textColor = NavBarItemColor;
    [bgView addSubview:titleLabel];
    
    CGFloat gap = 10; //上下左右的最外边的边距
    CGFloat cellWidth = bgView.width - gap*2;
    CGFloat cellHeight = 44;
    
    UILabel* shouhuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, 60, cellHeight)];
    shouhuoLabel.text = @"地区";
    shouhuoLabel.font = leftFont;
    shouhuoLabel.textColor = [UIColor blackColor];
    [bgView addSubview:shouhuoLabel];
    _shdetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(shouhuoLabel.right, shouhuoLabel.top, cellWidth - shouhuoLabel.width, shouhuoLabel.height)];
    _shdetailLabel.text = [NSString stringWithFormat:@"%@    |    %@    |    %@",_selectAddModel.province,_selectAddModel.city,_selectAddModel.area];
    _shdetailLabel.textColor = GrayTitleColor;
    _shdetailLabel.font = rightFont;
    _shdetailLabel.backgroundColor = [UIColor clearColor];
    _shdetailLabel.numberOfLines = 0;
    _shdetailLabel.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:_shdetailLabel];
    UIView* line0 = [[UIView alloc]initWithFrame:CGRectMake(gap, _shdetailLabel.bottom, cellWidth, 1)];
    line0.backgroundColor = LineColor;
    [bgView addSubview:line0];
    
    UILabel* jiedao = [[UILabel alloc]initWithFrame:CGRectMake(shouhuoLabel.left, line0.bottom, shouhuoLabel.width, cellHeight)];
    jiedao.text = @"街道";
    jiedao.font = leftFont;
    [bgView addSubview:jiedao];
    CGFloat inputW = cellWidth - shouhuoLabel.width;
    // 1.1帐号选择框
    _curAccount = [[UIButton alloc]initWithFrame:CGRectMake(jiedao.right, jiedao.top, inputW - cellHeight, cellHeight)];
    _curAccount.userInteractionEnabled = NO;
    // 字体
    [_curAccount setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    _curAccount.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _curAccount.titleLabel.numberOfLines = 2;
    _curAccount.titleLabel.adjustsFontSizeToFitWidth = YES;
    _curAccount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_curAccount setTitle:[NSString stringWithFormat:@"%@",_selectAddModel.servicecenter] forState:UIControlStateNormal];
    _curAccountID = [NSString stringWithFormat:@"%@",_selectAddModel.serviceid];
    // 显示框背景色
    [_curAccount setBackgroundColor:[UIColor whiteColor]];
    [_curAccount addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_curAccount];
    // 1.3下拉菜单弹出按钮
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openBtn setFrame:CGRectMake(_curAccount.right, _curAccount.top , _curAccount.height, _curAccount.height)];
    [openBtn setImage:[UIImage imageNamed:@"downcell.png"] forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openAccountList) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:openBtn];
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(jiedao.left, jiedao.bottom, cellWidth, 1)];
    line1.backgroundColor = LineColor;
    [bgView addSubview:line1];
    
    UILabel* menpai = [[UILabel alloc]initWithFrame:CGRectMake(shouhuoLabel.left, line1.bottom, shouhuoLabel.width, cellHeight)];
    menpai.text = @"门牌号";
    menpai.font = leftFont;
    [bgView addSubview:menpai];
    // 1.1帐号选择框
    _curAccount1 = [[UIButton alloc]initWithFrame:CGRectMake(menpai.right, menpai.top, inputW - cellHeight, cellHeight)];
    // 字体
    [_curAccount1 setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    _curAccount1.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _curAccount1.titleLabel.numberOfLines = 2;
    _curAccount1.titleLabel.adjustsFontSizeToFitWidth = YES;
    _curAccount1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 显示框背景色
    [_curAccount1 setBackgroundColor:[UIColor whiteColor]];
    [_curAccount1 addTarget:self action:@selector(openAccountList1) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_curAccount1];
    
    // 1.3下拉菜单弹出按钮
    UIButton *openBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [openBtn1 setFrame:CGRectMake(_curAccount1.right, _curAccount1.top , _curAccount1.height, _curAccount1.height)];
    [openBtn1 setImage:[UIImage imageNamed:@"downcell.png"] forState:UIControlStateNormal];
    [openBtn1 addTarget:self action:@selector(openAccountList1) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:openBtn1];
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(shouhuoLabel.left, menpai.bottom, cellWidth, 1)];
    line2.backgroundColor = LineColor;
    [bgView addSubview:line2];
    
    
    UILabel* xiaoqu = [[UILabel alloc]initWithFrame:CGRectMake(shouhuoLabel.left, line2.bottom, shouhuoLabel.width, cellHeight)];
    xiaoqu.text = @"小区";
    xiaoqu.font = leftFont;
    [bgView addSubview:xiaoqu];
    // 1.1帐号选择框
    _curAccount2 = [[UIButton alloc]initWithFrame:CGRectMake(xiaoqu.right, xiaoqu.top, inputW - cellHeight , cellHeight)];
    // 字体
    [_curAccount2 setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    _curAccount2.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _curAccount2.titleLabel.numberOfLines = 2;
    _curAccount2.titleLabel.adjustsFontSizeToFitWidth = YES;
    // 边框
    _curAccount2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 显示框背景色
    [_curAccount2 setBackgroundColor:[UIColor whiteColor]];
    [_curAccount2 addTarget:self action:@selector(openAccountList2) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_curAccount2];
    // 1.3下拉菜单弹出按钮
    UIButton *openBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [openBtn2 setFrame:CGRectMake(_curAccount2.right, _curAccount2.top , _curAccount2.height, _curAccount2.height)];
    [openBtn2 setImage:[UIImage imageNamed:@"downcell.png"] forState:UIControlStateNormal];
    [openBtn2 addTarget:self action:@selector(openAccountList2) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:openBtn2];
    UIView* line3 = [[UIView alloc]initWithFrame:CGRectMake(shouhuoLabel.left, xiaoqu.bottom, cellWidth, 1)];
    line3.backgroundColor = LineColor;
    [bgView addSubview:line3];
    
    UILabel* louhao = [[UILabel alloc]initWithFrame:CGRectMake(shouhuoLabel.left, line3.bottom, shouhuoLabel.width, cellHeight)];
    louhao.text = @"楼牌号";
    louhao.font = leftFont;
    louhao.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:louhao];
    // 1.1帐号选择框
    _curAccount3 = [[UIButton alloc]initWithFrame:CGRectMake(louhao.right, louhao.top, inputW - cellHeight, cellHeight)];
    // 字体
    [_curAccount3 setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    _curAccount3.titleLabel.font = [UIFont systemFontOfSize:12.0];
    _curAccount3.titleLabel.numberOfLines = 2;
    _curAccount3.titleLabel.adjustsFontSizeToFitWidth = YES;
    _curAccount3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 显示框背景色
    [_curAccount3 setBackgroundColor:[UIColor whiteColor]];
    [_curAccount3 addTarget:self action:@selector(openAccountList3) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_curAccount3];
    // 1.3下拉菜单弹出按钮
    UIButton *openBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [openBtn3 setFrame:CGRectMake(_curAccount3.right, _curAccount3.top , _curAccount3.height, _curAccount3.height)];
    [openBtn3 setImage:[UIImage imageNamed:@"downcell.png"] forState:UIControlStateNormal];
    [openBtn3 addTarget:self action:@selector(openAccountList3) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:openBtn3];
    UIView* line4 = [[UIView alloc]initWithFrame:CGRectMake(shouhuoLabel.left, louhao.bottom, cellWidth, 1)];
    line4.backgroundColor = LineColor;
    [bgView addSubview:line4];
    
    
    UILabel* detailAdd = [[UILabel alloc]initWithFrame:CGRectMake(shouhuoLabel.left, line4.bottom, shouhuoLabel.width, cellHeight)];
    detailAdd.text = @"详细地址";
    detailAdd.font = leftFont;
    [bgView addSubview:detailAdd];
    _detailTextField = [[UITextField alloc]initWithFrame:CGRectMake(detailAdd.right, detailAdd.top, cellWidth - detailAdd.right, cellHeight)];
    _detailTextField.font = rightFont;
    _detailTextField.delegate = self;
    _detailTextField.placeholder = @"请输入详细地址";
    _detailTextField.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:_detailTextField];
    UIView* line5 = [[UIView alloc]initWithFrame:CGRectMake(shouhuoLabel.left, detailAdd.bottom, cellWidth, 1)];
    line5.backgroundColor = LineColor;
    [bgView addSubview:line5];
    
    UILabel* namelabel = [[UILabel alloc]initWithFrame:CGRectMake(detailAdd.left, line5.bottom, shouhuoLabel.width, cellHeight)];
    namelabel.text = @"收货人";
    namelabel.font = leftFont;
    [bgView addSubview:namelabel];
    _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(namelabel.right, namelabel.top, cellWidth - namelabel.right , cellHeight)];
    _nameTextField.font = rightFont;
    _nameTextField.delegate = self;
    _nameTextField.placeholder = @"请输入姓名";
    _nameTextField.adjustsFontSizeToFitWidth = YES;
    [bgView addSubview:_nameTextField];
    UIView* line6 = [[UIView alloc]initWithFrame:CGRectMake(shouhuoLabel.left, namelabel.bottom, cellWidth, 1)];
    line6.backgroundColor = LineColor;
    [bgView addSubview:line6];
    
    UIView* firthcellView = [[UIView alloc]initWithFrame:CGRectMake(0, line6.bottom, mScreenWidth, cellHeight)];
    firthcellView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:firthcellView];
    UILabel* setLabel = [[UILabel alloc]initWithFrame:CGRectMake(shouhuoLabel.left, 0, firthcellView.width - shouhuoLabel.left*2, firthcellView.height)];
    setLabel.text = @"设为默认地址";
    setLabel.font = leftFont;
    [firthcellView addSubview:setLabel];
    _setSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(setLabel.right - 50, (cellHeight - 30)/2, 50, 30)];
    _setSwitch.backgroundColor = [UIColor clearColor];
    _setSwitch.onTintColor = NavBarItemColor;
    [firthcellView addSubview:_setSwitch];
    [_setSwitch setOn:YES];
    [_setSwitch addTarget:self action:@selector(swChange:) forControlEvents:UIControlEventValueChanged];
    UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(40, firthcellView.bottom+40, bgView.width - 40*2, 55);
    [sureBtn setImage:[UIImage imageNamed:@"shouhuosurebtn.png"] forState:UIControlStateNormal];
    [bgView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    _accountList = [[PopListTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList.delegate = self;
    // 数据
    _accountList.accountSource = _serviceArray;
    // 初始化frame
    [self updateListH:_accountList];
    // 隐藏下拉菜单
    _accountList.view.frame = CGRectZero;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList];
    [bgView addSubview:_accountList.view];
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    _accountList1 = [[PopListTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList1.delegate = self;
    // 数据
    _accountList1.accountSource = _villageArray;
    // 初始化frame
    [self updateListH:_accountList1];
    // 隐藏下拉菜单
    _accountList1.view.frame = CGRectZero;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList1];
    [bgView addSubview:_accountList1.view];
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    _accountList2 = [[PopListTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList2.delegate = self;
    // 数据
    _accountList2.accountSource = _communityArray;
    // 初始化frame
    [self updateListH:_accountList2];
    // 隐藏下拉菜单
    _accountList2.view.frame = CGRectZero;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList2];
    [bgView addSubview:_accountList2.view];
    // 2.设置账号弹出菜单(最后添加显示在顶层)
    _accountList3 = [[PopListTableViewController alloc] init];
    // 设置弹出菜单的代理为当前这个类
    _accountList3.delegate = self;
    // 数据
    _accountList3.accountSource = _roomnumberArray;
    // 初始化frame
    [self updateListH:_accountList3];
    // 隐藏下拉菜单
    _accountList3.view.frame = CGRectZero;
    // 将下拉列表作为子页面添加到当前视图，同时添加子控制器
    [self addChildViewController:_accountList3];
    [bgView addSubview:_accountList3.view];
    
    
}

- (void)thirdBorder:(UIButton*)sender borderWidth:(CGFloat)borderWidth color:(UIColor*)color left:(BOOL)left
{
    float height=sender.frame.size.height;
    float width=sender.frame.size.width;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, height -borderWidth, width, borderWidth);
    bottomBorder.backgroundColor = color.CGColor;
    [sender.layer addSublayer:bottomBorder];
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, width, borderWidth);
    topBorder.backgroundColor = color.CGColor;
    [sender.layer addSublayer:topBorder];
    if (left) {
        CALayer* leftBorder = [CALayer layer];
        leftBorder.frame = CGRectMake(0.0f, 0.0f, borderWidth, height);
        leftBorder.backgroundColor = color.CGColor;
        [sender.layer addSublayer:leftBorder];
    }else{
        CALayer* rightBorder = [CALayer layer];
        rightBorder.frame = CGRectMake(width - borderWidth, 0.0f, borderWidth, height);
        rightBorder.backgroundColor = color.CGColor;
        [sender.layer addSublayer:rightBorder];
    }
}


/**
 * 监听代理更新下拉菜单
 */
- (void)updateListH:(UITableViewController*)tableView {
    if (tableView == _accountList) {
        CGFloat listH;
        // 数据大于3个现实3个半的高度，否则显示完整高度
        if (_serviceArray.count > 3) {
            listH = inputH * 3.5;
        }else{
            listH = inputH * _serviceArray.count;
        }
        _listFrame = CGRectMake(_curAccount.frame.origin.x, _curAccount.frame.origin.y + _curAccount.frame.size.height, _curAccount.frame.size.width, listH);
        NSLog(@"_accountList-------------------%f,%f,%f",_listFrame.size.width,_listFrame.origin.x,_listFrame.size.height);
        [_accountList.view setFrame:_listFrame];
        _accountList.accountSource = _serviceArray;
        //        _accountList.view.frame = _listFrame;
        [_accountList reloadtbViewData];
    }else if(tableView == _accountList1){
        CGFloat listH;
        // 数据大于3个现实3个半的高度，否则显示完整高度
        if (_villageArray.count > 3) {
            listH = inputH * 3.5;
        }else{
            listH = inputH * _villageArray.count;
        }
        _listFrame1 = CGRectMake(_curAccount1.frame.origin.x, _curAccount1.frame.origin.y + _curAccount1.frame.size.height, _curAccount1.frame.size.width, listH);
        NSLog(@"_accountList1--------------%f,%f,%f",_listFrame1.size.width,_listFrame1.origin.x,_listFrame1.size.height);
        //        _accountList1.view.frame = _listFrame1;
        [_accountList1.view setFrame:_listFrame1];
        _accountList1.accountSource = _villageArray;
        [_accountList1 reloadtbViewData];
    }else if (tableView == _accountList2){
        CGFloat listH;
        // 数据大于3个现实3个半的高度，否则显示完整高度
        if (_communityArray.count > 3) {
            listH = inputH * 3.5;
        }else{
            listH = inputH * _communityArray.count;
        }
        _listFrame2 = CGRectMake(_curAccount2.frame.origin.x, _curAccount2.frame.origin.y + _curAccount2.frame.size.height, _curAccount2.frame.size.width, listH);
        NSLog(@"_accountList2--------------%f,%f,%f",_listFrame2.size.width,_listFrame2.origin.x,_listFrame2.size.height);
        //        _accountList2.view.frame = _listFrame2;
        [_accountList2.view setFrame:_listFrame2];
        _accountList2.accountSource = _communityArray;
        [_accountList2 reloadtbViewData];
    }else if (tableView == _accountList3){
        CGFloat listH;
        // 数据大于3个现实3个半的高度，否则显示完整高度
        if (_roomnumberArray.count > 3) {
            listH = inputH * 3.5;
        }else{
            listH = inputH * _roomnumberArray.count;
        }
        _listFrame3 = CGRectMake(_curAccount3.frame.origin.x, _curAccount3.frame.origin.y + _curAccount3.frame.size.height, _curAccount3.frame.size.width, listH);
        NSLog(@"_accountList2--------------%f,%f,%f",_listFrame3.size.width,_listFrame3.origin.x,_listFrame3.size.height);
        [_accountList3.view setFrame:_listFrame3];
        _accountList3.accountSource = _roomnumberArray;
        [_accountList3 reloadtbViewData];
    }
}
/**
 * 弹出关闭账号选择列表
 */
- (void)openAccountList {
    _accountList.isOpen = !_accountList.isOpen;
    if (_accountList.isOpen) {
        _accountList1.isOpen = NO;
        _accountList2.isOpen = NO;
        _accountList3.isOpen = NO;
        [_curAccount setTitle:@"" forState:UIControlStateNormal];
        _curAccountID = @"";
        [_curAccount1 setTitle:@"" forState:UIControlStateNormal];
        _curAccount1ID = @"";
        [_curAccount2 setTitle:@"" forState:UIControlStateNormal];
        _curAccount2ID = @"";
        [_curAccount3 setTitle:@"" forState:UIControlStateNormal];
        _curAccount3ID = @"";
        NSLog(@"-_listFrame,-----------%f,%f,%@",_listFrame.origin.y,_listFrame.size.height,_selectAddModel.areaid);
        [_accountList.view setFrame:_listFrame];
        if (!IsEmptyValue(_selectAddModel.villageid)) {
            [self ServiceCenterRequest:[NSString stringWithFormat:@"%@",_selectAddModel.villageid]];
        }
    }
    else {
        [_accountList.view setFrame:CGRectZero];
    }
    NSLog(@"-----_accountList----%f%f",_accountList.view.frame.origin.y,_accountList.view.frame.size.height);
}

/**
 * 弹出关闭账号选择列表
 */
- (void)openAccountList1 {
    _accountList1.isOpen = !_accountList1.isOpen;
    if (_accountList1.isOpen) {
        _accountList.isOpen = NO;
        _accountList2.isOpen = NO;
        _accountList3.isOpen = NO;
        [_curAccount1 setTitle:@"" forState:UIControlStateNormal];
        _curAccount1ID = @"";
        [_curAccount2 setTitle:@"" forState:UIControlStateNormal];
        _curAccount2ID = @"";
        [_curAccount3 setTitle:@"" forState:UIControlStateNormal];
        _curAccount3ID = @"";
        NSLog(@"-_listFrame1,-----------%f%f%@",_listFrame1.origin.y,_listFrame1.size.height,_curAccountID);
        [_accountList1.view setFrame:_listFrame1];
        if (!IsEmptyValue(_selectAddModel.villageid)) {
            //
            if (!IsEmptyValue(_curAccountID)) {
                [self VillageRequest:[NSString stringWithFormat:@"%@",_curAccountID] villageid:[NSString stringWithFormat:@"%@",_selectAddModel.villageid]];
            }
        }
    }
    else {
        [_accountList1.view setFrame:CGRectZero];
    }
    NSLog(@"-----_accountList1----%f%f",_accountList1.view.frame.origin.y,_accountList1.view.frame.size.height);
}
/**
 * 弹出关闭账号选择列表
 */
- (void)openAccountList2 {
    _accountList2.isOpen = !_accountList2.isOpen;
    if (_accountList2.isOpen) {
        _accountList.isOpen = NO;
        _accountList1.isOpen = NO;
        _accountList3.isOpen = NO;
        [_curAccount2 setTitle:@"" forState:UIControlStateNormal];
        _curAccount2ID = @"";
        [_curAccount3 setTitle:@"" forState:UIControlStateNormal];
        _curAccount3ID = @"";
        NSLog(@"-_listFrame2,-----------%f%f%@",_listFrame2.origin.y,_listFrame2.size.height,_curAccount1ID);
        [_accountList2.view setFrame:_listFrame2];
        if (!IsEmptyValue(_curAccount1ID)) {
            [self LoadcommunityRequestData:[NSString stringWithFormat:@"%@",_curAccount1ID]];
        }
    }
    else {
        [_accountList2.view setFrame:CGRectZero];
    }
    NSLog(@"-----_accountList2----%f%f",_accountList2.view.frame.origin.y,_accountList2.view.frame.size.height);
}

/**
 * 弹出关闭账号选择列表
 */
- (void)openAccountList3 {
    _accountList3.isOpen = !_accountList3.isOpen;
    if (_accountList3.isOpen) {
        _accountList.isOpen = NO;
        _accountList1.isOpen = NO;
        _accountList2.isOpen = NO;
        [_curAccount3 setTitle:@"" forState:UIControlStateNormal];
        _curAccount3ID = @"";
        [_accountList3.view setFrame:_listFrame3];
        if (!IsEmptyValue(_curAccount2ID)) {
            [self LoadroomnumberRequestData:[NSString stringWithFormat:@"%@",_curAccount2ID]];
        }
    }
    else {
        [_accountList3.view setFrame:CGRectZero];
    }
    NSLog(@"-----_accountList2----%f%f",_accountList3.view.frame.origin.y,_accountList3.view.frame.size.height);
}


/**
 * 监听代理选定cell获取选中账号
 */
- (void)selectedCell:(NSInteger)index tableView:(UITableViewController *)tableView{
    if (tableView == _accountList) {
        // 更新当前选中账号
        Account *acc = _serviceArray[index];
        [_curAccount setTitle:acc.account forState:UIControlStateNormal];
        _curAccountID = [NSString stringWithFormat:@"%@",acc.password];
        // 关闭菜单
        [self openAccountList];
    }else if (tableView == _accountList1){
        // 更新当前选中账号
        Account *acc = _villageArray[index];
        [_curAccount1 setTitle:acc.account forState:UIControlStateNormal];
        _curAccount1ID = [NSString stringWithFormat:@"%@",acc.password];
        // 关闭菜单
        [self openAccountList1];
    }else if (tableView == _accountList2){
        // 更新当前选中账号
        Account *acc = _communityArray[index];
        [_curAccount2 setTitle:acc.account forState:UIControlStateNormal];
        _curAccount2ID = [NSString stringWithFormat:@"%@",acc.password];
        // 关闭菜单
        [self openAccountList2];
    }else if (tableView == _accountList3){
        // 更新当前选中账号
        Account *acc = _roomnumberArray[index];
        [_curAccount3 setTitle:acc.account forState:UIControlStateNormal];
        _curAccount3ID = [NSString stringWithFormat:@"%@",acc.password];
        // 关闭菜单
        [self openAccountList3];
    }
}

- (void)swChange:(UISwitch*)sender
{
    
    if (sender.isOn) {
        
        NSLog(@"on");
    }
    else
    {
        NSLog(@"off");
    }
}

- (void)sureBtnClick:(UIButton*)sender
{
    //    NSString *showMsg = [NSString stringWithFormat:@"省%@市%@区%@街道%@门牌%@小区%@楼号%@详细%@收货人%@默认地址%hhd",_selectAddModel.province,_selectAddModel.city,_selectAddModel.area,_curAccountID,_curAccount1ID,_curAccount2ID,_curAccount3ID,_detailTextField.text,_nameTextField.text,_setSwitch.on];
    //    NSLog(@"地址选择器返回值%@",showMsg);
    if (!IsEmptyValue(_selectAddModel.provinceid)&&!IsEmptyValue(_selectAddModel.cityid)&&!IsEmptyValue(_selectAddModel.areaid)&&!IsEmptyValue(_curAccountID)&&!IsEmptyValue(_curAccount1ID)&&!IsEmptyValue(_curAccount2ID)&&!IsEmptyValue(_curAccount3ID)&&!IsEmptyValue(_detailTextField.text)) {
        if (!IsEmptyValue(_selectAddModel.linkerid)) {
            if (!IsEmptyValue(_nameTextField.text)) {
                [self AddCustAddrRequest:sender];
            }else{
                [self showAlert:@"收货人未填写"];
            }
        }else{
            [self showAlert:@"分销人信息为空"];
        }
    }else{
        [self showAlert:@"地址不全,请重新选择"];
    }
    
}




//区域数据请求
- (void)ServiceCenterRequest:(NSString*)villageId
{
    /*
     /areamanage/loadservicecenter.do
     areaid
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [_serviceArray removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadfitvillage.do?mobile=true&villageid=%@",ROOT_Path,villageId];
    NSLog(@"区域数据请求url%@",urlStr);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"ServiceCenter%@",array);
            [_serviceArray removeAllObjects];
            for (int i =0; i <array.count; i++) {
                ServiceCenterModel * model = [[ServiceCenterModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                Account* acc = [[Account alloc]init];
                acc.account = [NSString stringWithFormat:@"%@",model.name];
                acc.password = [NSString stringWithFormat:@"%@",model.Id];
                [_serviceArray addObject:acc];
            }
            if (_serviceArray.count!=0) {
                _accountList.isOpen = YES;
                [self updateListH:_accountList];
            }
        }
        [hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [hud hide:YES];
    }];
}



//业务中心数据请求
- (void)VillageRequest:(NSString*)centerID villageid:(NSString*)villageid
{
    /*
     areamanage/loadhousenumber.do
     villageid
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [_villageArray removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadhousenumber.do?villageid=%@&servicecenterid=%@",ROOT_Path,villageid,centerID];
    NSLog(@"业务中心数据请求url%@",urlStr);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"VillageArray%@",array);
        for (int i =0; i <array.count; i++) {
            VillageModel* model = [[VillageModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            Account* acc = [[Account alloc]init];
            acc.account = [NSString stringWithFormat:@"%@",model.name];
            acc.password = [NSString stringWithFormat:@"%@",model.Id];
            [_villageArray addObject:acc];
        }
        if (_villageArray.count!=0) {
            _accountList1.isOpen = YES;
            [self updateListH:_accountList1];
        }
        [hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [hud hide:YES];
    }];
    
}
//小区
- (void)LoadcommunityRequestData:(NSString*)housenumid{
    /*
     areamanage/loadcommunity.do
     housenumberid
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [_communityArray removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadcommunity.do?housenumberid=%@",ROOT_Path,housenumid];
    NSLog(@"小区数据请求url%@",urlStr);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"community%@",array);
        for (int i =0; i <array.count; i++) {
            CommunityModel* model = [[CommunityModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            Account* acc = [[Account alloc]init];
            acc.account = [NSString stringWithFormat:@"%@",model.name];
            acc.password = [NSString stringWithFormat:@"%@",model.Id];
            [_communityArray addObject:acc];
        }
        if (_communityArray.count!=0) {
            _accountList2.isOpen = YES;
            [self updateListH:_accountList2];
        }
        [hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [hud hide:YES];
    }];
    
    
}

//楼号
- (void)LoadroomnumberRequestData:(NSString*)communityid{
    /*
     /areamanage/loadroomnumber.do
     comunityid
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [_roomnumberArray removeAllObjects];
    NSString* urlStr = [NSString stringWithFormat:@"%@/areamanage/loadroomnumber.do?comunityid=%@",ROOT_Path,communityid];
    NSLog(@"楼号数据请求url%@",urlStr);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"community%@",array);
        for (int i =0; i <array.count; i++) {
            RoomnumberModel* model = [[RoomnumberModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            Account* acc = [[Account alloc]init];
            acc.account = [NSString stringWithFormat:@"%@",model.name];
            acc.password = [NSString stringWithFormat:@"%@",model.Id];
            [_roomnumberArray addObject:acc];
        }
        if (_roomnumberArray.count!=0) {
            _accountList3.isOpen = YES;
            [self updateListH:_accountList3];
        }
        [hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [hud hide:YES];
    }];
    
}


- (void)AddCustAddrRequest:(UIButton*)sender{
    /*
     /login/appAddCustAddr.do
     mobile:true
     data{
     custid,
     provinceid,
     cityid,
     areaid,
     serviceid,
     villageid,
     xiaoqu,
     louhao,
     address,
     isdefault,
     invitecode
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //    NSString *showMsg = [NSString stringWithFormat:@"省%@市%@区%@街道%@门牌%@小区%@楼号%@详细%@收货人%@默认地址%hhd",_selectAddModel.province,_selectAddModel.city,_selectAddModel.area,_curAccountID,_curAccount1ID,_curAccount2ID,_curAccount3ID,_detailTextField.text,_nameTextField.text,_setSwitch.on];
    //    NSLog(@"地址选择器返回值%@",showMsg);
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    _selectAddModel.provinceid = [self convertNull:_selectAddModel.provinceid];
    _selectAddModel.cityid = [self convertNull:_selectAddModel.cityid];
    _selectAddModel.areaid = [self convertNull:_selectAddModel.areaid];
    _curAccountID = [self convertNull:_curAccountID];
    _curAccount1ID = [self convertNull:_curAccount1ID];
    _curAccount2ID = [self convertNull:_curAccount2ID];
    _curAccount3ID = [self convertNull:_curAccount3ID];
    _selectAddModel.linkerid = [self convertNull:_selectAddModel.linkerid];
    _detailTextField.text = [self convertNull:_detailTextField.text];
    _nameTextField.text = [self convertNull:_nameTextField.text];
    NSString* isdefault = @"0";
    if (_setSwitch.on) {
        isdefault = @"1";
    }else{
        isdefault = @"0";
    }
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appAddCustAddr.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"serviceid\":\"%@\",\"villageid\":\"%@\",\"xiaoqu\":\"%@\",\"louhao\":\"%@\",\"address\":\"%@\",\"isdefault\":\"%@\",\"invitecode\":\"%@\",\"addressname\":\"%@\",\"doornumber\":\"%@\"}",userid,_selectAddModel.provinceid,_selectAddModel.cityid,_selectAddModel.areaid,_curAccountID,_selectAddModel.villageid,_curAccount2ID,_curAccount3ID,_detailTextField.text,isdefault,_selectAddModel.linkerid,_nameTextField.text,_curAccount1ID];
    
    [parmas setObject:datastr forKey:@"data"];
    
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"添加收货地址接口%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/login/appAddCustAddr.do重新登录");
            [self showAlert:@"登录过期请重新登录"];
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound){
            [self showAlert:@"收货地址添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert:@"收货地址添加失败"];
        }
        [hud hide:YES];
    } fail:^(NSError *error) {
        [hud hide:YES];
        NSLog(@"收货地址添加失败原因%@",error.localizedDescription);
    }];
}





@end
