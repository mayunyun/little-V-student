//
//  SwipeGR.h
//  DDwork
//
//  Created by 山东三米 on 13-11-8.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeGR : UISwipeGestureRecognizer
@property(nonatomic,copy)NSString *touchRow;//用来标示行号
@property(nonatomic,copy)NSString *touchRowNum;//
@property(nonatomic,assign)NSInteger myRow;
@property(nonatomic,assign)NSInteger myNumber;
@end
