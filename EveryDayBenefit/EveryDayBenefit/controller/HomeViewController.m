
//  HomeViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "UINavigationBar+PS.h"
//#import "AdView.h"
#import "EScrollerView.h"
#import "ClassViewController.h"
#import "HomeProvViewController.h"
#import "CityViewController.h"//城市
#import "HomeHotCollectionView.h"
#import "HomeYouLikeCollectionView.h"
#import "HomeSearchViewController.h"
#import "HomeHotGoodsViewController.h"
#import "PeopleOnLineViewController.h"
#import "ProDetailOnlineViewController.h"//tbView
#import "ProDetailTbViewController.h"
#import "MBProgressHUD.h"
#import "LoginNewViewController.h"
#import "CommonTableViewCell.h"

#import "getAllProductTypeModel.h"
#import "HomeProTypeViewController.h"
#import "getHotProductModel.h"
#import "getSpecialProductModel.h"
#import "YoulikeModel.h"
#import "HomeSpecialProductsViewController.h"
#import "AddrNameToIdModel.h"

#import "ZBarReaderViewController.h"//二维码
#import "ORCodeViewController.h"
#import "HomePointViewController.h"
#import "HomeIconsCollectionView.h"
#import "HomeBenefitCollectionView.h"
#import "PayTypeTbVC.h"
#import "LeadScrollView.h"
#import "LeadModel.h"
#import "HTNetWorking.h"

#import "LianhangViewController.h"
#import "AddEcodeXVAddressViewController.h"
#define ThreeCellHight 150
#define TwoCellHight 220
#define SecondwhiteColorColor [UIColor whiteColor]//[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]
#define headerColor [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
@interface HomeViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EScrollerViewDelegate,UITableViewDelegate,UITableViewDataSource,ZBarReaderDelegate>
{
    NSString *_versionUrl;
    UIView* _navBarView;//二维码
    UIButton* _leftBtn;//二维码
    UIView* _statusBarView;
    MBProgressHUD* _hud;
    CGSize _imgsize;
    NSMutableDictionary* _addressDict;
    NSMutableArray* _getAllProductTypeArray;
    NSMutableArray* _getHotProductArray;
    NSMutableArray* _getSpecialProductArray;
    NSMutableArray* _getBenefitArray;
    NSMutableArray* _getYouLikeArray;
    
    UIView* _tirthHotView;
    UIView* _fourLikeView;
    UIImageView* _hotImgView;
    UIImageView* _likeImgView;
    
    int oldnum;
    BOOL oldupOrdown;
    NSTimer * oldtimer;
    
}
@property (nonatomic, strong) UIImageView * line;//二维码
@property (nonatomic,strong)UITextField* searchTextField;
@property (nonatomic,strong)UITableView* tbView;
@property (nonatomic,strong)EScrollerView* adView;
//@property (nonatomic,strong)UIView* iconsview;//标签选项
@property (nonatomic,strong)HomeIconsCollectionView* iconsCollView;
@property (nonatomic,strong)HomeHotCollectionView* collView;
@property (nonatomic,strong)HomeYouLikeCollectionView* youLikeCollView;
//@property (nonatomic,strong)HomeBenefitCollectionView* benefitCollView;
@property (nonatomic,strong)HomeBenefitCollectionView* benefitNewCollView;
@property (nonatomic,retain)AddrNameToIdModel * addrIdModel;
@property (nonatomic,strong)UIView* firstADView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _addressDict = [[NSMutableDictionary alloc]init];
    _getAllProductTypeArray = [[NSMutableArray alloc]init];
    _getHotProductArray = [[NSMutableArray alloc]init];
    _getSpecialProductArray = [[NSMutableArray alloc]init];
    _getBenefitArray = [[NSMutableArray alloc]init];
    _getYouLikeArray = [[NSMutableArray alloc]init];
    if ([LeadScrollView launchFirst]) {
            /*
             /guidepagesite/searchGuidepagePhone.do
             */
        NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/guidepagesite/searchGuidepagePhone.do"];
        [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
                NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
                NSLog(@"guidepagesite/searchGuidepagePhone.do%@",str);
                NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
                if (array.count!=0) {
                     [self creatLeadUI];
                }else{
                    [self creatNavBarView];
                    [self creatUI];
                    [self versionRequest];
                }
        } fail:^(NSError *error) {
                [self creatNavBarView];
                [self creatUI];
                [self versionRequest];
        }];
    }else{
        [self creatNavBarView];
        [self creatUI];
        [self versionRequest];
    }
}
- (void)creatLeadUI
{
    LeadScrollView *leadVC = [[LeadScrollView alloc] initWithFrame:APPDelegate.window.bounds];
    leadVC.scrollsToTop = NO;
    leadVC.backgroundColor = [UIColor clearColor];
    __weak typeof (LeadScrollView*)weakleadVC = leadVC;
    [leadVC setTransValue:^(NSArray * array) {
        //设置尺寸
        weakleadVC.contentSize = CGSizeMake(weakleadVC.width * array.count , weakleadVC.height);
    }];
    [APPDelegate.window addSubview:leadVC];
    [leadVC createPageContrl];
    
    leadVC.beginBlock = ^()
    {
        [self creatNavBarView];
        [self creatUI];
        [self versionRequest];
    };
}

- (void)dataRequest
{
    //icons上面的请求
    [self getAllProductTypeRequest];
    //热卖请求
    [self HotProductDataRequest];
    //专题轮播
    [self SpecialProductDataRequest];
    //每天特惠
    [self BenefitRequestData];
    //获取通知中心单例对象
    NSNotificationCenter * WXcenter = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [WXcenter addObserver:self selector:@selector(loginnotice:) name:IsLogin object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIImage *image = [UIImage imageNamed:@"touming_ai"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //或者背景图可以为空会是全透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 去掉阴影
    [self.navigationController.navigationBar setShadowImage:[UIImage alloc]];

    [self dataRequest];
    
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [_leftBtn setTitle:@"泰安市" forState:UIControlStateNormal];
        
    }else{
        NSString* cityname = [[NSUserDefaults standardUserDefaults]objectForKey:CITYNAME];
        cityname = [self convertNull:cityname];
        NSString* str2 = [self changeTxt:cityname changeTxt:@"市"];
        [_leftBtn setTitle:[NSString stringWithFormat:@"%@市",str2] forState:UIControlStateNormal];
    }
    if ([self isLocationServiceOpen]) {
        [self locate];
    }else{
        UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"使用自动定位？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        aleartView.tag = 10003;
        [aleartView show];
    }
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:CITYNAME object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    _geoCode.delegate = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CITYNAME object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IsLogin object:nil];
}

