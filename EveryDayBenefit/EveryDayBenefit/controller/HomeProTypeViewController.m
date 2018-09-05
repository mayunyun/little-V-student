//
//  HomeProTypeViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/12.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeProTypeViewController.h"
#import "LoginNewViewController.h"
#import "DetailCollectionViewCell.h"
//#import "ProDetailViewController.h"
#import "MBProgressHUD.h"
#import "BuyCarVC.h"
#import "BuyCarViewController.h"
#import "OrderDetailViewController.h"
#import "ProDetailTbViewController.h"//
#import "GetCustInfoModel.h"
#import "GetCustInfoAddressModel.h"
#import "ClassDetailModel.h"
#import "getHotProductModel.h"
#import "GoodsCollectionCell.h"

@interface HomeProTypeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>{
    
    MBProgressHUD *_hud;
    NSInteger _page;
    UIButton *_selectButton;
    UIButton *_totalButton;
    UIButton *_saleButton;
    UIButton *_pricButton;
    NSMutableArray *_btnArray;
    UIImageView *_signImgView; //升降标志
    NSInteger _priceSelect ;
    NSInteger _requestSign;
    //
    UICollectionView *_proCollectionView;
    NSMutableArray *_proArray;   //产品列表数据
    
    //进入购物车
    UILabel *_countLabel;
    UIButton *_goToBuyCar;
    NSInteger _proPayCount;
    NSMutableArray* _getCustInfoAddrArray;//客户地址数据
    NSMutableArray* _getHotProductArray;//热卖商品数据
    UIButton * swichBtn;
//    ClassDetailModel* qModel;
}
@property (nonatomic,retain)GetCustInfoModel* custInfoModel;
//当前排列显示状态
@property (nonatomic, assign) BOOL isPermutation;
@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
@end

@implementation HomeProTypeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _page = 1;
    [_proArray removeAllObjects];
    [self dataRequest1];
    
    //获取登录信息
//    [self getPersonContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnArray = [NSMutableArray array];
    _proArray = [NSMutableArray array];
    _getCustInfoAddrArray = [[NSMutableArray alloc]init];
    _getHotProductArray = [[NSMutableArray alloc]init];
    _page = 1;
    _proPayCount = 1;
    _priceSelect = 0;  //默认升序
    _requestSign = 0;  //默认综合
    self.isPermutation = YES;
    [self initNav];
    //二级详情页面（产品）
    [self initView];
    //进度HUD'
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    
    //获取购物车的数据
    [self getCarNum];
    
    self.title = [NSString stringWithFormat:@"%@",self.titlename];
    
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
//        BuyCarVC *carVC = [[BuyCarVC alloc] init];
//        [self.navigationController pushViewController:carVC animated:YES];
    BuyCarViewController* carVC = [[BuyCarViewController alloc]init];
    [self.navigationController pushViewController:carVC animated:YES];
    
}

- (void)initNav{
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    UIImageView* rightimgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
    rightimgView.image = [UIImage imageNamed:@"icon-4"];
    [rightBtn addSubview:rightimgView];
    [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
}
- (void)backAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"返回");
}
//- (void)searchAction{
////    ProListViewController *listVC = [[ProListViewController alloc] init];
////    [listVC setHidesBottomBarWhenPushed:YES];
////    [self.navigationController pushViewController:listVC animated:YES];
//
//}

