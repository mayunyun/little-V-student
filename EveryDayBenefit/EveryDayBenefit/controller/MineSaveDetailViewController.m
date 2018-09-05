//
//  MineSaveDetailViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MineSaveDetailViewController.h"
#import "RegisterSalesModel.h"
#import "GetCustInfoAddressModel.h"
#import "LoginNewViewController.h"


@interface MineSaveDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView* _groundSView;
    UIImageView* _headerImgView;
    NSArray* _nameArray;
    UITextField* _nickNameTextField;
    UITextField* _nameTextField;
    UITextField* _phoneTextField;
    UIButton* _linkerBtn;
    NSString* _linkerBtnID;
    
    UIView* _myAleartView;
    UITableView* _fxCustTableView;
    NSMutableArray* _fxCustArray;
    
    UIView* _myAleareView;
    
}


@end

@implementation MineSaveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fxCustArray = [[NSMutableArray alloc]init];
    
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:@"完善个人资料"];
    _nameArray = @[@"昵称",@"姓名",@"联系方式"];
    [self creatUI];
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    _groundSView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 49 - 64)];
    _groundSView.contentSize = CGSizeMake(mScreenWidth, 400);
    _groundSView.bounces = NO;
    _groundSView.scrollEnabled = YES;
    _groundSView.backgroundColor = BackGorundColor;
    [self.view addSubview:_groundSView];
    
    UIView* sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, _groundSView.width, 80)];
    sectionView.backgroundColor = [UIColor whiteColor];
    [_groundSView addSubview:sectionView];
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, sectionView.width - 110, sectionView.height)];
    headerLabel.text = @"头像";
    [sectionView addSubview:headerLabel];
    _headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(headerLabel.right, 10, 60, 60)];
    _headerImgView.layer.masksToBounds = YES;
    _headerImgView.layer.cornerRadius = 30.0;
//    _headerImgView.image = [UIImage imageNamed:@"icon-img"];
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",ROOT_Path,_custInfoModel.picsrc,_custInfoModel.picname]] placeholderImage:[UIImage imageNamed:@"icon-img"]];
    _headerImgView.userInteractionEnabled = YES;
    [sectionView addSubview:_headerImgView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    [_headerImgView addGestureRecognizer:tap];
    UIImageView* rightView = [[UIImageView alloc]initWithFrame:CGRectMake(_headerImgView.right+10, _headerImgView.center.y - 5, 5, 10)];
    rightView.image = [UIImage imageNamed:@"icon-right"];
    [sectionView addSubview:rightView];
    
    UIView* section1View = [[UIView alloc]initWithFrame:CGRectMake(0, sectionView.bottom+10, _groundSView.width, 90)];
    section1View.backgroundColor = [UIColor whiteColor];
    [_groundSView addSubview:section1View];
    UILabel* nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 44)];
    nickLabel.text = @"昵称";
    nickLabel.font = PCMTextFont14;
    nickLabel.textColor = GrayTitleColor;
    [section1View addSubview:nickLabel];
    _nickNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(nickLabel.right, 0, section1View.width - nickLabel.width - 20, nickLabel.height)];
    _nickNameTextField.delegate = self;
    if (!IsEmptyValue(_custInfoModel.account)) {
        _nickNameTextField.text = [NSString stringWithFormat:@"%@",_custInfoModel.account];
    }
    [section1View addSubview:_nickNameTextField];
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, nickLabel.bottom, mScreenWidth, 1)];
    line.backgroundColor = LineColor;
    [section1View addSubview:line];
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nickLabel.bottom, 60, 44)];
    nameLabel.text = @"真是姓名";
    nameLabel.font = PCMTextFont14;
    nameLabel.textColor = GrayTitleColor;
    [section1View addSubview:nameLabel];
    _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, section1View.width - 80, nameLabel.height)];
    _nameTextField.delegate = self;
    [section1View addSubview:_nameTextField];
    if (!IsEmptyValue(_custInfoModel.name)) {
        _nameTextField.text = [NSString stringWithFormat:@"%@",_custInfoModel.name];
    }
    UIView* line1 = [[UIView alloc]initWithFrame:CGRectMake(0, nameLabel.bottom , mScreenWidth, 1)];
    line1.backgroundColor = LineColor;
    [section1View addSubview:line1];
    
    UILabel* phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line1.bottom, 80, 44)];
    phoneLabel.text = @"联系方式";
    phoneLabel.font = PCMTextFont14;
    phoneLabel.textColor = GrayTitleColor;
//    [section1View addSubview:phoneLabel];
    _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, section1View.width - 100, phoneLabel.height)];
    _phoneTextField.delegate = self;
//    [section1View addSubview:_phoneTextField];
    _phoneTextField.text = [NSString stringWithFormat:@"%@",_custInfoModel.phone];
    UIView* line2 = [[UIView alloc]initWithFrame:CGRectMake(0, phoneLabel.bottom , mScreenWidth, 1)];
    line2.backgroundColor = LineColor;
