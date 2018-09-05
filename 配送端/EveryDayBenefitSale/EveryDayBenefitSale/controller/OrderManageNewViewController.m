//
//  OrderManageNewViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/19.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderManageNewViewController.h"
#define cellHight 110
#import "MBProgressHUD.h"
#import "OrderManageListModel.h"
#import "OrderManageProTableViewCell.h"
#import "OrderDetailReceiveViewController.h"
#import "LoginViewController.h"
#define blueColorN [UIColor colorWithHexString:@"005dc1"]

@interface OrderManageNewViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIButton *_selectButton;
    UIScrollView* _groundScrollView;
    UITableView* _tbView;//全部评价
    UITableView* _willtbView;
    UITableView* _ingtbView;
    UITableView* _edtbView;
    NSString* _selectFlag;
    NSInteger _page;
    NSInteger _page1;
    NSInteger _page2;
    NSInteger _page3;
    UIView* _navBarView;
    UITextField* _searchTextField;
}
@property (nonatomic,strong)NSMutableArray* btnArray;
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)NSMutableArray* willDataArray;
@property (nonatomic,strong)NSMutableArray* ingDataArray;
@property (nonatomic,strong)NSMutableArray* edDataArray;
@property (nonatomic,strong)NSMutableDictionary* offscreenCells;


@end