#pragma mark - 搜索方法
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *name = textField.text;
    /*
     /product/searchProduct.do
     mobile:true
     data{
     proname（产品名称）
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
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/searchProduct.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"proname\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",name,provinceid,cityid,areaid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/product/searchProduct.do%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [_proArray removeAllObjects];
        for (int i = 0; i <array.count; i++) {
            getHotProductModel* model = [[getHotProductModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            model.proid = [NSString stringWithFormat:@"%@",model.Id];
            [_proArray addObject:model];
        }
        [_proCollectionView reloadData];
        
    } fail:^(NSError *error) {
    }];
    
}

- (void)initView{
    self.view.backgroundColor = BackGorundColor;
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, mScreenWidth - 20, 35)];
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView.layer setCornerRadius:2];
    [searchView.layer setBorderWidth:.5];
    [searchView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    //
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 35)];
    imgView.contentMode =  UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"icon-search.png"];
    [searchView addSubview:imgView];
    //
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, mScreenWidth- 150, 35)];
    searchField.textColor = [UIColor lightGrayColor];
    searchField.delegate = self;
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.placeholder = @"搜索全部产品";
    [searchView addSubview:searchField];
    [self.view addSubview:searchView];
    
    UIView *upline = [[UIView alloc] initWithFrame:CGRectMake(0, searchView.bottom, mScreenWidth, 1)];
    upline.backgroundColor = LineColor;
    [self.view addSubview:upline];
    //3个按钮的设置
    CGFloat wide = ScreenWidth/4;
    
    _totalButton =[[UIButton alloc]initWithFrame:CGRectMake(0, searchView.bottom+5,wide , 49)];
    [_totalButton setTitle:@"综合" forState:UIControlStateNormal];
    _totalButton.tag = 100;
    _totalButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_totalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_totalButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _totalButton.backgroundColor = [UIColor whiteColor];
    _selectButton = _totalButton;
    _selectButton.selected = YES;
    [_totalButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_totalButton];
    
    _saleButton =[[UIButton alloc]initWithFrame:CGRectMake(_totalButton.right,_totalButton.top , wide,49)];
    [_saleButton setTitle:@"销量" forState:UIControlStateNormal];
    _saleButton.tag = 101;
    [_saleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_saleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _saleButton.backgroundColor = [UIColor whiteColor];
    [_saleButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _saleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_saleButton];
    
    _pricButton =[[UIButton alloc]initWithFrame:CGRectMake(_saleButton.right,_totalButton.top , wide,49)];
    [_pricButton setTitle:@"价格" forState:UIControlStateNormal];
    _pricButton.tag = 102;
    [_pricButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pricButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _pricButton.backgroundColor = [UIColor whiteColor];
    [_pricButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    _pricButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_pricButton];
    
    _signImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_pricButton.center.x + 20, _totalButton.top, 10, 49)];
    _signImgView.image = [UIImage imageNamed:@"price_sign.png"];
    _signImgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_signImgView];
    

    swichBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    swichBtn.frame = CGRectMake(_signImgView.right+15,_totalButton.top , wide,49);
    swichBtn.tag = 103;
    [swichBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [swichBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    swichBtn.backgroundColor = [UIColor whiteColor];
    [swichBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [swichBtn setImage:[UIImage imageNamed:@"商品列表样式1"] forState:(UIControlState)UIControlStateNormal];
    [swichBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 4, 0)];
    [self.view addSubview:swichBtn];

    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat size = (ScreenWidth - 4)/2;
    self.flowLayout.minimumInteritemSpacing = 2;
    self.flowLayout.minimumLineSpacing = 4;
    self.flowLayout.itemSize = CGSizeMake(size, 200);
    
    _proCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, _pricButton.bottom + 5, mScreenWidth , mScreenHeight - _pricButton.bottom - 5 - 64) collectionViewLayout:self.flowLayout];
    _proCollectionView.dataSource=self;
    _proCollectionView.delegate=self;
    _proCollectionView.backgroundColor = [UIColor clearColor];
    //注册Cell，必须要有
    [_proCollectionView registerNib:[UINib nibWithNibName:@"DetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DetailCollectionViewCellID"];
    [_proCollectionView registerNib:[UINib nibWithNibName:@"GoodsCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsCollectionCell"];
    [self.view addSubview:_proCollectionView];
    
    //     下拉刷新
    _proCollectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_proArray removeAllObjects];
        [self dataRequest1];
        // 结束刷新
        [_proCollectionView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _proCollectionView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _proCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self dataRequest1];
        [_proCollectionView.mj_footer endRefreshing];
        
    }];
    _proCollectionView.mj_footer.hidden = YES;
    
    
}

- (void)selectBtn:(UIButton *)btn
{
    if (btn != _selectButton)
    {
        _selectButton.selected = NO;
        _selectButton = btn;
        
    }
    _selectButton.selected = YES;
    //综合销量
    if (btn.tag == 100 ) {
        _signImgView.image = [UIImage imageNamed:@"price_sign.png"];
        _priceSelect = 0;
        _requestSign = 0;
        //加载数据
        [self dataRequest];
    }
    if (btn.tag == 101) {
        _signImgView.image = [UIImage imageNamed:@"price_sign.png"];
        _priceSelect = 0;
        _requestSign = 1;
        //加载数据
        [self dataRequest];
        
        
    }
    //价格
    if (btn.tag == 102) {
        if (_priceSelect == 0) {
            _signImgView.image = [UIImage imageNamed:@"price_up.png"];
            _priceSelect  = 1;
            _requestSign = 2;
            //加载数据
            [self dataRequest];
            
        }else if (_priceSelect == 1) {
            _signImgView.image = [UIImage imageNamed:@"price_down.png"];
            _priceSelect = 0;
            _requestSign = 3;
            //加载数据
            [self dataRequest];
            
        }
        
    }
    if (btn.tag == 103) {
        if (self.isPermutation) {
            [swichBtn setImage:[UIImage imageNamed:@"商品列表样式2"] forState:(UIControlState)UIControlStateNormal];
            self.isPermutation = NO;
            self.flowLayout.itemSize = CGSizeMake(ScreenWidth,100);
            self.flowLayout.minimumLineSpacing      = 0;
            self.flowLayout.minimumInteritemSpacing = 0;
            self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _proCollectionView.collectionViewLayout = self.flowLayout;
        }else{
            self.isPermutation = YES;
            [swichBtn setImage:[UIImage imageNamed:@"商品列表样式1"] forState:(UIControlState)UIControlStateNormal];
            CGFloat size = (ScreenWidth - 4)/2;
            self.flowLayout.minimumInteritemSpacing = 2;
            self.flowLayout.minimumLineSpacing = 4;
            self.flowLayout.itemSize = CGSizeMake(size, 200);
            _proCollectionView.collectionViewLayout = self.flowLayout;
        }
        [_proCollectionView reloadData];
    }
    
}
- (void)dataRequest{
    /*
     /product/getTypeProduct.do
     mobile:true
     data{
     id分类id
     rows:20
     page
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
    self.iconid = [self convertNull:self.iconid];
    NSString* datastr;
    if (_requestSign == 0) {
        datastr= [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"total\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.iconid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==1) {
        datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"sales\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.iconid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==2) {
        NSLog(@"加载价格升序数据");
        datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"price\":\"1\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.iconid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==3) {
        NSLog(@"加载价格降序数据");
        datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"price\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.iconid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/getTypeProduct.do"];
    NSDictionary* parmas = @{@"data":datastr,@"mobile":@"true"};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"getTypeProduct.do返回%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/product/getTypeProduct.do重新登录");
            
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"list"];
            NSLog(@"dict%@",dict);
            [_proArray removeAllObjects];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    ClassDetailModel* model = [[ClassDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_proArray addObject:model];
                }
                [_proCollectionView reloadData];
            }
            
        }
        
    } fail:^(NSError *error) {
        [_hud hide:YES];
        NSLog(@"getTypeProduct.do请求失败%@",error.localizedDescription);
    }];
    
    
    
}
#pragma mark - 获得用户个人信息
- (void)getPersonContent{
    /*
     /login/getCustInfo.do
     custid:用户id
     mobile:true
     */
    NSString* custid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    custid = [self convertNull:custid];
    NSDictionary *params = @{@"custid":custid,@"mobile":@"true"};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/getCustInfo.do"];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        //判断是否登录状态
        NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
