//
//  ORCodeViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ORCodeViewController.h"

@interface ORCodeViewController ()

@end

@implementation ORCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(30, 40, ScreenWidth-60, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, labIntroudction.bottom+10, ScreenWidth-60, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(30, imageView.bottom+20, labIntroudction.width, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, ScreenWidth-100, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animationnew) userInfo:nil repeats:YES];

}

-(void)animationnew
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, ScreenWidth-100, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, ScreenWidth-100, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
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
            [self setupCamera];
        } else if (status == AVAuthorizationStatusNotDetermined) {
//            if ([AVCaptureDevice instancesRespondToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        [self setupCamera];
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
                [self setupCamera];
            }
        } else if(status == AVAuthorizationStatusRestricted){
            [self showAlert:@"您没有权限访问相机"];
        }

    }else{
        [self setupCamera];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self checkAVAuthorizationStatus];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
//        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    _output.metadataObjectTypes=@[AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(40,110,ScreenWidth-80,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^
     {
         [timer invalidate];
         NSLog(@"%@",stringValue);
//         [self showAlert:stringValue];
         if (_transVaule) {
             _transVaule(stringValue);
         }
     }];
}


@end
