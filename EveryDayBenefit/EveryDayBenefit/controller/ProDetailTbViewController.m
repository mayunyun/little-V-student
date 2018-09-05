//
//  ProDetailTbViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/5.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ProDetailTbViewController.h"
#import "ProDetailImgTableViewCell.h"//imgViewCell
#import "ProDetailProTableViewCell.h"//proCell
#import "ProDetailMessTableViewCell.h"//messCell
#import "ProDetailCommTableViewCell.h"//commCell
#import "UIproessMy.h"//自定义进度条
#import "PayForVC.h"//收银台
#import "getProductDetailModel.h"
#import "getProductDetailImgModel.h"
#import "OrderDetailViewController.h"
#import "LoginNewViewController.h"
//#import "BuyCarVC.h"
#import "BuyCarViewController.h"
#import "GetCustInfoModel.h"
#import "ProCommentsViewController.h"
#import "UIproessMy.h"
#import "NSAttributedString+html.h"
#import "MBProgressHUD.h"
#import "YJTagView.h"


@interface ProDetailTbViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,YJTagViewDelegate,YJTagViewDataSource>
{
    MBProgressHUD* _hud;
    UIButton* _leftBarBtn;
    UIButton* _payCarBarBtn;
    UITableView* _tbView;
    UILabel* _proPayCountLabel;
    NSMutableArray* _proDetailImgArray;
    NSInteger _proPayCount;
    CGFloat _documentHeight;

    UIWebView* _webView;
    CGSize _imgsize;
    
    UIView *_typeBgview;
    NSArray *_typeArr;
    
    NSMutableArray *_typeviewheightArr;
    NSMutableArray *_typeDataArr;

}
@property (nonatomic,retain)getProductDetailModel* proDetailModel;
@property (nonatomic,retain)GetCustInfoModel* custInfoModel;
@property (nonatomic,strong)UIproessMy* proess;

@end

@implementation ProDetailTbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    _typeArr = [[NSArray alloc]init];
    _typeviewheightArr = [[NSMutableArray alloc]init];
    _proDetailImgArray = [[NSMutableArray alloc]init];
    _typeDataArr = [[NSMutableArray alloc]init];
    _proPayCount = 1;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    [self creatUI];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, 35, mScreenWidth - 20, 1)];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _leftBarBtn.hidden = NO;
    _payCarBarBtn.hidden = NO;
    if (self.typepro == typeProGoods) {
        [self dataRequest];
    }else if (self.typepro == typeProPoint){
        [self dataRequestGolds];
    }
    if ([Command islogin]) {
        [self addProductBrowerResquest];
    }
    [self addproductbrowerRequestData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _leftBarBtn.hidden = YES;
    _payCarBarBtn.hidden = YES;
}
- (UIView *)typeBgview{
    [_typeBgview removeFromSuperview];
    float height = 0;
    for (int i=0 ; i<_typeviewheightArr.count; i++) {
        
        height = height+[_typeviewheightArr[i] floatValue]+15*MYWIDTH;
    }
    _typeBgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, height+((_typeArr.count>0)?15*MYWIDTH:0))];
    _typeBgview.backgroundColor = [UIColor whiteColor];
    
    for (int i=0; i<_typeArr.count; i++) {
        float typeheight = 0;
        for (int y=0; y<_typeviewheightArr.count;y++) {
            if (i>y) {
                typeheight = typeheight+[_typeviewheightArr[y] floatValue]+15*MYWIDTH;
            }
        }
        
        UILabel * titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15*MYWIDTH, typeheight+15*MYWIDTH, 60*MYWIDTH, 20*MYWIDTH)];
        titleLabel1.font = [UIFont systemFontOfSize:14];
        titleLabel1.textColor = [UIColor blackColor];
        titleLabel1.text = [NSString stringWithFormat:@"%@:",[_typeArr[i] objectForKey:@"typename"]];
        [_typeBgview addSubview:titleLabel1];
        
        YJTagView *colorview = [[YJTagView alloc] initWithFrame:CGRectMake(109*MYWIDTH, titleLabel1.top, mScreenWidth-124*MYWIDTH, [_typeviewheightArr[i] floatValue])];
        colorview.tag = 1100+i;
        colorview.themeColor = [UIColor blueColor];
        colorview.backgroundColor = [UIColor whiteColor];
        colorview.tagCornerRadius = 0;
        colorview.dataSource = self;
        colorview.delegate = self;
        [_typeBgview addSubview:colorview];
        
    }
    return _typeBgview;
}
- (NSInteger)numOfItemstagView:(YJTagView *)tagView  {
    
    for (int i=0; i<_typeArr.count; i++) {
        if (tagView.tag == 1100+i) {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            NSMutableDictionary *dic = _typeArr[i];
            NSString *str = [dic objectForKey:@"typename"];
            [dic removeObjectForKey:@"typename"];
            for (NSString *s in [dic allValues]) {
                if (![[NSString stringWithFormat:@"%@",s] isEqualToString:@"<null>"]) {
                    [arr addObject:s];
                }
            }
            [dic setObject:str forKey:@"typename"];
            return arr.count;
        }
    }
    return 0;
}

