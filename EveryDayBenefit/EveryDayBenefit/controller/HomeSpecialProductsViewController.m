//
//  HomeSpecialProductsViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/20.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeSpecialProductsViewController.h"
#import "LoginNewViewController.h"
#import "DetailCollectionViewCell.h"
#import "MBProgressHUD.h"
//#import "BuyCarVC.h"
#import "BuyCarViewController.h"

#import "ProDetailTbViewController.h"//
#import "GetCustInfoModel.h"
#import "GetCustInfoAddressModel.h"
#import "getHotProductModel.h"


@interface HomeSpecialProductsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>{
    
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
    
    NSMutableArray* _getCustInfoAddrArray;//客户地址数据
    NSMutableArray* _getHotProductArray;//热卖商品数据
    
}
@property (nonatomic,retain)GetCustInfoModel* custInfoModel;

@end

@implementation HomeSpecialProductsViewController

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
    _priceSelect = 0;  //默认升序
    _requestSign = 0;  //默认综合
    [self initNav];
    //二级详情页面（产品）
    [self initView];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    
    //获取购物车的数据
    [self getCarNum];
    self.title = @"专题推荐";
    
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)rightBarClick:(UIButton*)sender
//{
//        BuyCarVC *carVC = [[BuyCarVC alloc] init];
//        [self.navigationController pushViewController:carVC animated:YES];
//}

- (void)initNav{
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
//    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 30, 30);
//    UIImageView* rightimgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
//    rightimgView.image = [UIImage imageNamed:@"icon-4"];
//    [rightBtn addSubview:rightimgView];
//    [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = right;
    
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
    if (![textField.text isEqualToString:@""]) {
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
#pragma mark provinceid&cityid&areaid
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
                [_proArray addObject:model];
            }
            [_proCollectionView reloadData];
            
        } fail:^(NSError *error) {
        
        }];
    }
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
    CGFloat wide = ScreenWidth/3;
    
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
    //    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, ScreenWidth, 1)];
    //    line.backgroundColor = LineColor;
    //    [_pricButton addSubview:line];
    //
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat size = (ScreenWidth - 4)/2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.minimumLineSpacing = 4;
    flowLayout.itemSize = CGSizeMake(size, 200);
    _proCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, _pricButton.bottom + 5, mScreenWidth , mScreenHeight - _pricButton.bottom - 5 - 64) collectionViewLayout:flowLayout];
    _proCollectionView.dataSource=self;
    _proCollectionView.delegate=self;
    _proCollectionView.backgroundColor = [UIColor clearColor];
    //注册Cell，必须要有
    [_proCollectionView registerNib:[UINib nibWithNibName:@"DetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DetailCollectionViewCellID"];
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
    
}
- (void)dataRequest{
    /*
    /product/getSpecialToProductDetail.do
     data{
     specialid专题的id
     rows:首页显示条数
     page：
     total综合排序按照销量和价格降序
     sales销量排序1升序 0降序
     price价格排序1升序 0降序
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
    self.Id = [self convertNull:self.Id];
    NSString* datastr;
    if (_requestSign == 0) {
        datastr= [NSString stringWithFormat:@"{\"specialid\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"total\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.Id,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==1) {
        datastr = [NSString stringWithFormat:@"{\"specialid\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"sales\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.Id,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==2) {
        NSLog(@"加载价格升序数据");
        datastr = [NSString stringWithFormat:@"{\"specialid\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"price\":\"1\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.Id,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
        
    }
    if (_requestSign ==3) {
        NSLog(@"加载价格降序数据");
        datastr = [NSString stringWithFormat:@"{\"specialid\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"price\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.Id,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@/product/getSpecialToProductDetail.do",ROOT_Path];
    NSLog(@"urlstr%@",urlstr);
    //    NSString* downStr = @"0";
    //    NSString* upStr = @"1";
    NSDictionary* params = @{@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"getSpecialToProductDetail.do-str%@",str);
        if([str rangeOfString:@"sessionoutofdate"].location !=NSNotFound)
        {
            NSLog(@"otProductDataRequest重新登录");
        }else{
            NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"array%@",array);
            if (array.count!=0) {
                [_proArray removeAllObjects];
                for (int i = 0; i < array.count; i++) {
                    getHotProductModel* model = [[getHotProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_proArray addObject:model];
                }
            }
            [_proCollectionView reloadData];
            [_hud hide:YES afterDelay:.5];
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"加载失败");
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
    DetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCollectionViewCellID" forIndexPath:indexPath];
    //加入购物车
    UIButton *carBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    carBtn.frame = CGRectMake(cell.frame.size.width - 65, cell.frame.size.height - 45, 60, 40);
    carBtn.tag = 110 + indexPath.row;
    [carBtn addTarget:self action:@selector(carAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:carBtn];
    if (_proArray.count != 0) {
        ProDetailModel *model = _proArray[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.proname];
        cell.model = _proArray[indexPath.row];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell setNeedsLayout];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark 详情页面
    //    ProDetailViewController *proDetailVC = [[ProDetailViewController alloc] init];
    //    [self.navigationController pushViewController:proDetailVC animated:YES];
    if (_proArray.count!=0) {
        NSLog(@"_proArray%@",_proArray);
        getHotProductModel* model = _proArray[indexPath.item];
        ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
        vc.proid = [NSString stringWithFormat:@"%@",model.Id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 加入购物车
- (void)carAction:(UIButton *)button{
    //tag  ＝ 110 ＋i
    NSLog(@"Tag%zi",button.tag);
    NSInteger selet = button.tag - 110;
    /* /qitao/qitaoMall/qitao
     action=addShoppingCart
     freemarker=no
     data:{"proid":"545","num":"1","proprice":"120","pronm":"精品男士棉衣","isvalid":"1","isgroup":"0","isorder":"0"}
     data:{"prosummony":"1888","proid":"555","num":"1","proprice":"1888","pronm":"华为高配NOT2.0","isvalid":"1","isgroup":"0","isorder":"0"}
     */
    ProDetailModel *model = _proArray[selet];
    
    if ([_isgroup integerValue] == 1) {
        NSDictionary *params;
        params = @{@"action":@"addShoppingCart",@"freemarker":@"no",@"data":[NSString stringWithFormat:@"{\"prosummony\":\"%@\",\"proid\":\"%@\",\"num\":\"1\",\"proprice\":\"%@\",\"pronm\":\"%@\",\"isvalid\":\"1\",\"isgroup\":\"%@\",\"isorder\":\"0\"}",model.price,model.proid,model.price,model.proname,_isgroup]};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"qitaoMall/qitao"];
        [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        
            NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            if ([str isEqualToString:@"\"nologin\""]) {
//                [self showAlert:@"未登录,请先登录!"];
                LoginNewViewController *relogVC = [[LoginNewViewController alloc] init];
                [self presentViewController:relogVC animated:YES completion:nil];
                
                
            }else{
                if ([str isEqualToString:@"\"true\""]) {
                    //[self showAlert:@"加入购物车成功！"];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示:"
                                                                    message:@"加入购物车成功,是否继续购物？"
                                                                   delegate:self
                                                          cancelButtonTitle:@"继续"
                                                          otherButtonTitles:@"去结算", nil];
                    alert.tag = 1002;
                    [alert show];
                    //                    BuyCarVC *jiaru = [[BuyCarVC  alloc  ]init];
                    //                    [self.navigationController pushViewController:jiaru animated:YES];
                }
            }
            [self getCarNum];
            
        } fail:^(NSError *error) {
        
        }];
        
        
        
    }else{
        
        NSDictionary *params = @{@"action":@"addShoppingCart",@"freemarker":@"no",@"data":[NSString stringWithFormat:@"{\"prosummony\":\"%@\",\"proid\":\"%@\",\"num\":\"1\",\"proprice\":\"%@\",\"pronm\":\"%@\",\"isvalid\":\"1\",\"isgroup\":\"0\",\"isorder\":\"0\"}",model.price,model.proid,model.price,model.proname]};
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"qitaoMall/qitao"];
        [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        
            NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            if ([str isEqualToString:@"\"nologin\""]) {
                
//                [self showAlert:@"未登录,请先登录!"];
                LoginNewViewController *relogVC = [[LoginNewViewController alloc] init];
                [self presentViewController:relogVC animated:YES completion:nil];
                
            }else{
                if ([str isEqualToString:@"\"true\""]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示:"
                                                                    message:@"加入购物车成功,是否继续购物？"
                                                                   delegate:self
                                                          cancelButtonTitle:@"继续"
                                                          otherButtonTitles:@"去结算", nil];
                    alert.tag = 1002;
                    [alert show];
                }
            }
            
            [self getCarNum];
        } fail:^(NSError *error) {
        
        }];
    }
    
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
    /* qitao/mservlet/muser
     action=getShoppingCart
     
     */
    
    
    NSDictionary *params = @{@"action":@"getShoppingCart"};
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"mservlet/muser"];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"购物车数量%zi",array.count);
        _countLabel.text = [NSString stringWithFormat:@"%zi",array.count];
    } fail:^(NSError *error) {
    }];
}