- (void)loginnotice:(NSNotificationCenter*)sender
{
    if (![Command isEmptyValueProAndCityAndArea]) {
        [self YouLikeDataRequest];
    }
}

- (void)notice:(NSNotificationCenter*)sender
{
    NSString* str = [[NSUserDefaults standardUserDefaults]objectForKey:CITYNAME];
    if (!IsEmptyValue(str)) {
        NSString* str2 = [self changeTxt:str changeTxt:@"市"];
        [_leftBtn setTitle:[NSString stringWithFormat:@"%@市",str2] forState:UIControlStateNormal];
    }else{
        [_leftBtn setTitle:@"泰安市" forState:UIControlStateNormal];
    }
}

//改变某字符串的颜色
- (NSString*)changeText:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
       NSString* text1 = [text substringWithRange:NSMakeRange(0, length - location)];
        return text1;
    }
    return text;
}

#pragma mark ---- 原生界面
- (UIView*)creatNavBarView
{
    [self.navigationController.navigationBar ps_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    _navBarView.hidden = NO;
    if (_navBarView==nil) {
        _statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 20)];
        _statusBarView.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].delegate.window addSubview:_statusBarView];
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth - 20, 40)];
        _navBarView.userInteractionEnabled = YES;
        _navBarView.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = _navBarView;
        self.navigationItem.titleView.frame = CGRectMake(0, 20, mScreenWidth - 20, 40) ;
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _leftBtn.frame = CGRectMake(0, 5, 50, 30);
        [_leftBtn setBackgroundColor:[UIColor clearColor]];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _leftBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _leftBtn.titleLabel.numberOfLines = 1;
        [_leftBtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:_leftBtn];
//        UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:_leftBtn];
//        self.navigationItem.leftBarButtonItem = left;
        NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
        provinceid = [self convertNull:provinceid];
        NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
        cityid = [self convertNull:cityid];
        NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
        areaid = [self convertNull:areaid];
        if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
            [_leftBtn setTitle:@"泰安市" forState:UIControlStateNormal];
        }else{
            NSString* cityname = [[NSUserDefaults standardUserDefaults]objectForKey:CITYNAME];
            cityname = [self convertNull:cityname];
            NSString* str2 = [self changeTxt:cityname changeTxt:@"市"];
            [_leftBtn setTitle:[NSString stringWithFormat:@"%@市",str2] forState:UIControlStateNormal];
        }
        
        UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.frame = CGRectMake(_navBarView.right - 30, 10, 30, 30);
        UIImageView* rightimgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        rightimgView.image = [UIImage imageNamed:@"ecode"];
        rightimgView.backgroundColor = [UIColor clearColor];
        [rightBtn addSubview:rightimgView];
        [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_navBarView addSubview:rightBtn];
        UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = right;
        
        UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.layer.masksToBounds = YES;
        searchBtn.layer.cornerRadius = 5;
        searchBtn.layer.borderColor = [UIColor grayColor].CGColor;
        searchBtn.layer.borderWidth = .5;
        searchBtn.userInteractionEnabled = YES;
        searchBtn.frame = CGRectMake(_leftBtn.right +10, 3, _navBarView.width - _leftBtn.width - 10 - 5 , 40 - 6);
        searchBtn.backgroundColor = [UIColor whiteColor];
        searchBtn.alpha = 0.6;
        [_navBarView addSubview:searchBtn];
        UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
        searchImgView.userInteractionEnabled = YES;
        searchImgView.image = [UIImage imageNamed:@"icon-search"];
        [searchBtn addSubview:searchImgView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick:)];
        [searchImgView addGestureRecognizer:tap];
        
        UIImageView* erweimaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(searchBtn.width - 30 - 5, 5, 25, 25)];
        erweimaImgView.userInteractionEnabled = YES;
        erweimaImgView.image = [UIImage imageNamed:@"icon-erweima"];
//        [searchBtn addSubview:erweimaImgView];
        UITapGestureRecognizer* erweimatap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(erweimaClick:)];
        [erweimaImgView addGestureRecognizer:erweimatap];
        
        
        _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right+5, 0, searchBtn.width-searchImgView.width - 45, 30)];
        _searchTextField.delegate = self;
        [_searchTextField setPlaceholder:@"  输入商品查找"];
        [searchBtn addSubview:_searchTextField];
    }
    return _navBarView;
    
}

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, mScreenWidth, mScreenHeight-49)];
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.scrollsToTop = YES;
    _tbView.scrollEnabled = YES;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    _tbView.backgroundColor = BackGorundColor;
    _tbView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新
        [self dataRequest];
//        // 结束刷新
        [_tbView.mj_header endRefreshing];
    }];
    
}

- (NSInteger)array:(NSArray*)array rowNum:(NSInteger)index
{
    if (array.count == 0||array == nil || index == (NSInteger)nil ) {
        return 0;
    }else{
        if (array.count%index!=0) {
            return array.count/index+1;
        }else{
            return array.count/index;
        }
        
    }
}

