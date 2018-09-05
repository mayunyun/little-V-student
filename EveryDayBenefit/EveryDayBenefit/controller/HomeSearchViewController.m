//
//  HomeSearchViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/15.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeSearchViewController.h"
#import "EmptyCollectionViewCell.h"

@interface HomeSearchViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
{
    UIView* _navBarView;
    UIView* _bgFirstView;
    UIScrollView* _bgSecondView;
    NSArray* _hotArray;
    UISearchController*_searchController;
    UIScrollView* _searchbgView;
    UITableView* _searchTbView;
}
@property (nonatomic,strong)UITextField* searchTextField;
@property (nonatomic,strong)UICollectionView* hotCollView;
@property (nonatomic,strong)UIScrollView* firstView;
@property (nonatomic,strong)UITableView* historyTbView;
@property(nonatomic,strong)NSArray*historyArray;
@property(nonatomic,strong)NSArray*searchResults;

@end

@implementation HomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNavBarView];
    [self creatUI];
    [self hotRequest];
    [self historyRequest];
//    [self creatsearchUI];
//    [self dataRequest];
}


#pragma mark ---- 原生界面
- (UIView*)creatNavBarView
{
    _navBarView.hidden = NO;
    if (_navBarView==nil) {
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth - 70, 40)];
        _navBarView.userInteractionEnabled = YES;
        _navBarView.backgroundColor = [UIColor redColor];
        self.navigationItem.titleView = _navBarView;
        
        UIButton* leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBarBtn.frame = CGRectMake(0, 0, 30, 40);
        UIImageView* leftBarimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 10, 20)];
        leftBarimgView.image = [UIImage imageNamed:@"icon-back"];
        [leftBarBtn addSubview:leftBarimgView];
        [leftBarBtn addTarget:self action:@selector(BackClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* left = [[UIBarButtonItem alloc]initWithCustomView:leftBarBtn];
        self.navigationItem.leftBarButtonItem = left;
        
        UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.frame = CGRectMake(_navBarView.right - 40, 5, 40, 30);
        [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [rightBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor grayColor];
        rightBtn.layer.masksToBounds = YES;
        rightBtn.layer.cornerRadius = 5.0;
        [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = right;
        
//        UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        searchBtn.layer.masksToBounds = YES;
//        searchBtn.layer.cornerRadius = 5;
//        searchBtn.userInteractionEnabled = YES;
//        searchBtn.frame = CGRectMake(0, 0, _navBarView.width - rightBtn.width, 40);
//        searchBtn.backgroundColor = [UIColor whiteColor];
//        searchBtn.alpha = 0.5;
//        [_navBarView addSubview:searchBtn];
//        UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//        searchImgView.userInteractionEnabled = YES;
//        searchImgView.image = [UIImage imageNamed:@"icon-search"];
//        [searchBtn addSubview:searchImgView];
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick:)];
//        [searchImgView addGestureRecognizer:tap];
//        _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right+5, 0, searchBtn.width-searchImgView.width - 40, 30)];
//        _searchTextField.delegate = self;
//        [_searchTextField setPlaceholder:@"  输入商品查找"];
//        [searchBtn addSubview:_searchTextField];
        
    }
    return _navBarView;
    
}

- (void)creatUI
{
    _bgFirstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    _bgFirstView.backgroundColor = BackGorundColor;
    [self.view addSubview:_bgFirstView];

    UIView* firstWightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    firstWightView.backgroundColor = [UIColor whiteColor];
    [_bgFirstView addSubview:firstWightView];
    
    UILabel* hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, firstWightView.height)];
    hotLabel.backgroundColor = [UIColor whiteColor];
    hotLabel.text = @"热门搜索";
    hotLabel.font = [UIFont systemFontOfSize:13];
    hotLabel.textColor = GrayTitleColor;
    [firstWightView addSubview:hotLabel];
    
    _firstView = [[UIScrollView alloc]initWithFrame:CGRectMake(hotLabel.right, 0, mScreenWidth - hotLabel.right, 50)];
    _firstView.backgroundColor = [UIColor whiteColor];
    _firstView.showsVerticalScrollIndicator = NO;
    _firstView.showsHorizontalScrollIndicator = NO;
    [firstWightView addSubview:_firstView];
    
    UICollectionViewFlowLayout* hotLayOut = [[UICollectionViewFlowLayout alloc]init];
    hotLayOut.minimumLineSpacing = 5;
    hotLayOut.minimumInteritemSpacing = 5;
    _hotCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , _firstView.width - hotLabel.right, 50) collectionViewLayout:hotLayOut];
    _hotCollView.backgroundColor = [UIColor whiteColor];
    _hotCollView.delegate = self;
    _hotCollView.dataSource = self;
    _hotCollView.scrollEnabled = NO;
    _hotCollView.showsVerticalScrollIndicator = NO;
    _hotCollView.showsHorizontalScrollIndicator = NO;
    [_firstView addSubview:_hotCollView];
    
    UILabel* historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(hotLabel.left, firstWightView.bottom, mScreenWidth - hotLabel.left, 30)];
    historyLabel.text = @"搜索历史";
    historyLabel.font = [UIFont systemFontOfSize:13];
    [_bgFirstView addSubview:historyLabel];
    
    _historyTbView = [[UITableView alloc]initWithFrame:CGRectMake(0, historyLabel.bottom, mScreenWidth, _bgFirstView.height - historyLabel.bottom)];
    _historyTbView.delegate = self;
    _historyTbView.dataSource = self;
    [_bgFirstView addSubview:_historyTbView];
    
    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater=self;
    _searchController.delegate = self;
    //是否是要设置背景色为般透明色
    _searchController.dimsBackgroundDuringPresentation=YES;
    _searchController.hidesNavigationBarDuringPresentation = NO;     //是否隐藏导航栏
    //必须要设置一个属性,否则无法显示
    [_searchController.searchBar sizeToFit];
    self.navigationItem.titleView=_searchController.searchBar;
}