@implementation OrderManageNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _willDataArray = [[NSMutableArray alloc]init];
    _edDataArray = [[NSMutableArray alloc]init];
    _ingDataArray = [[NSMutableArray alloc]init];
    _offscreenCells = [[NSMutableDictionary alloc]init];
    _page = 1;
    _page1 = 1;
    _page2 = 1;
    _page3 = 1;
    [self creatUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    _selectFlag = @"";
    [self searchOrderDataRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)creatUI
{
    self.view.backgroundColor = BackGorundColor;
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 64)];
    [self.view addSubview:backView];
    UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(10, 20, mScreenWidth/2, 40);
    UIImageView* leftBarimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
    leftBarimgView.image = [UIImage imageNamed:@"icon-back"];
    [leftBarBtn addSubview:leftBarimgView];
    UILabel* leftBarLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftBarimgView.right+5, 0, leftBarBtn.width - leftBarimgView.width, 40)];
    leftBarLabel.text = @"我的订单";
    [leftBarBtn addSubview:leftBarLabel];
    [leftBarBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:leftBarBtn];
    
    UIView* searchView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.bottom, mScreenWidth, 40)];
    [self.view addSubview:searchView];
    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, mScreenWidth - 80 - 30, 35)];
    _searchTextField.backgroundColor = [UIColor clearColor];
    _searchTextField.layer.borderWidth = 1.0f;
    _searchTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchTextField.layer.masksToBounds = YES;
    _searchTextField.layer.cornerRadius = 12;
    _searchTextField.font = [UIFont systemFontOfSize:13];
    _searchTextField.delegate = self;
    _searchTextField.placeholder = @" 请输入订单号或关键字";
    [searchView addSubview:_searchTextField];
    UIImageView* searchimg = [[UIImageView alloc]initWithFrame:CGRectMake(_searchTextField.right - 30, (searchView.height - 20)*0.5, 20, 20)];
    searchimg.image = [UIImage imageNamed:@"icon-search"];
    [searchView addSubview:searchimg];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(_searchTextField.right+5, 5, 80, 30);
    btn.backgroundColor = blueColorN;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.0;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"搜订单" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchOrderno:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btn];
    
    
    UIView* btnView = [[UIView alloc]initWithFrame:CGRectMake(0, searchView.bottom, mScreenWidth, 40)];
    btnView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnView];
    
    NSArray* titleLabelArr = @[@"全部",@"待配送",@"配送中",@"已完成"];
    CGFloat width = (mScreenWidth - 50)/titleLabelArr.count;
    CGFloat gapWidth = 10;
    for (int i = 0; i < titleLabelArr.count; i ++) {
        UIButton* titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.backgroundColor = [UIColor clearColor];
        titleBtn.tag = 100+i;
        titleBtn.frame = CGRectMake(gapWidth+width*i+gapWidth*i, 0, width, btnView.height);
        [btnView addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleBtn.width, btnView.height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.tag = 200+i;
        titleLabel.text = titleLabelArr[i];
        [titleBtn addSubview:titleLabel];
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, titleBtn.bottom - 1, titleBtn.width, 2)];
        line.tag = 400+i;
        [titleBtn addSubview:line];
        [_btnArray addObject:titleBtn];
        if (titleBtn.tag == 100) {
            _selectButton = titleBtn;
            _selectButton.selected = YES;
            titleLabel.textColor = blueColorN;
            line.backgroundColor = blueColorN;
        }
        
    }
    _groundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, btnView.bottom, mScreenWidth,mScreenHeight - 64 - 49 - btnView.height - 40)];
    _groundScrollView.delegate = self;
    _groundScrollView.bounces = NO;
    _groundScrollView.pagingEnabled = YES;
    _groundScrollView.alwaysBounceVertical = NO;
    _groundScrollView.contentSize = CGSizeMake(mScreenWidth*4, mScreenHeight - 64 - 50);
    [self.view addSubview:_groundScrollView];
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth,_groundScrollView.height)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.rowHeight = 150;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_tbView];
    
    _willtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth, 0, mScreenWidth, _groundScrollView.height)];
    _willtbView.delegate = self;
    _willtbView.dataSource = self;
    _willtbView.rowHeight = 150;
    _willtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_willtbView];
    
    _edtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth*3, 0, mScreenWidth, _groundScrollView.height)];
    _edtbView.delegate = self;
    _edtbView.dataSource = self;
    _edtbView.rowHeight = 150;
    _edtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_edtbView];
    
    _ingtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth*2, 0, mScreenWidth, _groundScrollView.height)];
    _ingtbView.delegate = self;
    _ingtbView.dataSource = self;
    _ingtbView.rowHeight = 150;
    _ingtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_ingtbView];
    _tbView.estimatedRowHeight = 50.0f;
    _tbView.rowHeight = UITableViewAutomaticDimension;
    _willtbView.estimatedRowHeight = 50.0f;
    _willtbView.rowHeight = UITableViewAutomaticDimension;
    _ingtbView.estimatedRowHeight = 50.0;
    _ingtbView.rowHeight = UITableViewAutomaticDimension;
    _edtbView.estimatedRowHeight = 50.0;
    _edtbView.rowHeight = UITableViewAutomaticDimension;
    
    //     下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        _tbView.mj_footer.hidden = NO;
        [self searchOrderDataRequest];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self searchOrderDataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];
    //     下拉刷新
    _willtbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page1 = 1;
        [_willDataArray removeAllObjects];
        _willtbView.mj_footer.hidden = NO;
        [self searchOrderDataRequest];
        // 结束刷新
        [_willtbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _willtbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _willtbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page1 ++ ;
        [self searchOrderDataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];
    //     下拉刷新
    _ingtbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page2 = 1;
        [_ingDataArray removeAllObjects];
        _ingtbView.mj_footer.hidden = NO;
        [self searchOrderDataRequest];
        // 结束刷新
        [_ingtbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _ingtbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _ingtbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page2 ++ ;
        [self searchOrderDataRequest];
        [_ingtbView.mj_footer endRefreshing];
        
    }];
    //     下拉刷新
    _edtbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page3 = 1;
        [_edDataArray removeAllObjects];
        _edtbView.mj_footer.hidden = NO;
        [self searchOrderDataRequest];
        // 结束刷新
        [_edtbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _edtbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _edtbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page3 ++ ;
        [self searchOrderDataRequest];
        [_edtbView.mj_footer endRefreshing];
        
    }];

    
    
}

#pragma mark TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (void)searchOrderno:(UIButton*)sender
{
    if (![_searchTextField.text isEqualToString:@""]) {
        [self SearchTextOrderRequest:_searchTextField.text];
    }
}

