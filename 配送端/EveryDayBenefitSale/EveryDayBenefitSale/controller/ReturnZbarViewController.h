//
//  ReturnZbarViewController.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/29.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ReturnZbarViewController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (nonatomic, strong) UIImageView * line;
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

//block声明
@property (nonatomic, copy) void (^transVaule)(NSString* code);

@end
