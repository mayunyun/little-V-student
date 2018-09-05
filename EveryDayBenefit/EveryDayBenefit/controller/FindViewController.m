//
//  FindViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "FindViewController.h"
#import "FindTableViewCell.h"
#import "MBProgressHUD.h"
//#import "ProDetailViewController.h"
#import "ProDetailTbViewController.h"
#import "FineProListModel.h"

#import "PeopleOnLineViewController.h"
#import "HomeHotGoodsViewController.h"
#import "ORCodeViewController.h"
#import "LoginNewViewController.h"

@interface FindViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD* _hud;
    UIView* _navBarView;
    UITextField* _searchTextField;
    UITableView* _tbView;
    NSInteger _page;
    NSMutableArray* _imageHeightArray;
    
}
@property (nonatomic,strong)NSMutableArray* tbdataArray;


@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tbdataArray = [[NSMutableArray alloc]init];
    _imageHeightArray = [[NSMutableArray alloc]init];
    [self creatNavUI];
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
    [self dataRequest];
}


//- (UIView*)creatNavUI
//{
//    _navBarView.hidden = NO;
//    if (_navBarView==nil) {
//        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth - 20, 40)];
//        _navBarView.userInteractionEnabled = YES;
//        _navBarView.backgroundColor = [UIColor clearColor];
//        self.navigationItem.titleView = _navBarView;
//        
//        UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        leftBtn.frame = CGRectMake(0, 5, 30, 30);
//        [leftBtn setBackgroundColor:[UIColor clearColor]];
//        [leftBtn setImage:[UIImage imageNamed:@"icon-1"] forState:UIControlStateNormal];
//        [leftBtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
////        [_navBarView addSubview:leftBtn];
//        
//        
//        UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightBtn.frame = CGRectMake(_navBarView.right - 30, 5, 30, 30);
//        UIImageView* rightimgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, 20, 20)];
//        rightimgView.image = [UIImage imageNamed:@"icon-h"];
//        [rightBtn addSubview:rightimgView];
//        [rightBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
////        [_navBarView addSubview:rightBtn];
//        
//        
//        UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        searchBtn.layer.masksToBounds = YES;
//        searchBtn.layer.cornerRadius = 5;
//        searchBtn.userInteractionEnabled = YES;
//        searchBtn.frame = CGRectMake(leftBtn.right, 0, _navBarView.width - rightBtn.width - leftBtn.width, 40);
//        searchBtn.backgroundColor = [UIColor whiteColor];
//        searchBtn.alpha = 0.5;
//        [_navBarView addSubview:searchBtn];
//        UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        searchImgView.userInteractionEnabled = YES;
//        searchImgView.image = [UIImage imageNamed:@"icon-search"];
//        [searchBtn addSubview:searchImgView];
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick:)];
//        [searchImgView addGestureRecognizer:tap];
//        
//        _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right+5, 0, searchBtn.width-searchImgView.width - 40, 30)];
//        _searchTextField.delegate = self;
//        [_searchTextField setPlaceholder:@"  输入商品查找"];
//        [searchBtn addSubview:_searchTextField];
//    }
//    return _navBarView;
//
//}

#pragma mark ---- 原生界面
- (UIView*)creatNavUI
{
    if (_navBarView==nil) {
        _navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth - 20, 40)];
        _navBarView.userInteractionEnabled = YES;
        _navBarView.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = _navBarView;
        self.navigationItem.titleView.frame = CGRectMake(0, 20, mScreenWidth - 20, 40) ;
        UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.layer.masksToBounds = YES;
        searchBtn.layer.cornerRadius = 5;
        searchBtn.layer.borderColor = [UIColor grayColor].CGColor;
        searchBtn.layer.borderWidth = .5;
        searchBtn.userInteractionEnabled = YES;
        searchBtn.frame = CGRectMake(+10, 3, _navBarView.width - 10 - 5 , 40 - 6);
        searchBtn.backgroundColor = [UIColor whiteColor];
        searchBtn.alpha = 0.5;
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
        [searchBtn addSubview:erweimaImgView];
        UITapGestureRecognizer* erweimatap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(erweimaClick:)];
        [erweimaImgView addGestureRecognizer:erweimatap];
        
        
        _searchTextField= [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right+5, 0, searchBtn.width-searchImgView.width - 40, 30)];
        _searchTextField.delegate = self;
        [_searchTextField setPlaceholder:@"  输入商品查找"];
        [searchBtn addSubview:_searchTextField];
    }
    return _navBarView;
    
}



- (void)creatUI
{
    self.view.backgroundColor = BackGorundColor;
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, mScreenWidth, mScreenHeight - 64 - 10 - 49) style:UITableViewStylePlain];
    _tbView.rowHeight = 280;
    _tbView.backgroundColor = BackGorundColor;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tbView];
    [self setExtraCellLineHidden:_tbView];
     //下拉刷新
        _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
            _page = 1;
            [_tbdataArray removeAllObjects];
            [self dataRequest];
            // 结束刷新
            [_tbView.mj_header endRefreshing];
    
        }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self dataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];
}

