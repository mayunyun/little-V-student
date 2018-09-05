//
//  BuyCarViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/13.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//
//#define CollCellHight (kDevice_Is_iPhone5 ? 200 : (kDevice_Is_iPhone6 ? 235: (kDevice_Is_iPhone6Plus ?288 : (kDevice_Is_iPhone4s ?200 : 200) ) ) )
#define CollCellHight (kDevice_Is_iPhone5 ? 150 : (kDevice_Is_iPhone6 ? 176: (kDevice_Is_iPhone6Plus ?216 : (kDevice_Is_iPhone4s ?150 : 150) ) ) )
#define cellHeight 70
#define creatEmptyHeight mScreenHeight - 64 - 120 - 100
#import "BuyCarViewController.h"
#import "MBProgressHUD.h"
#import "BuyCarModel.h"
#import "OrderDetailViewController.h"
#import "HomeViewController.h"
#import "YoulikeModel.h"
#import "ProDetailTbViewController.h"
#import "BuyCarTableViewCell.h"
#import "LoginNewViewController.h"
#import "YouLikeCollectionViewCell.h"

@interface BuyCarViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,BuyCarTableViewCellDelegate>
{
    MBProgressHUD *_hud;
    BOOL *buycar;
    UIScrollView *_mainScrollView;
    NSInteger _page;
    
    UITableView * _buyCayTableView;
    //购物车列表数据，如果数组为空，则购物车为空
    NSMutableArray * _carArray;;
    UIView *_bottomView;
    UICollectionView * _proCollectionView;
    NSMutableArray * _proArray;
    UIView* _emptyView;
    //选择
    
    //去结算
    BOOL _isSelectAll;
    UIImageView *_selectImg;
    UIButton *_allSelect;
    UIView *_gotoBuy;
    UILabel *_totalLabel;
    NSMutableArray *_selectArray;
    NSInteger _select;
    UIButton *_tobuy;
}
@end

@implementation BuyCarViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!IsEmptyValue(_selectArray)) {
        [_selectArray removeAllObjects];
    }
    [self getCarContent];
    [self YouLikeDataRequest];
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _carArray = [NSMutableArray array];
    _proArray = [NSMutableArray array];
    _selectArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor =  [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:@"购物车"];
        }
    }
    else{
        //present方式
        self.title = @"购物车";
    }
    _page = 1;
    
    [self createUI];
}