//            [self showAlert:@"未登录,请先登录!"];
            LoginNewViewController *relogVC = [[LoginNewViewController alloc] init];
            //            [self presentViewController:relogVC animated:YES completion:nil];
            [self.navigationController pushViewController:relogVC animated:NO];
            
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"个人信息数据%@",array);
            
            NSDictionary* dict = array[0];
            _custInfoModel = [[GetCustInfoModel alloc]init];
            [_custInfoModel setValuesForKeysWithDictionary:dict];
            [_getCustInfoAddrArray removeAllObjects];
            
            
            
            NSArray* addArray = array[1][@"addrlist"];
            for (int i =0; i < addArray.count; i++) {
                GetCustInfoAddressModel* addressModel = [[GetCustInfoAddressModel alloc]init];
                [addressModel setValuesForKeysWithDictionary:addArray[i]];
                [_getCustInfoAddrArray addObject:addressModel];
            }
            
        }
        if (_proArray.count != 0) {
            [_proArray removeAllObjects];
            _page = 1;
            
        }
        [self dataRequest1];
        [_hud hide:YES afterDelay:.5];
        
    } fail:^(NSError *error) {
        
    }];
    
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    _proCollectionView.mj_footer.hidden = _proArray.count == 0;
    return _proArray.count ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isPermutation){
        DetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCollectionViewCellID" forIndexPath:indexPath];
        
        if (_proArray.count != 0) {
            cell.model = _proArray[indexPath.row];
        }
        __weak typeof (DetailCollectionViewCell*) weakcell = cell;
        [weakcell setDownBtnBlock:^{
            if (_proPayCount > 1) {
                _proPayCount--;
            }
            weakcell.countLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
        }];
        [weakcell setUpBtnBlock:^{
            _proPayCount ++;
            weakcell.countLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
        }];
        [weakcell setRightNowBtnBlock:^{
            if (_proPayCount > 0) {
                OrderDetailViewController* orderVC = [[OrderDetailViewController alloc]init];
                orderVC.typeOrder = typeOrderAddress;
                orderVC.nowProdetailModel = _proArray[indexPath.row];
                orderVC.nowProcount = _proPayCount;
                if (self.type == tPoint) {
                    orderVC.golds = @"1";
                }
                [self.navigationController pushViewController:orderVC animated:YES];
            }else{
                [self showAlert:@"商品个数为0"];
            }
        }];
        [weakcell setJoinShopCarBtnBlock:^{
            if (_proPayCount>0) {
                [self addCarDoRequest:indexPath.item];
            }else{
                [self showAlert:@"商品个数为0"];
            }
        }];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setNeedsLayout];
        
        return cell;
        
    }else{
        GoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsCollectionCell" forIndexPath:indexPath];
        cell.model = _proArray[indexPath.row];
//        model = _proArray[indexPath.row];
        __weak typeof (GoodsCollectionCell*) weakcell = cell;
        [weakcell setDownBtnBlock:^{
            if (_proPayCount > 1) {
                _proPayCount--;
            }
            weakcell.countLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
        }];
        [weakcell setUpBtnBlock:^{
            _proPayCount ++;
            weakcell.countLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
        }];
        [weakcell setRightNowBtnBlock:^{
            if (_proPayCount > 0) {
                OrderDetailViewController* orderVC = [[OrderDetailViewController alloc]init];
                orderVC.typeOrder = typeOrderAddress;
                orderVC.nowProdetailModel = _proArray[indexPath.row];
                orderVC.nowProcount = _proPayCount;
                if (self.type == tPoint) {
                    orderVC.golds = @"1";
                }
                [self.navigationController pushViewController:orderVC animated:YES];
            }else{
                [self showAlert:@"商品个数为0"];
            }
        }];
        [weakcell setJoinShopCarBtnBlock:^{
            if (_proPayCount>0) {
                [self addCarDoRequest:indexPath.item];
            }else{
                [self showAlert:@"商品个数为0"];
            }
        }];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setNeedsLayout];
        return cell;
        
    }

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark 详情页面
    //    ProDetailViewController *proDetailVC = [[ProDetailViewController alloc] init];
    //    [self.navigationController pushViewController:proDetailVC animated:YES];
    if (_proArray.count!=0) {
        NSLog(@"_proArray%@",_proArray);
        ClassDetailModel* model = _proArray[indexPath.item];
        ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
        if (!IsEmptyValue(model.proid)) {
            vc.proid = [NSString stringWithFormat:@"%@",model.proid];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
//添加购物车的接口
- (void)addCarDoRequest:(NSUInteger)index
{
    /*
     /cart/addCart.do
     mobile:true
     data{
     cartlist[{
     custid:客户id
     proid:产品id
     proname:产品名称
     count:数量
     prono:订单编号
     saleprice:产品单价
     totalprice:产品总价
     specification:规格
     prounitid:单位
     prounitname:单位名称
     isgolds://是否是积分商城中的商品1，不是积分商城中的商品
     pickupway:是否自取。1自取，0配送
     }]
     }
     */
    ClassDetailModel* qModel = _proArray[index];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //    sender.enabled = NO;
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    qModel.proid = [self convertNull:qModel.proid];
    NSLog(@"%@-------",qModel.proid);
    qModel.proname = [self convertNull:qModel.proname];
    qModel.price = [self convertNull:qModel.price];
    double totlemoney = [qModel.price doubleValue]*_proPayCount;
    NSString* totlestr = [NSString stringWithFormat:@"%.2f",totlemoney];
    qModel.specification = [self convertNull:qModel.specification];
    qModel.prounitid = [self convertNull:qModel.prounitid];
    qModel.prounitname = [self convertNull:qModel.prounitname];
    qModel.pickupway = [self convertNull:qModel.pickupway];
    NSString* isgolds ;
    if (self.type == tGoods) {
        isgolds = @"0";
    }else if (self.type == tPoint){
        isgolds = @"1";
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/addCart.do"];
    NSString* cartliststr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"count\":\"%@\",\"saleprice\":\"%@\",\"totalprice\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"isgolds\":\"%@\",\"pickupway\":\"%@\"}",userid,qModel.proid,qModel.proname,qModel.prono,[NSString stringWithFormat:@"%li",(long)_proPayCount],qModel.price,totlestr,qModel.specification,qModel.prounitid,qModel.prounitname,isgolds,qModel.pickupway];
    NSString* datastr = [NSString stringWithFormat:@"{\"cartlist\":[%@]}",cartliststr];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        [hud hide:YES];
        //        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"添加购物车返回信息%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/cart/addCart.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"添加购物车成功"];
        }else{
            [self showAlert:@"添加购物车失败"];
        }
        
    } fail:^(NSError *error) {
        [hud hide:YES];
        //        sender.enabled = YES;
        NSLog(@"添加购物车成功%@",error.localizedDescription);
    }];
    
}
#pragma mark - 加入购物车
- (void)carAction:(UIButton *)button{
    //tag  ＝ 110 ＋i
    NSLog(@"Tag%zi",button.tag);
//    NSInteger selet = button.tag - 110;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
//            BuyCarVC *carVC = [[BuyCarVC alloc] init];
//            [self.navigationController pushViewController:carVC animated:YES];
            BuyCarViewController* carVC = [[BuyCarViewController alloc]init];
            [self.navigationController pushViewController:carVC animated:YES];
        }
    }
    
};

- (void)getCarNum{

}




- (void)dataRequest1{
    /*
     /product/getTypeProduct.do
     mobile:true
     data{
     id分类id
     rows:20
     page
     provinceid cityid areaid 客户定位省市区域的id
     }
     */
    if (_page == 1) {
        [_proArray removeAllObjects];
    }
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
    self.iconid = [self convertNull:self.iconid];
    NSString* datastr;
    if (_requestSign == 0) {
        datastr= [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"total\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.iconid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==1) {
        datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"sales\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.iconid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==2) {
        NSLog(@"加载价格升序数据");
        datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"price\":\"1\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.iconid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
        
    }
    if (_requestSign ==3) {
        NSLog(@"加载价格降序数据");
        datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"price\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.iconid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/getTypeProduct.do"];
    NSDictionary* parmas = @{@"data":datastr,@"mobile":@"true"};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"getTypeProduct.do返回%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/product/getTypeProduct.do重新登录");
            
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"list"];
            NSLog(@"dict%@",dict);
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    ClassDetailModel* model = [[ClassDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_proArray addObject:model];
                }
            }
           [_proCollectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        [_hud hide:YES];
        NSLog(@"getTypeProduct.do请求失败%@",error.localizedDescription);
    }];
}






@end
