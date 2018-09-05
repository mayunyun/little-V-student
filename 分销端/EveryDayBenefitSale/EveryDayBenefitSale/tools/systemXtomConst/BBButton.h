//
//  BBButton.h
//  BiaoBiao
//
//  Created by 山东三米 on 14-1-3.
//  Copyright (c) 2014年 山东三米. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBButton : UIButton
@property(nonatomic,copy)NSString *btnId;
@property(nonatomic,assign)NSInteger btnRow;
@property(nonatomic,retain)NSString *typeIdd;
@property (nonatomic,retain)NSString *nameTitle;
@property (nonatomic,assign)NSInteger guanZhuTag;
@end