#pragma mark navClick
- (void)leftBarClick:(UIButton*)sender
{
    [_locService stopUserLocationService];
    HomeProvViewController* cityVC = [[HomeProvViewController alloc]init];
    cityVC.loctionCity = _leftBtn.titleLabel.text;
    [self.navigationController pushViewController:cityVC animated:YES];
//    CityViewController* vc = [[CityViewController alloc]init];
//    vc.loctionCity = _leftBtn.titleLabel.text;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
//    PayTypeTbVC* vc = [[PayTypeTbVC alloc]init];
//    vc.orderMoney1 = @"0.01";
//    vc.orderno1 = @"111222";
//    vc.orderstr = @"测试";
//    vc.name = @"测试";
//    vc.mssage1 = @"测试";
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)rightBarClick:(UIButton*)sender
{
    if(IOS7)
    {
        ORCodeViewController * rt = [[ORCodeViewController alloc]init];
        [rt setTransVaule:^(NSString *code) {
            [self getEcodeString:code];
        }];
        [self presentViewController:rt animated:YES completion:^{
            
        }];
    }
    else
    {
        [self checkAVAuthorizationStatus];
    }
}

- (void)searchClick:(UITapGestureRecognizer*)sender
{
//    HomeSearchViewController* searchVC = [[HomeSearchViewController alloc]init];
//    [self.navigationController pushViewController:searchVC animated:YES];
    HomeHotGoodsViewController* hotVC = [[HomeHotGoodsViewController alloc]init];
    [self.navigationController pushViewController:hotVC animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        HomeHotGoodsViewController* hotVC = [[HomeHotGoodsViewController alloc]init];
        hotVC.text = textField.text;
        [self.navigationController pushViewController:hotVC animated:YES];
        textField.text = @"";
    }
}


- (void)erweimaClick:(UITapGestureRecognizer*)sender
{
    if(IOS7)
    {
        ORCodeViewController * rt = [[ORCodeViewController alloc]init];
        [rt setTransVaule:^(NSString *code) {
            [self getEcodeString:code];
        }];
        [self presentViewController:rt animated:YES completion:^{
            
        }];
    }
    else
    {
        [self checkAVAuthorizationStatus];
    }
}

-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"点击轮播图%lu",(unsigned long)index);
    getSpecialProductModel* model = _getSpecialProductArray[index];
    HomeSpecialProductsViewController* specialVC = [[HomeSpecialProductsViewController alloc]init];
    specialVC.Id = model.Id;
    specialVC.titlename = model.specialname;
    [self.navigationController pushViewController:specialVC animated:YES];
}

