//
//  YZXTimeButton.m
//  WangShangHui
//
//  Created by yang on 14/10/27.
//  Copyright (c) 2014年 MingXun. All rights reserved.
//

#import "YZXTimeButton.h"

@implementation YZXTimeButton
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.tintColor = [UIColor grayColor];
        [self setTitle:self.buttonTitle forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.miao = 60;
        self.backgroundColor = NavBarItemColor;
        
    }
    return self;
}

- (void)setKaishi:(int)input
{
    
    if ([self.recoderTime isEqualToString:@"yes"]) {
        self.enabled = NO;
        self.backgroundColor = BackGorundColor;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeButtonTitle) userInfo:nil repeats:YES];
        _Kaishi = input;
        

    }
}

- (void)changeButtonTitle
{
    
    self.miao--;
    [self setTitle:[NSString stringWithFormat:@"%ds后重发",self.miao] forState:UIControlStateNormal];
    if (self.miao == 0) {
        self.enabled = YES;
        [self setTitle:self.buttonTitle forState:UIControlStateNormal];
        [self.timer invalidate];
        self.miao = 60;
        self.backgroundColor = NavBarItemColor;
    }
}



@end