- (void)dataRequest1{
    /*
     /product/getSpecialToProductDetail.do
     data{
     specialid专题的id
     rows首页显示条数   total综合排序按照销量和价格降序     sales销量排序1升序 0降序    price价格排序1升序 0降序
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
    self.Id = [self convertNull:self.Id];
    NSString* datastr;
    if (_requestSign == 0) {
        datastr= [NSString stringWithFormat:@"{\"specialid\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"total\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.Id,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==1) {
        datastr = [NSString stringWithFormat:@"{\"specialid\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"sales\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.Id,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    if (_requestSign ==2) {
        NSLog(@"加载价格升序数据");
        datastr = [NSString stringWithFormat:@"{\"specialid\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"price\":\"1\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",[NSString stringWithFormat:@"%li",(long)_page],self.Id,provinceid,cityid,areaid];
        
    }
    if (_requestSign ==3) {
        NSLog(@"加载价格降序数据");
        datastr = [NSString stringWithFormat:@"{\"specialid\":\"%@\",\"rows\":\"10\",\"page\":\"%@\",\"price\":\"0\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.Id,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@/product/getSpecialToProductDetail.do",ROOT_Path];
    NSLog(@"urlstr%@",urlstr);
    //    NSString* downStr = @"0";
    //    NSString* upStr = @"1";
    NSDictionary* params = @{@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"getSpecialToProductDetail.do-str%@",str);
        if([str rangeOfString:@"sessionoutofdate"].location !=NSNotFound)
        {
            NSLog(@"otProductDataRequest重新登录");
        }else{
            NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"array%@",array);
            if (array.count!=0) {
                [_proArray removeAllObjects];
                for (int i = 0; i < array.count; i++) {
                    getHotProductModel* model = [[getHotProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_proArray addObject:model];
                }
            }
            [_proCollectionView reloadData];
            [_hud hide:YES afterDelay:.5];
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"加载失败");
    }];
}




@end