#pragma mark _bgViewIconsClick
//点击icons
- (void)btnClick:(UIButton*)sender
{
    if (sender.tag == 100) {
        getAllProductTypeModel* model = _getAllProductTypeArray[0];
        HomeProTypeViewController* iconeVC = [[HomeProTypeViewController alloc]init];
        iconeVC.iconid = [NSString stringWithFormat:@"%@",model.Id];
        [self.navigationController pushViewController:iconeVC animated:YES];
        
    }else if(sender.tag == 101){
        getAllProductTypeModel* model = _getAllProductTypeArray[1];
        HomeProTypeViewController* iconeVC = [[HomeProTypeViewController alloc]init];
        iconeVC.iconid = [NSString stringWithFormat:@"%@",model.Id];
        [self.navigationController pushViewController:iconeVC animated:YES];
        
    }else if (sender.tag == 102){
        getAllProductTypeModel* model = _getAllProductTypeArray[2];
        HomeProTypeViewController* iconeVC = [[HomeProTypeViewController alloc]init];
        iconeVC.iconid = [NSString stringWithFormat:@"%@",model.Id];
        [self.navigationController pushViewController:iconeVC animated:YES];
        
    }else if (sender.tag == 103){
        getAllProductTypeModel* model = _getAllProductTypeArray[3];
        HomeProTypeViewController* iconeVC = [[HomeProTypeViewController alloc]init];
        iconeVC.iconid = [NSString stringWithFormat:@"%@",model.Id];
        [self.navigationController pushViewController:iconeVC animated:YES];
        
    }else if (sender.tag == 104){
        getAllProductTypeModel* model = _getAllProductTypeArray[4];
        HomeProTypeViewController* iconeVC = [[HomeProTypeViewController alloc]init];
        iconeVC.iconid = [NSString stringWithFormat:@"%@",model.Id];
        [self.navigationController pushViewController:iconeVC animated:YES];
        
    }else if (sender.tag == 105){
        getAllProductTypeModel* model = _getAllProductTypeArray[5];
        HomeProTypeViewController* iconeVC = [[HomeProTypeViewController alloc]init];
        iconeVC.iconid = [NSString stringWithFormat:@"%@",model.Id];
        [self.navigationController pushViewController:iconeVC animated:YES];
        
    }
    else if (sender.tag == 106){
    //积分
        HomePointViewController* pointVC = [[HomePointViewController alloc]init];
        [self.navigationController pushViewController:pointVC animated:YES];
    }
    //tag:100-107
    else if (sender.tag == 107) {
        //全部分类
        ClassViewController* ClassVC = [[ClassViewController alloc]init];
        [self.navigationController pushViewController:ClassVC animated:YES];
    }

}
//热卖产品点击事件
- (void)hotGoodsTitleClick:(UITapGestureRecognizer*)sender
{
    HomeHotGoodsViewController* hotVC = [[HomeHotGoodsViewController alloc]init];
    [self.navigationController pushViewController:hotVC animated:YES];

}
//猜你喜欢点击事件
- (void)titleViewClick:(UITapGestureRecognizer*)sender
{

}
//每天特惠点击事件
- (void)benefitImgViewClick:(UITapGestureRecognizer*)sender
{
    HomeHotGoodsViewController* hotVC = [[HomeHotGoodsViewController alloc]init];
    hotVC.hometype = typeHomtBenefit;
    [self.navigationController pushViewController:hotVC animated:YES];
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tbView) {
        if (scrollView.contentOffset.y>100) {
            [self.navigationController.navigationBar ps_setBackgroundColor:[UIColor whiteColor]];
            [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
            [_leftBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
        }else{
            [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
            [self.navigationController.navigationBar ps_setBackgroundColor:[UIColor clearColor]];
            [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 5;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (indexPath.row == 0) {
            if (_imgsize.height!=0) {
                //return mScreenWidth*_imgsize.height/_imgsize.width;
                return 200*MYWIDTH;
            }else{
                return mScreenWidth*206/517;
            }
        }else if (indexPath.row == 1){
            return 170;
        }else if (indexPath.row == 3){
            if (_getHotProductArray.count == 0) {
                return 0;
            }else{
                NSInteger num = [self array:_getHotProductArray rowNum:3];
                return num*ThreeCellHight*HightRuler+30+10;
            }
        }else if (indexPath.row == 2){
            if (_getBenefitArray.count == 0) {
                return 0;
            }else{
                NSInteger num = [self array:_getBenefitArray rowNum:3];
                return num*ThreeCellHight*HightRuler+30+10;
            }
        }else if (indexPath.row == 4){
            if (_getYouLikeArray.count == 0) {
                return 0;
            }else{
                NSInteger num = [self array:_getYouLikeArray rowNum:3];
                return num*ThreeCellHight*HightRuler+30+10;//+130
            }
        }
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
//    // 通过不同标识创建cell实例
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
//    UITableViewCell *cell;
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == _tbView) {
        if (indexPath.row == 0) {
            [_firstADView removeFromSuperview];
            _firstADView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,mScreenWidth, mScreenWidth*206/517)];
            _firstADView.tag = 100;
            _firstADView.backgroundColor = BackGorundColor;
            [cell.contentView addSubview:_firstADView];
            if (!IsEmptyValue(_getSpecialProductArray)) {
                NSMutableArray* adArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < _getSpecialProductArray.count; i ++) {
                    getSpecialProductModel* model = _getSpecialProductArray[i];
                    [adArray addObject:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]];
                }
//                UIImageView* mView = [[UIImageView alloc]init];
//                __weak typeof(self) weakSelf = self;
//                [mView sd_setImageWithURL:[NSURL URLWithString:[adArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"default_img_banner"]options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    CGSize size1 = image.size;
//                    CGFloat w = size1.width;
//                    CGFloat h = size1.height;
//                    if (w!=0) {
//                        _imgsize = CGSizeMake(w, h);
//                        weakSelf.firstADView.frame = CGRectMake(0, 0,mScreenWidth, mScreenWidth*_imgsize.height/_imgsize.width);
//                        weakSelf.adView.frame = CGRectMake(0, 0, mScreenWidth, weakSelf.firstADView.height);
//                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//                        [weakSelf.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                    }
//                } ];
                _adView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, mScreenWidth, _firstADView.height) ImageArray:adArray];
                _adView.delegate = self;
                [_firstADView addSubview:_adView];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[adArray objectAtIndex:0]]];
                UIImage *image = [UIImage imageWithData:data];
                NSLog(@"w = %f,h = %f",image.size.width,image.size.height);
                if (image.size.width!=0) {
                    for (UIView* view in _firstADView.subviews) {
                        [view removeFromSuperview];
                    }
                    _imgsize = CGSizeMake(image.size.width, image.size.height);
                    //_firstADView.frame = CGRectMake(0, 0,mScreenWidth, mScreenWidth*_imgsize.height/_imgsize.width);
                    _firstADView.frame = CGRectMake(0, 0,mScreenWidth, 200*MYWIDTH);
                    _adView.frame = CGRectMake(0, 0, mScreenWidth, _firstADView.height);
                    _adView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, mScreenWidth, _firstADView.height) ImageArray:adArray];
                    _adView.delegate = self;
                    [_firstADView addSubview:_adView];
                }
            }
            NSLog(@"-------%ld%ld",(long)indexPath.row,(long)indexPath.section);
            
        }else if (indexPath.row == 1){
            [_iconsCollView removeFromSuperview];
            _iconsCollView = [[HomeIconsCollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 160)];
            _iconsCollView.contentSize = CGSizeMake(mScreenWidth, 160);
            _iconsCollView.delegate = self;
            _iconsCollView.bounces = NO;
            _iconsCollView.scrollsToTop = NO;
            _iconsCollView.scrollEnabled = NO;
            _iconsCollView.userInteractionEnabled = YES;
            if (_getAllProductTypeArray.count == 8) {
                _iconsCollView.dataArr = _getAllProductTypeArray;
                [_iconsCollView reloadData];
            }
            [cell.contentView addSubview:_iconsCollView];
            _iconsCollView.backgroundColor = [UIColor clearColor];
        }else if (indexPath.row == 3){
            if (_getHotProductArray.count == 0) {
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
            //模块热卖产品
            [_collView removeFromSuperview];
            UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
            headerView.backgroundColor = headerColor;
            [cell.contentView addSubview:headerView];
            _hotImgView = [[UIImageView alloc]init];
            _hotImgView.frame = CGRectMake(0, headerView.bottom, mScreenWidth, 30);
            _hotImgView.backgroundColor = SecondwhiteColorColor;
            _hotImgView.userInteractionEnabled = YES;
            [cell.contentView addSubview:_hotImgView];
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth - 100)/2, 0, 100, _hotImgView.height)];
            view.backgroundColor = [UIColor clearColor];
            [_hotImgView addSubview:view];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotGoodsTitleClick:)];
            [_hotImgView addGestureRecognizer:tap];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (view.height - 20)/2, 20, 20)];
            imageView.image = [UIImage imageNamed:@"remai"];
            [view addSubview:imageView];
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, view.width - 30, _hotImgView.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = NavBarItemColor;
            label.text = @"热卖商品";
            [view addSubview:label];
            UILabel* morelabel = [[UILabel alloc]initWithFrame:CGRectMake(_hotImgView.width - 60, 0, 30, _hotImgView.height)];
            morelabel.textColor = [UIColor blackColor];
            morelabel.text = @"更多";
            morelabel.font = [UIFont systemFontOfSize:13];
            [_hotImgView addSubview:morelabel];
            UIImageView* rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(morelabel.right, (morelabel.height - 14)/2, 8, 14)];
            rightImgView.image = [UIImage imageNamed:@"you"];
            [_hotImgView addSubview:rightImgView];
            
            _collView = [[HomeHotCollectionView alloc]initWithFrame:CGRectMake(0, _hotImgView.bottom, mScreenWidth, 3*ThreeCellHight*HightRuler)];
            _collView.delegate = self;
            _collView.bounces = NO;
            _collView.scrollsToTop = NO;
            _collView.scrollEnabled = NO;
            _collView.userInteractionEnabled = YES;
            _collView.backgroundColor = [UIColor clearColor];
            if (!IsEmptyValue(_getHotProductArray)) {
                _collView.dataArr = _getHotProductArray;
                [_collView reloadData];
                _collView.frame = CGRectMake(0, _hotImgView.bottom, mScreenWidth, [self array:_getHotProductArray rowNum:3]*ThreeCellHight*HightRuler);
            }
            [cell.contentView addSubview:_collView];
        }else if (indexPath.row == 2){
            if (_getBenefitArray.count == 0) {
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
            [_benefitNewCollView removeFromSuperview];
            cell.contentView.frame = CGRectMake(0, 0, 20000, ThreeCellHight*HightRuler+30);
            UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
            headerView.backgroundColor = headerColor;
            [cell.contentView addSubview:headerView];
            UIImageView* benefitImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, headerView.bottom, mScreenWidth, 30)];
            benefitImgView.backgroundColor = SecondwhiteColorColor;
            benefitImgView.userInteractionEnabled = YES;
            [cell.contentView addSubview:benefitImgView];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(benefitImgViewClick:)];
            [benefitImgView addGestureRecognizer:tap];
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth - 100)/2, 0, 100, benefitImgView.height)];
            view.backgroundColor = [UIColor clearColor];
            [benefitImgView addSubview:view];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (view.height - 20)/2, 20, 20)];
            imageView.image = [UIImage imageNamed:@"tehui"];
            [view addSubview:imageView];
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, view.width - 30, benefitImgView.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = NavBarItemColor;
            label.text = @"每天特惠";
            [view addSubview:label];
            
            UILabel* morelabel = [[UILabel alloc]initWithFrame:CGRectMake(benefitImgView.width - 60, 0, 30, benefitImgView.height)];
            morelabel.textColor = [UIColor blackColor];
            morelabel.text = @"更多";
            morelabel.font = [UIFont systemFontOfSize:13];
            [benefitImgView addSubview:morelabel];
            UIImageView* rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(morelabel.right, (morelabel.height - 14)/2, 8, 14)];
            rightImgView.image = [UIImage imageNamed:@"you"];
            [benefitImgView addSubview:rightImgView];
