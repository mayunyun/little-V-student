//
//  UIViewController+HTHud.m
//  zhicai
//
//  Created by D on 15/9/14.
//  Copyright (c) 2015年 zhicai. All rights reserved.
//

#import "UIViewController+HTHud.h"

@implementation UIViewController (HTHud)


#pragma mark 延迟调用
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block
{
    block();
}

@end
