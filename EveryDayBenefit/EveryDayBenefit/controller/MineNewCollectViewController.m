
//
//  MineNewCollectViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/16.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#define ROWS @"20"
#import "MineNewCollectViewController.h"
#define TwoCellHight 220
#import "CommonCollectionViewCell.h"
#import "ProCollModel.h"
#import "LoginNewViewController.h"
#import "ProDetailTbViewController.h"
#define cellHeight 70
#define CollCellHight (kDevice_Is_iPhone5 ? 200 : (kDevice_Is_iPhone6 ? 235: (kDevice_Is_iPhone6Plus ?288 : (kDevice_Is_iPhone4s ?200 : 200) ) ) )
#define creatEmptyHeight mScreenHeight - 64 - 120 - 100
#import "MineNewCollectTableViewCell.h"
#import "YouLikeCollectionViewCell.h"
#import "MBProgressHUD.h"

@interface MineNewCollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CommonCollectionViewCellDelegate,UITableViewDelegate,UITableViewDataSource,MineNewCollectTableViewCellDelegate>
{
    NSInteger _page;
    BOOL _isSelectFinish;
    BOOL _isSelectItemimg;
    NSMutableIndexSet *_indexSetToDel;
    NSMutableArray* _delIDArray;
    BOOL _isSelectAll;
    //
    UIView* _deleteView;
    UIImageView* _deSelectImg;
    
    UIScrollView* _mainScrollView;
    UITableView* _tbView;
    UIView* _bottomView;
    NSMutableArray* _proArray;
    UICollectionView* _proCollectionView;
    
}
@property (nonatomic,strong)NSMutableArray* dataArr;

@end

@implementation MineNewCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    _delIDArray = [[NSMutableArray alloc]init];
    _proArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.title = @"我的收藏";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"编辑"];
    [self dataRequest];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self YouLikeDataRequest];
}

- (void)creatUI
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 49)];
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = LineColor;
    [self.view addSubview:_mainScrollView];
    
    // 下拉刷新
    _mainScrollView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        [_dataArr removeAllObjects];
        [self dataRequest];
        // 结束刷新
        [_mainScrollView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _mainScrollView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    _mainScrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self dataRequest];
        [_mainScrollView.mj_footer endRefreshing];
        
    }];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, _dataArr.count * cellHeight)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.rowHeight = cellHeight;
    _tbView.contentSize = CGSizeMake(0, cellHeight*_dataArr.count);
    [_mainScrollView addSubview:_tbView];
    
    //猜你喜欢
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _tbView.bottom + 5, ScreenWidth, 870)];
    [_mainScrollView addSubview:_bottomView];
    UIImageView * remai = [[UIImageView   alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 30)];
    remai.image = [UIImage imageNamed:@"buycaryoulike"];
    remai.contentMode = UIViewContentModeScaleAspectFit;
    [_bottomView addSubview:remai];
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGFloat size = (ScreenWidth - 12)/3;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 4;
    flowLayout.itemSize = CGSizeMake(size,  CollCellHight);
    
    NSInteger count;
    NSInteger itemsinrow = 2;
    if (_proArray.count%itemsinrow != 0) {
        count = _proArray.count/itemsinrow + 1;
    }else if (_proArray.count%itemsinrow == 0){
        count = _proArray.count/itemsinrow;
    }
    _mainScrollView.contentSize = CGSizeMake(0, _dataArr.count* cellHeight + (CollCellHight+5) * count + 40);
    _proCollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(10, remai.bottom + 5, ScreenWidth - 20 , (CollCellHight+5)*count + 50) collectionViewLayout:flowLayout];
    _proCollectionView.dataSource = self;
    _proCollectionView.delegate = self;
    _proCollectionView.bounces = NO;
    _proCollectionView.backgroundColor = [UIColor clearColor];
    //注册Cell，必须要有
    [_proCollectionView registerNib:[UINib nibWithNibName:@"YouLikeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YouLikeCollectionViewCellID"];
    [_bottomView addSubview:_proCollectionView];
    
    //-------------编辑删除----------------
    _deleteView=[[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 64 - 49, mScreenWidth, 49)];
    _deleteView.backgroundColor = [UIColor blackColor];
    _deleteView.hidden = YES;
    [self.view addSubview:_deleteView];
    _deSelectImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 49)];
    _deSelectImg.contentMode = UIViewContentModeScaleAspectFit;
    _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
    [_deleteView addSubview:_deSelectImg];
    UILabel *deSelectTitle = [[UILabel alloc] initWithFrame:CGRectMake(_deSelectImg.right, 0, 30, 49)];
    deSelectTitle.font = [UIFont systemFontOfSize:12];
    deSelectTitle.textColor = [UIColor whiteColor];
    deSelectTitle.text = @"全选";
    [_deleteView addSubview:deSelectTitle];
    UIButton *deAllSelect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deAllSelect.frame = CGRectMake(0, 0, 100, 49);
    [deAllSelect addTarget:self action:@selector(deAllSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteView addSubview:deAllSelect];
}