//            UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, benefitImgView.bottom, mScreenWidth, ThreeCellHight*HightRuler)];
//            scrollView.delegate = self;
//            scrollView.backgroundColor = [UIColor clearColor];
//            [cell.contentView addSubview:scrollView];
//            _benefitCollView = [[HomeBenefitCollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, ThreeCellHight*HightRuler)];
//            _benefitCollView.delegate = self;
//            _benefitCollView.bounces = NO;
//            _benefitCollView.scrollsToTop = NO;
//            _benefitCollView.scrollEnabled = NO;
//            _benefitCollView.userInteractionEnabled = YES;
//            _benefitCollView.backgroundColor = [UIColor clearColor];
//            if (!IsEmptyValue(_getBenefitArray)) {
//                _benefitCollView.dataArr = _getBenefitArray;
//                _benefitCollView.frame = CGRectMake(0, 0, _getBenefitArray.count*(mScreenWidth/3+2), ThreeCellHight*HightRuler);
//                scrollView.contentSize = CGSizeMake(_getBenefitArray.count*(mScreenWidth/3+2), ThreeCellHight*HightRuler);
//                [_benefitCollView reloadData];
//            }
//            [scrollView addSubview:_benefitCollView];
            _benefitNewCollView = [[HomeBenefitCollectionView alloc]initWithFrame:CGRectMake(0, benefitImgView.bottom, mScreenWidth, 3*ThreeCellHight*HightRuler)];
            _benefitNewCollView.delegate = self;
            _benefitNewCollView.bounces = NO;
            _benefitNewCollView.scrollsToTop = NO;
            _benefitNewCollView.scrollEnabled = NO;
            _benefitNewCollView.userInteractionEnabled = YES;
            _benefitNewCollView.backgroundColor = [UIColor clearColor];
            if (!IsEmptyValue(_getBenefitArray)) {
                _benefitNewCollView.dataArr = _getBenefitArray;
                [_benefitNewCollView reloadData];
                _benefitNewCollView.frame = CGRectMake(0, benefitImgView.bottom, mScreenWidth, [self array:_getBenefitArray rowNum:3]*ThreeCellHight*HightRuler);
            }
            [cell.contentView addSubview:_benefitNewCollView];
        }else if (indexPath.row == 4){
            if (_getYouLikeArray.count == 0) {
                cell.hidden = YES;
            }else{
                cell.hidden = NO;
            }
            [_youLikeCollView removeFromSuperview];
            UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
            headerView.backgroundColor = headerColor;
            [cell.contentView addSubview:headerView];
            //猜你喜欢商品
            _likeImgView = [[UIImageView alloc]init];
            _likeImgView.frame = CGRectMake(0, headerView.bottom, mScreenWidth, 30);
            _likeImgView.backgroundColor = SecondwhiteColorColor;
            [cell.contentView addSubview:_likeImgView];
            UIView* view = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth - 100)/2, 0, 100, _likeImgView.height)];
            view.backgroundColor = [UIColor clearColor];
            [_likeImgView addSubview:view];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (view.height - 20)/2, 20, 20)];
            imageView.image = [UIImage imageNamed:@"like"];
            [view addSubview:imageView];
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, view.width - 30, _likeImgView.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = NavBarItemColor;
            label.text = @"猜你喜欢";
            [view addSubview:label];
            UILabel* morelabel = [[UILabel alloc]initWithFrame:CGRectMake(_likeImgView.width - 60, 0, 30, _likeImgView.height)];
            morelabel.textColor = [UIColor blackColor];
            morelabel.text = @"更多";
            morelabel.font = [UIFont systemFontOfSize:13];
