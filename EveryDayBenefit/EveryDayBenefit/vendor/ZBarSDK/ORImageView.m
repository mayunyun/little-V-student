//
//  ORImageView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/9.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ORImageView.h"
#import "UIImage+MDQRCode.h"

@implementation ORImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat imageSize = ceilf(self.bounds.size.width);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.bounds.size.width - imageSize), floorf(self.bounds.size.height - imageSize), imageSize, imageSize)];
        [self addSubview:imageView];
//        CGFloat imageSize = ceilf(self.bounds.size.width * 0.6f);
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(floorf(self.bounds.size.width * 0.5f - imageSize * 0.5f), floorf(self.bounds.size.height * 0.5f - imageSize * 0.5f), imageSize, imageSize)];
//        [self addSubview:imageView];
        imageView.image = [UIImage mdQRCodeForString:_str size:imageView.bounds.size.width fillColor:[UIColor darkGrayColor]];
    }
    return self;
}




@end