- (NSString *)tagView:(YJTagView *)tagView titleForItemAtIndex:(NSInteger)index {
    for (int i=0; i<_typeArr.count; i++) {
        if (tagView.tag == 1100+i) {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            NSMutableDictionary *dic = _typeArr[i];
            NSString *str = [dic objectForKey:@"typename"];
            [dic removeObjectForKey:@"typename"];
            for (NSString *s in [dic allValues]) {
                if (![[NSString stringWithFormat:@"%@",s] isEqualToString:@"<null>"]) {
                    [arr addObject:s];
                }
            }
            [dic setObject:str forKey:@"typename"];
            return arr[index];
        }
    }
    
    return nil;
}
- (void)tagView:(YJTagView *)tagView heightUpdated:(CGFloat)height{
    NSLog(@">>>>>>>???>>>>>%.2f",height);
    int y=0;
    for (int i=0; i<_typeviewheightArr.count; i++) {
        if (tagView.tag == 1100+i) {
            [_typeviewheightArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.2f",height]];
        }
        if ([_typeviewheightArr[i] floatValue]==0) {
            y=1;
        }
    }
    if (y==0) {
        [_tbView reloadData];
    }
}

- (void)tagView:(YJTagView *)tagView didSelectedItemAtIndex:(NSInteger)index {
    for (int i=0; i<_typeArr.count; i++) {
        if (tagView.tag == 1100+i) {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            NSMutableDictionary *dic = _typeArr[i];
            NSString *str = [dic objectForKey:@"typename"];
            [dic removeObjectForKey:@"typename"];
            for (NSString *s in [dic allValues]) {
                if (![[NSString stringWithFormat:@"%@",s] isEqualToString:@"<null>"]) {
                    [arr addObject:s];
                }
            }
            [dic setObject:str forKey:@"typename"];
            
            [_typeDataArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",arr[index]]];
        }
    }
}
- (void)creatUI
{
    _leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBarBtn setImage:[UIImage imageNamed:@"icon-back2"] forState:UIControlStateNormal];
    _leftBarBtn.frame = CGRectMake(10, 20, 30, 30);
    [APPDelegate.window addSubview:_leftBarBtn];
    [_leftBarBtn addTarget:self action:@selector(leftBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _payCarBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payCarBarBtn setImage:[UIImage imageNamed:@"icon-gouwuce"] forState:UIControlStateNormal];
    _payCarBarBtn.frame = CGRectMake(mScreenWidth - 40, 20, 30, 30) ;
    [APPDelegate.window addSubview:_payCarBarBtn];
    [_payCarBarBtn addTarget:self action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 49)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    
    UIImageView* bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 49, mScreenWidth, 49)];
    bottomView.userInteractionEnabled = YES;
    bottomView.image = [UIImage imageNamed:@""];
    [self.view addSubview:bottomView];
    CGFloat bottomWidth = mScreenWidth/3;
    UIView* bottomleftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomWidth, bottomView.height)];
    [bottomView addSubview:bottomleftView];
    UIButton* leftReduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftReduceBtn.frame = CGRectMake(10, 10, 30, 30);
    [leftReduceBtn setImage:[UIImage imageNamed:@"icon-14"] forState:UIControlStateNormal];
    [bottomleftView addSubview:leftReduceBtn];
    [leftReduceBtn addTarget:self action:@selector(reduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* leftAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftAddBtn.frame = CGRectMake(bottomleftView.right - 30, 10, 30, 30);
    [leftAddBtn setImage:[UIImage imageNamed:@"icon-17"] forState:UIControlStateNormal];
    [bottomleftView addSubview:leftAddBtn];
    [leftAddBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _proPayCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, bottomleftView.width - 40 - 30, 20)];
    _proPayCountLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
    _proPayCountLabel.textAlignment = NSTextAlignmentCenter;
    _proPayCountLabel.textColor = NavBarItemColor;
    [bottomleftView addSubview:_proPayCountLabel];
    
    UIButton* bottomcenterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomcenterBtn.frame = CGRectMake(bottomleftView.right, 0, bottomWidth, bottomView.height);
    bottomcenterBtn.backgroundColor = COLOR(252, 209, 5, 1);
    [bottomcenterBtn setTitleColor:COLOR(50, 50, 50, 1) forState:UIControlStateNormal];
    [bottomcenterBtn setTitle:@"立即购买" forState:UIControlStateNormal];
//    [bottomcenterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    bottomcenterBtn.backgroundColor = [UIColor blackColor];
    [bottomView addSubview:bottomcenterBtn];
    [bottomcenterBtn addTarget:self action:@selector(bottomCenerClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* bottomrightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomrightBtn.frame = CGRectMake(bottomcenterBtn.right, 0, bottomWidth, bottomView.height);
    [bottomrightBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [bottomrightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomrightBtn.backgroundColor = COLOR(247, 114, 85, 1);//NavBarItemColor;
    [bottomView addSubview:bottomrightBtn];
    [bottomrightBtn addTarget:self action:@selector(bottomRightClick:) forControlEvents:UIControlEventTouchUpInside];


}

- (void)leftBarClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
//    BuyCarVC* buyCarVC = [[BuyCarVC alloc]init];
//    [self.navigationController pushViewController:buyCarVC animated:YES];
    BuyCarViewController* buyCarVC = [[BuyCarViewController alloc]init];
    [self.navigationController pushViewController:buyCarVC animated:YES];
}

- (void)reduceBtnClick:(UIButton*)sender
{
    if (_proPayCount > 1) {
        _proPayCount--;
    }
    _proPayCountLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];
}

- (void)addBtnClick:(UIButton*)sender
{
    _proPayCount ++;
    _proPayCountLabel.text = [NSString stringWithFormat:@"%li",(long)_proPayCount];

}

- (void)bottomCenerClick:(UIButton*)sender
{
    for (NSString *type in _typeDataArr) {
        if ([type isEqualToString:@"0"]) {
            [self showAlert:@"请选择商品规格"];
            return;
        }
    }
    if (_proPayCount > 0) {
        NSMutableString *carTypeStr;
        for (int i=0 ; i<_typeDataArr.count; i++) {
            carTypeStr = [NSMutableString stringWithFormat:@"%@,%@",carTypeStr,_typeDataArr[i]];
        }
        [carTypeStr deleteCharactersInRange:NSMakeRange(0, 7)];
        
        OrderDetailViewController* orderVC = [[OrderDetailViewController alloc]init];
        orderVC.typeOrder = typeOrderAddress;
        orderVC.nowProdetailModel = _proDetailModel;
        orderVC.nowProcount = _proPayCount;
        orderVC.type = carTypeStr;
        if (self.typepro == typeProPoint) {
            orderVC.golds = @"1";
        }
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        [self showAlert:@"商品个数为0"];
    }
}

- (void)bottomRightClick:(UIButton*)sender
{
    for (NSString *type in _typeDataArr) {
        if ([type isEqualToString:@"0"]) {
            [self showAlert:@"请选择商品规格"];
            return;
        }
    }
    if (_proPayCount>0) {
        [self addCarDoRequest:sender];
    }else{
        [self showAlert:@"商品个数为0"];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if (_imgsize.height!=0) {
                return mScreenWidth*_imgsize.height/_imgsize.width;
            }else{
                return 280*HightRuler;
            }
        }
            
            break;
        case 1: return 100; break;
        case 2: return _typeBgview.height; break;
        case 3:{
//            NSString* str = [NSString stringWithFormat:@"%@",[self convertNull:_proDetailModel.note]];
//            NSString* heightstr = [Command filterHTML:str];
//            CGFloat height = [Command detailLabelHeight:heightstr width:mScreenWidth - 10 fontsize:13];
            return 40+_webView.frame.size.height;
        }
            break;
        case 4: return 100; break;
        default: return 0; break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ProDetailImgTableViewCell* imgCell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailImgTableViewCellID"];
    if (!imgCell) {
        imgCell = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailImgTableViewCell" owner:self options:nil]firstObject];
//        imgCell.imgView.contentMode = UIViewContentModeScaleAspectFit;
        if (!IsEmptyValue(_proDetailImgArray)) {
            getProductDetailImgModel* model = _proDetailImgArray[0];
            [imgCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]]];
            UIImage *image = [UIImage imageWithData:data];
            NSLog(@"w = %f,h = %f",image.size.width,image.size.height);
            if (image.size.width!=0) {
                _imgsize = CGSizeMake(image.size.width, image.size.height);
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [_tbView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    ProDetailProTableViewCell* procell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailProTableViewCellID"];
    if (!procell) {
        procell = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailProTableViewCell" owner:self options:nil]firstObject];
    }
    ProDetailMessTableViewCell* messCell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailMessTableViewCellID"];
    if (!messCell) {
        messCell = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailMessTableViewCell" owner:self options:nil]firstObject];
    }
    ProDetailCommTableViewCell* commCell = [tableView dequeueReusableCellWithIdentifier:@"ProDetailCommTableViewCellID"];
    if (!commCell) {
        commCell = [[[NSBundle mainBundle]loadNibNamed:@"ProDetailCommTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (indexPath.row == 0) {
        if (_proDetailImgArray.count!=0) {
            getProductDetailImgModel* model = _proDetailImgArray[0];
            [imgCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_banner"]];
        }
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return imgCell;
    }else if (indexPath.row == 1){
        procell.titleLabel.text = [NSString stringWithFormat:@"%@",[self convertNull:_proDetailModel.proname]];
        if (!IsEmptyValue(_proDetailModel.prosale)) {
            procell.countLabel.text = [NSString stringWithFormat:@"销量%@",[self convertNull:_proDetailModel.prosale]];
        }else{
            procell.countLabel.text = [NSString stringWithFormat:@"销量0"];
        }
        if (!IsEmptyValue(_proDetailModel.pickupway)) {
            if ([_proDetailModel.pickupway integerValue] == 1) {
                procell.pickupwayLabel.text = @"自取";
            }else if ([_proDetailModel.pickupway integerValue]==0){
                procell.pickupwayLabel.text = @"配送";
            }
        }
        if (self.typepro == typeProGoods) {
            if (!IsEmptyValue(_proDetailModel.price)) {
                procell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[self convertNull:_proDetailModel.price] doubleValue]];
            }else{
                procell.priceLabel.text = [NSString stringWithFormat:@"￥0"];
            }
        }else if (self.typepro == typeProPoint){
            if (!IsEmptyValue(_proDetailModel.price)) {
                procell.priceLabel.text = [NSString stringWithFormat:@"金币：%@",[self convertNull:_proDetailModel.price]];
            }else{
                procell.priceLabel.text = [NSString stringWithFormat:@"金币：0"];
            }
        }
        NSString* islogin = [[NSUserDefaults standardUserDefaults]objectForKey:IsLogin];
        if ([islogin integerValue] == 1) {
            procell.collBtnImgView.hidden = NO;
        }else{
            procell.collBtnImgView.hidden = YES;
        }
        if ([_proDetailModel.collection integerValue] == 1) {
            [procell.collBtnImgView setImage:[UIImage imageNamed:@"collection1"] forState:UIControlStateNormal];
        }else{
            [procell.collBtnImgView setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        }
        __weak typeof (ProDetailProTableViewCell*) weakprocell = procell;
        [procell setTransVaule:^(BOOL isclick) {
            weakprocell.collBtnImgView.enabled = NO;
            if ([_proDetailModel.collection integerValue] == 1) {
                [self DelProductCollectRequest:weakprocell.collBtnImgView];
            }else{
                [self AddProductCollectRequest:weakprocell.collBtnImgView];
            }
        }];
        procell.selectionStyle = UITableViewCellSelectionStyleNone;
        return procell;
    }else if (indexPath.row == 2){
        [cell addSubview:[self typeBgview]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 3){
//        messCell.detailLabel.numberOfLines = 0;
//        messCell.detailLabel.adjustsFontSizeToFitWidth = YES;
//        NSString* str = [NSString stringWithFormat:@"%@",[self convertNull:_proDetailModel.note]];
//        NSAttributedString * contentStr = [[NSAttributedString alloc] initWithString:@""];
//        NSMutableString * totalHtmlstring = [[NSMutableString alloc] initWithString:[contentStr toHtmlString]];
//        [totalHtmlstring replaceCharactersInRange:[totalHtmlstring rangeOfString:@"<body>\n</body>"] withString:str];
//        messCell.detailLabel.attributedText = [totalHtmlstring toAttributedString];
//        
//        NSLog(@"---------%@",messCell.detailLabel.attributedText.string);
//        NSLog(@"-----------%@",messCell.detailLabel.attributedText);
        //原高度是80
//        NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
//        CGSize size1 =  [messCell.detailLabel.attributedText.string boundingRectWithSize:CGSizeMake(messCell.detailLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
//        NSLog(@"size.width=%f, size.height=%f", size1.width, size1.height);
//        messCell.detailLabelWith.constant = size1.height+20;
        
        [messCell.contentView addSubview:_webView];
        
//        [messCell.detailWebView loadHTMLString:[NSString stringWithFormat:@"%@%@",_proDetailModel.note,linkCss] baseURL:nil];
//        [messCell setTransVaule:^(CGFloat hight) {
//            _documentHeight = hight;
//        }];
//        //我们可以先把src对应的图片解析出来，放到本地
//        NSString* htmlString = _proDetailModel.note;
//        NSRange httpRange=[htmlString rangeOfString:@"http://"];
//        NSRange endRange=[htmlString rangeOfString:@".png"];
//        NSString *picString=[htmlString substringWithRange:NSMakeRange(httpRange.location, endRange.location+endRange.length-httpRange.location)];
//        UIImage *scaledImage;
//        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:picString] options:nil progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {     //按照字体大小缩小图片，具体实现在下文
////            scaledImage=[self scaleImage:image font:10];
//            NSData *imgData=UIImagePNGRepresentation(scaledImage);      NSString *libPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,     NSUserDomainMask, YES) lastObject];
//            NSString *cachePath=[libPath stringByAppendingPathComponent:@"Caches"];
//            NSString *scaledImagesPath=[cachePath stringByAppendingPathComponent:@"scaledImages"];
//            if(![[NSFileManager defaultManager] fileExistsAtPath:scaledImagesPath]){
//                [[NSFileManager defaultManager] createDirectoryAtPath:scaledImagesPath withIntermediateDirectories:YES attributes:nil error:nil];
//            }
//            NSString *picName=[[picString componentsSeparatedByString:@"/"] lastObject];
//            NSString *filePath=[scaledImagesPath stringByAppendingPathComponent:picName];
//            [imgData writeToFile:filePath atomically:YES]; //用空字符串替换远程图片路径
////            htmlString = [htmlString stringByReplacingOccurrencesOfString:picString withString:@""];
//        }];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 220, 20)];
//        [self.view addSubview:label];
//        UIFont *font=[UIFont systemFontOfSize:14];
//        label.font=font; //利用NSTextAttachment文UILabel添加图片，并调整位置实现居中对齐
//        NSTextAttachment *attach=[[NSTextAttachment alloc] init];
//        attach.bounds=CGRectMake(2, -(label.frame.size.height-font.pointSize)/2, 12, 14);
//        attach.image=scaledImage;
//        NSMutableAttributedString *componets=[[NSMutableAttributedString alloc] init];
//        NSAttributedString *imagePart=[NSAttributedString attributedStringWithAttachment:attach];
//        [componets appendAttributedString:imagePart];
//        NSDictionary *optoins=@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,                             NSFontAttributeName:font};
//        NSData *data=[htmlString dataUsingEncoding:NSUnicodeStringEncoding];
//        NSAttributedString *textPart=[[NSAttributedString alloc] initWithData:data                                                                      options:optoins                                                           documentAttributes:nil                                                                        error:nil];
//        [componets appendAttributedString:textPart];
//        label.attributedText=componets;
        messCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return messCell;
    }else if (indexPath.row == 4){
        NSString* bad = [self convertNull:_proDetailModel.bad];
        NSInteger badnum = [bad integerValue];
        NSString* good = [self convertNull:_proDetailModel.good];
        NSInteger goodnum = [good integerValue];
        NSString* middle = [self convertNull:_proDetailModel.middle];
        NSInteger middlenum = [middle integerValue];
        NSInteger totlenum = goodnum+badnum+middlenum;
        if (totlenum!=0) {
            CGFloat numb = (CGFloat)goodnum*100/totlenum;
            NSString* str = @"%";
            NSString* num = [NSString stringWithFormat:@"%.2f%@",numb,str];
            commCell.rateLabel.text = [NSString stringWithFormat:@"好评度%@",num];
            [self changeTextColor:commCell.rateLabel Txt:commCell.rateLabel.text changeTxt:num];
        }
        commCell.goodImgView.text = [NSString stringWithFormat:@"%@",[self convertNull:good]];
        commCell.badImgView.text = [NSString stringWithFormat:@"%@",[self convertNull:bad]];
        for (UIView* view in commCell.rateView.subviews) {
            [view removeFromSuperview];
        }
        self.proess=[[UIproessMy alloc]initWithFrame:CGRectMake(10, 5, mScreenWidth - 20, 3) color:NavBarItemColor];
        NSString* rate = [NSString stringWithFormat:@"%.2f",(CGFloat)goodnum/totlenum];
        if ([rate floatValue] != 0) {
            self.proess.rate = [rate floatValue];
        }
        [commCell.rateView addSubview:self.proess];
        commCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return commCell;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(UIImage *)scaleImage:(UIImage *)origin font:(UIFont *)font{
    CGFloat imgH=origin.size.height;
    CGFloat imgW=origin.size.width;
    CGFloat width;
    CGFloat height;
    CGFloat fontHeight=font.pointSize;
    if(imgW>imgH){
        width=fontHeight;
        height=fontHeight/imgW*imgH;
    }     else{
        height=fontHeight;
        width=fontHeight/imgH*imgW;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [origin drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == _tbView) {
        if (indexPath.row == 3) {
            ProCommentsViewController* commVC = [[ProCommentsViewController alloc]init];
            commVC.proid = [NSString stringWithFormat:@"%@",_proDetailModel.Id];
            _proDetailModel.bad = [self convertNull:_proDetailModel.bad];
            _proDetailModel.good = [self convertNull:_proDetailModel.good];
            _proDetailModel.middle = [self convertNull:_proDetailModel.middle];
            NSInteger total = [_proDetailModel.bad integerValue]+[_proDetailModel.good integerValue]+[_proDetailModel.middle integerValue];//
            if (IsEmptyValue(_proDetailModel.bad)) {
                commVC.bad = @"0";
            }else{
                commVC.bad = [NSString stringWithFormat:@"%@",_proDetailModel.bad];
            }
            if (IsEmptyValue(_proDetailModel.good)) {
                commVC.good = @"0";
            }else{
                commVC.good = [NSString stringWithFormat:@"%@",_proDetailModel.good];
            }
            if (IsEmptyValue(_proDetailModel.middle)) {
                commVC.middle = @"0";
            }else{
                commVC.middle = [NSString stringWithFormat:@"%@",_proDetailModel.middle];
            }
            commVC.total = [NSString stringWithFormat:@"%li",(long)total];
            [self.navigationController pushViewController:commVC animated:YES];
        }
    }
}

//某label改变字符串颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"1683fb"] range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth,oldheight;"
     "var maxwidth=300;"// 图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat documentHeight= [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"webView的高度-----%f",documentHeight);
    _documentHeight = documentHeight;
//    [_tbView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    _webView.frame = CGRectMake(_webView.frame.origin.x,_webView.frame.origin.y, mScreenWidth - 20, documentHeight);
    [_tbView reloadData];

}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}

#pragma mark 接口---proid->产品详情
- (void)dataRequest
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
    _proid = [self convertNull:_proid];
    NSString* userstr = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userstr = [self convertNull:userstr];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",userstr,_proid,provinceid,cityid,areaid];
    [params setObject:datastr forKey:@"data"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"商品详情请求%@",str);
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"商品详情请求%@",dict);
        NSArray* listArray = dict[@"list"];
        _typeArr = dict[@"typelist"];
        [_typeviewheightArr removeAllObjects];
        [_typeDataArr removeAllObjects];
        for (int i=0; i<_typeArr.count; i++) {
            [_typeviewheightArr addObject:@"0"];
            [_typeDataArr addObject:@"0"];
        }
        
        if (listArray.count!=0) {
            _proDetailModel = [[getProductDetailModel alloc]init];
            [_proDetailModel setValuesForKeysWithDictionary:listArray[0]];
        }
        NSArray* piclistArray = dict[@"piclist"];
        [_proDetailImgArray removeAllObjects];
        if (piclistArray.count!=0) {
            for (NSDictionary* dict in piclistArray) {
                getProductDetailImgModel* model = [[getProductDetailImgModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_proDetailImgArray addObject:model];
            }
        }
        //在此处加载webView的原因是：不能在tableViewcell中加载网页那样会造成因为cellForRowAtIndexPath和webViewDidFinishLoad代理互相调用引起的内存泄漏。
        NSString* linkCss = @"<style type=\"text/css\"> img {"
        "width:100%;"
        "height:auto;"
        "}"
        "</style>";
        if (!IsEmptyValue(_proDetailModel.note)) {
            [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@",_proDetailModel.note,linkCss] baseURL:[NSURL URLWithString:ROOT_Path]];
        }
        [_tbView reloadData];
        
    } fail:^(NSError *error) {
        [_hud hide:YES];
        NSLog(@"商品详情请求失败%@",urlstr);
        
    }];

}
//接口---添加收藏
- (void)AddProductCollectRequest:(UIButton*)sender
{
/*
 /product/addproductcollect.do
 mobile:true
 data{
 proid:产品id
 custid:客户id
 isgolds://是否是积分商城中的商品1，不是积分商城中的商品
 }
 */
    NSString* isgolds ;
    if (self.typepro == typeProGoods) {
        isgolds = @"0";
    }else if (self.typepro == typeProPoint){
        isgolds = @"1";
    }
    _proDetailModel.Id = [self convertNull:_proDetailModel.Id];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/addproductcollect.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];

    NSString* datastr = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"custid\":\"%@\",\"isgolds\":\"%@\"}",_proDetailModel.Id,userid,isgolds];
    [parmas setObject:datastr forKey:@"data"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"添加收藏%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            [self showAlert:@"登录失效请重新登录"];
            LoginNewViewController* VC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:VC animated:NO];
            
        }else{
            if ([str rangeOfString:@"true"].location != NSNotFound) {
                [self showAlert:@"添加收藏成功"];
                _proDetailModel.collection = @"1";
                [_tbView reloadData];
            }else{
                [self showAlert:@"添加收藏不成功"];
            }
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [self showAlert:error.localizedDescription];
        NSLog(@"添加收藏失败%@",error.localizedDescription);
    }];
    
}
//接口---删除收藏
- (void)DelProductCollectRequest:(UIButton*)sender{
    /*
     /product/delproductcollect.do
     mobile:true
     data{
     proid:产品id
     custid:用户id
     }
     */
    _proDetailModel.Id = [self convertNull:_proDetailModel.Id];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/delproductcollect.do"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"true" forKey:@"mobile"];
    NSString* datastr = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"custid\":\"%@\"}",_proDetailModel.Id,userid];
    [params setObject:datastr forKey:@"data"];
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
                _proDetailModel.collection = @"0";
                [_tbView reloadData];
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

//添加购物车的接口
- (void)addCarDoRequest:(UIButton*)sender
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
    NSMutableString *carTypeStr;
    for (int i=0 ; i<_typeDataArr.count; i++) {
        carTypeStr = [NSMutableString stringWithFormat:@"%@,%@",carTypeStr,_typeDataArr[i]];
    }
    [carTypeStr deleteCharactersInRange:NSMakeRange(0, 7)];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    sender.enabled = NO;
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    _proDetailModel.Id = [self convertNull:_proDetailModel.Id];
    _proDetailModel.proname = [self convertNull:_proDetailModel.proname];
    _proDetailModel.price = [self convertNull:_proDetailModel.price];
    double totlemoney = [_proDetailModel.price doubleValue]*_proPayCount;
    NSString* totlestr = [NSString stringWithFormat:@"%.2f",totlemoney];
    _proDetailModel.specification = [self convertNull:_proDetailModel.specification];
    _proDetailModel.mainunitid = [self convertNull:_proDetailModel.mainunitid];
    _proDetailModel.mainunitname = [self convertNull:_proDetailModel.mainunitname];
    _proDetailModel.pickupway = [self convertNull:_proDetailModel.pickupway];
    NSString* isgolds ;
    if (self.typepro == typeProGoods) {
        isgolds = @"0";
    }else if (self.typepro == typeProPoint){
        isgolds = @"1";
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/addCart.do"];
    NSString* cartliststr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"count\":\"%@\",\"saleprice\":\"%@\",\"totalprice\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"isgolds\":\"%@\",\"pickupway\":\"%@\",\"type\":\"%@\"}",userid,_proDetailModel.Id,_proDetailModel.proname,_proDetailModel.prono,[NSString stringWithFormat:@"%li",(long)_proPayCount],_proDetailModel.price,totlestr,_proDetailModel.specification,_proDetailModel.mainunitid,_proDetailModel.mainunitname,isgolds,_proDetailModel.pickupway,carTypeStr];
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

#pragma mark 浏览历史添加接口
- (void)addProductBrowerResquest
{
    /*
     /product/addproductbrower.do
     mobile:true
     data{
     proid:产品id
     creatorid：用户id
     }
     */
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* isgolds;
    if (self.typepro == typeProPoint) {
        isgolds = @"1";
    }else{
        isgolds = @"0";
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/addproductbrower.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"creatorid\":\"%@\",\"isgolds\":\"%@\"}",self.proid,userid,isgolds];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"addproductbrower.do---%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/product/addproductbrower.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if([str rangeOfString:@"true"].location != NSNotFound){
//            [self showAlert:@"添加到浏览历史"];
            
        }
    } fail:^(NSError *error) {
        
    }];

}

