//
//  UIViewController+HTHud.h
//  zhicai
//
//  Created by D on 15/9/14.
//  Copyright (c) 2015年 zhicai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HTHud)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;


@end