- (void)emptyUI
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, creatEmptyHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:view];
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth - 120)/2, (view.height - 64 - 120)/2, 120, 120)];
    view1.backgroundColor = [UIColor clearColor];
    [view addSubview:view1];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((view.width - 100)/2, 80, 100, 100)];
    imgView.image = [UIImage imageNamed:@"kongshoucang"];
    [view addSubview:imgView];
    
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+5, view.width, 20)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = GrayTitleColor;
    label1.text = @"您还没有收藏过商品";
    [view addSubview:label1];
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.bottom+5, view.width, 20)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:10];
    label2.textColor = [UIColor blackColor];
    label2.text = @"已经到最底了";
    [view addSubview:label2];
}


- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    _isSelectFinish = !_isSelectFinish;
    if (_isSelectFinish == NO) {
        for (int i= 0 ; i < _dataArr.count; i++) {
            ProCollModel* model = _dataArr[i];
            if ([model.isselect integerValue] == 1) {
                [_delIDArray addObject:model];
            }
        }
        //点击编辑
        if (!IsEmptyValue(_delIDArray)) {
            [self DelProductCollectRequest:sender];
        }
        _deleteView.hidden = YES;
        [_tbView setEditing:NO animated:YES];
    }else{
        //点击完成
        [sender setTitle:@"删除" forState:UIControlStateNormal];
        [_tbView reloadData];
        _deleteView.hidden = NO;
         [_tbView setEditing:YES animated:YES];
    }
}

- (void)deAllSelect:(UIButton*)sender
{
    
    if (_isSelectFinish == YES) {
        if (_isSelectAll == YES) {
            
            //取消全部选中
            for (int i = 0 ; i < _dataArr.count ; i++) {
                ProCollModel *model = _dataArr[i];
                model.isselect = @"0";
                _isSelectAll = NO;
                [_delIDArray removeAllObjects];
                NSIndexPath * selIndex = [NSIndexPath indexPathForRow:i inSection:0];
                [_tbView deselectRowAtIndexPath:selIndex animated:YES];
            }
            _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
//            [_tbView reloadData];
            
        }else{
            //全部选中
            for (int i = 0 ; i < _dataArr.count ; i++) {
                ProCollModel *model = _dataArr[i];
                model.isselect = @"1";
                [_delIDArray addObject:model];
                NSIndexPath * selIndex = [NSIndexPath indexPathForRow:i inSection:0];
                [_tbView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            _isSelectAll = YES;
            _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
//            [_tbView reloadData];
        }
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IsEmptyValue(_dataArr)) {
        return 0;
    }else{
        return _dataArr.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId1 = @"MineNewCollectTableViewCellID";
    MineNewCollectTableViewCell * cell = (MineNewCollectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId1];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineNewCollectTableViewCell" owner:self options:nil]firstObject];
    }
    cell.buyCarBtn.userInteractionEnabled = YES;
    cell.buyCarBtn.tag = indexPath.row;
    cell.delegate = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count != 0) {
        ProCollModel *model = _dataArr[indexPath.row];
        cell.model = model;
    }
    if (!IsEmptyValue(_dataArr)) {
        ProCollModel* model = _dataArr[indexPath.item];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.proname];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
//        cell.saleCountLabel.text = [NSString stringWithFormat:@"销量%@",model.prosale];
        if ([model.isgolds integerValue] == 1) {
            if (IsEmptyValue(model.price)) {
                cell.priceLabel.text = [NSString stringWithFormat:@"金币0"];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"金币%@",model.price];
            }
        }else if ([model.isgolds integerValue] == 0){
            if (IsEmptyValue(model.price)) {
                cell.priceLabel.text = [NSString stringWithFormat:@"0"];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
            }
        }
    }
    
    [cell setNeedsLayout];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;//表示多选状态
}