- (void)createUI
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 49*2)];
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = LineColor;
    [self.view addSubview:_mainScrollView];
    
    // 下拉刷新
    _mainScrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        [_carArray removeAllObjects];
        [self getCarContent];
        // 结束刷新
        [_mainScrollView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _mainScrollView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _mainScrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self getCarContent];
        [_mainScrollView.mj_footer endRefreshing];
        
    }];
    
    _buyCayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, _carArray.count * cellHeight)];
    _buyCayTableView.delegate = self;
    _buyCayTableView.dataSource = self;
    _buyCayTableView.rowHeight = cellHeight;
    _buyCayTableView.contentSize = CGSizeMake(0, cellHeight*_carArray.count);
    [_mainScrollView addSubview:_buyCayTableView];
    
    //猜你喜欢
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _buyCayTableView.bottom + 5, ScreenWidth, 870)];
    [_mainScrollView addSubview:_bottomView];
    UIImageView * remai = [[UIImageView   alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 30)];
    remai.image = [UIImage imageNamed:@"buycaryoulike"];
    remai.contentMode = UIViewContentModeScaleAspectFit;
    [_bottomView addSubview:remai];
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat size = (ScreenWidth - 15)/3;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(size,  CollCellHight);
    
    NSInteger count;
    NSInteger itemsinrow = 3;
    if (_proArray.count%itemsinrow != 0) {
        count = _proArray.count/itemsinrow + 1;
    }else if (_proArray.count%itemsinrow == 0){
        count = _proArray.count/itemsinrow;
    }
    _mainScrollView.contentSize = CGSizeMake(0, _carArray.count* cellHeight + (CollCellHight+5) * count + 40);
    _proCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(10, remai.bottom + 5, ScreenWidth - 20 , (CollCellHight+5)*count + 50) collectionViewLayout:flowLayout];
    _proCollectionView.dataSource = self;
    _proCollectionView.delegate = self;
    _proCollectionView.bounces = NO;
    _proCollectionView.backgroundColor = [UIColor clearColor];
    //注册Cell，必须要有
    [_proCollectionView registerNib:[UINib nibWithNibName:@"YouLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YouLikeCollectionViewCellID"];
    [_bottomView addSubview:_proCollectionView];
    
    //去结算的View
    _gotoBuy= [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 64 - 49 - 49, ScreenWidth, 49)];
    _gotoBuy.backgroundColor = [UIColor whiteColor];
    _gotoBuy.alpha = 1;
    [self.view addSubview:_gotoBuy];
    _selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 49)];
    _selectImg.contentMode = UIViewContentModeScaleAspectFit;
    _selectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
    [_gotoBuy addSubview:_selectImg];
    UILabel *selectTitle = [[UILabel alloc] initWithFrame:CGRectMake(_selectImg.right, 0, 30, 49)];
    selectTitle.font = [UIFont systemFontOfSize:12];
    selectTitle.textColor = [UIColor blackColor];
    selectTitle.text = @"全选";
    [_gotoBuy addSubview:selectTitle];
    _allSelect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _allSelect.frame = CGRectMake(0, 0, 60, 49);
    [_allSelect addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_gotoBuy addSubview:_allSelect];
    UILabel *totalTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 50, 49)];
    totalTitle.text = @"合计: ¥";
    totalTitle.textColor = [UIColor blackColor];
    totalTitle.font = [UIFont systemFontOfSize:14];
    [_gotoBuy addSubview:totalTitle];
    
    //合计的金额
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(_allSelect.right + 50, 0, mScreenWidth - 200, 49)];
    _totalLabel.font = [UIFont systemFontOfSize:14];
    _totalLabel.textColor = [UIColor blackColor];
    [_gotoBuy addSubview:_totalLabel];
    _tobuy = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 80, 0, 80, 49)];
    _tobuy.selected = NO;
    _tobuy.backgroundColor = [UIColor redColor];
    [_tobuy setTitle:@"去结算" forState:UIControlStateNormal];
    [_tobuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy addSubview:_tobuy];
    [_tobuy addTarget:self action:@selector(payFor:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            [_mainScrollView setFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 49)];
            [_gotoBuy setFrame:CGRectMake(0, mScreenHeight - 64 - 49, ScreenWidth, 49)];
        }
    }
}

- (void)creatEmptyUI
{
    _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, creatEmptyHeight)];
    _emptyView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_emptyView];
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth - 120)/2, (_emptyView.height - 64 - 120)/2, 120, 120)];
    view1.backgroundColor = [UIColor clearColor];
    [_emptyView addSubview:view1];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gouwuche"]];
    imageView.frame = CGRectMake((view1.width - 50)/2, 0, 50, 50);
    [view1 addSubview:imageView];
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom, view1.width, 20)];
    label1.text = @"购物车快饿扁了T.T";
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    label1.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:label1];
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.bottom, view1.width, 20)];
    label2.text = @"主人快给我挑点宝贝吧";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = GrayTitleColor;
    label2.font = [UIFont systemFontOfSize:10];
    [view1 addSubview:label2];
    UIButton * hotbuybtn  =[[UIButton alloc]initWithFrame:CGRectMake((view1.width - 50)/2, label2.bottom+2, 50, 25)];
    hotbuybtn.backgroundColor = [UIColor whiteColor];
    [hotbuybtn.layer setBorderWidth:1];
    hotbuybtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [hotbuybtn setTitle:@"去逛逛" forState:UIControlStateNormal];
    [hotbuybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hotbuybtn.layer setCornerRadius:5];
    hotbuybtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [hotbuybtn addTarget:self action:@selector(hotbuyClick) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:hotbuybtn];
}