#pragma mark 积分商城
- (void)dataRequestGolds
{
    /*
     /product/getGoldsProductDetail.do
     mobile:true
     data{
     proid 商品主键id
     provinceid cityid areaid 客户定位省市区域的id
     custid 当前登录用户id
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
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/getGoldsProductDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"custid\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",self.proid,userid,provinceid,cityid,areaid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"商品详情请求%@",str);
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"商品详情请求%@",dict);
        NSArray* listArray = dict[@"list"];
        if (listArray.count!=0) {
            _proDetailModel = [[getProductDetailModel alloc]init];
            [_proDetailModel setValuesForKeysWithDictionary:listArray[0]];
        }
        NSArray* piclistArray = dict[@"piclist"];
        [_proDetailImgArray removeAllObjects];
        if (piclistArray.count!=0) {
            for (NSDictionary* dict in piclistArray) {
                getProductDetailImgModel* model = [[getProductDetailImgModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_proDetailImgArray addObject:model];
            }
        }
        [_tbView reloadData];
        
    } fail:^(NSError *error) {
        [_hud hide:YES];
    }];
    
}

- (void)addproductbrowerRequestData{
/*
 /product/addproductbrowerCount.do
 mobile:true
 data:{
 proid
 creatorid
 }
 */
    NSString* custid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    custid = [self convertNull:custid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/addproductbrowerCount.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"creatorid\":\"%@\"}",self.proid,custid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/product/addproductbrower.do%@",str);
        
    } fail:^(NSError *error) {
        
    }];
}





@end
