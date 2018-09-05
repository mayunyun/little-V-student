//
//  ClassViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/12.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ClassViewController.h"
#import "MBProgressHUD.h"
#import "ClassDetailTableViewCell.h"
#import "getAllProductTypeModel.h"
#import "ProDetailTbViewController.h"
#import "ClassDetailModel.h"
#import "OrderDetailViewController.h"
#import "LoginNewViewController.h"
@interface ClassViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    MBProgressHUD *_hud;
    UITableView *_listTableView;
    NSMutableArray *_listArray;
    NSInteger _page;
    NSString* _typeProId;
    //详情原数据数组
    UITableView *_detailTableView;
    NSMutableArray *_detailArray;
    NSMutableArray * _payArray;
    //
    UILabel* _countlabel;
    NSInteger _proPayCount;
    ClassDetailModel * model;
}
@property (nonatomic,strong)UILabel* priceLabel;
@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部分类";
    self.view.backgroundColor = BackGorundColor;
    _listArray = [NSMutableArray array];
    _detailArray = [[NSMutableArray alloc]init];
    _payArray = [[NSMutableArray alloc]init];
    _proPayCount = 1;
    _page = 1;
    [self backBarButtonItemTarget:self action:@selector(leftBarBtnClick:)];

//    [self initNav];
    //一级详情页面
    [self initView];
    
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    
    
    //数据加载
    [self dataRequest];
    
    
}

- (void)leftBarBtnClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"返回");
}

