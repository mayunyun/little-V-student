//
//  SwipeGR.m
//  DDwork
//
//  Created by 山东三米 on 13-11-8.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import "SwipeGR.h"

@implementation SwipeGR
@synthesize touchRow;
@synthesize touchRowNum;
@synthesize myRow;
@synthesize myNumber;

-(void)dealloc
{
    [touchRow release];touchRow = nil;
    [touchRowNum release];touchRowNum = nil;
    [super dealloc];
}
@end