- (void)creatsearchUI
{
    _searchbgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    [self.view addSubview:_searchbgView];
    _searchTbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _searchbgView.width, _searchbgView.height)];
    _searchTbView.delegate = self;
    _searchTbView.dataSource = self;
    [_searchbgView addSubview:_searchTbView];
    _searchbgView.hidden = YES;
}

- (void)BackClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{

}


- (void)searchClick:(UIButton*)sender
{

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!IsEmptyValue(_hotArray)) {
        return _hotArray.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *HomeSelarCellID = @"EmptyCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"EmptyCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    EmptyCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (!IsEmptyValue(_hotArray)) {
        cell.titleLabel.text = _hotArray[indexPath.row];
    }
    [self framAdd:cell];
    return cell;

}

- (void)framAdd:(id)sender
{
    CALayer *layer = [sender layer];
    layer.borderColor = [UIColor lightGrayColor].CGColor;
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

#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 50);
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld",(long)indexPath.row);
}

- (void)hotRequest
{
    _hotArray = @[@"北京",@"上海",@"hotArray",@"济南",@"广州",@"北京",@"上海",@"hotArray",@"济南",@"广州",@"北京",@"上海",@"hotArray",@"济南",@"广州"];
    _hotCollView.frame = CGRectMake(_hotCollView.left, _hotCollView.top, _hotArray.count*(60+5), _hotCollView.height);
    _hotCollView.contentSize = CGSizeMake(_hotArray.count*65, 50);
    _firstView.contentSize = CGSizeMake(_hotArray.count*65, _firstView.height);
    [_hotCollView reloadData];
}

- (void)historyRequest
{
    _historyArray = @[@"histArray",@"济南",@"广州",@"北京",@"上海",@"hotArray",@"济南",@"广州",@"北京",@"上海",@"hotArray",@"济南",@"广州"];
    [_historyTbView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == _historyTbView) {
        if (IsEmptyValue(_historyArray)) {
            return 0;
        }else{
//            return _historyArray.count;
            if (_searchController.active) {
                return self.searchResults.count;
            } else {
                return self.historyArray.count;
            }
        }
//    }else{
//        if (IsEmptyValue(_dataArray)) {
//            return 0;
//        }else{
//            if (_searchController.active) {
//                return self.searchResults.count;
//            } else {
//                return self.dataArray.count;
//            }
//        }
//    }

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
//    if (tableView == _historyTbView) {
        if (!IsEmptyValue(_historyArray)) {
            if (_searchController.active) {
                cell.textLabel.text = self.searchResults[indexPath.row];
            } else {
                cell.textLabel.text=self.historyArray[indexPath.row];
            }
        }
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTbView ) {
        NSLog(@"点击了_historyTbView第%ld个cell",(long)indexPath.row);
    }else{
        NSLog(@"点击了_searchTbView第%ld个cell",(long)indexPath.row);
    }
    
}

#pragma mark 实现协议方法
//协议中的方法，每当用户在searchBar中输入的内容发生变化时，这个方法就会被调用，我们可以在这里根据用户输入的内容对数组中的内容进行过滤，找到要搜索的内容。
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //filteredArrayUsingPredicate:这个方法是根据参数指定的谓词（NSPredicate）对self.dataArray中的内容进行过滤
    //谓词中OC中的类，用于指定对数组进行过滤的条件
    //predicateWithBlock是NSPredicate中的类方法，用来生成一个谓词对象，其参数是一个Block，用于指定数组过淲的条件。
    //filteredArrayUsingPredicate方法执行时会遍历数组self.dataArray中的每一个元素，每遍历到一个元素就调用Block中的方法。evaluatedObject就是当前被遍历到的数组元素。我们可以在Block中判断这个元素是否符合过滤条件（搜索条件），如果符合搜索条件该Blick返回YES、否则返回NO。filteredArrayUsingPredicate方法的返回值就是新生成的数组，数组中元素就是符合过滤条件（搜索条件）的元素。
    
        self.searchResults = [self.historyArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject hasPrefix:_searchController.searchBar.text];
        }]];
        //UISearchController并没有像UISearchDisplayController那样自动创建了一个tableView，而是我们要用原来的那个tableView既显示原始数据又显示搜索结果。所以这里要对_tableView刷新一下
        [_historyTbView reloadData];
}
- (void)willPresentSearchController:(UISearchController *)searchController{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    
    
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    
   
}



@end