//协议中取消选中tableView中某行时被调用
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tbView.editing) {
        //把之前选中的行号扔掉
        ProCollModel* model = _dataArr[indexPath.row];
        model.isselect = @"0";
        [_delIDArray removeObject:model];
        [_indexSetToDel removeIndex:indexPath.row];
        if (_delIDArray.count == _dataArr.count) {
            _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
        }else{
            _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        }
    }
}

 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tbView.editing) {
        //是编辑状态，记录选中的行号做数组下标
        ProCollModel* model = _dataArr[indexPath.row];
        model.isselect = @"1";
        [_delIDArray addObject:model];
        [_indexSetToDel addIndex:indexPath.row];
        if (_delIDArray.count == _dataArr.count) {
            _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
        }else{
            _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        }
    }else{
        if (_dataArr.count!=0) {
            ProCollModel* model = _dataArr[indexPath.row];
            ProDetailTbViewController* detailVC = [[ProDetailTbViewController alloc]init];
            if (!IsEmptyValue(model.proid)) {
                if ([model.isgolds integerValue] == 0) {
                    detailVC.proid = model.proid;
                    detailVC.typepro = typeProGoods;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }else{
                    detailVC.proid = model.proid;
                    detailVC.typepro = typeProPoint;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
            }
        }
    }
}