- (void)titleBtnClick:(UIButton*)sender
{
    
    if (sender != _selectButton)
    {
        _selectButton.selected = NO;
        _selectButton = sender;
        
    }
    _selectButton.selected = YES;
    [_groundScrollView setContentOffset:CGPointMake((sender.tag-100) * mScreenWidth, 0) animated:YES];
    for (int i = 0; i < 4; i++) {
        UILabel* titleLabel = (UILabel*)[self.view viewWithTag:200+i];
        UILabel* detailLabel = (UILabel*)[self.view viewWithTag:300+i];
        UIView* line = (UIView*)[self.view viewWithTag:400+i];
        titleLabel.textColor = GrayTitleColor;
        detailLabel.textColor = GrayTitleColor;
        line.backgroundColor = [UIColor clearColor];
    }
    
    UILabel* titleLabel = (UILabel*)[sender viewWithTag:200+sender.tag - 100];
    UILabel* detailLabel = (UILabel*)[sender viewWithTag:300+sender.tag - 100];
    UIView* line = (UIView*)[sender viewWithTag:400+sender.tag - 100];
    titleLabel.textColor = blueColorN;
    detailLabel.textColor = blueColorN;
    line.backgroundColor = blueColorN;
    switch (sender.tag) {
        case 100:
        {
            _selectFlag = @"";
            [self searchOrderDataRequest];
        }
            break;
        case 101:
        {
            _selectFlag = @"0";
            [self searchOrderDataRequest];
        }
            break;
        case 102:
        {
            _selectFlag = @"1";
            [self searchOrderDataRequest];
        }
            break;
        case 103:
        {
            _selectFlag = @"2";
            [self searchOrderDataRequest];
        }
            break;
            
        default:
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"---scrollViewDidEndDecelerating---");
    //随着整页滑动的相关栏目的变色及移动  对应起来好看！
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    } else if([scrollView isKindOfClass:[UIScrollView class]]){
        for (int i = 0; i < 4; i++) {
            UILabel* titleLabel = (UILabel*)[self.view viewWithTag:200+i];
            UILabel* detailLabel = (UILabel*)[self.view viewWithTag:300+i];
            UIView* line = (UIView*)[self.view viewWithTag:400+i];
            titleLabel.textColor = GrayTitleColor;
            detailLabel.textColor = GrayTitleColor;
            line.backgroundColor = [UIColor clearColor];
        }
        NSLog(@"scroView%f",scrollView.contentOffset.x);
        int i = scrollView.contentOffset.x/mScreenWidth;
        switch (i) {
            case 0:
            {
                _selectFlag = @"";
                [self searchOrderDataRequest];
            }
                break;
            case 1:
            {
                _selectFlag = @"0";
                [self searchOrderDataRequest];
            }
                break;
            case 2:
            {
                _selectFlag = @"1";
                [self searchOrderDataRequest];
            }
                break;
            case 3:
            {
                _selectFlag = @"2";
                [self searchOrderDataRequest];
            }
                break;
                
            default:
                break;
        }
        for (int j = 0; j < _btnArray.count; j++) {
            if (j == i) {
                if (_btnArray[i] != _selectButton) {
                    _selectButton.selected = NO;
                    _selectButton = _btnArray[i];
                }
                _selectButton.selected = YES;
                UILabel* titleLabel = (UILabel*)[_selectButton viewWithTag:200+_selectButton.tag - 100];
                UILabel* detailLabel = (UILabel*)[_selectButton viewWithTag:300+_selectButton.tag - 100];
                UIView* line = (UIView*)[_selectButton viewWithTag:400+_selectButton.tag - 100];
                titleLabel.textColor = blueColorN;
                detailLabel.textColor = blueColorN;
                line.backgroundColor = blueColorN;
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbView) {
        if (IsEmptyValue(_dataArray)) {
            return 0;
        }else{
            return _dataArray.count;
        }
    }else if (tableView == _willtbView){
        if (IsEmptyValue(_willDataArray)) {
            return 0;
        }else{
            return _willDataArray.count;
        }
        
    }else if (tableView == _ingtbView){
        if (IsEmptyValue(_ingDataArray)) {
            return 0;
        }else{
            return _ingDataArray.count;
        }
    }else{
        if (IsEmptyValue(_edDataArray)) {
            return 0;
        }else{
            return _edDataArray.count;
        }
        
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)&&_dataArray.count>=indexPath.section) {
            OrderManageListModel* model = _dataArray[indexPath.section];
            NSArray* prolist = model.prolist;
            return 100+80*prolist.count;
        }else{
            return 0;
        }
    }else if (tableView == _willtbView){
        if (!IsEmptyValue(_willDataArray)&&_willDataArray.count>=indexPath.section) {
            OrderManageListModel* model = _willDataArray[indexPath.section];
            NSArray* prolist = model.prolist;
            return 100+80*prolist.count;
        }else{
            return 0;
        }
    }else if (tableView == _ingtbView){
        if (!IsEmptyValue(_ingDataArray)&&_ingDataArray.count>=indexPath.section) {
            OrderManageListModel* model = _ingDataArray[indexPath.section];
            NSArray* prolist = model.prolist;
            return 100+80*prolist.count;
        }else{
            return 0;
        }
    }else{
        if (!IsEmptyValue(_edDataArray)&&_edDataArray.count>=indexPath.section) {
            OrderManageListModel* model = _edDataArray[indexPath.section];
            NSArray* prolist = model.prolist;
            return 100+80*prolist.count;
        }else{
            return 0;
        }
        
    }
    
}

