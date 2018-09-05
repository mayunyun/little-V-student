//
//  PointListTableViewCell.h
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *saleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
