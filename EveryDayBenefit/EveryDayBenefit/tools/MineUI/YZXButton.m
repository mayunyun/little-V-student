//
//  YZXButton.m
//  BaoGongDuanAn
//
//  Created by yang on 15/5/5.
//  Copyright (c) 2015年 YZX. All rights reserved.
//

#import "YZXButton.h"
#import <QuartzCore/QuartzCore.h>
@implementation YZXButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame buttonName:(NSString*)name title:(NSString*)title buttonBackgroundImage:(UIImage*)ig
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(5, 0, frame.size.width-10, frame.size.width-10);
        [self.button setTitle:name forState:UIControlStateNormal];
        [self.button setBackgroundImage:ig forState:UIControlStateNormal];
        self.button.layer.cornerRadius = (frame.size.width-10)/2.0;
        self.button.layer.masksToBounds = YES;
        [self addSubview:self.button];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.button.frame.size.height, frame.size.width, 20)];
        self.nameLabel.text = title;
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor grayColor];
        [self addSubview:self.nameLabel];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame buttonName:(NSString*)name title:(NSString*)title buttonBackgroundImage:(UIImage*)ig juLi:(NSString*)ju
{
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(5, 0, frame.size.width-10, frame.size.width-10);
        [self.button setTitle:name forState:UIControlStateNormal];
        [self.button setBackgroundImage:ig forState:UIControlStateNormal];
        self.button.layer.cornerRadius = (frame.size.width-10)/2.0;
        self.button.layer.masksToBounds = YES;
        [self addSubview:self.button];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.button.frame.size.height-5, frame.size.width, 20)];
        self.nameLabel.text = title;
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor grayColor];
        [self addSubview:self.nameLabel];
        
    }
    return self;
}
- (id)initWithFrameBuQieJiao:(CGRect)frame buttonName:(NSString*)name title:(NSString*)title buttonBackgroundImage:(UIImage*)ig
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake((frame.size.width-25)/2.0, 3, 25, 22);
        [self.button setTitle:name forState:UIControlStateNormal];
        [self.button setBackgroundImage:ig forState:UIControlStateNormal];
        [self addSubview:self.button];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, frame.size.width, 20)];
        self.nameLabel.text = title;
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.nameLabel];
        
    }
    return self;
}
@end