- (CGFloat)detailLabelHeight:(NSString*)text width:(CGFloat)width fontsize:(NSInteger)index
{
    NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:index]};
    CGSize size1 =  [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    return size1.height+20;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString* cellID = @"cellID";
//    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
    
    static NSString* cellID = @"OrderManageProTableViewCellID";
    OrderManageProTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManageProTableViewCell" owner:self options:nil]firstObject];
    }
    cell.delBtn.hidden = YES;

    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            OrderManageListModel* model = _dataArray[indexPath.section];
            if ([model.isgolds integerValue] == 1) {
                cell.priceLabel.text = [NSString stringWithFormat:@"%@金币",model.ordermoney];//@"总金额**元";
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"%@元",model.ordermoney];//@"总金额**元";
            }
            NSString* str;
            NSString* selectStr;
            model.sendstatus = [self convertNull:model.sendstatus];
            switch ([model.sendstatus intValue]) {
                case -1:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 未分配配送人
                    selectStr = @"未分配配送人";
                }break;
                case 0:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 等待配送
                    selectStr = @"等待配送";
                }
                    break;
                case 1:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 配送中
                    selectStr = @"配送中";
                }
                    break;
                case 2:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 配送完成
                    selectStr = @"配送完成";
                }break;
                default:
                    break;
            }
            cell.countLabel.text = str;
            cell.statusLabel.text = selectStr;
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.custname];
            cell.addrLabel.text = [NSString stringWithFormat:@"%@",model.receiveraddr];
            cell.senderNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
            cell.ordernoLabel.text = [NSString stringWithFormat:@"%@",model.orderno];
            cell.prolistArr = model.prolist;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView == _willtbView){
        if (!IsEmptyValue(_willDataArray)) {
            OrderManageListModel* model = _willDataArray[indexPath.section];
            if ([model.isgolds integerValue] == 1) {
                cell.priceLabel.text = [NSString stringWithFormat:@"总金额%@金币",model.ordermoney];//@"总金额**元";
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"总金额%@元",model.ordermoney];//@"总金额**元";
            }
            NSString* str;
            NSString* selectStr;
            model.sendstatus = [self convertNull:model.sendstatus];
            switch ([model.sendstatus intValue]) {
                case -1:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 未分配配送人
                    selectStr = @"未分配配送人";
                }break;
                case 0:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 等待配送
                    selectStr = @"等待配送";
                }
                    break;
                case 1:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 配送中
                    selectStr = @"配送中";
                }
                    break;
                case 2:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 配送完成
                    selectStr = @"配送完成";
                }break;
                default:
                    break;
            }
            cell.countLabel.text = str;
            cell.statusLabel.text = selectStr;
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.custname];
            cell.addrLabel.text = [NSString stringWithFormat:@"%@",model.receiveraddr];
            cell.senderNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
            cell.ordernoLabel.text = [NSString stringWithFormat:@"%@",model.orderno];
            cell.prolistArr = model.prolist;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView == _ingtbView){
        if (!IsEmptyValue(_ingDataArray)) {
            OrderManageListModel* model = _ingDataArray[indexPath.section];
            if ([model.isgolds integerValue] == 1) {
                cell.priceLabel.text = [NSString stringWithFormat:@"总金额%@金币",model.ordermoney];//@"总金额**元";
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"总金额%@元",model.ordermoney];//@"总金额**元";
            }
            NSString* str;
            NSString* selectStr;
            model.sendstatus = [self convertNull:model.sendstatus];
            switch ([model.sendstatus intValue]) {
                case -1:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 未分配配送人
                    selectStr = @"未分配配送人";
                }break;
                case 0:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 等待配送
                    selectStr = @"等待配送";
                }
                    break;
                case 1:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 配送中
                    selectStr = @"配送中";
                }
                    break;
                case 2:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 配送完成
                    selectStr = @"配送完成";
                }break;
                default:
                    break;
            }
            cell.countLabel.text = str;
            cell.statusLabel.text = selectStr;
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.custname];
            cell.addrLabel.text = [NSString stringWithFormat:@"%@",model.receiveraddr];
            cell.senderNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
            cell.ordernoLabel.text = [NSString stringWithFormat:@"%@",model.orderno];
            cell.prolistArr = model.prolist;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView == _edtbView){
        if (!IsEmptyValue(_edDataArray)) {
            OrderManageListModel* model = _edDataArray[indexPath.section];
            if ([model.isgolds integerValue] == 1) {
                cell.priceLabel.text = [NSString stringWithFormat:@"总金额%@金币",model.ordermoney];//@"总金额**元";
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"总金额%@元",model.ordermoney];//@"总金额**元";
            }
            NSString* str;
            NSString* selectStr;
            model.sendstatus = [self convertNull:model.sendstatus];
            switch ([model.sendstatus intValue]) {
                case -1:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 未分配配送人
                    selectStr = @"未分配配送人";
                }break;
                case 0:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 等待配送
                    selectStr = @"等待配送";
                }
                    break;
                case 1:
                {
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 配送中
                    selectStr = @"配送中";
                }
                    break;
                case 2:{
                    str = [NSString stringWithFormat:@"共%@件商品",model.ordercount];// | 配送完成
                    selectStr = @"配送完成";
                }break;
                default:
                    break;
            }
            cell.countLabel.text = str;
            cell.statusLabel.text = selectStr;
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.custname];
            cell.addrLabel.text = [NSString stringWithFormat:@"%@",model.receiveraddr];
            cell.senderNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
            cell.ordernoLabel.text = [NSString stringWithFormat:@"%@",model.orderno];
            cell.prolistArr = model.prolist;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    [cell setNeedsLayout];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

