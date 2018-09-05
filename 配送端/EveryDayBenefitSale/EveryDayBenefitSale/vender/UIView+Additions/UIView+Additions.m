//
//  UIView+Additions.m
//  zhicai
//
//  Created by D on 15/9/14.
//  Copyright (c) 2015年 zhicai. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

-(UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    while (next != nil)
    {
        if ([next isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

@end