//            [_likeImgView addSubview:morelabel];
            UIImageView* rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(morelabel.right, (morelabel.height - 14)/2, 8, 14)];
            rightImgView.image = [UIImage imageNamed:@"you"];
//            [_likeImgView addSubview:rightImgView];
            
            //    _youLikeCollView = [[HomeYouLikeCollectionView alloc]initWithFrame:CGRectMake(0, _likeImgView.bottom, mScreenWidth, [self array:dataArr rowNum:2]*TwoCellHight*HightRuler)];
            _youLikeCollView = [[HomeYouLikeCollectionView alloc]initWithFrame:CGRectMake(0, _likeImgView.bottom, mScreenWidth, 3*ThreeCellHight*HightRuler)];
            _youLikeCollView.delegate = self;
            _youLikeCollView.bounces = NO;
            _youLikeCollView.scrollsToTop = NO;
            _youLikeCollView.scrollEnabled = NO;
            _youLikeCollView.userInteractionEnabled = YES;
            [cell.contentView addSubview:_youLikeCollView];
            _youLikeCollView.backgroundColor = [UIColor clearColor];
            if (!IsEmptyValue(_getYouLikeArray)) {
                _youLikeCollView.dataArr = _getYouLikeArray;
                [_youLikeCollView reloadData];
                _youLikeCollView.frame = CGRectMake(0, _likeImgView.bottom, mScreenWidth, [self array:_getYouLikeArray rowNum:3]*ThreeCellHight*HightRuler);//CGRectMake(0, _hotImgView.bottom, mScreenWidth, [self array:_getHotProductArray rowNum:3]*ThreeCellHight*HightRuler);
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了%ld",(long)indexPath.row);
}

#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[HomeHotCollectionView class]]) {
        return CGSizeMake(mScreenWidth/3, ThreeCellHight*HightRuler);
    }else if([collectionView isKindOfClass:[HomeYouLikeCollectionView class]]){
        return  CGSizeMake(mScreenWidth/3, ThreeCellHight*HightRuler);
    }else if ([collectionView isKindOfClass:[HomeBenefitCollectionView class]]){
        return CGSizeMake(mScreenWidth/3, ThreeCellHight*HightRuler);
    }else if ([collectionView isKindOfClass: [HomeIconsCollectionView class]]){
        return  CGSizeMake(mScreenWidth/4, 80);
    }else{
        return CGSizeMake(0, 0);
    }
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
    if ([collectionView isKindOfClass:[HomeHotCollectionView class]]) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else if([collectionView isKindOfClass:[HomeYouLikeCollectionView class]]){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else if ([collectionView isKindOfClass:[HomeBenefitCollectionView class]]){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isKindOfClass:[HomeHotCollectionView class]]) {
        ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
        getHotProductModel* model = _getHotProductArray[indexPath.row];
        model.Id = [self convertNull:model.Id];
        vc.proid = model.Id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([collectionView isKindOfClass:[HomeYouLikeCollectionView class]]){
        ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
        YoulikeModel* model = _getYouLikeArray[indexPath.row];
        model.Id = [self convertNull:model.Id];
        vc.proid = model.Id;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([collectionView isKindOfClass:[HomeBenefitCollectionView class]]){
        ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
        getHotProductModel* model = _getBenefitArray[indexPath.row];
        model.Id = [self convertNull:model.Id];
        vc.proid = model.Id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([collectionView isKindOfClass:[HomeIconsCollectionView class]]){
        if (indexPath.row < 6) {
            if (!IsEmptyValue(_getAllProductTypeArray)) {
                getAllProductTypeModel* model = _getAllProductTypeArray[indexPath.row];
                HomeProTypeViewController* iconeVC = [[HomeProTypeViewController alloc]init];
                iconeVC.iconid = [NSString stringWithFormat:@"%@",model.Id];
                iconeVC.titlename = [NSString stringWithFormat:@"%@",model.name];
                [self.navigationController pushViewController:iconeVC animated:YES];
            }
        }else if (indexPath.row == 6){
            //积分
            HomePointViewController* pointVC = [[HomePointViewController alloc]init];
            [self.navigationController pushViewController:pointVC animated:YES];
        }
        //tag:100-107
        else if (indexPath.row == 7) {
            //全部分类
            ClassViewController* ClassVC = [[ClassViewController alloc]init];
            [self.navigationController pushViewController:ClassVC animated:YES];
        }
    }
}

- (BOOL)isLocationServiceOpen {
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else
        return YES;
}

#pragma mark - 定位
- (void)locate
{
    _geoCode = [[BMKGeoCodeSearch alloc] init];
    _geoCode.delegate = self;
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //上传经纬度获取
    self.lblLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.lblLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    //停止定位服务
    _loc = coordinate;
    [_locService stopUserLocationService];
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:ManualPositioning] isEqualToString:@"1"]) {
        [self outputAdd];
    }
    //定位显示点
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = _loc;
    annotation.title = @"我的位置";
    [_mapView setCenterCoordinate:_loc];
    [_mapView addAnnotation:annotation];
}

//- (BMKGeoCodeSearch *)geoCode
//{
//    if (!_geoCode) {
//        _geoCode = [[BMKGeoCodeSearch alloc] init];
//        _geoCode.delegate = self;
//    }
//    return _geoCode;
//}