//首行缩进
- (void)resetContent:(UILabel*)label text:(NSString*)text{
    //    NSString *_test  =  @"首行缩进根据字体大小自动调整 间隔可自定根据需求随意改变。。。。。。。" ;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = label.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 2.0f;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    
    label.attributedText = attrText;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            OrderManageListModel* model = _dataArray[indexPath.section];
            OrderDetailReceiveViewController* detailVC = [[OrderDetailReceiveViewController alloc]init];
            detailVC.orderNo = model.orderno;
            model.sendstatus = [self convertNull:model.sendstatus];
            detailVC.sendstatus = model.sendstatus;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else if (tableView == _willtbView){
        if (!IsEmptyValue(_willDataArray)) {
            OrderManageListModel* model = _willDataArray[indexPath.section];
            OrderDetailReceiveViewController* detailVC = [[OrderDetailReceiveViewController alloc]init];
            detailVC.orderNo = model.orderno;
            model.sendstatus = [self convertNull:model.sendstatus];
            detailVC.sendstatus = model.sendstatus;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else if (tableView == _ingtbView){
        if (!IsEmptyValue(_ingDataArray)) {
            OrderManageListModel* model = _ingDataArray[indexPath.section];
            OrderDetailReceiveViewController* detailVC = [[OrderDetailReceiveViewController alloc]init];
            detailVC.orderNo = model.orderno;
            model.sendstatus = [self convertNull:model.sendstatus];
            detailVC.sendstatus = model.sendstatus;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else if (tableView ==_edtbView){
        if (!IsEmptyValue(_edDataArray)) {
            OrderManageListModel* model = _edDataArray[indexPath.section];
            OrderDetailReceiveViewController* detailVC = [[OrderDetailReceiveViewController alloc]init];
            detailVC.orderNo = model.orderno;
            model.sendstatus = [self convertNull:model.sendstatus];
            detailVC.sendstatus = model.sendstatus;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    
}
////在scrollview上加一个tablevew，scrollview水平滑动，tableview支持滑动删除，此时两者滑动冲突
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    UIView *view = touch.view;
//    if ([view isKindOfClass:[UITableView class]] || [@"UITableViewCellContentView" isEqualToString:[[view class] description]] )
//    {
//        return NO;
//    }
//    
//    return YES;
//}

- (void)searchOrderDataRequest
{
    /*
     /order/searchOrder.do
     mobile:true
     data{
     senderid
     sendstatus:默认传空 0等待配送1配送中2配送完成""
     page
     rows
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    if (_page1 == 1) {
        [_willDataArray removeAllObjects];
    }
    if (_page2 == 1) {
        [_ingDataArray removeAllObjects];
    }
    if (_page3 == 1) {
        [_edDataArray removeAllObjects];
    }
    NSString* orderstatus;
    if (IsEmptyValue(_selectFlag)) {
        orderstatus = @"";
    }else{
        orderstatus = _selectFlag;
    }
    NSInteger page;
    if ([orderstatus isEqualToString:@""]) {
        page = _page;
    }else if([orderstatus integerValue] == 0){
        page = _page1;
    }else if ([orderstatus integerValue] == 1){
        page = _page2;
    }else if ([orderstatus integerValue] == 2){
        page = _page3;
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"senderid\":\"%@\",\"sendstatus\":\"%@\",\"page\":\"%@\",\"rows\":\"20\"}",userid,orderstatus,[NSString stringWithFormat:@"%li",(long)page]];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        [hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"searchOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i++) {
                    OrderManageListModel* model = [[OrderManageListModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    if ([orderstatus isEqualToString:@""]) {
                        [_dataArray addObject:model];
                    }else if([orderstatus integerValue] == 0){
                        [_willDataArray addObject:model];
                    }else if ([orderstatus integerValue] == 1){
                        [_ingDataArray addObject:model];
                    }else if ([orderstatus integerValue] == 2){
                        [_edDataArray addObject:model];
                    }
                }
            }
            if ([orderstatus isEqualToString:@""]) {
                [_tbView reloadData];
            }else if([orderstatus integerValue] == 0){
                [_willtbView reloadData];
            }else if ([orderstatus integerValue] == 1){
                [_ingtbView reloadData];
            }else if ([orderstatus integerValue] == 2){
                [_edtbView reloadData];
            }
            
        }
    } failureBlock:^(NSError *error) {
        [hud hide:YES];
    }];
}

- (void)SearchTextOrderRequest:(NSString*)orderno
{
    /*
     /order/searchOrderDetail.do
     data{
     orderno:订单编号
     page:1
     rows:1
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\",\"page\":\"1\",\"rows\":\"1\"}",orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        [hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/searchOrderDetail.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"/order/searchOrderDetail.do%@",array);
            if (array.count!=0) {
                OrderDetailReceiveViewController* detailVC = [[OrderDetailReceiveViewController alloc]init];
                detailVC.orderNo = [NSString stringWithFormat:@"%@",orderno];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    } failureBlock:^(NSError *error) {
        [hud hide:YES];
    }];
}


@end