- (void)initView{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 1)];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth*0.25, mScreenHeight - 49 - 64)];
    _listTableView.backgroundColor = BackGorundColor;
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self.view addSubview:_listTableView];
    [ self setExtraCellLineHidden:_listTableView];

    
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth*0.25, 0, mScreenWidth*0.75, mScreenHeight - 64 - 49)];
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.rowHeight = 70;
    [self.view addSubview:_detailTableView];
    [ self setExtraCellLineHidden:_detailTableView];
    //     下拉刷新
    _detailTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        if (!IsEmptyValue(_typeProId)) {
            [_detailArray removeAllObjects];
            [self GetTypeProductRequest:_typeProId];
        }
        // 结束刷新
        [_detailTableView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _detailTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _detailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (!IsEmptyValue(_typeProId)) {
            _page ++ ;
            [self GetTypeProductRequest:_typeProId];
        }
        [_detailTableView.mj_footer endRefreshing];
        
    }];
    
    UIView* bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 64 - 49, mScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bottomView];
    UIButton* shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopBtn.userInteractionEnabled = YES;
    [shopBtn setImage:[UIImage imageNamed:@"icon-20"] forState:UIControlStateNormal];
    shopBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    shopBtn.frame = CGRectMake(0, 0, _listTableView.width, 50);
    [bottomView addSubview:shopBtn];
    [shopBtn addTarget:self action:@selector(shopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _countlabel = [[UILabel alloc]initWithFrame:CGRectMake(shopBtn.width/2, 0, shopBtn.width/2, 50)];
    _countlabel.text = @"X0";
    [shopBtn addSubview:_countlabel];
    
    UIButton* payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    payBtn.frame = CGRectMake(bottomView.width - 100, 0, 100, bottomView.height);
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    payBtn.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:payBtn];
    [payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(shopBtn.right, 0, bottomView.width - shopBtn.width - payBtn.width, bottomView.height)];
    _priceLabel.text = @"共￥0";
    [bottomView addSubview:_priceLabel];
    
    
    
}
#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _listTableView) {
        return _listArray.count;
    }else if (tableView == _detailTableView){
        return _detailArray.count;
    }
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *iden = @"cell_list";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.backgroundColor = BackGorundColor;
    }
    ClassDetailTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell1 == nil) {
        cell1 = (ClassDetailTableViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"ClassDetailTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (tableView == _listTableView) {
        getAllProductTypeModel *model = _listArray[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.numberOfLines = 0;
        //cell的高亮颜色
        cell.textLabel.highlightedTextColor =[UIColor redColor];
        
        //cell的高亮背景色
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, cell.frame.size.width -2, cell.frame.size.height- 2)];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 3, cell.frame.size.height - 2)];
        imgView.backgroundColor = [UIColor redColor];
        [cell.selectedBackgroundView addSubview:imgView];
        return cell;
    }
    if (tableView == _detailTableView) {
//        tableView.allowsSelection = NO;
//        cell1.contentView.frame = CGRectMake(0, 0, _detailTableView.width, 65);
//        UIButton* addproBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [addproBtn setImage:[UIImage imageNamed:@"icon-17"] forState:UIControlStateNormal];
//        addproBtn.frame = CGRectMake( cell1.contentView.right - 40, cell1.contentView.bottom - 40, 40, 40);
//        addproBtn.tag = indexPath.row;
////        [cell1.contentView addSubview:addproBtn];
//        [addproBtn addTarget:self action:@selector(addProClick:) forControlEvents:UIControlEventTouchUpInside];
        if (!IsEmptyValue(_detailArray)) {
            cell1.model = _detailArray[indexPath.row];
            model = _detailArray[indexPath.row];
        }
        __weak typeof (ClassDetailTableViewCell*) weakcell = cell1;
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
                orderVC.nowProdetailModel = _detailArray[indexPath.row];
                orderVC.nowProcount = _proPayCount;
                if (self.type == typePoint) {
                    orderVC.golds = @"1";
                }
                [self.navigationController pushViewController:orderVC animated:YES];
            }else{
                [self showAlert:@"商品个数为0"];
            }
        }];
        [weakcell setJoinShopCarBtnBlock:^{
            if (_proPayCount>0) {
                [self addCarDoRequest];
            }else{
                [self showAlert:@"商品个数为0"];
            }
        }];
        return cell1;
    }
    
    return cell;
    
    
}
//cell 的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _listTableView) {
        if (!IsEmptyValue(_listArray)) {
            getAllProductTypeModel* model = _listArray[indexPath.row];
            _page = 1;
            [self GetTypeProductRequest:model.Id];
        }
    }else if (tableView == _detailTableView){
        if (!IsEmptyValue(_detailArray)) {
            ProDetailTbViewController* detailVC = [[ProDetailTbViewController alloc]init];
            ClassDetailModel* model = _detailArray[indexPath.row];
            if (!IsEmptyValue(model.proid)) {
                detailVC.proid = model.proid;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }

}
//添加购物车的接口
- (void)addCarDoRequest
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    sender.enabled = NO;
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    model.Id = [self convertNull:model.Id];
    model.proname = [self convertNull:model.proname];
    model.price = [self convertNull:model.price];
    double totlemoney = [model.price doubleValue]*_proPayCount;
    NSString* totlestr = [NSString stringWithFormat:@"%.2f",totlemoney];
    model.specification = [self convertNull:model.specification];
    model.prounitid = [self convertNull:model.prounitid];
    model.prounitname = [self convertNull:model.prounitname];
    model.pickupway = [self convertNull:model.pickupway];
    NSString* isgolds ;
    if (self.type == typeGoods) {
        isgolds = @"0";
    }else if (self.type == typePoint){
        isgolds = @"1";
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/addCart.do"];
    NSString* cartliststr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"count\":\"%@\",\"saleprice\":\"%@\",\"totalprice\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"isgolds\":\"%@\",\"pickupway\":\"%@\"}",userid,model.Id,model.proname,model.prono,[NSString stringWithFormat:@"%li",(long)_proPayCount],model.price,totlestr,model.specification,model.prounitid,model.prounitname,isgolds,model.pickupway];
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

- (void)addProClick:(UIButton*)sender
{
    NSLog(@"点击了第%ld个加号",(long)sender.tag);
    //取到_detailArray中的价格
    ClassDetailModel* model = _detailArray[sender.tag];
    [_payArray addObject:model];
}


//消息点击方法复写 单独的点击事件
- (void)msgClick:(UIButton*)btn
{
    
    
    NSLog(@">>>>");
}



#pragma mark - 数据请求
- (void)dataRequest{
    /*
     /product/getAllProductType.do
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@/product/getAllProductType.do",ROOT_Path];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"str%@",str);
        NSArray * array = [NSJSONSerialization JSONObjectWithData:result options:kNilOptions error:nil];
        NSLog(@"array%@",array);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
        }else{
            if (array.count!=0) {
                [_listArray removeAllObjects];
                for (int i = 0; i <array.count; i++) {
                    getAllProductTypeModel* model = [[getAllProductTypeModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_listArray  addObject:model];
                }
                
                [_listTableView reloadData];
                //默认选择第一行
                NSIndexPath *first = [NSIndexPath
                                      indexPathForRow:0 inSection:0];
                [_listTableView selectRowAtIndexPath:first
                                            animated:YES
                                      scrollPosition:UITableViewScrollPositionTop];
                if (!IsEmptyValue(_listArray)) {
                    getAllProductTypeModel* model = _listArray[0];
                    [self GetTypeProductRequest:model.Id];
                } 
                
            }
        }
        [_hud hide:YES afterDelay:.5];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
    }];
    
}

- (void)GetTypeProductRequest:(NSString*)typeid
{
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
    [_hud show:YES];
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
    typeid = [self convertNull:typeid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/getTypeProduct.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"rows\":\"20\",\"page\":\"%li\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",typeid,_page,provinceid,cityid,areaid];
    _typeProId = typeid;
    if (_page == 1) {
        [_detailArray removeAllObjects];
    }
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
            NSLog(@"/product/getTypeProduct.do%@",dict);
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    ClassDetailModel* model = [[ClassDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_detailArray addObject:model];
                }
                
            }
            [_detailTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [_hud hide:YES];
        NSLog(@"getTypeProduct.do请求失败%@",error.localizedDescription);
    }];
    
}

- (void)shopBtnClick:(UIButton*)sender
{

}

- (void)payBtnClick:(UIButton*)sender
{

}

@end
