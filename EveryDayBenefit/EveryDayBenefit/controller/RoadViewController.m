//
//  RoadViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/22.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "RoadViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "MBProgressHUD.h"
#import "RoadTableViewCell.h"

@interface RoadViewController ()<UITextFieldDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>
{
    UIView* _navBarView;
    UITextField* _searchTextField;
    CLLocationCoordinate2D _loc;
    BMKLocationService *_locService;
    NSString *_poiName;  //标志型建筑名称
    UILabel* _addressLabel;
    MBProgressHUD* _HUD;
    UITableView* _tbView;
    NSInteger _page;
    NSInteger _selectimg;
}

@property(nonatomic,strong)BMKMapView *mapView;

@property (nonatomic, strong) BMKGeoCodeSearch *geoCode;

@property (strong,nonatomic)NSString * addressMessage;

@property (nonatomic,strong)BMKPoiSearch* searcher;

@property (nonatomic,strong)NSMutableArray* dataArray;


@end

@implementation RoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    [self creatNavUI];
    [self creatUI];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式为进度框形的
    _HUD.labelText = @"网络不给力，正在加载中...";
    _HUD.mode = MBProgressHUDModeIndeterminate;
    [_HUD show:YES];
    
    [self locate];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
}

- (void)creatNavUI
{
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.backgroundColor = [UIColor grayColor];
    rightBtn.frame = CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth - 20 - 30 - 60, 40)];
    _navBarView.userInteractionEnabled = YES;
    _navBarView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _navBarView;
    UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 5;
    [searchBtn.layer setBorderWidth:.5];
    [searchBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    searchBtn.userInteractionEnabled = YES;
    searchBtn.frame = CGRectMake(0, 0, _navBarView.width, 40);
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.alpha = 0.5;
    [_navBarView addSubview:searchBtn];
    UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20, 20)];
    searchImgView.userInteractionEnabled = YES;
    searchImgView.image = [UIImage imageNamed:@"icon-search"];
    [searchBtn addSubview:searchImgView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick:)];
    [searchImgView addGestureRecognizer:tap];
    
    _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right+5, 0, searchBtn.width-searchImgView.width - 40, 30)];
    _searchTextField.textColor = [UIColor lightGrayColor];
    _searchTextField.delegate = self;
    [_searchTextField setPlaceholder:@"请输入小区/大厦/学校等进行搜索"];
    [searchBtn addSubview:_searchTextField];
    
    
}

- (void)creatUI
{
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 200)];
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 15;
    [self.view addSubview:self.mapView];
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, _mapView.bottom, mScreenWidth, mScreenHeight - 200 - 64)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    
    //下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        [_dataArray removeAllObjects];
        [self searchkey];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self searchkey];
        [_tbView.mj_footer endRefreshing];
        
    }];
    
}
- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    [self searchkey];

}

- (void)searchClick:(UITapGestureRecognizer*)tap
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IsEmptyValue(_dataArray)) {
        return 0;
    }else{
        return _dataArray.count;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString* cellID = @"cellID";
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
    RoadTableViewCell* roadcell = [tableView dequeueReusableCellWithIdentifier:@"RoadTableViewCellID"];
    if (!roadcell) {
        roadcell = [[[NSBundle mainBundle]loadNibNamed:@"RoadTableViewCell" owner:self options:nil]firstObject];
    }
    if (!IsEmptyValue(_dataArray)) {
        BMKPoiInfo* addinfo = _dataArray[indexPath.row];
        if (indexPath.row == _selectimg) {
            roadcell.imgView.image = [UIImage imageNamed:@"locationlight"];
        }else{
            roadcell.imgView.image = [UIImage imageNamed:@"location"];
        }
        roadcell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",addinfo.name,addinfo.city];
        roadcell.addressLabel.text = [NSString stringWithFormat:@"%@",addinfo.address];
    }
    roadcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return roadcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectimg = indexPath.row;
    [tableView reloadData];
    if (!IsEmptyValue(_dataArray)) {
        BMKPoiInfo* addinfo = _dataArray[indexPath.row];
        NSLog(@"===%@=%@=%@=======",addinfo.name,addinfo.address,addinfo.city);
        
        //    通过block反向传值
        if (_transVaule) {
            _transVaule(addinfo.name, addinfo.address);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    

}

#pragma mark - 定位
- (void)locate
{
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
    [self outputAdd];
    
    //定位显示点
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = _loc;
    annotation.title = @"我的位置";
    [_mapView setCenterCoordinate:_loc];
    [_mapView addAnnotation:annotation];
    [self searchkey];
}

- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}

- (void)outputAdd
{
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将TextField中的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake([self.lblLatitude floatValue], [self.lblLongitude floatValue]);
    NSLog(@"%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:option];
}

#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        NSLog(@"标志性建筑 - - - -- - - %@",result);
        NSLog(@"%@ - %@", result.address, result.addressDetail.streetNumber);
        
        if (result.poiList.count != 0) {
            BMKPoiInfo *poiInfo = result.poiList[0];
            NSLog(@"标志性建筑:%@  ",poiInfo.name);
            _poiName = poiInfo.name;
        }
        //位置信息
        self.addressMessage = result.address;
        _addressLabel.text = [NSString stringWithFormat:@"%@(%@附近)",self.addressMessage,_poiName];
        NSLog(@"显示位置:%@",self.addressMessage);
        [_HUD hide:YES afterDelay:.5];
    }else{
        NSLog(@"找不到相对应的位置信息");
        
    }
}

- (void)searchkey
{
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = _page;//curPage
    option.pageCapacity = 10;//一页有多少
    option.location = _loc;//CLLocationCoordinate2D{39.915, 116.404};
    if (_searchTextField.text.length == 0) {
        option.keyword = @"大厦";
    }else{
        option.keyword = _searchTextField.text;
    }
    BOOL flag = [_searcher poiSearchNearBy:option];
    option = nil;
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        [self showAlert:@"周边检索发送失败"];
        NSLog(@"周边检索发送失败");
    }
}


- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [_dataArray addObjectsFromArray: poiResultList.poiInfoList];
//        int num = poiResultList.totalPoiNum;
//        int currentnum = poiResultList.currPoiNum;
//        int pages = poiResultList.pageNum;
//        int currentpage = poiResultList.pageIndex;
//        NSArray* currentList = poiResultList.cityList;
//        BOOL address = poiResultList.isHavePoiAddressInfoList;
//        NSArray* poiaddList = poiResultList.poiAddressInfoList;
//        NSLog(@"poiResultList%@-----%d-----%d-----%d-----%d------%@----%hhd-----%@---",_dataArray,num,currentnum,pages,currentpage,currentList,address,poiaddList);
        [_tbView reloadData];
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        [self showAlert:@"抱歉，未找到结果"];
        NSLog(@"抱歉，未找到结果");
    }
}



@end