- (void)hotbuyClick{
    [self.tabBarController setSelectedIndex:0];
    NSArray* array = self.navigationController.viewControllers;
    for (int i = 0; i < array.count; i++) {
        if ([array[i] isKindOfClass:[HomeViewController class]]) {
            UIViewController* vc = array[i];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
#pragma mark - 全选方法
- (void)allSelect:(UIButton *)button{
    if (_isSelectAll == YES) {
        //取消全部选中
        for (BuyCarModel *model in _carArray) {
            model.select = @"0";
            _isSelectAll = NO;
            _totalLabel.text = @"0.00";
            [_selectArray removeAllObjects];
        }
        _selectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        [_buyCayTableView reloadData];
    }else{
        //全部选中
        double sum = 0.00;
        for (BuyCarModel *model in _carArray) {
            model.select = @"1";
            sum = sum + [model.totalprice doubleValue];
            [_selectArray addObject:model];
        }
        _isSelectAll = YES;
        _totalLabel.text = [NSString stringWithFormat:@"%.2f",sum];
        _selectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
        [_buyCayTableView reloadData];
    }
}

#pragma mark - 结算跳转
- (void)payFor:(UIButton *)button{
    if (_selectArray.count!=0) {
        NSMutableArray* idarray = [[NSMutableArray alloc]init];
        NSInteger count = 0;
        NSInteger pickcount = 0;
        for (int i = 0; i < _selectArray.count; i++) {
            BuyCarModel* model = _selectArray[i];
            if ([model.isgolds integerValue] == 1) {
                count++;
            }
            if ([model.pickupway integerValue] == 1) {
                pickcount++;
            }
            [idarray addObject:[NSString stringWithFormat:@"%@",model.Id]];
        }
        if (count == _selectArray.count) {
            if (pickcount == _selectArray.count || pickcount == 0) {
                //积分商城
                NSArray* array = [NSArray arrayWithArray:idarray];
                OrderDetailViewController* orderVC = [[OrderDetailViewController alloc]init];
                orderVC.typeOrder = typeOrderpayCar;
                orderVC.golds = @"1";
                orderVC.dataIdArray =array;
                [self.navigationController pushViewController:orderVC animated:YES];
            }else{
                [self showAlert:@"自取和配送的商品请分开结算"];
            }
        }else if (count == 0){
            if (pickcount == _selectArray.count || pickcount == 0) {
                //全是正常商品
                NSArray* array = [NSArray arrayWithArray:idarray];
                OrderDetailViewController* orderVC = [[OrderDetailViewController alloc]init];
                orderVC.typeOrder = typeOrderpayCar;
                orderVC.dataIdArray =array;
                [self.navigationController pushViewController:orderVC animated:YES];
            }else{
                [self showAlert:@"自取和配送的商品请分开结算"];
            }
            
        }else{
            //既有积分商城的商品也有正常商品
            [self showAlert:@"正价商品和积分商城商品请分别结算"];
        }
        
    }else{
        [self showAlert:@"未选中商品"];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            
        }
    }
    if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
            [self delCartRequest];
        }
    }
};

#pragma mark - 删除购物车的产品
- (void)del:(UIButton *)btn{
    
    _select = btn.tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否将删除此产品?"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 1002;
    [alert show];
    
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _proArray.count ;
}
#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((mScreenWidth - 25)/3, CollCellHight);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YouLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YouLikeCollectionViewCellID" forIndexPath:indexPath];
    cell.model = _proArray[indexPath.item];
    cell.backgroundColor = [UIColor whiteColor];
    [cell setNeedsLayout];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"产品列表");
    ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
    YoulikeModel* model = _proArray[indexPath.item];
    model.Id = [self convertNull:model.Id];
    vc.proid = model.Id;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _carArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId1 = @"BuyCarTableViewCellID";
    BuyCarTableViewCell * cell = (BuyCarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId1];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BuyCarTableViewCell" owner:self options:nil]firstObject];
    }
    cell.selectBtn.tag = indexPath.row;
    cell.delBtn.tag = indexPath.row;
    cell.addBtn.tag = indexPath.row;
    cell.reduceBtn.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (_carArray.count != 0) {
        BuyCarModel *model = _carArray[indexPath.row];
        cell.model = model;
    }
    [cell setNeedsLayout];
    return cell;
}
#pragma mark - 选择产品的方法

- (void)selectAction:(UIButton *)btn{
    
    NSLog(@"选中的%zi",btn.tag);
    BuyCarModel *model = _carArray[btn.tag];
    NSInteger select = [model.select integerValue];
    if (select == 1) {
        model.select = @"0";
        [_selectArray removeObject:model];
    }else{
        model.select = @"1";
        [_selectArray addObject:model];
    }
    [_buyCayTableView reloadData];
    if (_selectArray.count == _carArray.count) {
        _selectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
    }else{
        _selectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
    }
    [self getMoney];
    
}
#pragma mark - 获得选中的产品的金额并赋值
- (void)getMoney{
    //遍历所有选中的产品（有效的） 计算总金额
    double sum = 0.00;
    for (BuyCarModel *model in _carArray) {
        NSInteger select = [model.select integerValue];
        //只取有效产品进行计算
        if ( select == 1) {
            sum = sum + [model.totalprice doubleValue];
        }
    }
    //赋值
    _totalLabel.text = [NSString stringWithFormat:@"%.2f",sum];
}

