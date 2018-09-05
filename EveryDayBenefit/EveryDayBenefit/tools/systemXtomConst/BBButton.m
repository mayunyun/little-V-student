//
//  BBButton.m
//  BiaoBiao
//
//  Created by 山东三米 on 14-1-3.
//  Copyright (c) 2014年 山东三米. All rights reserved.
//

#import "BBButton.h"
//#import "EmitterView.h"

@implementation BBButton
@synthesize btnId;
@synthesize btnRow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        /*
        EmitterView *emitterView = [[EmitterView alloc] initWithFrame:CGRectZero];
        [self addSubview:emitterView];
         */
    }
    return self;
}
- (void)dealloc
{
    [btnId release];btnId = nil;
    [super dealloc];
}

@end
