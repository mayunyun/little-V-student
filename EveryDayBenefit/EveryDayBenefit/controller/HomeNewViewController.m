
//  HomeViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeNewViewController.h"
#import "UINavigationBar+PS.h"
//#import "AdView.h"
#import "EScrollerView.h"
#import "ClassViewController.h"
#import "HomeProvViewController.h"
#import "CityViewController.h"//城市
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
#import "CommonCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface HomeNewViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,EScrollerViewDelegate,ZBarReaderDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
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
    UIImageView* _likeImgView;
    
    int oldnum;
    BOOL oldupOrdown;
    NSTimer * oldtimer;
    
}
@property (nonatomic, strong) UIImageView * line;//二维码
@property (nonatomic,strong)UITextField* searchTextField;
@property(nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)EScrollerView* adView;
@property (nonatomic,strong)HomeIconsCollectionView* iconsCollView;
@property (nonatomic,retain)AddrNameToIdModel * addrIdModel;

@end

@implementation HomeNewViewController

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
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize =CGSizeMake(mScreenWidth, mScreenHeight-64-49);
    layout.minimumInteritemSpacing = 0; //列间距
    layout.minimumLineSpacing = 0;//行间距
    _collection =[[UICollectionView alloc]initWithFrame:CGRectMake(0, -64, mScreenWidth, mScreenHeight-49) collectionViewLayout:layout];
    _collection.delegate =self;
    _collection.dataSource =self;
    _collection.scrollsToTop = YES;
    _collection.scrollEnabled = YES;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = BackGorundColor;
    [self.view addSubview:_collection];
    
    [_collection registerNib:[UINib nibWithNibName:@"CommonTableViewCell" bundle:nil] forCellWithReuseIdentifier:@"CommonTableViewCellID"];
    
    // 注册头视图
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing0"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing1"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader2"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader3"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader4"];
    [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerheader5"];
    //     下拉刷新
    _collection.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self dataRequest];
        // 结束刷新
        [_collection.mj_header endRefreshing];

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
    if (scrollView == _collection) {
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (collectionView == _collection) {
        return CGSizeMake(mScreenWidth/3, (mScreenWidth/3-8)*4/3);
    }else if ([collectionView isKindOfClass: [HomeIconsCollectionView class]]){
        return  CGSizeMake(mScreenWidth/4, 80);
    }
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (collectionView == _collection) {
        if (section == 0) {
            if (_imgsize.height!=0) {
                return CGSizeMake(mScreenWidth,_imgsize.height*mScreenWidth/_imgsize.width);
            }else{
                return CGSizeMake(mScreenWidth,mScreenWidth*206/517);
            }
        }else if (section == 1){
            return CGSizeMake(mScreenWidth,170);
        }else if (section == 2){
            if (_getBenefitArray.count != 0) {
                return CGSizeMake(mScreenWidth,40);
            }
        }else if (section == 3){
            if (_getHotProductArray.count != 0) {
                return CGSizeMake(mScreenWidth,40);
            }
        }else if (section == 4){
            if (_getYouLikeArray.count != 0) {
                return CGSizeMake(mScreenWidth,40);
            }
        }
        return CGSizeMake(0,0);
    }
    return CGSizeMake(0, 0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0||section == 1) {
        return 0;
    }else if (section==2){
            return _getBenefitArray.count;
    }else if (section==3){
            return _getHotProductArray.count;
    }else if (section==4){
            return _getYouLikeArray.count;
    }
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *HomeSelarCellID = @"CommonCollectionViewCellID";
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"CommonCollectionViewCell" bundle: [NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    CommonCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (collectionView == _collection) {
        if (indexPath.section == 2) {
            [self getHotProductModelSetCell:cell array:_getBenefitArray indexPath:indexPath];
        }else if (indexPath.section == 3){
            [self getHotProductModelSetCell:cell array:_getHotProductArray indexPath:indexPath];
        }else if (indexPath.section == 4){
            [self YoulikeModelSetCell:cell array:_getYouLikeArray indexPath:indexPath];
        }
    }else if ([collectionView isKindOfClass:[HomeIconsCollectionView class]]){
        
        
    }
    return cell;
}

- (void)getHotProductModelSetCell:(CommonCollectionViewCell*)cell array:(NSArray*)array indexPath:(nonnull NSIndexPath *)indexPath{
    [self framAdd:cell];
    if (array.count!=0) {
        getHotProductModel* model = array[indexPath.row];
        model.proname = [self convertNull:model.proname];
        model.price = [self convertNull:model.price];
        model.prosale = [self convertNull:model.prosale];
        
        cell.titleLabel.text = nil;
        cell.prictLabel.text = nil;
        cell.saleCountLabel.text = nil;
        cell.imgView.image = nil;
        cell.titleLabel.text = model.proname;
        if (!IsEmptyValue1(model.price)) {
            model.price = [NSString stringWithFormat:@"%@",model.price];
            cell.prictLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price doubleValue]];
        }else{
            cell.prictLabel.text = [NSString stringWithFormat:@"￥0"];
        }
        if (!IsEmptyValue1(model.prosale)) {
            cell.saleCountLabel.text = [NSString stringWithFormat:@"销量%@",model.prosale];//@"销量200";
        }else{
            cell.saleCountLabel.text = [NSString stringWithFormat:@"销量0"];//@"销量200";
        }
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    }
}
- (void)YoulikeModelSetCell:(CommonCollectionViewCell*)cell array:(NSArray*)array indexPath:(nonnull NSIndexPath *)indexPath{
    [self framAdd:cell];
    if (array.count!=0) {
        YoulikeModel* model = array[indexPath.row];
        model.proname = [self convertNull:model.proname];
        model.singleprice = [self convertNull:model.singleprice];
        model.prosale = [self convertNull:model.prosale];
        
        cell.titleLabel.text = nil;
        cell.prictLabel.text = nil;
        cell.saleCountLabel.text = nil;
        cell.imgView.image = nil;
        cell.titleLabel.text = model.proname;
        if (!IsEmptyValue1(model.singleprice)) {
            model.singleprice = [NSString stringWithFormat:@"%@",model.singleprice];
            cell.prictLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.singleprice doubleValue]];
        }else{
            cell.prictLabel.text = [NSString stringWithFormat:@"￥0"];
        }
        if (!IsEmptyValue1(model.prosale)) {
            cell.saleCountLabel.text = [NSString stringWithFormat:@"销量%@",model.prosale];//@"销量200";
        }else{
            cell.saleCountLabel.text = [NSString stringWithFormat:@"销量0"];//@"销量200";
        }
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];

    }
    
}