- (void)outputAdd
{
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将TextField中的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake([self.lblLatitude floatValue], [self.lblLongitude floatValue]);
    NSLog(@"reverseGeoPoint%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    
    // 调用反地址编码方法，让其在代理方法中输出
//    [_geoCode reverseGeoCode:option];
    BOOL flag = [self.geoCode reverseGeoCode:option];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}
#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (searcher == _geoCode) {
        if (result) {
            NSLog(@"标志性建筑 - - - -- - - %@",result);
            NSLog(@"%@ - %@", result.address, result.addressDetail.streetNumber);
            if (result.addressDetail.province.length!=0) {
                [_addressDict setObject:result.addressDetail.province forKey:@"province"];
            }
            if (result.addressDetail.city.length!=0){
                [_addressDict setObject:result.addressDetail.city forKey:@"city"];
            }
            if (result.addressDetail.district.length!=0){
                [_addressDict setObject:result.addressDetail.district forKey:@"district"];
            }
            if (result.poiList.count != 0) {
                BMKPoiInfo *poiInfo = result.poiList[0];
                NSLog(@"标志性建筑:%@  ",poiInfo.city);
                NSString* text = [self changeTxt:poiInfo.city changeTxt:@"市"];
                if (text.length!=0) {
                    [[NSUserDefaults standardUserDefaults]setObject:text forKey:CITYNAME];
                    [_leftBtn setTitle:[NSString stringWithFormat:@"%@市",text] forState:UIControlStateNormal];
                }
            }
            [self addressToIdRequest];
            
        }else{
            NSLog(@"找不到相对应的位置信息");
        }
 
    }
}


//截取字符串
- (NSString*)changeTxt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableString * muStr = [NSMutableString stringWithString:text];
        [muStr deleteCharactersInRange:NSMakeRange(location, length)];
        //赋值
        return muStr;
    }else{
        return text;
    }
}

#pragma mark 数据请求

- (void)getAllProductTypeRequest
{
    /*
     /product/getAllProductTypeCount.do 产品分类固定6条接口
     */

    NSString* urlstr = [NSString stringWithFormat:@"%@/product/getAllProductTypeCount.do",ROOT_Path];///
    NSLog(@"urlstr%@",urlstr);
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/product/getAllProductTypeCount.do---%@",str);
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
//        NSLog(@"array%@",array);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
        }else{
            [_getAllProductTypeArray removeAllObjects];
            if (array.count!=0) {
                NSMutableArray* titleArray = [[NSMutableArray alloc]init];
                NSMutableArray* imgArray = [[NSMutableArray alloc]init];
                for (int i = 0; i <array.count; i++) {
                    getAllProductTypeModel* model = [[getAllProductTypeModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_getAllProductTypeArray  addObject:model];
                    
                    [titleArray addObject:model.name];
                    [imgArray addObject:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,model.folder,model.picname]];
                }
                [_tbView reloadData];
                //如果数据为空的时候就隐藏每天特惠这一项
//                if (array.count != 0) {
//                    //一个cell刷新
//                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
//                    [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                }

            }

        }
    } fail:^(NSError *error) {
        NSLog(@"加载失败,失败原因%@",error.localizedDescription);
    }];
}



- (void)HotProductDataRequest
{
    /*
     /product/getHotProductCount.do热销产品固定9条
     data{
        provinceid cityid areaid 客户定位省市区域的id
     }
     */
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
//#warning mark provinceid&cityid&areaid
    NSString* urlstr = [NSString stringWithFormat:@"%@/product/getHotProductCount.do",ROOT_Path];
    NSLog(@"urlstr%@",urlstr);
    NSString* datastr = [NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",provinceid,cityid,areaid];
    NSDictionary* params = @{@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"HotProductDataRequest-str%@",str);
        if([str rangeOfString:@"sessionoutofdate"].location !=NSNotFound)
        {
            NSLog(@"otProductDataRequest重新登录");
        }else{
            [_getHotProductArray removeAllObjects];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"array%@",array);
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    getHotProductModel* model = [[getHotProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_getHotProductArray addObject:model];
                }
            }
            [_tbView reloadData];
            //如果数据为空的时候就隐藏每天特惠这一项
//            if (array.count != 0) {
//                //一个cell刷新
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
//                [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            }
        }
        
    } fail:^(NSError *error) {
        NSLog(@"加载失败%@",error);
    }];
    
}

- (void)SpecialProductDataRequest
{
    /*
     /product/getSpecialProduct.do//轮播图
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@/product/getSpecialProduct.do",ROOT_Path];
    NSLog(@"urlstr%@",urlstr);
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"getSpecialProductarray%@",str);
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        NSLog(@"getSpecialProductarray%@",array);
        
        if([str rangeOfString:@"sessionoutofdate"].location !=NSNotFound)
        {
            NSLog(@"getSpecialProductarray重新登录");
        }else
        {
            [_getSpecialProductArray removeAllObjects];
            if (array.count!=0) {
                NSMutableArray* adArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < array.count; i ++) {
                    getSpecialProductModel* model = [[getSpecialProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_getSpecialProductArray addObject:model];
                    [adArray addObject:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]];
                }
                NSLog(@"adArray%@",adArray);
                [_tbView reloadData];
                //如果数据为空的时候就隐藏每天特惠这一项
//                if (array.count != 0) {
//                    //一个cell刷新
//                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//                    [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                }
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"加载失败");
    }];

}
//每天特惠
- (void)BenefitRequestData
{
    /*
     /product/specialProduct.do//每天特惠
     mobile:true
     data{
        provinceid  cityid  areaid
     }
     */
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
//#warning mark provinceid&cityid&areaid
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/specialProduct.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",provinceid,cityid,areaid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/product/specialProduct.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location!=NSNotFound) {
            
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            [_getBenefitArray removeAllObjects];
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    getHotProductModel* model = [[getHotProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_getBenefitArray addObject:model];
                }
            }
            //如果数据为空的时候就隐藏每天特惠这一项
