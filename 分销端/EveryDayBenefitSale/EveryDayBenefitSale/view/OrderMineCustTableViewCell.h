//
//  OrderMineCustTableViewCell.h
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 17/2/6.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMineCustTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *ordernoLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

@end
