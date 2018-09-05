//
//  FindTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/17.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHight;
@property (nonatomic, strong) UIImage *image;
@end
