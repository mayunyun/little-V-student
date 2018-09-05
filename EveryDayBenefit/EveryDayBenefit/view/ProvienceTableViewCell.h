//
//  ProvienceTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvienceTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@end