//    [section1View addSubview:line2];
    if (_custInfoModel.phone.length!=0) {
        _phoneTextField.text = _custInfoModel.phone;
    }
    
    UILabel* linkerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line2.bottom, 80, 44)];
    linkerLabel.text = @"绑定分销人";
    linkerLabel.font = PCMTextFont14;
    linkerLabel.textColor = GrayTitleColor;
//    [section1View addSubview:linkerLabel];
    _linkerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _linkerBtn.frame = CGRectMake(linkerLabel.right, linkerLabel.top, section1View.width - 100, linkerLabel.height);
    [_linkerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_linkerBtn setTitle:@"绑定分销人" forState:UIControlStateNormal];
    if (!IsEmptyValue(_addressModel.linker)) {
        [_linkerBtn setTitle:[NSString stringWithFormat:@"%@",_addressModel.linker] forState:UIControlStateNormal];
        _linkerBtnID = _addressModel.linkerid;
    }
//    [section1View addSubview:_linkerBtn];
    [_linkerBtn addTarget:self action:@selector(linkerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* line3 = [[UIView alloc]initWithFrame:CGRectMake(0, linkerLabel.bottom, mScreenWidth, 1)];
    line3.backgroundColor = LineColor;
//    [section1View addSubview:line3];

    UIButton* saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    saveBtn.frame = CGRectMake(10, mScreenHeight -64 -49, mScreenWidth - 20, 44);
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 5.0;
    [saveBtn setBackgroundColor:NavBarItemColor];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView*)creatFxCustUI{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_myAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFxCustAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleartView.height - 350)/2, _myAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _fxCustTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _fxCustTableView.backgroundColor = [UIColor grayColor];
        _fxCustTableView.delegate = self;
        _fxCustTableView.dataSource = self;
        [windowView addSubview:_fxCustTableView];
        
    }
    return _myAleartView;
}

- (void)closeFxCustAleartView:(UITapGestureRecognizer*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}
- (void)closeAleartView:(UIButton*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}


- (void)saveClick:(UIButton*)sender
{
//    if (!IsEmptyValue(_linkerBtnID)) {
        [self appCompeleteDetailRequest:sender];
//    }else{
//        [self showAlert:@"绑定分销人不能为空"];
//    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = @"请输入详细地址";
        textView.textColor = GrayTitleColor;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

//点击头像
- (void)headerClick:(UITapGestureRecognizer*)tap
{
    UIActionSheet* sheet = [[UIActionSheet alloc
                             ]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册里选择照片", @"现在就拍一张", nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
}
#pragma mark 点击了分销人
- (void)linkerBtnClick:(UIButton*)sender
{
    [self FxCustRequest];
    [self creatFxCustUI];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    }else if (scrollView == _groundSView){
    
    }else{
        for (int i = 0; i < 3; i ++) {
            UIButton* btn = (UIButton*)[APPDelegate.window viewWithTag:2000+i];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIView* view = (UIView*)[APPDelegate.window viewWithTag:2100+i];
            view.backgroundColor = [UIColor clearColor];
        }
        
        int i = scrollView.contentOffset.x/mScreenWidth;
        UIView* line = (UIView*)[APPDelegate.window viewWithTag:2100 +i];
        line.backgroundColor = NavBarItemColor;
        UIButton* btn = (UIButton*)[APPDelegate.window viewWithTag:2000 + i];
        [btn setTitleColor:NavBarItemColor forState:UIControlStateNormal];

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _fxCustTableView) {
        return _fxCustArray.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    if (tableView == _fxCustTableView) {
        RegisterSalesModel* model = _fxCustArray[indexPath.row];
        cell.textLabel.text = model.account;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _fxCustTableView) {
        RegisterSalesModel* model = _fxCustArray[indexPath.row];
        [_linkerBtn setTitle:model.account forState:UIControlStateNormal];
        _linkerBtnID = model.Id;
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    }
}


- (void)FxCustRequest
{
    ///login/fxCust.do
    NSString* urlStr = [NSString stringWithFormat:@"%@/login/fxCust.do",ROOT_Path];
    _addressModel.villageid = [self convertNull:_addressModel.villageid];
    NSDictionary* params = @{@"villageid":[NSString stringWithFormat:@"%@",_addressModel.villageid]};
    NSLog(@"urlStr---%@params---%@",urlStr,params);
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"FxCustRequeststr%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"FxCustRequestarray%@",array);
        if (array.count!=0) {
            [_fxCustArray removeAllObjects];
            for (int i = 0; i < array.count; i++) {
                RegisterSalesModel* model = [[RegisterSalesModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                [_fxCustArray addObject:model];
            }
            [_fxCustTableView reloadData];
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"FxCustRequest请求错误，错误原因%@",error.localizedDescription);
    }];
}

- (void)appCompeleteDetailRequest:(UIButton*)sender
{
    /*
     /login/appcompeleteDetail.do
     mobile:true
     data{
     account:昵称,
     name:真实姓名,
     phone:电话,
     id:用户id,
     }
     */
    sender.enabled = NO;
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appcompeleteDetail.do"];
    NSString* data = [NSString stringWithFormat:@"{\"account\":\"%@\",\"name\":\"%@\",\"phone\":\"%@\",\"id\":\"%@\"}",_nickNameTextField.text,_nameTextField.text,_phoneTextField.text,self.custInfoModel.Id];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:data forKey:@"data"];
    [parmas setObject:@"true" forKey:@"mobile"];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"完善信息返回字符串%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound){
            [self showAlert:@"完善信息成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlert:@"完善信息返回失败"];
        }
        
    } fail:^(NSError *error) {
        sender.enabled = YES;
        NSLog(@"完善信息返回失败,%@",error.localizedDescription);
    }];
    
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //头像
    if (actionSheet.tag == 1001) {
        if (0 == buttonIndex) {
            [self LocalPhoto];
        } else if (1 == buttonIndex) {
            [self takePhoto];
        }
    }

}