//            if (array.count != 0) {
//                //一个cell刷新
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
//                [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            }
            [_tbView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (void)YouLikeDataRequest
{
    /*
     /product/likeProduct.do//猜你喜欢
     mobile:true
     data{
     custid,
     provinceid  cityid  areaid
     }
     */
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
//#warning mark provinceid&cityid&areaid
    NSString* custid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    custid = [self convertNull:custid];
    NSString* urlstr = [NSString stringWithFormat:@"%@/product/likeProduct.do",ROOT_Path];
    NSLog(@"urlstr%@",urlstr);
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",custid,provinceid,cityid,areaid];
    NSDictionary* params = @{@"data":datastr,@"mobile":@"true"};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/product/likeProduct.do-str%@",str);
        if([str rangeOfString:@"sessionoutofdate"].location !=NSNotFound)
        {
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
            NSLog(@"/product/likeProduct.do重新登录");
        }else{
            [_getYouLikeArray removeAllObjects];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"array%@",array);
            if (array.count!=0) {
                
                for (int i = 0; i < array.count; i++) {
                    YoulikeModel* model = [[YoulikeModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_getYouLikeArray addObject:model];
                }
            }
//            //如果数据为空的时候就隐藏每天特惠这一项
//            if (array.count != 0) {
//                //一个cell刷新
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
//                [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            }
            [_tbView reloadData];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"加载失败");
    }];
    
}




- (void)addressToIdRequest
{
/*
 /login/getAreaid.do?1=1
 data{
 province:山东省
 city:济南市,
 area:历下区
 }
 */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/getAreaid.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"province\":\"%@\",\"city\":\"%@\",\"area\":\"%@\"}",_addressDict[@"province"],_addressDict[@"city"],_addressDict[@"district"]];
    NSDictionary* dict = @{@"data":datastr};
    NSLog(@"%@--%@",urlstr,dict);
    
   
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:dict success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"....%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([str rangeOfString:@"msg"].location !=NSNotFound) {
            [self showAlert:array[0][@"msg"]];
        }else{
            if (array.count!=0) {
                _addrIdModel = [[AddrNameToIdModel alloc]init];
                [_addrIdModel setValuesForKeysWithDictionary:array[0]];
                [[NSUserDefaults standardUserDefaults]setObject:_addrIdModel.provinceid forKey:PROVINCEID];
                [[NSUserDefaults standardUserDefaults]setObject:_addrIdModel.cityid forKey:CITYID];
                [[NSUserDefaults standardUserDefaults]setObject:_addrIdModel.areaid forKey:AREAID];
                [[NSUserDefaults standardUserDefaults]setObject:_addressDict[@"province"] forKey:PROVINCENAME];
                [[NSUserDefaults standardUserDefaults]setObject:_addressDict[@"city"] forKey:CITYNAME];
                [[NSUserDefaults standardUserDefaults]setObject:_addressDict[@"district"] forKey:AREANAME];
            }
        }

    } fail:^(NSError *error) {
        NSLog(@"定位匹配失败%@",error.localizedDescription);
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
        [self showAlert:result];
        [self getEcodeString:result];
    }];
}

- (void)getEcodeString:(NSString*)codestr
{
    /*
     /product/searchProno.do 参数：prono
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/searchProno.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"prono\":\"%@\"}",codestr];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/product/searchProno.do%@",str);
        id obj = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if ([obj isKindOfClass:[NSArray class]]) {
        }else if([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary* dict = obj;
            NSString* proid = dict[@"id"];
            if (!IsEmptyValue(proid)) {
                [self getProductDetailRequestData:proid];
            }else{
                NSString* status = dict[@"status"];
                if (!IsEmptyValue(status)) {
                     [self showAlert:status];
                }
            }
        }
    } fail:^(NSError *error) {
        
    }];
    
//    if ([self checkNumber:codestr]) {
//        [self getProductDetailRequestData:codestr];
//    }else if ([self checkOrdernoNumber:codestr]){
//        //确认收货接口
////        [self confirmOrderRequestData:codestr];
//    
//    }
}
#pragma proid
- (BOOL)checkNumber:(NSString *)Number
{
    NSString *pattern = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:Number];
    return isMatch;
}

- (BOOL)checkOrdernoNumber:(NSString*)number
{
    if ([number rangeOfString:@"dd"].location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

- (void)confirmOrderRequestData:(NSString*)orderno
{
    /*
     /send/custConfirmOrder.do
     mobile:true
     data{
     orderno:订单编号
     }
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/custConfirmOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/send/custConfirmOrder.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:[NSString stringWithFormat:@"%@,确认收货成功",orderno]];
            //跳评价
        }else{
            [self showAlert:[NSString stringWithFormat:@"%@,确认收货失败",orderno]];
        }
    } fail:^(NSError *error) {
        
    }];
}

//二维码扫描到的是产品有效的话就跳转界面
- (void)getProductDetailRequestData:(NSString*)proid
{
    /*
     /product/getProductDetail.do
     data{
     custid
     proid 商品主键id
     provinceid cityid areaid 客户定位省市区域的id
     }
     */
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
#pragma mark provinceid&cityid&areaid
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/getProductDetail.do"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"true" forKey:@"mobile"];
    proid = [self convertNull:proid];
    NSString* userstr = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userstr = [self convertNull:userstr];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",userstr,proid,provinceid,cityid,areaid];
    [params setObject:datastr forKey:@"data"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"商品详情请求%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"商品详情请求%@",dict);
            NSArray* listArray = dict[@"list"];
            if (listArray.count!=0) {
                //可以跳转
                ProDetailOnlineViewController* prodetailVC = [[ProDetailOnlineViewController alloc]init];
                prodetailVC.proid = proid;
                [self.navigationController pushViewController:prodetailVC animated:YES];
            }else{
                [self showAlert:@"该定位地址没有该商品"];
            }
        }
        
    } fail:^(NSError *error) {
        NSLog(@"商品详情请求失败%@",urlstr);
        
    }];
    
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
    //http://182.92.96.58
    NSString *urlStr = [NSString stringWithFormat:@"%@:8004/lxpub/app/version",Ver_Address];
    
    NSDictionary *parameters = @{@"action":@"getVersionInfo",@"project":[NSString stringWithFormat:@"%@",@"applexiaowei"]};//
    
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parameters success:^(id result) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"版本信息:%@",dic);
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
    } fail:^(NSError *error) {
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
    }else if (alertView.tag == 10003){
        if (buttonIndex == 1) {
            if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }
    }
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}





@end