- (void)detailbtn:(UIButton*)btn
{
#pragma  mark 详情
    //    ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)addClick:(UIButton *)button{
    [_hud show:YES];
    NSLog(@"增加%zi",button.tag);
    BuyCarModel *model = _carArray[button.tag];
    NSInteger num = [model.count integerValue];
    double proprice = [model.saleprice doubleValue];
    num = num + 1;
    NSString* count = [NSString stringWithFormat:@"%zi",num];
    double totalprice = [model.totalprice doubleValue];
    totalprice = totalprice+proprice;
    NSString* totalpriceall = [NSString stringWithFormat:@"%.2f",totalprice];
    [self CarUpdateCartRequest:model.Id count:count totalprice:totalpriceall tag:button.tag];
}

- (void)reduceClick:(UIButton*)sender
{
    [_hud show:YES];
    NSLog(@"减少%zi",sender.tag);
    BuyCarModel *model = _carArray[sender.tag];
    NSInteger num = [model.count integerValue];
    double proprice = [model.saleprice doubleValue];
    num = num - 1;
    if (num < 1) {
        [self showAlert:@"商品数不能为零"];
    }else{
        NSString* count = [NSString stringWithFormat:@"%zi",num];
        double totalprice = [model.totalprice doubleValue];
        totalprice = totalprice-proprice;
        NSString* totalpriceall = [NSString stringWithFormat:@"%.2f",totalprice];
        [self CarUpdateCartRequest:model.Id count:count totalprice:totalpriceall tag:sender.tag];
    }
}



#pragma mark - 获得购物车的内容
- (void)getCarContent{
    /*
     /cart/searchCart.do
     mobile:true
     data{
     custid:客户id
     page:页码
     rows:行数
     provinceid&cityid&areaid
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
    if (_page == 1) {
        [_carArray removeAllObjects];
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"page\":\"%@\",\"rows\":\"20\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",userid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    NSDictionary* params = @{@"data":datastr,@"mobile":@"true"};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/searchCart.do"];
    NSLog(@"url%@,params%@",urlStr,params);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        
        //判断是否登录状态
        NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"searchCart.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"searchCart.do重新登录");
            //            [self showAlert:@"未登录,请先登录!"];
            LoginNewViewController *relogVC = [[LoginNewViewController alloc] init];
            [self.navigationController pushViewController:relogVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dict[@"rows"];
            NSLog(@"购物车数据%@",array);
            
            for (NSDictionary *dic  in array) {
                BuyCarModel *model = [[BuyCarModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_carArray addObject:model];
            }
            if (_carArray.count!=0) {
                for (UIView* view in self.view.subviews) {
                    [view removeFromSuperview];
                }
                [self createUI];
                [_buyCayTableView reloadData];
            }else{
                [_buyCayTableView removeFromSuperview];
                [self creatEmptyUI];
                [_bottomView setFrame:CGRectMake(0, creatEmptyHeight + 5, ScreenWidth, 870)];
                NSInteger count;
                NSInteger itemsinrow = 3;
                if (_proArray.count%itemsinrow != 0) {
                    count = _proArray.count/itemsinrow + 1;
                }else if (_proArray.count%itemsinrow == 0){
                    count = _proArray.count/itemsinrow;
                }
                _mainScrollView.contentSize = CGSizeMake(0, creatEmptyHeight + (CollCellHight+5) * count + 40);
                [_proCollectionView setFrame:CGRectMake(10, _proCollectionView.top, ScreenWidth - 20 , (CollCellHight+5)*count + 50)];
                [_proCollectionView reloadData];
            }
        }
        [_hud hide:YES afterDelay:.5];
        } fail:^(NSError *error) {
        [_hud hide:YES];
    }];
    
    
}
//删除购物车
- (void)delCartRequest
{
    /*
     /cart/delCart.do
     mobile:true
     data{
     ids:删除的商品
     }
     */
    BuyCarModel *model = _carArray[_select];
    NSString* idsstr = [self convertNull:model.Id];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/delCart.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"ids\":\"%@\"}",idsstr];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"删除商品信息返回%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"delCart.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound){
            [self showAlert:@"删除购物车成功"];
            BOOL select = NO;
            for (BuyCarModel* model in _carArray) {
                if ([model.select integerValue] == 1) {
                    select = YES;
                }
            }
            //先算出要删除的价格之后的显示价格，然后再删除
            if (select) {
                BuyCarModel *model = _carArray[_select];
//                double count = [model.count doubleValue];
                double price = [model.totalprice doubleValue];
                double sum = 0.00;
                for (BuyCarModel *model in _carArray) {
                    if ([model.select integerValue] == 1) {
                        sum = sum + [model.totalprice doubleValue];
                    }
                }
                _totalLabel.text = [NSString stringWithFormat:@"%.2f",sum - price];
            }
            //删除数据
            if (_carArray.count>=_select) {
                [_carArray removeObjectAtIndex:_select];
            }
            if (_carArray.count!=0) {
                [_buyCayTableView reloadData];
                [_buyCayTableView setFrame:CGRectMake(0, 0, mScreenWidth, _carArray.count*cellHeight)];
                [_bottomView setFrame:CGRectMake(0, _buyCayTableView.bottom + 5, ScreenWidth, 870)];
                NSInteger count;
                NSInteger itemsinrow = 2;
                if (_proArray.count%itemsinrow != 0) {
                    count = _proArray.count/itemsinrow + 1;
                }else if (_proArray.count%itemsinrow == 0){
                    count = _proArray.count/itemsinrow;
                }
                _mainScrollView.contentSize = CGSizeMake(0, _carArray.count*cellHeight + (CollCellHight+5) * count + 40);
                
            }else{
                //                for (UIView* view in self.view.subviews) {
                //                    [view removeFromSuperview];
                //                }
                [_buyCayTableView removeFromSuperview];
                [self creatEmptyUI];
                [_bottomView setFrame:CGRectMake(0, creatEmptyHeight + 5, ScreenWidth, 870)];
                NSInteger count;
                NSInteger itemsinrow = 3;
                if (_proArray.count%itemsinrow != 0) {
                    count = _proArray.count/itemsinrow + 1;
                }else if (_proArray.count%itemsinrow == 0){
                    count = _proArray.count/itemsinrow;
                }
                _mainScrollView.contentSize = CGSizeMake(0, creatEmptyHeight + (CollCellHight+5) * count + 40);
                [_proCollectionView setFrame:CGRectMake(10, _proCollectionView.top, ScreenWidth- 20 , (CollCellHight+5)*count + 50)];
                [_proCollectionView reloadData];
                
            }
        }else{
            [self showAlert:@"删除购物车失败"];
        }
        } fail:^(NSError *error) {
        NSLog(@"删除商品信息返回%@",error.localizedDescription);
    }];
    
}