//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        // DLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        //修改图片的大小为90*90
        image = [self thumbnailImage:CGSizeMake(90.0, 90.0) withImage:image];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        [self requestPortal:data img:image];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//修改头像大小
- (UIImage*)thumbnailImage:(CGSize)targetSize withImage:(UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width * screenScale;
    CGFloat targetHeight = targetSize.height * screenScale;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //DLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestPortal:(NSData*)imgData img:(UIImage*)img {
    //NSData 转 Base64
//    NSString* imgStr = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//        NSLog(@"上传图片的请求imgStr%@",imgStr);
#pragma mark 上传图片的请求
    _headerImgView.image = img;

    
//    //
    /*
     /login/exportPhone.do
     mobile:true
     custid
     */
    NSString* urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/exportPhone.do"];
    self.custInfoModel.Id = [self convertNull:self.custInfoModel.Id];
    NSDictionary* parmas = @{@"mobile":@"true",@"custid":self.custInfoModel.Id};
        [HTNetWorking postWithUrl:urlStr refreshCache:YES params:parmas success:^(id result) {
            
            NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"上传头像返回%@",str);
            if ([str rangeOfString:@"true"].location != NSNotFound) {
                [self showAlert:@"头像上传成功"];
            }
        } fail:^(NSError *error) {
        NSLog(@"error %@",error);
            
            
        }];
    
//    NSString* str = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/exportText.do"];
//    NSDictionary* params = @{@"mobile":@"true",@"custid":self.custInfoModel.Id,@"src":imgStr};
//    [DataPost requestAFWithUrl:str params:params finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
//        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
//        NSLog(@"图片上传返回%@",str);
//        
//        } fail:^(NSError *error) {
//        
//    }];
}

//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:_encodedImageStr];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}

//#pragma mark - 上传图片
//- (void)uploadPhoto{
//    /* nosession
//     action＝uploadFile
//     table=mall_user
//     cardPositiveImg=正面
//     cardReverseImg=反面
//     
//     */
//    __block NSInteger flag = 0;
//    NSMutableArray *imageArray = [NSMutableArray array];
//    NSData *imageData1 = UIImagePNGRepresentation(_firstImgView.image);
//    NSData *imageData2 = UIImagePNGRepresentation(_secondImgView.image);
//    [imageArray addObject:imageData1];
//    [imageArray addObject:imageData2];
//    
//    for (NSData *imageData in imageArray) {
//        
//        NSDictionary *params = @{@"action":@"uploadFile",@"table":@"mall_user",@"id":_registeId};
//        
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"nosession"];
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"text/plain", nil];
//        
//        [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *str = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//            
//            [formData appendPartWithFileData:imageData
//                                        name:@"img"
//                                    fileName:fileName
//                                    mimeType:@"image/jpeg"];
//            
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSDictionary *returnDic = (NSDictionary *)responseObject;
//            NSString *status = returnDic[@"status"];
//            NSString *msg = returnDic[@"msg"];
//            
//            if ([status isEqualToString:@"true"]) {
//                flag ++;
//                if (flag==2) {
//                    [self showAlertView:msg];
//                }
//                
//                [self dismissViewControllerAnimated:YES completion:nil];
//                //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示!"
//                //                                                               message:msg
//                //                                                              delegate:self
//                //                                                     cancelButtonTitle:nil otherButtonTitles:@"返回登录页", nil];
//                //                [alert show];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"error %@",error);
//            
//            
//        }];
//        
//    }
//    
//    
//    
//    
//}







@end