- (void)addBuyCarClick:(UIButton*)sender
{
    //tag  ＝ 110 ＋i
    NSLog(@"Tag%zi",sender.tag);
    NSInteger selet = sender.tag;
    ProCollModel* model = [[ProCollModel alloc]init];
    model = _dataArr[selet];
    /*
     /cart/addCart.do
     mobile:true
     data{
     custid:客户id
     proid:产品id
     proname:产品名称
     count:数量
     saleprice:产品单价
     totalprice:产品总价
     specification:规格
     prounitid:单位
     prounitname:单位名称
     isgolds://是否是积分商城中的商品
     pickupway //是否自取，1，自取；2，配送
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    sender.enabled = NO;
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    model.Id = [self convertNull:model.Id];
    model.proname = [self convertNull:model.proname];
    model.price = [self convertNull:model.price];
    double totlemoney = [model.price doubleValue]*1;
    NSString* totlestr = [NSString stringWithFormat:@"%.2f",totlemoney];
    model.specification = [self convertNull:model.specification];
    model.mainunitid = [self convertNull:model.mainunitid];
    model.mainunitname = [self convertNull:model.mainunitname];
    model.prono = [self convertNull:model.prono];
//    model.pickupway = [self convertNull:model.pickupway];
    NSString* pickupway = @"0";
//    NSString* isgolds ;
//    isgolds = @"0";
    model.isgolds = [self convertNull:model.isgolds];
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/addCart.do"];
    NSString* cartliststr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"count\":\"%@\",\"saleprice\":\"%@\",\"totalprice\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"isgolds\":\"%@\",\"pickupway\":\"%@\"}",userid,model.proid,model.proname,model.prono,[NSString stringWithFormat:@"%i",1],model.price,totlestr,model.specification,model.mainunitid,model.mainunitname,model.isgolds,pickupway];
    NSString* datastr = [NSString stringWithFormat:@"{\"cartlist\":[%@]}",cartliststr];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        [hud hide:YES];
        sender.enabled = YES;
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
        sender.enabled = YES;
        NSLog(@"添加购物车成功%@",error.localizedDescription);
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _proArray.count ;
}
#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((mScreenWidth - 25)/2, CollCellHight);
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



- (void)dataRequest
{
    /*
     /product/searchproductcollect.do
     mobile:true
     data{
     provinceid
     cityid
     areaid
     custid
     page
     rows
     }
     */
    if (_page == 1) {
        [_dataArr removeAllObjects];
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
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/searchproductcollect.do"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"true" forKey:@"mobile"];
    NSString* datastr = [NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"custid\":\"%@\",\"page\":\"%@\",\"rows\":\"%@\"}",provinceid,cityid,areaid,userid,[NSString stringWithFormat:@"%li",(long)_page],ROWS];
    [params setObject:datastr forKey:@"data"];
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"收藏列表查询返回str%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"list"];
            if (array.count!=0) {
                for (NSDictionary* dict in array) {
                    ProCollModel* model = [[ProCollModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [_dataArr addObject:model];
                }
            }
//            [_tbView reloadData];
//            if (_dataArr.count == 0) {
//                [self emptyUI];
//            }
            if (_dataArr.count!=0) {
                for (UIView* view in self.view.subviews) {
                    [view removeFromSuperview];
                }
                [self creatUI];
                [_tbView reloadData];
            }else{
                [_tbView removeFromSuperview];
                [self emptyUI];
                [_bottomView setFrame:CGRectMake(0, creatEmptyHeight + 5, ScreenWidth, 870)];
                NSInteger count;
                NSInteger itemsinrow = 2;
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
    } fail:^(NSError *error) {
        NSLog(@"收藏列表失败返回%@",error.localizedFailureReason);
        [self showAlert:error.localizedFailureReason];
    }];
}

- (void)DelProductCollectRequest:(UIButton*)sender{
    /*
     /product/delproductcollect.do
     mobile:true
     data{
     ids:1,2,3
     custid:用户id
     }
     */
    NSMutableString* delestr = [[NSMutableString alloc]initWithString:@""];
    for (int i = 0; i < _delIDArray.count; i++) {
        ProCollModel* model = _delIDArray[i];
        NSString* str = [NSString stringWithFormat:@"%@,",model.Id];
        [delestr appendString:str];
    }
    NSString* idstr = delestr;
    NSRange range = {0,idstr.length - 1};
    idstr = [idstr substringWithRange:range];
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/delproductcollect.do"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"true" forKey:@"mobile"];
    NSString* userstr = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userstr = [self convertNull:userstr];
    NSString* datastr = [NSString stringWithFormat:@"{\"ids\":\"%@\",\"custid\":\"%@\"}",idstr,userstr];//,\"\":\"\"
    [params setObject:datastr forKey:@"data"];
    NSLog(@"删除收藏传参数%@",params);
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"删除收藏返回str%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            [self showAlert:@"登录失效请重新登录"];
            LoginNewViewController* VC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:VC animated:NO];
            
        }else{
            if ([str rangeOfString:@"true"].location != NSNotFound) {
                [self showAlert:@"删除收藏成功"];
                [sender setTitle:@"编辑" forState:UIControlStateNormal];
                [_delIDArray removeAllObjects];
                if (_isSelectAll == YES) {
                    _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
                }
                _page = 1;
                [self dataRequest];
            }else{
                [self showAlert:@"删除收藏不成功"];
            }
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [self showAlert:error.localizedDescription];
        NSLog(@"删除收藏失败%@",error.localizedDescription);
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
            NSInteger itemsinrow = 2;
            if (_proArray.count%itemsinrow != 0) {
                count = _proArray.count/itemsinrow + 1;
            }else if (_proArray.count%itemsinrow == 0){
                count = _proArray.count/itemsinrow;
            }
            _mainScrollView.contentSize = CGSizeMake(0, _dataArr.count* cellHeight + (CollCellHight+5) * count + 40);
            [_proCollectionView setFrame:CGRectMake(10, _proCollectionView.top, ScreenWidth-20 , (CollCellHight+5)*count + 50)];
            [_proCollectionView reloadData];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"加载失败");
    }];
    
}



@end