- (void)CarUpdateCartRequest:(NSString*)proid count:(NSString*)count totalprice:(NSString*)price tag:(NSInteger)tag
{
    /*
     /cart/updateCart.do
     data{
     id ,购物车id
     count,数量
     totalprice,购物车id对应的价格。
     }
     mobile=true
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/updateCart.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"count\":\"%@\",\"totalprice\":\"%@\"}",proid,count,price];
    NSDictionary* parmas = @{@"data":datastr,@"mobile":@"true"};
        [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/cart/updateCart.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            BuyCarModel *model = _carArray[tag];
            model.count = count;
            model.totalprice = price;
            [_buyCayTableView reloadData];
            double sum = 0.00;
            for (BuyCarModel *model in _carArray) {
                if ([model.select integerValue] == 1) {
                    sum = sum + [model.totalprice doubleValue];
                }
            }
            _totalLabel.text = [NSString stringWithFormat:@"%.2f",sum];
            [self showAlert:@"购物车数据更新成功"];
        }else{
            [self showAlert:@"购物车数据更改失败"];
        }
        [_hud hide:YES afterDelay:.5];
        } fail:^(NSError *error) {
        [hud hide:YES];
    }];
}

- (void)YouLikeDataRequest
{
    /*
     /product/likeProduct.do
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
            [_proArray removeAllObjects];
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"array%@",array);
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    YoulikeModel* model = [[YoulikeModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_proArray addObject:model];
                }
            }
            NSInteger count;
            NSInteger itemsinrow = 3;
            if (_proArray.count%itemsinrow != 0) {
                count = _proArray.count/itemsinrow + 1;
            }else if (_proArray.count%itemsinrow == 0){
                count = _proArray.count/itemsinrow;
            }
            _mainScrollView.contentSize = CGSizeMake(0, _carArray.count* cellHeight + (CollCellHight+5) * count + 40);
            [_proCollectionView setFrame:CGRectMake(10, _proCollectionView.top, ScreenWidth-20 , (CollCellHight+5)*count + 50)];
            [_proCollectionView reloadData];
        }
        
        } fail:^(NSError *error) {
        NSLog(@"加载失败");
    }];
    
}



@end
