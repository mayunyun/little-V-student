//
//  HomePointViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/17.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomePointViewController.h"
#import "PointListTableViewCell.h"
#import "HomePointViewController.h"
#import "LoginNewViewController.h"
#import "SearchGoldsProModel.h"
#import "MBProgressHUD.h"
#import "ProDetailTbViewController.h"
@interface HomePointViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    MBProgressHUD* _hud;
    UITableView *_proTbView;
    NSMutableArray *_proArray;   //产品列表数据
    NSInteger _page;
}

@end

@implementation HomePointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _proArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.title = @"金币商城";
    [self initNav];
    [self creatUI];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dataRequest1];
}

- (void)initNav{
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    UIImageView* rightimgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
    rightimgView.image = [UIImage imageNamed:@"icon-4"];
//    [rightBtn addSubview:rightimgView];
    [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{

    
}


- (void)creatUI
{
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
    
    _proTbView = [[UITableView alloc]initWithFrame:CGRectMake(0,  upline.bottom+5, mScreenWidth , mScreenHeight - 5 - 64) style:UITableViewStylePlain];
    _proTbView.delegate = self;
    _proTbView.dataSource = self;
    _proTbView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_proTbView];
    
    //     下拉刷新
    _proTbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_proArray removeAllObjects];
        [self dataRequest1];
        // 结束刷新
        [_proTbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _proTbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _proTbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++ ;
        [self dataRequest1];
        [_proTbView.mj_footer endRefreshing];
        
    }];
//    _proTbView.mj_footer.hidden = YES;
}




#pragma mark UITableView

- (NSInteger)
tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!IsEmptyValue(_proArray)) {
        return _proArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _proTbView) {
        return 70;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointListTableViewCell* procell = [tableView dequeueReusableCellWithIdentifier:@"PointListTableViewCellID"];
    if (!procell) {
        procell = [[[NSBundle mainBundle]loadNibNamed:@"PointListTableViewCell" owner:self options:nil]firstObject];
    }
    if (!IsEmptyValue(_proArray)) {
        SearchGoldsProModel* model = _proArray[indexPath.row];
        [procell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
        procell.titleLabel.text = [NSString stringWithFormat:@"%@",model.proname];
        if (!IsEmptyValue(model.prosale)) {
            procell.saleLabel.text = [NSString stringWithFormat:@"销量：%@",model.prosale];
        }else{
            procell.saleLabel.text = [NSString stringWithFormat:@"销量：0"];
        }
        if (!IsEmptyValue(model.price)) {
            procell.priceLabel.text = [NSString stringWithFormat:@"价格：%@金币",model.price];
        }else{
            procell.priceLabel.text = [NSString stringWithFormat:@"价格：0金币"];
        }
        
    }
    
    return procell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!IsEmptyValue(_proArray)) {
        SearchGoldsProModel* model = _proArray[indexPath.row];
        ProDetailTbViewController* detailVC = [[ProDetailTbViewController alloc]init];
        detailVC.typepro = typeProPoint;
        detailVC.proid = model.Id;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        [self searchGoldsProductRequest:textField.text];
    }
}


- (void)dataRequest1
{
    /*
     /golds/searchGoldsPro.do
     mobile:true
     data{
     provinceid ,cityid ,areaid
     page
     rows
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
//#warning mark provinceid&cityid&areaid
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/golds/searchGoldsPro.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"page\":\"%@\",\"rows\":\"20\"}",provinceid,cityid,areaid,[NSString stringWithFormat:@"%li",(long)_page]];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/golds/searchGoldsPro.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    SearchGoldsProModel* model = [[SearchGoldsProModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_proArray addObject:model];
                }
                [_proTbView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [_hud hide:YES];
    }];
}


#pragma mark 积分商城搜索
- (void)searchGoldsProductRequest:(NSString*)text
{
/*
 /product/searchGoldsProduct.do
 mobile:true
 data{
 proname 商品名称
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
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/searchGoldsProduct.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"proname\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",text,provinceid,cityid,areaid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"searchGoldsProduct.do%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [_proArray removeAllObjects];
        if (!IsEmptyValue(array)) {
            for (int i = 0; i < array.count; i++) {
                SearchGoldsProModel* model = [[SearchGoldsProModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                [_proArray addObject:model];
            }
            
        }
        [_proTbView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
    
}






@end
