//
//  Alum.m
//  TestQQOuthour
//
//  Created by 杨雨 on 13-12-30.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "Alum.h"

@implementation Alum



- (id)initWithFrame:(CGRect)frame url:(NSString*)url name:(NSString*)name
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *ig = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-50)/2.0, 0, 50, 50)];
        ig.layer.cornerRadius = 50/2.0;
        ig.layer.masksToBounds = YES;
        [ig sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"meinv.png"]];
        [self addSubview:ig];
        _backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ig.frame.size.width+5, frame.size.width, 20)];
        _backLabel.alpha = .8;
        _backLabel.backgroundColor = [UIColor clearColor];
        _backLabel.textAlignment = NSTextAlignmentCenter;
        _backLabel.text = name;
        _backLabel.textColor = [UIColor grayColor];
        _backLabel.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:_backLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