- (void)framAdd:(id)sender
{
    CALayer *layer = [sender layer];
    layer.borderColor = SecondBackGorundColor.CGColor;
    layer.borderWidth = .5f;
    //    //添加四个边阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(0,0);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius = 10.0;//给imageview添加阴影和边框
    //    //添加两个边的阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(4,4);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius=2.0;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _collection) {
        if (indexPath.section == 0) {
#pragma mark ----- 重用的问题
            UICollectionReusableView *header;
            if (header==nil) {
                header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing0" forIndexPath:indexPath];
            }
            header.backgroundColor = [UIColor whiteColor];
            for (UIView *view in header.subviews) { [view removeFromSuperview]; }
            UIImageView *headview;
            if (headview==nil) {
                headview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,mScreenWidth, mScreenWidth*206/517)];
                headview.tag = 100;
                headview.backgroundColor = BackGorundColor;
                headview.image = [UIImage imageNamed:@"default_img_banner"];
                [header addSubview:headview];
            }

            if (!IsEmptyValue(_getSpecialProductArray)) {
                NSMutableArray* adArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < _getSpecialProductArray.count; i ++) {
                    getSpecialProductModel* model = _getSpecialProductArray[i];
                    [adArray addObject:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]];
                }
                NSArray* imgarray = adArray;
                if (!IsEmptyValue(imgarray)) {
                    __weak typeof(UICollectionView*) weakcollView = _collection;
                    [headview sd_setImageWithURL:[NSURL URLWithString:imgarray[0]] placeholderImage:[UIImage imageNamed:@"default_img_banner"] completed:^(UIImage *image,NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                        CGFloat w = image.size.width;
                        CGFloat h = image.size.height;
                        if (_imgsize.width == 0||_imgsize.height == 0) {
                            _imgsize = CGSizeMake(w, h);
                            [weakcollView reloadData];
                        }
                    }];
                }
                if (_imgsize.height!=0&&_imgsize.width!=0) {
                    for (UIView* view in header.subviews) {
                        [view removeFromSuperview];
                    }
                    _adView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, mScreenWidth, _imgsize.height*mScreenWidth/_imgsize.width) ImageArray:adArray];
                    _adView.delegate = self;
                    [header addSubview:_adView];
                }

