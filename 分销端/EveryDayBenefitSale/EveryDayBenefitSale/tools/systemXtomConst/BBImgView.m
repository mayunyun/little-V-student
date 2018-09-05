//
//  BBImgView.m
//  BiaoBiao
//
//  Created by 山东三米 on 14-5-8.
//  Copyright (c) 2014年 山东三米. All rights reserved.
//

#import "BBImgView.h"

@implementation BBImgView
@synthesize imgURL;

- (void)dealloc
{
    [imgURL release];imgURL = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