//取消多余cell
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)leftBarClick:(UIButton*)sender
{
     [self.tabBarController setSelectedIndex:0];
}

- (void)rightBarClick:(UIButton*)sender
{
    PeopleOnLineViewController* peopleVC = [[PeopleOnLineViewController alloc]init];
    [self.navigationController pushViewController:peopleVC animated:YES];
}

- (void)searchClick:(UITapGestureRecognizer*)sender
{
    HomeHotGoodsViewController* hotVC = [[HomeHotGoodsViewController alloc]init];
    [self.navigationController pushViewController:hotVC animated:YES];
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


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        HomeHotGoodsViewController* hotVC = [[HomeHotGoodsViewController alloc]init];
        hotVC.text = textField.text;
        [self.navigationController pushViewController:hotVC animated:YES];
        textField.text = @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IsEmptyValue(_tbdataArray)) {
        return 0;
    }else{
        return _tbdataArray.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 先从缓存中查找图片
    FineProListModel* model = _tbdataArray[indexPath.row];
    NSString *imgURL = [NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    // 没有找到已下载的图片就使用默认的占位图
    if (!image) {
        image = [UIImage imageNamed:@"default_img_cell"];
    }
    CGFloat imgHeight = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
    NSLog(@"indexpath.row = %ld, height = %.2f",indexPath.row, imgHeight);
    
    return imgHeight;
}

- (void)configureCell:(FindTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FineProListModel* model = _tbdataArray[indexPath.row];
    NSString *imgURL = [NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
    
    if ( !cachedImage ) {
        [self downloadImage:imgURL forIndexPath:indexPath];
        cell.image = [UIImage imageNamed:@"default"];
    } else {
        cell.image = cachedImage;;
    }
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    // 利用 SDWebImage 框架提供的功能下载图片
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        if (image) {
//            [[SDImageCache sharedImageCache] storeImage:image forKey:self.datas[indexPath.row] toDisk:YES completion:^{
//                
//            }];
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [self.tableView reloadData];
//            });
//        }
//    }];
    NSURL*url = [NSURL URLWithString:imageURL];
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:url  options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
            FineProListModel* model = _tbdataArray[indexPath.row];
            NSString *imgURL = [NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname];
            [[SDImageCache sharedImageCache] storeImage:image forKey:imgURL toDisk:YES ];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tbView reloadData];
            });
        }

    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellID = [NSString stringWithFormat:@"FindTableViewCellID%ld%ld",(long)indexPath.section,(long)indexPath.row];
//    static NSString* cellID = @"FindTableViewCellID";
    FindTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FindTableViewCell" owner:self options:nil]firstObject];
    }
    [self configureCell:cell atIndexPath:indexPath];
//    if (!IsEmptyValue(_tbdataArray)) {
//        FineProListModel* model = _tbdataArray[indexPath.row];
//        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
//        cell.imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [cell setNeedsDisplay];
////        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_banner"] options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////            cell.imgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
////            cell.contentHight.constant = image.size.height;
////            NSLog(@"高度的变化%f",cell.contentHight.constant);
////            [_imageHeightArray addObject:[NSString stringWithFormat:@"%f",image.size.height]];
////        }];
////        NSLog(@"高度的变化---%f",cell.contentHight.constant);
////        [tableView layoutIfNeeded];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ProDetailViewController* vc = [[ProDetailViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    if (!IsEmptyValue(_tbdataArray)) {
        FineProListModel* model = _tbdataArray[indexPath.row];
        ProDetailTbViewController* vc = [[ProDetailTbViewController alloc]init];
        vc.proid = model.proid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dataRequest
{
    /*
     /product/findProduct.do
     mobile:true
     data{
     provinceid&cityid&areaid 客户定位省市区域的id
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
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/findProduct.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    NSString* datastr = [NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",provinceid,cityid,areaid];
    [parmas setObject:datastr forKey:@"data"];
    [parmas setObject:@"ture" forKey:@"mobile"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"发现信息返回%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [_tbdataArray removeAllObjects];
        for (int i = 0; i < array.count; i++) {
            FineProListModel* model = [[FineProListModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [_tbdataArray addObject:model];
        }
        [_tbView reloadData];
        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"发现信息返回失败%@",error.localizedDescription);
        [_hud hide:YES];
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
                ProDetailTbViewController* prodetailVC = [[ProDetailTbViewController alloc]init];
                prodetailVC.proid = proid;
                [self.navigationController pushViewController:prodetailVC animated:YES];
            }
        }
        
    } fail:^(NSError *error) {
        NSLog(@"商品详情请求失败%@",urlstr);
        
    }];
    
}



@end