//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[adArray objectAtIndex:0]]];
//                UIImage *image = [UIImage imageWithData:data];
//                NSLog(@"w = %f,h = %f",image.size.width,image.size.height);
//                if (image.size.width!=0) {
//                    for (UIView* view in header.subviews) {
//                        [view removeFromSuperview];
//                    }
//                    _imgsize = CGSizeMake(image.size.width, image.size.height);
//                    _adView = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, mScreenWidth, _imgsize.height*mScreenWidth/_imgsize.width) ImageArray:adArray];
//                    _adView.delegate = self;
//                    [header addSubview:_adView];
//                }
            }
            return header;
        }else if (indexPath.section == 1){
            UICollectionReusableView *header;
            if (header==nil) {
                header=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerKing1" forIndexPath:indexPath];
            }
            header.backgroundColor = [UIColor whiteColor];
            for (UIView *view in header.subviews) { [view removeFromSuperview]; }
                _iconsCollView = [[HomeIconsCollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 160)];
                _iconsCollView.contentSize = CGSizeMake(mScreenWidth, 160);
                _iconsCollView.delegate = self;
                _iconsCollView.bounces = NO;
                _iconsCollView.scrollsToTop = NO;
                _iconsCollView.scrollEnabled = NO;
                _iconsCollView.userInteractionEnabled = YES;
                [header addSubview:_iconsCollView];
                _iconsCollView.backgroundColor = [UIColor clearColor];
            if (_getAllProductTypeArray.count == 8) {
                _iconsCollView.dataArr = _getAllProductTypeArray;
                [_iconsCollView reloadData];
            }
            return header;
        }
        
        UICollectionReusableView *headerheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"headerheader%zd",indexPath.section] forIndexPath:indexPath];
        for (UIView *view in headerheader.subviews) { [view removeFromSuperview]; }
        
        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 10)];
        headerView.backgroundColor = headerColor;
        [headerheader addSubview:headerView];
        UIImageView* hotImgView = [[UIImageView alloc]init];
        hotImgView.frame = CGRectMake(0, headerView.bottom, mScreenWidth, 30);
        hotImgView.backgroundColor = SecondwhiteColorColor;
        hotImgView.tag = 1000+indexPath.section;
        hotImgView.userInteractionEnabled = YES;
        [headerheader addSubview:hotImgView];
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth - 100)/2, 0, 100, hotImgView.height)];
        view.backgroundColor = [UIColor clearColor];
        [hotImgView addSubview:view];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (view.height - 20)/2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"remai"];
        [view addSubview:imageView];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, view.width - 30, hotImgView.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = NavBarItemColor;
        label.text = @"热卖商品";
        [view addSubview:label];
        UILabel* morelabel = [[UILabel alloc]initWithFrame:CGRectMake(hotImgView.width - 60, 0, 30, hotImgView.height)];
        morelabel.textColor = [UIColor blackColor];
        morelabel.text = @"更多";
        morelabel.font = [UIFont systemFontOfSize:13];
        [hotImgView addSubview:morelabel];
        UIImageView* rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(morelabel.right, (morelabel.height - 14)/2, 8, 14)];
        rightImgView.image = [UIImage imageNamed:@"you"];
        [hotImgView addSubview:rightImgView];
        
        if (indexPath.section==2) {
            imageView.image = [UIImage imageNamed:@"tehui"];
            label.text = @"特惠产品";
            if (_getBenefitArray.count == 0) {
                headerheader.hidden = YES;
            }else{
                headerheader.hidden = NO;
            }
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(benefitImgViewClick:)];
            [hotImgView addGestureRecognizer:tap];
        }else if (indexPath.section==3){
            imageView.image = [UIImage imageNamed:@"remai"];
            label.text = @"热卖产品";
            if (_getHotProductArray.count == 0) {
                headerheader.hidden = YES;
            }else{
                headerheader.hidden = NO;
            }
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotGoodsTitleClick:)];
            [hotImgView addGestureRecognizer:tap];
        }else if (indexPath.section==4){
            label.text = @"猜你喜欢";
            imageView.image = [UIImage imageNamed:@"like"];
            if (_getYouLikeArray.count == 0) {
                headerheader.hidden = YES;
            }else{
                headerheader.hidden = NO;
            }
        }
        return headerheader;
    }
        NSString *identifier;
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            identifier = @"headerView";
        } else {
            identifier = @"footerView";
        }
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 120, 30)];
        [view addSubview:label];
        
        if (indexPath.section == 0) {
            label.text = @"section1";
        }else {
            label.text = @"section2";
        }
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            view.backgroundColor = [UIColor redColor];
        } else {
            view.backgroundColor = [UIColor purpleColor];
            
        }
        return view;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collection) {
        ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
        NSArray* array;
        if (indexPath.section == 2) {
            array = _getBenefitArray;
        }else if (indexPath.section == 3){
            array = _getHotProductArray;
        }else if (indexPath.section == 4){
            array = _getYouLikeArray;
        }
        if (!IsEmptyValue(array)) {
            getHotProductModel* model = array[indexPath.row];
            model.Id = [self convertNull:model.Id];
            vc.proid = model.Id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([collectionView isKindOfClass:[HomeIconsCollectionView class]]){
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
                [_collection reloadData];
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
            [_collection reloadData];
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
                [_collection reloadData];
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
            [_collection reloadData];
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
            [_collection reloadData];
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
